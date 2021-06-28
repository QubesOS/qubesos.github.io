#!/usr/bin/python3

import argparse
import os
import sys

parser = argparse.ArgumentParser()
parser.add_argument('lang')
parser.add_argument('translation_dir')
parser.add_argument('tx_mapping')

def main():
    args = parser.parse_args()
    
    valid_files = set()
    with open(args.tx_mapping) as f_mapping:
        for line in f_mapping.readlines():
            if line.startswith('file_filter = '):
                valid_files.add(line.strip().split(' = ')[1].replace('<lang>', args.lang))

    if not valid_files:
        print('No files found in {}, aborting!'.format(args.tx_mapping))
        return 1

    existing_files = set()
    for dirpath, dirs, files in os.walk(args.translation_dir):
        existing_files.update(os.path.join(dirpath, name) for name in files)

    if not existing_files:
        print('No files found in {}, aborting!'.format(args.translation_dir))
        return 1

    for obsolete in existing_files.difference(valid_files):
        print('Removing {}'.format(obsolete))
        os.unlink(obsolete)


if __name__ == '__main__':
    sys.exit(main())

