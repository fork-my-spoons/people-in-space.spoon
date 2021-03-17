local obj = {}
obj.__index = obj

-- Metadata
obj.name = "people-in-space"
obj.version = "1.0"
obj.author = "Pavel Makhov"
obj.homepage = "https://github.com/fork-my-spoons/people-in-space.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.indicator = nil
obj.timer = nil
obj.menu = {}
obj.iconPath = hs.spoons.resourcePath("icons")

local function show_warning(status, body)
    hs.notify.new(function() end, {
        autoWithdraw = false,
        title = 'Jira Spoon',
        informativeText = string.format('Received status: %s\nbody:%s', status, string.sub(body, 1, 400))
    }):send()
end

local user_icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
local calendar_icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})

local function styledText(text)
    return hs.styledtext.new(text, {color = {hex = '#8e8e8e'}})
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function parse_date(date_str)
    local pattern = '(%d+)%-(%d+)%-(%d+)'
    local y, m, d = date_str:match(pattern)
    return os.time{year=y, month=m, day=d}
end

local function updateMenu()
    local url = 'https://www.howmanypeopleareinspacerightnow.com/peopleinspace.json'
    hs.http.asyncGet(url, {}, function(status, body)
        obj.menu = {}

        if status ~=200 then
            show_warning(status, body)
            return
        end
        
        local response = hs.json.decode(body)
        obj.indicator:setTitle(response.number)
        
        table.sort(response.people, function(left, right) return left.country < right.country end)

        local cur_status = ''
        local current_time = os.time(os.date('!*t'))
        for _, person in ipairs(response.people) do
            if cur_status ~= person.country then
                table.insert(obj.menu, { title = '-'})
                table.insert(obj.menu, { title = person.country, disabled = true})
                cur_status = person.country
            end
            
            print()

            local menu = { 
                image = hs.image.imageFromURL(person.biophoto):setSize({w=64,h=64}),
                title = hs.styledtext.new(person.name .. '\n') 
                .. user_icon .. styledText(person.title .. '\n') 
                .. calendar_icon .. styledText(math.floor(os.difftime(current_time, parse_date(person.launchdate)) / 86400) .. ' days in space')
            }

            local submenu = {}

            if person.bio ~= '' then
                local bio = ''
                for i,v in ipairs(split(person.bio, ' ')) do
                    bio = bio .. ' ' .. v
                    if i % 8 == 0 then bio = bio .. '\n' i = 0 end
                end

                table.insert(submenu, { 
                    disabled = true,
                    title = hs.styledtext.new(bio) 
                })
                table.insert(submenu, {title = '-'})
            end

            if person.twitter ~= '' then
                local start, _ = string.find(person.twitter, '/[^/]*$')
                local twitter_username = string.sub(person.twitter, start + 1)

                table.insert(submenu, { 
                    image = hs.image.imageFromPath(obj.iconPath .. '/twitter.png'):setSize({w=16,h=16}),
                    title = hs.styledtext.new(twitter_username), fn = function() os.execute('open ' .. person.twitter ) end 
                })
            end

            if person.biolink ~= '' then
                table.insert(submenu, { 
                    image = hs.image.imageFromPath(obj.iconPath .. '/wiki.png'):setSize({w=16,h=16}),
                    title = hs.styledtext.new('Wiki article'),
                    fn = function() os.execute('open ' .. person.biolink) end 
                })
            end

            menu.menu = submenu

            table.insert(obj.menu, menu)
        end
        
    end)
end

function obj:buildMenu()
    return obj.menu
end

function obj:init()
    self.indicator = hs.menubar.new()
    self.indicator:setIcon(hs.image.imageFromPath(obj.iconPath .. '/astronaut.png'):setSize({w=16,h=16}), true)
    obj.indicator:setMenu(self.buildMenu)
    
    self.timer = hs.timer.new(18000, updateMenu)
end

function obj:start()
    self.timer:fire()
    self.timer:start()
end


return obj