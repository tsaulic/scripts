#!/usr/bin/env python


"""
   Ridiculous little tool for checking whether a Quake Live
   nickname is available or not.
"""


import sys

try:
    import requests
    from blessings import Terminal
except ImportError:
    sys.exit("Module doesn't exist. Install via: $pip install <module-name>")


TERM = Terminal()


def check_name(args):
    """Grabs a list of names to check availability for and returns
       the result.
    """
    server = "http://www.quakelive.com/register/verify/nametag"
    headers = {'content-type': 'application/x-www-form-urlencoded',
               'X-Requested-With': 'XMLHttpRequest'}
    for arg in args:
        payload = "value=" + args[args.index(arg)]
        request = requests.post(server, data=payload, headers=headers)
        if '"ECODE":0,"MSG":"OK"' in request.text:
            print args[args.index(arg)], ": " \
                + TERM.bold_bright_green_on_black("OK!")
        elif '"ECODE":-1,"MSG":"Name tag already in use"' in request.text:
            print args[args.index(arg)], ": " \
                + TERM.bold_red_on_black("TAKEN!")
        elif '"ECODE":-1,"MSG":"Restricted name tag"' in request.text:
            print args[args.index(arg)], ": " \
                + TERM.bold_red_on_black("NOT ALLOWED/RESTRICTED")
        else:
            print args[args.index(arg)], ": " \
                + TERM.bold_red_on_black("FATAL ERROR")


if __name__ == "__main__":
    if len(sys.argv[1:]) < 1:
        print TERM.bold_red_on_black("Please provide some nicknames!")
    else:
        check_name(sys.argv[1:])
