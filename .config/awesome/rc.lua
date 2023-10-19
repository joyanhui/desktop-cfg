-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- 跟随启动
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end
-- 部分 透明
run_once({"compton"})
--  网络
run_once({"nm-tray"})
--  plank 如果在左右侧面 会遮挡 bar部分区域导致无法点击，cairo-dock也有这个问题
--run_once({ "plank" })
-- tint2 没意义，不如配置一下 awful.widget.tasklist
--run_once({"tint2"})
-- 随机壁纸
run_once({"/usr/bin/feh --randomize --bg-fill ~/bg/* "})

--awful.spawn.with_shell("")
--awful.spawn.with_shell("sh .config/polybar/polybar_run.sh")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
    text = awesome.startup_errors})
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
        text = tostring(err)})
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers. 壁纸 和主题等
-- ls /usr/share/awesome/themes  default  gtk  sky  xresources  zenburn
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(string.format("%s/.config/awesome/themes/my-zenburn/theme.lua", os.getenv("HOME")))

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

--  可用布局
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {"查看热键", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
    {"查看手册", terminal .. " -e man awesome"},
    -- { "随即壁纸", awful.spawn.with_shell("/usr/bin/feh --randomize --bg-fill ~/bg/")},
    {"随机壁纸", function() awful.spawn.with_shell("/usr/bin/feh --randomize --bg-fill ~/bg/*") end},
    {"编辑配置", editor_cmd .. " " .. awesome.conffile},
    {"重启as", awesome.restart},
    {"退出桌面", function() awesome.quit() end},
}

