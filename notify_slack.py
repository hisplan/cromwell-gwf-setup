#!/usr/bin/env python

import argparse
from urllib import request, parse


def send(hook_key, message):

    url = "https://hooks.slack.com/services/{}".format(hook_key)

    data = "payload={'channel': '#scatac', 'username': 'jaeyoung-bot', 'text': '" + \
        message + "', 'icon_emoji': ':robot_face:'}"
    data = data.encode()

    req = request.Request(url, data=data)
    response = request.urlopen(req)
    
    print(response.read().decode())


def parse_arguments():

    parser = argparse.ArgumentParser(description='notify_slack')

    parser.add_argument(
        "--hook-key",
        action="store",
        dest="hook_key",
        required=True
    )

    parser.add_argument(
        "--message",
        action="store",
        dest="message",
        required=True
    )

    # parse arguments
    params = parser.parse_args()

    return params


if __name__ == "__main__":

    params = parse_arguments()

    send(
        params.hook_key,
        params.message
    )

