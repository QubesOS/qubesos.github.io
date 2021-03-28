#!/usr/bin/python3
'''
python _utils/_translation_utils/postprocess_htmlproofer.py <LANG> <OUTPUT_FROM_HTMLPROOFER> <TRANSLATED_DIRECTORY>
invoke: python _utils/_translation_utils/postprocess_htmlproofer.py de /tmp/html.output _translated/de/
<LANG>[de]: translation language 
<OUTPUT_FROM_HTMLPROOFER>[/tmp/html.output]: output from htmlproofer 
<TRANSLATED_DIRECTORY>[_translated/de/]: the directory with the downloaded translated files from transifex
'''
from frontmatter import Post, load, dump
import yaml
from io import open as iopen
from re import search
from sys import exit
import sys
from os import linesep, walk
from argparse import ArgumentParser
from os.path import isfile, isdir
from json import loads, dumps
from logging import basicConfig, getLogger, DEBUG, Formatter, FileHandler


SLASH = '/'
# markdown frontmatter keys
PERMALINK_KEY = 'permalink'
REDIRECT_KEY = 'redirect_from'
TRANSLATED_LANGS = ['de']
URL_KEY = 'url'


basicConfig(level=DEBUG)
logger = getLogger(__name__)
LOG_FILE_NAME='/tmp/postprocess_htmlproofer.log'

def configure_logging(logname):
    handler = FileHandler(logname)
    handler.setLevel(DEBUG)
    formatter = Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)

def log_debug(name, data):
    logger.debug('############################################')
    logger.debug('############################################')
    logger.debug('###\t'+ name.capitalize() +  '\t###')
    logger.debug('--------------------------------------------')
    if isinstance(data,dict):
        logger.debug(dumps(data, indent=4))
    else:
        logger.debug(data)
    logger.debug('############################################')
    logger.debug('############################################')

def get_new_line(line, internal_link, internal_links, permalink):
    if internal_link in internal_links and internal_link.startswith("/"):
     # TODO redundant
        indd = internal_link.find('#')
        internal_link_to_replace  = internal_link[0:indd]
        to_replace = line.replace(internal_link, internal_link_to_replace)
        return to_replace
    elif internal_link in internal_links and internal_link.startswith("#"):
        to_replace = line.replace(internal_link, permalink)
        return to_replace
    else:
        return line
    #return None


def process_markdown(translated_file, internal_links):
    """
    for every translated file discard the erroneous internal links 
    translated_file: marked and uploaded to transifex for translation, if not downloaded it will be printed out as a debug
    internal_links:all internal links belonging to the translated_file that are erroneous according to htmlproofer
    """
    mdt = Post
    try:
        with iopen(translated_file) as t:
            mdt = load(t)
            lines = []
            headings = []
            permalink = mdt.get(PERMALINK_KEY)
            if permalink == None:
                permalink = '/'
            for line in mdt.content.splitlines():
                # gather information
                inst = {}
                if line.startswith("[") and "]:" in line:
                    s = line.find(":")
                    internal_link = line[s+1:len(line)].strip()
                    if internal_link in internal_links and internal_link.startswith("/"):
                        ind  = line.rfind('#')
                        to_replace = line[0:ind]
                        lines.append(to_replace)
                        continue
                    if internal_link in internal_links and internal_link.startswith("#"):
                        to_replace = line.replace(internal_link, permalink)
                        lines.append(to_replace)
                        continue

                if "[" and "](" in line and ")" in line:
                    count = line.count('](')
                    tmp = line 
                    val = 0
                    for i in range(0, count):
                        s = line.find("](", val)
                        e = line.find(")", s + 1)
                        internal_link = line[s+2:e].strip().replace(')','')

                        line =  get_new_line(line, internal_link, internal_links, permalink)
                        val = val + s + 1 
                    lines.append(line)
                    continue
                lines.append(line)

        mdt.content = linesep.join(lines) + '\n'

        with iopen(translated_file, 'wb') as replaced:
           dump(mdt, replaced)

    except FileNotFoundError as e:
        logger.debug('Following file was not updated/downloaded from transifex: %s' % e.filename)



def get_all_translated_permalinks_and_redirects_to_file_mapping(translated_dir, lang):
    """
    traverse the already updated (via tx pull) root directory with all the translated files for a specific language
    and get their permalinks and redirects without the specific language
    translated_dir: root directory with all the translated files for a specific language
    lang: the specific language
    return: set holding the translated permalinks and redirects
    """
    mapping = {}
    perms = []
    yml_files = []
    for dirname, subdirlist, filelist in walk(translated_dir):
        if dirname[0] == '.':
            continue
        for filename in filelist:
            if filename[0] == '.':
                continue
            filepath = dirname + SLASH + filename
            md = Post
            with iopen(filepath) as fp:
                md = load(fp)
                if md.get(PERMALINK_KEY) != None:
                    perms.append(md.get(PERMALINK_KEY))
                elif filepath.endswith('.yml'):
                    yml_files.append(filepath)
                else:
                    logger.error('no permalink in frontmatter for file %s' % filename)
                redirects = md.get(REDIRECT_KEY)
                if redirects != None:
                    if isinstance(redirects,list):
                        for r in redirects:
                            perms.append(r)
                    elif isinstance(redirects,str):
                        perms.append(redirects)
                    else:
                        logger.error('ERRROR: unexpected in redirect_from: %s' % redirects)
                        exit(1)
                else:
                    logger.debug('no redirect_from in frontmatter for file %s' % filepath)
                mapping[filepath] = perms
                perms = [] 
    return mapping, yml_files