local menu_awesome = {"awesome", myawesomemenu, beautiful.awesome_icon}
local menu_terminal = {"open terminal", terminal}
local menu_alacritty = {"打开 alacritty", "alacritty"}
local menu_exitmenu = {"exit menu(Esc)", ""}

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = {menu_awesome},
    after = {menu_terminal, menu_alacritty, menu_exitmenu}})
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            {"Debian", debian.menu.Debian_menu.Debian},
            menu_terminal,
            menu_alacritty, menu_exitmenu
        }})
    end

    mylauncher = awful.widget.launcher({image = beautiful.awesome_icon,
    menu = mymainmenu})

    -- Menubar configuration
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it
    -- }}}

    -- Keyboard map indicator and switcher
    mykeyboardlayout = awful.widget.keyboardlayout()

    -- {{{ Wibar
    -- Create a textclock widget
    --mytextclock = wibox.widget.textclock()
    mytextclock = wibox.widget.textclock('%H:%M') -- 只要时间 不要日期

    -- Create a wibox for each screen and add it
    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({modkey}, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({modkey}, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))

    local function set_wallpaper(s)
        -- Wallpaper
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end

    -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
    screen.connect_signal("property::geometry", set_wallpaper)

    awful.screen.connect_for_each_screen(function(s)
        -- Wallpaper
        set_wallpaper(s)

        -- Each screen has its own tag table.
        awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(gears.table.join(
            awful.button({}, 1, function () awful.layout.inc(1) end),
            awful.button({}, 3, function () awful.layout.inc(-1) end),
            awful.button({}, 4, function () awful.layout.inc(1) end),
        awful.button({}, 5, function () awful.layout.inc(-1) end)))
        s.mylayoutbox.forced_height = 18
        s.mylayoutbox.forced_width = 18
        s.mylayoutbox.opacity = 0.5
        local mylayoutbox = wibox.container.margin(s.mylayoutbox, 0, 0, 2, 0) -- 设置容器的边距

        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }
        

  --[[ 

    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function (c)
            -- 左键 默认是  如果是焦点那么最小化 否则切换为焦点
            --if c == client.focus then  -- 如果是焦点那么最小化 
            --    c.minimized = true
            --else
            --    c:emit_signal("request::activate", "tasklist", {raise = true})  -- 否则切换为焦点
            --end
            -- 左键修改为 就替换到对应tag  因为主要用平铺
            c.minimized = false -- 取消最小化
            awful.tag.viewonly(c.first_tag) --切换到窗口所在屏幕
            -- 取消其他窗口的 activate {{
            local current_screen = awful.screen.focused()
            for _, cl in ipairs(current_screen.clients) do
                if cl ~= c and not cl.minimized then
                    cl:emit_signal("request::activate", "tasklist", {raise = false})
                end
            end
            c:emit_signal("request::activate", "tasklist", {raise = true}) 
            -- 重新绘制任务栏
            s.mytasklist:emit_signal("widget::redraw_needed")
            -- 将鼠标移动到激活的窗口的中心位置
          
            client.focus = c
            c:raise()
            local geo = c:geometry()
            local x = geo.x + geo.width / 2
            local y = geo.y + geo.height / 2
            mouse.coords({x = x, y = y}, true)
           
        end),
        awful.button({}, 3, function() awful.menu.client_list({theme = {width = 250}}) end), -- 右键 显示所有窗口
        awful.button({}, 4, function () awful.client.focus.byidx(1) end), --滚轮切换窗口 焦点
        awful.button({}, 5, function () awful.client.focus.byidx(-1) end) --滚轮切换窗口
        ) 


        -- Create a tasklist widget 任务栏 默认显示图标和文字
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags, -- 显示当前标签页中的任务
            filter  = awful.widget.tasklist.filter.alltags, -- 显示所有标签页中的任务
            buttons = tasklist_buttons -- 任务栏按键点击行为
        }
 -- ]]

    -- 定义点击任务栏的行为
    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function (c) -- 左键修改为 就切换到对应tag  因为主要用平铺
            c.minimized = false -- 取消最小化
            awful.tag.viewonly(c.first_tag) --切换到窗口所在屏幕
            c:emit_signal("request::activate", "tasklist", {raise = true})  -- 激活窗口
        end),
        awful.button({}, 3, function() awful.menu.client_list({theme = {width = 250}}) end), -- 右键 显示所有窗口
        awful.button({}, 4, function () awful.client.focus.byidx(1) end), --滚轮切换窗口 焦点
        awful.button({}, 5, function () awful.client.focus.byidx(-1) end) --滚轮切换窗口
        ) 
    -- 任务栏的配置
    s.mytasklist = awful.widget.tasklist {
                screen   = s,
                filter  = awful.widget.tasklist.filter.allscreen, -- awful.widget.tasklist.filter.focused
                buttons  = tasklist_buttons,  -- 按钮行为控制函数 只是鼠标的控制就好
                style    = {
                    shape_border_width = 1,
                    shape_border_color = '#555',
                    shape  = gears.shape.rounded_bar,
                },
                layout   = {
                    spacing = 5, --间隔
                    layout  = wibox.layout.flex.horizontal  -- 横向排列
                },
                widget_template = {
                    {
                        {
                            { -- 任务栏图标
                                {
                                    id     = 'icon_role',
                                    widget = wibox.widget.imagebox,
                                },
                                margins = 3, --用边距控制图标大小
                                widget  = wibox.container.margin,
                            },
                            { -- 任务栏文字
                                id     = 'text_role',
                                widget = wibox.widget.textbox,
                            },

                            layout = wibox.layout.fixed.horizontal,
                        },
                        left  = 2,
                        right = 2,
                        widget = wibox.container.margin
                    },
                    --forced_width = 10000,
                    id     = 'background_role',
                    widget          = wibox.container.background,
                    
                },


        }


        -- Create the wibox 状态栏
        -- s.mywibox = awful.wibar({ position = "bottom", screen = s })
        s.mywibox = awful.wibar({position = "top", screen = s})
        s.mywibox.opacity = 0.8 --状态栏整体透明度
        shell_pot = awful.widget.watch('echo 🔸', 3600000) -- 一个分隔符
        shell_space = awful.widget.watch('echo   -e "　" ', 3600000) --中文全角空格
        shell_weather = awful.widget.watch('bash -c "python3 ~/.config/topbar_plus/weather-plugin.py"', 1800) --天气预报
        shell_weather:buttons(gears.table.join(
            awful.button({}, 1, function() awful.spawn("xdg-open http://www.weather.com.cn/weather15d/101120802.shtml") end), -- 左键
            awful.button({}, 3, function() awful.spawn("xdg-open http://www.weather.com.cn/weather15d/101120802.shtml") end)--右键
        ))

        shell_lunarDate = awful.widget.watch('bash -c "$HOME/.env/lunarDate_plugin/bin/python ~/.config/topbar_plus/lunarDate-plugin.py"', 1) -- 农历阳历周
        shell_lunarDate:buttons(gears.table.join(
            awful.button({}, 1, function() awful.spawn("xdg-open https://wannianli.tianqi.com/") end), -- 左键
            awful.button({}, 3, function() awful.spawn("xdg-open https://wannianli.tianqi.com/") end)--右键
        ))

        local vicious = require("vicious")
        -- 监测 CPU 使用情况
        cpuwidget = wibox.widget.textbox()
        vicious.cache(vicious.widgets.cpu)
        vicious.register(cpuwidget, vicious.widgets.cpu, "CPU: <span foreground='#20B2AA'> $1% </span>", 13)

        memwidget = wibox.widget.textbox()
        vicious.cache(vicious.widgets.mem)
        vicious.register(memwidget, vicious.widgets.mem, "内存: <span foreground='#20B2AA'> $1% </span>", 13)

        -- 托盘
        mysystray = wibox.widget.systray()
        --mysystray.forced_width =50
        --mysystray.forced_height=10
        -- 直接用 forced_width 会导致图标多的时候图标太小，forced_height貌似无效，所以下面把托盘放到容器里面，控制容器边距变相修改托盘大小
        local mysystray_container = wibox.container.margin(mysystray, 0, 0, 4, 5) -- 设置容器的边距  [, left[, right[, top[, bottom[, color[, draw_empty]]]]]]

        -- 音量
        volume_widget = wibox.widget.textbox()
        --awful.widget.watch('bash -c "LANG=en_US.utf8 &&  pactl list sinks | grep \'front-left\' &&  pactl list sinks | grep \'Mute:\' "', 1, function(widget, stdout)
        awful.widget.watch('bash -c "LANG=en_US.utf8 && pactl list sinks | grep -E \'front-left|Mute:\'" ', 1, function(widget, stdout)
            -- 从输出中获取音量信息
            local volume = string.match(stdout, "(%d+)%%")
            -- 从输出中获取静音状态信息
            local mute = string.match(stdout, "Mute: (%a+)")
            -- 更新文本框内容
            local text = ' 🔈<span foreground="#20B2AA">' .. volume .. '</span> %'
            if mute == "yes" then
                text = ' 🔇<span foreground="#ce2605">' .. volume .. '</span> %'
            end
            widget:set_markup(text) -- widget:set_text(text)
        end, volume_widget)
        -- 音量 按键操作
        volume_widget:buttons(gears.table.join(
            awful.button({}, 1, function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end), -- 左键静音
            awful.button({}, 3, function() awful.spawn("pavucontrol") end), --右键打开 面板
            awful.button({}, 4, function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%") end), -- 向上滚动增大音量 另外绑定键盘的 音量键在 音量控制 那边
            awful.button({}, 5, function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -1%") end)-- 向下滚动减小音量
        ))

        -- 滚轮事件处理
        volume_widget:connect_signal("button::scroll_up", function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
        end)

        volume_widget:connect_signal("button::scroll_down", function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
        end)

        -- Add widgets to the wibox 状态栏布局 排序 全局标题栏
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            {-- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            {-- Right widgets
                layout = wibox.layout.fixed.horizontal,
                cpuwidget, memwidget,
                shell_pot,
                shell_weather,
                shell_pot,
                shell_lunarDate,
                shell_space,
                mytextclock,
                shell_pot,
                volume_widget,
                shell_space,
                --mykeyboardlayout,
                --  wibox.widget.systray(),
                mysystray_container,
                shell_space,
                mylayoutbox,
            },
        }
    end)
    -- }}}

    -- {{{ Mouse bindings  这里是屏幕空白地方的鼠标操作
    root.buttons(gears.table.join(
        awful.button({}, 3, function () mymainmenu:toggle() end),   --右键打开主菜单
        awful.button({}, 4, awful.tag.viewnext), -- 滚轮切换标签 不是窗口
    awful.button({}, 5, awful.tag.viewprev))) -- 滚轮切换标签
    -- }}}

    -- {{{ Key bindings  按键绑定
    globalkeys = gears.table.join(
        awful.key({modkey, }, "s", hotkeys_popup.show_help,
        {description = "show help 显示快捷键", group = "awesome"}),

        awful.key({modkey, }, "Left", awful.tag.viewprev,   --切换标签
        {description = "view previous 切换标签", group = "tag"}), 
        awful.key({modkey, }, "Right", awful.tag.viewnext,
        {description = "view next 切换标签", group = "tag"}),  --切换标签
        awful.key({modkey, }, "Escape", awful.tag.history.restore,  --返回标签
        {description = "go back 返回标签", group = "tag"}),

        awful.key({modkey, }, "j",  -- 切换 窗口焦点
            function ()
                awful.client.focus.byidx(1)
            end,
        {description = "focus next by index 切换 窗口焦点", group = "client"}),
        awful.key({modkey, }, "k",  -- 切换 窗口焦点
            function ()
                awful.client.focus.byidx(-1)
            end,
        {description = "focus previous by index 切换 窗口焦点", group = "client"}),

        awful.key({modkey, }, "w", function () mymainmenu:show() end, -- 显示主菜单
        {description = "show main menu 显示主菜单", group = "awesome"}),

        -- Layout manipulation
        awful.key({modkey, "Shift"}, "j", function () awful.client.swap.byidx(1) end,  -- 移动窗口位置
        {description = "swap with next client by index", group = "client"}),
        awful.key({modkey, "Shift"}, "k", function () awful.client.swap.byidx(-1) end, -- 移动窗口位置
        {description = "swap with previous client by index", group = "client"}),
        
        awful.key({modkey, "Control"}, "j", function () awful.screen.focus_relative(1) end,
        {description = "focus the next screen", group = "screen"}),
        awful.key({modkey, "Control"}, "k", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),
        awful.key({modkey, }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),
        awful.key({modkey, }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
        {description = "go back", group = "client"}),

        -- Standard program
        --awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
        awful.key({modkey, }, "Return", function () awful.spawn("alacritty") end,
        {description = "open a terminal 打开终端", group = "launcher"}),
        awful.key({modkey, "Control"}, "r", awesome.restart, --保留awesome的 win ctrl+r 配置出错的时候 只能用这个快捷键重载
        {description = "reload awesome 重载aw", group = "awesome"}),
        awful.key({modkey, "Shift"}, "s", awesome.restart, --和i3一致方便过度
        {description = "reload awesome 重载aw", group = "awesome"}),
        --awful.key({ modkey, "Shift"   }, "q", awesome.quit,
        ---          {description = "推出 awesome ", group = "awesome"}),
        -- 推出 awesome awful.prompt
        -- awful.key({ modkey, "Shift" }, "e", function()
        -- awful.prompt.run {
        --     prompt = "确定要退出 Awesome WM 吗？ (y/n): ",
        --     textbox = awful.screen.focused().mypromptbox.widget,
        --     exe_callback = function(answer)
        --         if answer == "y" then
        --             awesome.quit()
        --         end
        --     end
        -- }
        -- end, { description = "退出 Awesome WM", group = "awesome" })
        -- 推出 awesome ，用naughty.notify
        --awful.key({ modkey, "Shift" }, "e", function()
        --   naughty.notify({
        --        text = "　　　确定要退出 Awesome WM 吗？　　\n　　如果要推出输入y,不推出按下esc正常操作　　",
        --       timeout = 3,
        --       position = "bottom_right",
        --        bg = "#FF0000",
        --        fg = "#FFFFFF",
        --        font = "sans 25"
        --    })
        --   awful.prompt.run {
        --       prompt = "",
        --       textbox = awful.screen.focused().mypromptbox.widget,
        --        exe_callback = function(answer)
        --            if answer == "y" then
        --                awesome.quit()
        --            end
        --        end
        --    }
        --end, { description = "确定退出 Awesome WM", group = "awesome" }),
        -- 和i3 一致  推出 awesome
        -- 依赖 zenity
        awful.key({modkey, "Shift"}, "e", function()
            local command = "zenity --question --text '确定要退出 Awesome WM 吗？' --no-wrap --title '亲爱哒'"
            awful.spawn.easy_async_with_shell(command, function(_, _, _, exit_code)
                if exit_code == 0 then
                    awesome.quit()
                end
            end)
        end, {description = "确定退出 Awesome WM", group = "awesome"}),

        awful.key({modkey, }, "l", function () awful.tag.incmwfact(0.05) end,
        {description = "increase master width factor", group = "layout"}),
        awful.key({modkey, }, "h", function () awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}),
        awful.key({modkey, "Shift"}, "h", function () awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),
        awful.key({modkey, "Shift"}, "l", function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),
        awful.key({modkey, "Control"}, "h", function () awful.tag.incncol(1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}),
        awful.key({modkey, "Control"}, "l", function () awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}),
        awful.key({modkey, }, "space", function () awful.layout.inc(1) end,
        {description = "select next", group = "layout"}),
        awful.key({modkey, "Shift"}, "space", function () awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}),

        awful.key({modkey, "Control"}, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    c:emit_signal(
                    "request::activate", "key.unminimize", {raise = true})
                end
            end,
        {description = "restore minimized", group = "client"}),

        -- Prompt

        awful.key({modkey, "Shift"}, "Return", function () awful.spawn("rofi -show drun") end,
        {description = "rofi -show drun 启动器", group = "launcher"}),

        awful.key({modkey}, "Tab", function () awful.spawn("rofi -show window") end,
        {description = "rofi -show window 窗口切换", group = "launcher"}),
        awful.key({modkey}, "p", function () awful.spawn("/usr/bin/flameshot gui ") end,
        {description = "flameshot gui 截图 ", group = "launcher"}),
        awful.key({modkey}, "e", function () awful.spawn("pcmanfm ") end,
        {description = "pcmanfm 文件管理器 ", group = "launcher"}),

        -- 运行命令  这个用rofi替代掉
        -- awful.key({ modkey ,"Shift","Alt"},            "r",     function () awful.screen.focused().mypromptbox:run() end,
        --           {description = "run prompt此功能关闭", group = "launcher"}),
        -- 运行lua代码  不需要
        -- awful.key({ modkey ,"Shift" ,"Alt" }, "x",
        --           function ()
        --               awful.prompt.run {
        --                 prompt       = "Run Lua code: ",
        --                 textbox      = awful.screen.focused().mypromptbox.widget,
        --                 exe_callback = awful.util.eval,
        --                history_path = awful.util.get_cache_dir() .. "/history_eval"
        --              }
        --          end,
        --         {description = "lua execute prompt此功能关闭", group = "awesome"}),

        -- 音量控制


        awful.key({}, "XF86AudioRaiseVolume", function() os.execute("pactl set-sink-volume @DEFAULT_SINK@ +5%") end,
        {description = "volume up", group = "hotkeys"}),
        awful.key({}, "XF86AudioLowerVolume", function() os.execute("pactl set-sink-volume @DEFAULT_SINK@ -5%") end,
        {description = "volume down", group = "hotkeys"}),
        awful.key({}, "XF86AudioMute", function() os.execute("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
        {description = "toggle mute", group = "hotkeys"})

        -- Menubar 应用程序菜单 不需要，rifo 以及右键菜单以及右上角 mylauncher = awful.widget.launcher 都可以搞定
        --awful.key({ modkey  ,"Shift"}, "p", function() menubar.show() end,
        --          {description = "show the menubar 应用程序菜单", group = "launcher"})

    )

    clientkeys = gears.table.join(
        awful.key({modkey, }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
        {description = "toggle fullscreen全屏", group = "client"}),
        --awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
        awful.key({modkey, "Shift"}, "q", function (c) c:kill() end,
        {description = "close关闭窗口", group = "client"}),
        awful.key({modkey, "Control"}, "space", awful.client.floating.toggle,
        {description = "toggle floating浮动", group = "client"}),
        awful.key({modkey, "Control"}, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master主区域", group = "client"}),
        awful.key({modkey, }, "o", function (c) c:move_to_screen() end,
        {description = "move to screen", group = "client"}),
        awful.key({modkey, }, "t", function (c) c.ontop = not c.ontop end,
        {description = "toggle keep on top", group = "client"}),

        -- 隐藏和显示标题栏
        awful.key({modkey, "Shift"}, "b", function (c) awful.titlebar.toggle(c) end,
        {description = "Show/Hide Titlebars隐藏和显示标题栏", group = "client"}),

        awful.key({modkey, }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end,
        {description = "minimize最小化", group = "client"}),
        awful.key({modkey, }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end,
        {description = "(un)maximize", group = "client"}),
        awful.key({modkey, "Control"}, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
        {description = "(un)maximize vertically", group = "client"}),
        awful.key({modkey, "Shift"}, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
        {description = "(un)maximize horizontally", group = "client"}))

        -- Bind all key numbers to tags.
        -- Be careful: we use keycodes to make it work on any keyboard layout.
        -- This should map on the top row of your keyboard, usually 1 to 9.
        for i = 1, 9 do
            globalkeys = gears.table.join(globalkeys,
                -- View tag only 切换桌面
                awful.key({modkey}, "#" .. i + 9,
                    function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            tag:view_only()
                        end
                    end,
                {description = "view tag #"..i, group = "tag"}),
                -- Toggle tag display.合并两个桌面的窗口
                awful.key({modkey, "Control"}, "#" .. i + 9,
                    function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end,
                {description = "toggle tag #" .. i, group = "tag"}),
                -- Move client to tag. 移动窗口到桌面x
                awful.key({modkey, "Shift"}, "#" .. i + 9,
                    function ()
                        if client.focus then
                            local tag = client.focus.screen.tags[i]
                            if tag then
                                client.focus:move_to_tag(tag)
                            end
                        end
                    end,
                {description = "move focused client to tag #"..i, group = "tag"}),
                -- Toggle tag on focused client. 窗口同时显示到桌面x
                awful.key({modkey, "Control", "Shift"}, "#" .. i + 9,
                    function ()
                        if client.focus then
                            local tag = client.focus.screen.tags[i]
                            if tag then
                                client.focus:toggle_tag(tag)
                            end
                        end
                    end,
                {description = "toggle focused client on tag #" .. i, group = "tag"}))
            end
            -- 窗口的点击事件
            clientbuttons = gears.table.join(
                awful.button({}, 1, function (c)
                    c:emit_signal("request::activate", "mouse_click", {raise = true}) --鼠标左键单击：激活该窗口（如果没有激活），并将其置于顶层。
                end),
                awful.button({modkey}, 1, function (c)
                    c:emit_signal("request::activate", "mouse_click", {raise = true}) -- Mod 键 + 鼠标左键单击：激活该窗口，并开始移动窗口位置。
                    awful.mouse.client.move(c)
                end),
                awful.button({modkey}, 3, function (c)
                    c:emit_signal("request::activate", "mouse_click", {raise = true}) -- Mod 键 + 鼠标右键单击：激活该窗口，并开始改变窗口大小。
                    awful.mouse.client.resize(c)
                end))

                -- Set keys
                root.keys(globalkeys)
                -- }}}

                -- {{{ Rules
                -- Rules to apply to new clients (through the "manage" signal).
                -- 规则
                awful.rules.rules = {
                    -- All clients will match this rule.
                    {rule = {},
                        properties = {border_width = beautiful.border_width,
                            border_color = beautiful.border_normal,
                            focus = awful.client.focus.filter,
                            raise = true,
                            keys = clientkeys,
                            buttons = clientbuttons,
                            screen = awful.screen.preferred,
                            placement = awful.placement.no_overlap + awful.placement.no_offscreen
                        }},
                        -- Floating clients. 内置的自动浮动规则
                        {rule_any = {
                            instance = {
                                "DTA", -- Firefox addon DownThemAll.
                                "copyq", -- Includes session name in class.
                                "pinentry",
                            },
                            class = {
                                "Arandr",
                                "Blueman-manager",
                                "Gpick",
                                "Kruler",
                                "MessageWin", -- kalarm.
                                "Sxiv",
                                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                                "Wpa_gui",
                                "veromix",
                            "xtightvncviewer"},

                            -- Note that the name property shown in xprop might be set slightly after creation of the client
                            -- and the name shown there might not match defined rules here.
                            name = {
                                "Event Tester", -- xev.
                            },
                            role = {
                                "AlarmWindow", -- Thunderbird's calendar.
                                "ConfigManager", -- Thunderbird's about:config.
                                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
                            }}, properties = {floating = true}},

                            -- Add titlebars to normal clients and dialogs 标题栏
                            {rule_any = {type = {"normal", "dialog"}}, properties = {titlebars_enabled = true}},

                            --  xprop|grep CLASS  自动隐藏标题栏的软件 无标题栏
                            {rule_any = {
                                class = {
                                    "Sublime_text", "Geany", "Code",
                                    "Plank",
                                    "QQ", "TelegramDesktop",
                                    "Chromium", "Google-chrome", "Firefox-esr",
                                    "Microsoft-edge",
                                    "org.remmina.Remmina",
                                    "another-redis-desktop-manager",
                                    "Thonny",
                                "Thunar"},
                            }, properties = {titlebars_enabled = false}},
                            --  xprop|grep CLASS  强制默认平铺
                            {rule_any = {
                                class = {
                                    "Microsoft-edge",
                                },
                            }, properties = {floating = false}},
                            --  xprop|grep CLASS  自动浮动的软件 但不控制窗口位置
                            {rule_any = {
                                class = {
                                    "Plank", "tint2", "Tint2"
                                },
                            }, properties = {floating = true}},
                            --  xprop|grep CLASS  自动浮动的软件 并居中显示
                            {rule_any = {
                                name={"图片查看器"},
                                class = {
                                    "Pavucontrol", "fcitx5-config-qt", "Tint2conf"
                                },
                            }, properties = {floating = true, placement = awful.placement.centered}

                        },
                    }
                    -- }}}

                    -- {{{ Signals
                    -- Signal function to execute when a new client appears.
                    client.connect_signal("manage", function (c)
                        -- Set the windows at the slave,
                        -- i.e. put it at the end of others instead of setting it master.
                        -- if not awesome.startup then awful.client.setslave(c) end

                        if awesome.startup
                            and not c.size_hints.user_position
                            and not c.size_hints.program_position then
                            -- Prevent clients from being unreachable after screen count changes.
                            awful.placement.no_offscreen(c)
                        end
                    end)

                    -- Add a titlebar if titlebars_enabled is set to true in the rules.
                    client.connect_signal("request::titlebars", function(c)
                        -- buttons for the titlebar
                        local buttons = gears.table.join(
                            awful.button({}, 1, function()
                                c:emit_signal("request::activate", "titlebar", {raise = true})
                                awful.mouse.client.move(c)
                            end),
                            awful.button({}, 3, function()
                                c:emit_signal("request::aRctivate", "titlebar", {raise = true})
                                awful.mouse.client.resize(c)
                            end))
                            -- 窗口的标题栏配置
                            awful.titlebar(c) : setup {
                                {-- Left
                                    awful.titlebar.widget.iconwidget(c),
                                    buttons = buttons,
                                    layout = wibox.layout.fixed.horizontal
                                },
                                {-- Middle
                                    {-- Title
                                        align = "center",
                                    widget = awful.titlebar.widget.titlewidget(c)},
                                    buttons = buttons,
                                    layout = wibox.layout.flex.horizontal
                                },
                                {-- Right 标题右侧
                                    awful.titlebar.widget.floatingbutton (c),
                                    awful.titlebar.widget.maximizedbutton(c),
                                    awful.titlebar.widget.stickybutton (c),
                                    awful.titlebar.widget.ontopbutton (c),
                                    awful.titlebar.widget.closebutton (c),
                                layout = wibox.layout.fixed.horizontal()},
                                layout = wibox.layout.align.horizontal,
                                -- 默认隐藏标题栏 此代码会覆盖掉前面rule中的配置
                                --awful.titlebar.hide(c)
                            }
                        end)

                        -- Enable sloppy focus, so that focus follows mouse.
                        client.connect_signal("mouse::enter", function(c)
                            c:emit_signal("request::activate", "mouse_enter", {raise = false})
                        end)

                        client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
                        client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
                        -- }}}

                       