import argparse
import time

from datetime import date


def is_login(s):
    return len(s.split(" ")) > 3


def get_weekday(n):
    if n == 0:
        return "Mon"
    elif n == 1:
        return "Tue"
    elif n == 2:
        return "Wed"
    elif n == 3:
        return "Thu"
    elif n == 4:
        return "Fri"
    elif n == 5:
        return "Sat"
    elif n == 6:
        return "Sun"


def get_date(s):
    if is_login(s):
        return s.split(" ")[2]
    else:
        return s.split(" ")[1]


def get_year(s):
    return get_date(s).split("-")[0]


def get_month(s):
    return get_date(s).split("-")[1]


def get_day(s):
    return get_date(s).split("-")[2]


def get_time(s):
    if is_login(s):
        return s.split(" ")[3]
    else:
        return s.split(" ")[2]


def get_hour(s):
    return get_time(s).split(":")[0]


def get_minute(s):
    return get_time(s).split(":")[1]


def get_second(s):
    return get_time(s).split(":")[2]


def get_strptime_date(s):
    return get_year(s) + " " + get_month(s) + " " + get_day(s)


def get_strptime_time(s):
    return get_hour(s) + " " + get_minute(s) + " " + get_second(s)


def get_strptime(s):
    return get_strptime_date(s) + " " + get_strptime_time(s)


def get_epoch(s):
    return time.mktime(time.strptime(get_strptime(s), "%Y %m %d %H %M %S"))


def format_log(s):
    if is_login(s):
        r = "login  "
    else:
        r = "logout "

    r += get_weekday(date.fromtimestamp(get_epoch(s)).weekday())
    r += " " + get_month(s) + "/" + get_day(s) + "/" + get_year(s)
    r += " " + get_hour(s) + ":" + get_minute(s) + ":" + get_second(s)

    return r


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("unlocks")
    parser.add_argument("locks")

    args = parser.parse_args()
    logs = args.unlocks.split("\n") + args.locks.split("\n")

    logs.sort(key=get_epoch)

    for l in logs:
        print(format_log(l))


if __name__ == '__main__':
    main()
