#!/usr/bin/python3
# This is a script provided by TokiDev
# https://github.com/tokideveloper/langswitch-prototype/blob/master/_utils/merge_md_heading_ids.py

import sys
import re
import subprocess


def get_yaml_front_matter(gfm_lines):
    counter = 0
    start = 0
    end = 0
    for i in range(len(gfm_lines)):
        if gfm_lines[i] == '---\n':
            counter += 1
            if counter == 1:
                start = i
            elif counter == 2:
                end = i + 1
                return gfm_lines[start:end], start, end
    if counter == 1:
        return gfm_lines[start:], start, len(gfm_lines)
    # case counter == 0:
    return [], 0, 0



def line_only_made_of(line, char):
    length = len(line)
    for i in range(length - 1):
        if line[i] != char:
            return False
    return line[length - 1] == '\n'



def render(gfm_lines):
    p = subprocess.run(['kramdown'], stdout=subprocess.PIPE, input=''.join(gfm_lines), encoding='utf8')
    if p.returncode != 0:
        return None
    return p.stdout.splitlines(1)



def look_for_headline(rendered_html_lines, headline_id):
    for l in range(len(rendered_html_lines)):
        x = re.search('<h\\d\\s+id\\s*=\\s*"' + headline_id + '"\\s*>', rendered_html_lines[l])
        if x is None:
            continue
        c = x.start()
        if c is None:
            continue
        else:
            return l, c
    return None



def extract_headline_id(rendered_html_lines, l, c):
    line = rendered_html_lines[l]
    line = line[c:]
    x = re.search('<h\\d\\s+id\\s*=\\s*"', line)
    if x is None:
        return None
    col = x.start()
    if col is None:
        return None
    elif col > 0:
        return None
    span = x.span()
    line = line[(span[1] - span[0]):]
    end = line.find('"')
    line = line[:end]
    return line



def try_create_id(gfm_lines, line_number, this_line, next_line, rendered_html_lines, placeholder):
    # save headline
    saved_headline = gfm_lines[line_number]

    hl = None

    if this_line.startswith('#'):
        # headline starting with '#'
        gfm_lines[line_number] = '# ' + placeholder + '\n'
        hl = look_for_headline(render(gfm_lines), placeholder)
    elif len(next_line) >= 3 and (line_only_made_of(next_line, '=') or line_only_made_of(next_line, '-')):
        # headline starting with '===' or '---'
        gfm_lines[line_number] = placeholder + '\n'
        hl = look_for_headline(render(gfm_lines), placeholder)

    # revert headline
    gfm_lines[line_number] = saved_headline

    if hl is None:
        return None

    hl_line, hl_col = hl
    return extract_headline_id(rendered_html_lines, hl_line, hl_col)



def generate_unique_placeholder(rendered_html_lines):
    number = 0
    PREFIX = 'xq'
    SUFFIX = 'z'
    result = ''
    while True:
        result = PREFIX + str(number) + SUFFIX
        solution_found = True
        for line in rendered_html_lines:
            if result in line:
                number += 1
                solution_found = False
                break
        if solution_found:
            break
    # we assume that there will be at least one solution
    return result



def create_line_to_id_map(gfm_lines):
    result = {}
    gfm_lines2 = gfm_lines[:]
    rendered_html_lines = render(gfm_lines)

    placeholder = generate_unique_placeholder(rendered_html_lines)

    # line-by-line: assume a headline
    n = len(gfm_lines2)
    for i in range(n):
        this_line = gfm_lines2[i]
        next_line = ''
        if i < n - 1:
            next_line = gfm_lines2[i + 1]
        hid = try_create_id(gfm_lines2, i, this_line, next_line, rendered_html_lines, placeholder)
        if hid is not None:
            result[i] = hid

    return result



def insert_ids_to_gfm_file(line_to_id_map, gfm_lines):
    result = gfm_lines[:]
    n = len(result)
    for key, value in line_to_id_map.items():
        str_to_insert = '<a id="' + value + '"></a>'
        line = result[key]
        if line.startswith('#'):
            if key + 1 >= n:
                result = result + ['']
            result[key + 1] = str_to_insert + result[key + 1]
        else:
            if key + 2 >= n:
                result = result + ['']
            result[key + 2] = str_to_insert + result[key + 2]
    return result



def merge_ids_in_gfm_files(orig_gfm_lines, trl_gfm_lines):
    # assuming that both files match line by line such that matching headlines are in the same lines

    # get yaml front matter from orig
    orig_yaml_front_matter, orig_start, orig_end = get_yaml_front_matter(orig_gfm_lines)

    # get yaml front matter from trl
    trl_yaml_front_matter, trl_start, trl_end = get_yaml_front_matter(trl_gfm_lines)

    # get body from trl
    trl_body = trl_gfm_lines[trl_end:]

    # get body from orig
    orig_body = orig_gfm_lines[orig_end:]

    # create line-to-id map
    orig_line_to_id_map = create_line_to_id_map(orig_body)

    # insert ids
    preresult = insert_ids_to_gfm_file(orig_line_to_id_map, trl_body)

    # create translated document with adapted body
    result_trl_gfm = ''.join(trl_yaml_front_matter) + ''.join(preresult)

    return result_trl_gfm


def write_lines(content, filename):
    with open(filename,'w') as f:
        f.write(content)

def read_lines(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    return lines

def process_headers(mapping):

    for key, item in mapping.items():
        if not item.endswith('.yml'):
            original_lines = read_lines(key)
            translated_lines = read_lines(item)
            # merge ids in gfm files
            print(key)

            result = merge_ids_in_gfm_files(original_lines, translated_lines)
            write_lines(result, item)


