# -*- coding:utf-8 -*-
from zhdate import ZhDate
from datetime import datetime


def get_chinese_traditional_calendar(date=None):
    """
    :param date: none = now day.
    :return:
    """
    if date:
        year, month, day = int(date[:4]), int(date[4:6]), int(date[6:])
    else:
        now = str(datetime.now().strftime('%Y-%m-%d')).split("-")
        year, month, day = int(now[0]), int(now[1]), int(now[2])

    return ZhDate.from_datetime(datetime(year, month, day))


def get_difference_days(date1, date2=None):
    """
    :param date1:
    :param date2: none = now day
    :return:
    """
    if date2:
        year1, month1, day1 = int(date1[:4]), int(date1[4:6]), int(date1[6:])
        year2, month2, day2 = int(date2[:4]), int(date2[4:6]), int(date2[6:])
    else:
        now = str(datetime.now().strftime('%Y-%m-%d')).split("-")
        year1, month1, day1 = int(date1[:4]), int(date1[4:6]), int(date1[6:])
        year2, month2, day2 = int(now[0]), int(now[1]), int(now[2])
        date2 = f"{year2}{month2}{day2}"

    one_day = datetime(year2, month2, day2)
    other_day = datetime(year1, month1, day1)
    difference = abs(one_day.toordinal() - other_day.toordinal())
    print(f'{date1} 距离 {date2} 相差 {difference} 天')
    return difference


def get_difference_chinese_calendar(gc_date, lc_date):
    """
    :param gc_date: the gregorian calendar 公历
    :param lc_day: the lunar calendar 农历
    :return:
    """
    year1, month1, day1 = int(gc_date[:4]), int(gc_date[4:6]), int(gc_date[6:])
    year2, month2, day2 = int(lc_date[:4]), int(lc_date[4:6]), int(lc_date[6:])
    gc_day = datetime(year1, month1, day1)

    lc_day = ZhDate(year2, month2, day2).to_datetime()
    difference = lc_day.toordinal() - gc_day.toordinal()
    print(f'公历 {gc_date} 距离 农历 {lc_date} 相差 {abs(difference)} 天')
    return difference


if __name__ == '__main__':
    # 当前日期对应的农历日期
    date1 = get_chinese_traditional_calendar()
    current_year = datetime.now().year
    lunar_date_str = str(date1)
    lunar_date_str = lunar_date_str.replace("农历{}年".format(current_year), "")
    # 阳历日期
    formatted_yldate = datetime.now().strftime('%Y-%m-%d')
    print(formatted_yldate+" "+lunar_date_str)

    #print(date1)
    #print(date1.replace("农历{}年".format(datetime.now().year), ""))
    #print(date1.chinese())

    # 指定日期对应的农历日期
    #date2 = get_chinese_traditional_calendar("20220328")
    #print(date2)
   # print(date2.chinese())

    # 公历日期相差
   # get_difference_days("20220511")
    #get_difference_days("20220327", "20221001")

    # 公历距离农历相差
   # get_difference_chinese_calendar("20220327", "20220303")  # 距离农历三月三
    #get_difference_chinese_calendar("20220327", "20220505")  # 距离端午节
   # get_difference_chinese_calendar("20220327", "20220815")  # 距离中秋节
    #get_difference_chinese_calendar("20220327", "20220909")  # 距离重阳节
    #get_difference_chinese_calendar("20220327", "20230101")  # 距离春节
