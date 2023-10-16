# desktop-cfg



- i3
- openbox
- wayfire
- waybar
- polybar
- 同时兼容waybar polybar awesome的天气和农历
- dunst
- ksnip
- rofi
- Thunar
- PCManFM
- user-dirs.local


## 依赖情况

### 天气和农历 基于pythone3
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