# TODO simplify
def get_error_output_from_htmlproofer(htmlproofer_output):
    errors_tmp = []
    with iopen(htmlproofer_output,'r') as h:
        lines = h.readlines()
        errors_tmp = [x for x in lines if not(x.startswith('Checking') or x.startswith('Ran') or x.startswith('Running') or x.startswith('\n') or x.startswith('htmlproofer'))]
    
    count = 0
    errors = {}
    internal_link = []
    u = ''
    pattern = 'a href='
    for i in range(len(errors_tmp)):
        if pattern in errors_tmp[i]:
            i1 = errors_tmp[i].find(pattern, 0)
            i2 = errors_tmp[i].find('"', i1 + len(pattern))
            i3 = errors_tmp[i].find('"', i2 +1 )
            
            i_l = errors_tmp[i][i2+1:i3]
            if '">' in i_l:
                i_l = search('(.*)">', i_l).group(1)
            internal_link.append(i_l)
            count += 1
        if './_site' in errors_tmp[i]:
            if count > 0:
                errors[u] = internal_link
                internal_link = []
            u = search('./_site(.*)index.html',errors_tmp[i]).group(1)
            count = 0
    errors[u] = internal_link
    return errors

def replace_url(to_replace, errorlinks):
    """
    recursively remove header from the URL in an yaml file.
    to_replace: the translated yaml content as a dictionary
    errorlinks: all internal links that are deadend and need to be cut off before # meaning get rid of the headers
    """
    if not isinstance(to_replace,dict):
        return
    for (k_r, v_r) in to_replace.items():
        if isinstance(v_r, list):
            for i in v_r:
                replace_url(i, errorlinks)
        elif URL_KEY == k_r:
            val = to_replace[k_r]
            if val is not None and '#' in val:
                tmp_val = val[0:val.find('#')]
                to_replace[URL_KEY]= tmp_val if (val in errorlinks) else val

def process_yml(translated, errorlinks):
    """
    for every given source-translated yml file pair add the language to the urls if they belong to already translated files,
    if not retain the original ones
    translated: translated yml file
    errorlinks: all internal links that are deadend and need to be cut off before # meaning get rid of the headers
    """
    docs = []
    try:
        with iopen(translated) as tp:
            docs = yaml.safe_load(tp)
            if docs == None:
                logger.error("Empty translated file %s" %translated)
                exit(1)
            for a in docs:
                replace_url(a, errorlinks)
    except FileNotFoundError as e:
        logger.debug('Following file was NOT updated/downloaded from transifex: %s' % e.filename)

    try:
        if len(docs)>0:
            with iopen(translated, 'w') as replace:
                yaml.dump(docs, replace, sort_keys=False)
    except FileNotFoundError as e:
        logger.debug('do nothing for file: %s. it is OK.' % e.filename)

if __name__ == '__main__':
    # python _utils/_translation_utils/postprocess_htmlproofer.py de /tmp/html.output _translated/de/
    parser = ArgumentParser()
    # for which language should we do this
    parser.add_argument("language")
    # the file containing the output of htmlproofer
    parser.add_argument("htmlproofer_output")
    # the directory containing the translated (downloaded via tx pull) files
    parser.add_argument("translated_dir")
    args = parser.parse_args()

    configure_logging(LOG_FILE_NAME)

        
    if not isdir(args.translated_dir):
        print("please check your translated directory")
        logger.error("please check your translated directory")
        exit(1)

    if not args.language in TRANSLATED_LANGS:
        print("language not in the expected translation languages")
        logger.error("please check your translation language")
        exit(1)

    if not isfile(args.htmlproofer_output):
        print("please check your html proofer output file")
        logger.error("please check your html proofer output file")
        sys.exit(1)

    errors = get_error_output_from_htmlproofer(args.htmlproofer_output)

    if not errors:
        print("nothing to do, no errors to postprocess")
        sys.exit(1)

    logger.debug("------------------------------------------------")
    logger.debug("------------------------------------------------")
    logger.debug("------------------------------------------------")
    logger.debug("-------------STRINGS TAGGED NOTRANSLATE---------")
    logger.debug("------------------------------------------------")
    logger.debug("------------------------------------------------")


    error_links = list(sorted({el for val in errors.values() for el in val}))
    log_debug("HTML ERRORS", errors)
    log_debug("HTML ERRORS", error_links)
    logger.debug("------------------------------------------------")
    logger.debug("------------------------------------------------")
    logger.debug("------------------------------------------------")

    mapping, yml_files = get_all_translated_permalinks_and_redirects_to_file_mapping(args.translated_dir, args.language)


    log_debug('mapping ', mapping)
    log_debug('yml files ', yml_files)

    file_to_internal_links = {}
    for key, item  in mapping.items():
        for k, i in errors.items():
            if k in item:
                file_to_internal_links[key] = i

    log_debug(" file to internal links mapping", file_to_internal_links)    
    for key, item in file_to_internal_links.items():
        process_markdown(key, item)

    # traverse all yml data files and cut the translated urls if they are in error_urls
    for yml in yml_files:
        process_yml(yml, error_links)

