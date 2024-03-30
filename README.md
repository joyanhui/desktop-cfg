# 迁移到 nixos
私有仓库 [https://github.com/joyanhui/nixos-config/](https://github.com/joyanhui/nixos-config/)  这里不在维护
# desktop-cfg

- i3
- openbox
- wayfire
- waybar
- polybar
- 同时兼容waybar polybar awesome的天气和农历
- dunst
- ksnip
- rofi 后续可能会去掉
- Thunar 后续可能会去掉
- PCManFM
- tint2 plank 后续可能会去掉
- user-dirs.local


## 依赖情况

### 天气和农历 基于python3
```
sudo apt-get install -y python3-requests
sudo apt-get install -y python3.11-venv
mkdir -p $HOME/.env
rm -rf $HOME/.env/lunarDate_plugin
python3 -m venv $HOME/.env/lunarDate_plugin
$HOME/.env/lunarDate_plugin/bin/python -m pip install zhdate -i https://mirrors.aliyun.com/pypi/simple/
```
### PCManFM 和 Thunar
目前主要用PCManFM 
```
apt install pcmanfm 
apt install  lxappearance # GTK+ 主题更换工具
apt install gvfs gvfs-fuse udisks  sshfs #挂载 回收站
apt install libgsf-1-common #office缩略图
apt install ffmpegthumbnailer #视频缩略图
apt install evince #pdf缩略图

```

### 更新记录
- 2023 10 19 awesome 多处完善
    - 去掉dock类( plank 和 tint2)的依赖
    - 完善 tasklist 
        - 自定义模板 在bar位置空闲显示图标和尽可能详细的标题文字 在窗口较多的时候自动改为仅显示图标，并根据屏幕空间缩小图标大小
        - 微调颜色和间隙
    - 增加 taglist 间隙为dpi(1),无窗口的空闲屏幕背景色改为透明色 微调字体颜色
- 2023 10 18 去掉polybar自带的日期和时间
