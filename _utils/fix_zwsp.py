#!/usr/bin/python3 -O

import sys


def main():
    for filename in sys.argv[1:]:
        with open(filename, 'r+') as file:
            data = file.read()
            data = data.replace('\u200b', '')
            file.seek(0)
            file.truncate()
            file.write(data)

if __name__ == '__main__':
    main()
