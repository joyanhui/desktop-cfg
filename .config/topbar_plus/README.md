

天气
```
sudo apt-get install -y python3-requests
```

农历
```
apt-get install -y python3.11-venv
mkdir -p $HOME/.env
rm -rf $HOME/.env/lunarDate_plugin
python3 -m venv $HOME/.env/lunarDate_plugin
$HOME/.env/lunarDate_plugin/bin/python -m pip install zhdate -i https://mirrors.aliyun.com/pypi/simple/

```