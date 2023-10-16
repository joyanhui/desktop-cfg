-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------



local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Main
local theme = {}

theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/my-zenburn"

-- 默认壁纸
theme.wallpaper = theme.dir  .. "zenburn/zenburn-background.png"
-- }}}

-- {{{ Styles
--theme.font      = "sans 8"
--theme.font      ="JetBrains Mono:style=Regular 9"
theme.font      = "sans 9"

-- {{{ Colors
theme.bg_normal                                 = "#32302f"
theme.fg_normal                                 = "#a89984"
theme.bg_focus                                  = "#32302f"
theme.fg_focus                                  = "#232323"
theme.bg_urgent                                 = "#C92132"
theme.fg_urgent                                 = "#282828"


theme.fg_widget                                 = "#32302f"

theme.bg_systray = theme.bg_normal
-- }}}




-- 工作区颜色
-- 当前工作区
theme.taglist_bg_focus                          = "#ffb52a" 
theme.taglist_fg_focus                          = "#282828"
-- 后台工作区
theme.taglist_bg_occupied                       = "#b6a49b"
theme.taglist_fg_occupied                       = "#282828"
-- 空的工作区
theme.taglist_bg_empty                          = "#32302f"
theme.taglist_fg_empty                          = "#ebdbb2"
-- 有消息的 或者有新窗口
theme.taglist_bg_urgent                         = theme.bg_urgent 
theme.taglist_fg_urgent                         = theme.fg_urgent 

-- 任务栏
theme.tasklist_bg_normal                        = "#32302f"
theme.tasklist_fg_normal                        = "#ebdbb2"
theme.tasklist_bg_focus                         = "#32302f"
theme.tasklist_fg_focus                         = "#ebdbb2"
theme.tasklist_bg_urgent                        = "#C92132"
theme.tasklist_fg_urgent                        = "#32302f"


-- {{{ Borders  窗口边框
-- 窗口间隙
theme.useless_gap   = dpi(1)
--窗口边框
theme.border_width                              = dpi(0)
theme.border_normal                             = "#32302f"
theme.border_focus                              = "#3f3f3f"
theme.border_marked                             = "#CC9393"

-- }}}

-- {{{ Titlebars 窗口标题\

theme.titlebar_bg_normal                        = "#222222"
theme.titlebar_fg_normal                        = "#999999"

theme.titlebar_bg_focus                         = "#262626" -- 活跃窗口 标题背景
theme.titlebar_fg_focus                         = "#FFFFFF"-- 活跃窗口 标题字体

theme.titlebar_bg_focus_opacity = 0.5


-- }}}



-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu 菜单
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(24)
theme.menu_width  = dpi(140)

theme.menu_fg_normal = "#FFFFFF"  -- 正常状态的前景色
theme.menu_bg_normal = "#000000"  -- 正常状态的背景色
theme.menu_fg_focus = "#282828"   -- 获得焦点时的前景色
theme.menu_bg_focus = "#ffb52a"   -- 获得焦点时的背景色
-- }}}

-- 消息
theme.notification_font                         = "sans 8"
theme.notification_bg                           = theme.bg_normal
theme.notification_fg                           = theme.fg_normal
theme.notification_border_width                 = 0
theme.notification_border_color                 = theme.bg_normal
theme.notification_opacity                      = 1
theme.notification_margin                       = 30

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.dir  .. "zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = theme.dir  .. "zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
-- theme.awesome_icon           = theme.dir  .. "/awesome-icon.png"
theme.awesome_icon           = theme.dir  .. "/brackets.svg"
theme.menu_submenu_icon      = theme.dir  .. "/submenu.png"
--theme.awesome_icon                              = theme.dir  .. "/icons/awesome.png"
--theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"


-- }}}

-- {{{ Layout
theme.layout_tile       = theme.dir  .. "/layouts/tile.png"
theme.layout_tileleft   = theme.dir  .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.dir  .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.dir  .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.dir  .. "/layouts/fairv.png"
theme.layout_fairh      = theme.dir  .. "/layouts/fairh.png"
theme.layout_spiral     = theme.dir  .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.dir  .. "/layouts/dwindle.png"
theme.layout_max        = theme.dir  .. "/layouts/max.png"
theme.layout_fullscreen = theme.dir  .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.dir  .. "/layouts/magnifier.png"
theme.layout_floating   = theme.dir  .. "/layouts/floating.png"
theme.layout_cornernw   = theme.dir  .. "/layouts/cornernw.png"
theme.layout_cornerne   = theme.dir  .. "/layouts/cornerne.png"
theme.layout_cornersw   = theme.dir  .. "/layouts/cornersw.png"
theme.layout_cornerse   = theme.dir  .. "/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.dir  .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir  .. "/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = theme.dir  .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = theme.dir  .. "/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = theme.dir  .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir  .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.dir  .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir  .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.dir  .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir  .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir  .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir  .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.dir  .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir  .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.dir  .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir  .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.dir  .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir  .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir  .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir  .. "/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
