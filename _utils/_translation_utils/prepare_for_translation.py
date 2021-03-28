#!/usr/bin/python3
'''
this script adds lang and ref attribute (starting from counter) to existing markdown files after permalink line recursively from a given root dir
invocation: python prepare_for_translation.py en _doc/ ref_counter_file
param1 is the language in short form
param2 is a directory or a single file
param3 is a file containing the value of the current reference counter with exactly onle line in the form of:
current counter: x
'''
from io import open as iopen
from os.path import isfile
import os
from sys import exit
from argparse import ArgumentParser
from frontmatter import Post, load, dump
from logging import basicConfig, getLogger, DEBUG, Formatter, FileHandler


PERMALINK_KEY = 'permalink'
REDIRECT_KEY = 'redirect_from'
LANG_KEY = 'lang'
REF_KEY = 'ref'
FILENAME_EXTENSIONS = ['.png', '.svg', '.ico', '.jpg', '.css', '.scss', '.js', '.yml', '.sh', '.py', '.sed', '.dia', '.pdf', '.gif', '.eot', '.woff', '.ttf', '.otf', '.woff2', '.sig', '.json']

def read_counter(counterfile):
    if not isfile(counterfile):
        print('check your files')
        exit()
    with iopen(counterfile,'r') as c:
        counter_line = c.readline()
        counter_a = counter_line.split('current counter: ')
    return int(counter_a[1])

def write_counter_to_file(counter, counterfile):
    if not isfile(counterfile):
        print('check your files')
        exit()
    with iopen(counterfile,'w') as c:
        counter_line ='current counter: ' + str(counter)
        c.writelines(counter_line)
        c.truncate()

def check_file_name(file_name):
    return file_name[0] == '.' or any([file_name.endswith(t) for t in FILENAME_EXTENSIONS]) == True

def check_dir_name(dir_name):
    return dir_name[0] == '.' or '/.' in dir_name


def main(root_dir, lang, counter):
    # if this is only a file
    if os.path.isfile(root_dir):
        if not check_file_name(root_dir):
            with iopen(root_dir) as fp:
                md = load(fp)
                if not md.metadata:
                    return counter 
                # remove permalink in redirects if it is a list
                if md.get(PERMALINK_KEY) != None and md.get(REDIRECT_KEY) != None and md[PERMALINK_KEY] in md[REDIRECT_KEY]:
                    redirects = md.get(REDIRECT_KEY)
                    if not isinstance(redirects, str):
                        md[REDIRECT_KEY].remove(md[PERMALINK_KEY])
                if md.get(LANG_KEY) == None:
                    md[LANG_KEY] = "en"
                if md.get(REF_KEY) == None:
                    md[REF_KEY] = counter
                    counter += 1
            with iopen(root_dir, 'wb') as replaced:
                dump(md, replaced)
                replaced.write(b'\n')

        return counter

    for dir_name, subdir_list, file_list in os.walk(root_dir):
        print('current directory: %s' % dir_name)
        print(os.path.basename(dir_name))

        if check_dir_name(dir_name):
            print('\t%s' % dir_name)
            print('1continue')
            continue

        for file_name in file_list:
            print('\t%s' % file_name)
            # lazy
            if check_file_name(file_name):
                print('continue')
                continue
            file_path = dir_name + "/" + file_name
            with iopen(file_path) as fp:
                md = load(fp)
                if not md.metadata:
                    print('no metadata in %s' % file_path)
                    continue
                # remove permalink in redirects if it is a list
                if md.get(PERMALINK_KEY) != None and md.get(REDIRECT_KEY) != None and md[PERMALINK_KEY] in md[REDIRECT_KEY]:
                    redirects = md.get(REDIRECT_KEY)
                    if not isinstance(redirects, str):
                        md[REDIRECT_KEY].remove(md[PERMALINK_KEY])
                #if md.get(LANG_KEY) == None:
                #    md[LANG_KEY] = "en"
                #if md.get(REF_KEY) == None:
                #    md[REF_KEY] = counter
                #    counter += 1

            with iopen(file_path, 'wb') as replaced:
                dump(md, replaced)
                replaced.write(b'\n')

    return counter



if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument("language")
    parser.add_argument("directory")
    parser.add_argument("refcounterfile")
    args = parser.parse_args()

    counter_file = args.refcounterfile
    counter = read_counter(counter_file)

    print('\n CURRENT REF COUNTER IS %s' % counter)
    ref_counter = main(args.directory, args.language, counter)

    print('\n NEW CURRENT REF COUNTER IS %s' % ref_counter)
    write_counter_to_file(ref_counter, counter_file)
