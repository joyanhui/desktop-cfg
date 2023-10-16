import requests

REQ = requests.get("https://v0.yiketianqi.com/free/day?appid=31186598&appsecret=bny9jbCV&unescape=1&cityid=101120801")
try:
    if REQ.status_code == 200:
        wea=REQ.json()["wea"]
        tem=REQ.json()["tem"]
        tem_day=REQ.json()["tem_day"]
        tem_night=REQ.json()["tem_night"]
        win=REQ.json()["win"]
        win_meter=REQ.json()["win_meter"]
        win_speed=REQ.json()["win_speed"]
        air=REQ.json()["air"]
        pressure=REQ.json()["pressure"] #气压
        humidity=REQ.json()["humidity"]
        print("{},{}°C {}/{}°C,{}{} {}, {}/{}".format(wea,  tem,tem_day,tem_night,win,win_speed,win_meter,air,humidity))
    else:
        print("yiketianqi: BAD HTTP STATUS CODE ")
except:
    print("yiketianqi: Unable print the data")
