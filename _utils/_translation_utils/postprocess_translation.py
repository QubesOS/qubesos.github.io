#!/usr/bin/python3
# adds language pattern in permalink line and all found relative links in the current open file recursively from a given root dir
# evoke like: python _utils/postprocess_translation.py de _translated/de/ _utils/tx-mapping _utils/translated_hrefs_urls.txt --yml
#param1 is the language in short form
#param2 is the root translated dir 
#param3 is current transifex mapping between original and translated files in the format: 
# file_filter=
# source_file=
#param3 is the output of the script prepare_tx_config.sh
#param4 is the name for the file containing all the permalinks of translated/downloaded via tx client files. it is afterwards used by postprocess_translation.sh script 
#param5 is optional indicating .yml files to be processed as in _data directory with no frontmatter whatsoever

from yaml import safe_load
from yaml import dump as ydump
import frontmatter
from io import open as iopen
from os.path import isfile, isdir
from os import linesep, walk, environ
from re import findall
from sys import exit
from argparse import ArgumentParser
from json import loads, dumps
from collections import deque
from logging import basicConfig, getLogger, DEBUG, Formatter, FileHandler

patterns = (
    "](/",
    "]: /",
    "href=\"/",
    "url: /",
    "href=\'/",
)
# TODO vereinfachen der if bedingung mit einer liste von ommitted urls patterns
news = "/news/"
qubes_issues = "/qubes-issues/"
# constants and such
# yml keys:
YML_KEYS = ['url', 'topic', 'title', 'category', 'folder', 'htmlsection', 'tweet', 'avatar', 'img', 
        'article', 'quote', 'name', 'occupation', 'author', 'more', 'text', 
        'video', 'intro', 'version', 'subtitle', 'download', 'security', 'bug', 'help', 
        'join', 'partner', 'cert', 'picture', 'email', 'website', 'mail', 'links', 'id',
        'paragraph', 'snippet', 'column', 'hover', 'digest', 'signature', 'pgp', 'green', 'red', 'blue', 'trump', 
        'tts1', 'tts2', 'txp', 'txaq', 'pxaq', 'column1', 'column2', 'column3', 'yes_short', 'no_short', 'no_extended', 'tba',
        'bold', 'item', 'note', 'section', 'row', 'r_version',
        'go', 'search', 'metatopic', 'ddg', 'hover']
URL_KEY = 'url' 
# md frontmatterkeys:
PERMALINK_KEY = 'permalink'
REDIRECT_KEY = 'redirect_from'
REDIRECT_TO = 'redirect_to'
LANG_KEY = 'lang'
TRANSLATED_KEY = 'translated'
LAYOUT_KEY = 'layout'
SLASH = '/'
MD_URL_SPLIT_PATTERNS = ['/)','/#']
TRANSLATED_LANGS = ['de']
if 'TRANSLATED_LANGS' in environ:
    TRANSLATED_LANGS = environ['TRANSLATED_LANGS'].split()
#EXCLUDE_FILES = ['download.md' ]


basicConfig(level=DEBUG)
logger = getLogger(__name__)
LOG_FILENAME='/tmp/postprocess_translation.log'

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


def write_to_file(filename, lines):
    """ 
    write the given data structure to a file
    filename: the name of the file to be written to
    lines: the content
    """
    with iopen(filename,'w') as c:
        c.write('\n'.join(str(line) for line in lines))
        c.truncate()

def process_markdown(source_file, translated_file, permalinks, lang):
    """
    for every uploaded via tx client markdown file for translation, replace the markdown frontmatter with the frontmatter of the original file,
    set the specific language, set translated to yes and for all downloaded/updated via transifex files, respectively permalinks, 
    add the specific language to the internal url
    source_file: original file 
    translated_file: marked and uploaded to transifex for translation, if not downloaded it will be printed out as a debug
    permalinks:all internal links (permalink and redirect_from) belonging to the files dwonloaded from transifex
    lang: the translation language
    """
    mdt = frontmatter.Post
    try:
        with iopen(source_file) as s, iopen(translated_file) as t:
            mds = frontmatter.load(s)
            mdt = frontmatter.load(t)
            if mds.get(PERMALINK_KEY) != None:
                mdt[PERMALINK_KEY] = SLASH + lang + mds.get(PERMALINK_KEY)
            elif PERMALINK_KEY in mdt:
                # if missing in source, remove from translated too
                del mdt[PERMALINK_KEY]
    
            if mds.get(REDIRECT_KEY) != None:
                redirects = mds.get(REDIRECT_KEY)
                if isinstance(redirects, str):
                    redirects = [redirects]
                # just in case 
                if any('..' in elem for elem in redirects):
                    logger.error('\'..\' found in redirect_from in file %s' % source_file)
                    exit(1)
                mdt[REDIRECT_KEY] = [(SLASH + lang + elem.replace('/en/', SLASH) if not elem.startswith(SLASH + lang + SLASH) else elem)
                               for elem in redirects]

                if mds.get(PERMALINK_KEY) != None and mds[PERMALINK_KEY] in mdt[REDIRECT_KEY]:
                    mdt[REDIRECT_KEY].remove(mds[PERMALINK_KEY])
                if mdt.get(PERMALINK_KEY) != None and mdt[PERMALINK_KEY] in mdt[REDIRECT_KEY]:
                    mdt[REDIRECT_KEY].remove(mdt[PERMALINK_KEY])

                tmp = sorted(set(mdt[REDIRECT_KEY]))
                mdt[REDIRECT_KEY] = tmp
            elif REDIRECT_KEY in mdt:
                # if missing in source, remove from translated too
                del mdt[REDIRECT_KEY]

            if mds.get(LAYOUT_KEY) != None:
                mdt[LAYOUT_KEY] = mds[LAYOUT_KEY]

            if mds.get(REDIRECT_TO) != None:
                redirect = mds.get(REDIRECT_TO)
                if isinstance(redirect, list):
                    redirect = redirect[0]
                if redirect.startswith('/') and not redirect.startswith(SLASH + lang + SLASH) and not redirect.startswith(news):
                    mdt[REDIRECT_TO] = SLASH + lang + redirect
                else:
                    mdt[REDIRECT_TO] = redirect
            elif REDIRECT_TO in mdt:
                del mdt[REDIRECT_TO]

            mdt[LANG_KEY] = lang
            # TODO we do not need the translated key anymore
            #mdt[TRANSLATED_KEY] = 'yes'
            ## for testing purposes only
            #if mdt.get('title') != None:
            #    mdt['title'] = lang.upper() +"!: " + mdt.get('title')

        # replace links
        lines = []
        for line in mdt.content.splitlines():
            for pattern in patterns:
                if pattern in line:
                    tmp = line.split(pattern)
                    line = tmp[0]
                    for part in range(1, len(tmp)):
                        if '../' in tmp[part]:
                            logger.error('\'..\' found in internal url: %s' % tmp[part])
                            exit(1)

                        # TODO we can translate news you know
                        if not tmp[part].startswith(lang + SLASH) and \
                                not tmp[part].startswith('news') and \
                                not tmp[part].startswith('attachment') and \
                                not tmp[part].startswith('qubes-issues') and \
                                split_and_check(tmp[part],permalinks):
                            line += pattern + lang + SLASH + tmp[part]
                        # TODO this is the case with links at the bottom of the file
                        elif not tmp[part].startswith(SLASH) and \
                                SLASH + tmp[part] in permalinks:
                            line += pattern + lang + SLASH + tmp[part]
                        # TODO if a url contains a language but the url belongs to a file that is not translated should i  actually remove the language  -> overengineering?
#                        elif tmp[part].startswith(lang+SLASH) and not split_and_check(tmp[part][len(lang)+1],permalinks):
 #                           line += pattern + tmp[part][len(lang)+1]    
                        else:
                            line += pattern + tmp[part]
            lines.append(line)

        mdt.content = linesep.join(lines) + '\n'

        with iopen(translated_file, 'wb') as replaced:
           frontmatter.dump(mdt, replaced)

    except FileNotFoundError as e:
        logger.debug('Following file was not updated/downloaded from transifex: %s' % e.filename)



def split_and_check(md_line, permalinks):
    """
    for every given line in a markdown line containing an internal link
    return if the internal link belongs to a file already downloaded and translated from transifex
    md_line: line in a markdown line containing an internal link
    permalinks: all internal links (permalink and redirect_from) belonging to the files dwonloaded from transifex
    """
    for pattern in MD_URL_SPLIT_PATTERNS:
        if pattern in md_line:
            sp = md_line.split(pattern)
            t = sp[0]
            t = SLASH + t if not t.startswith(SLASH) else t
            t = t + SLASH if not t.endswith(SLASH) else t
            if t in permalinks:
                return True
            else:
                logger.debug("Following link: %s belongs to a file NOT translated/downloaded from transifex" %t)
    return False

def check_yml_attributes(to_replace, original):
    """
    recursively check if the title, folder and category attributes of the translated yaml file 
    are not empty strings 
    if they are: replace them with the original content
    it assumes that the order between original and translated files loaded as dictionary is preserved
    to_replace: the translated yaml content as a dictionary
    original: the original yaml content as a dictionary
    """

    if not (isinstance(to_replace,dict) and isinstance(original,dict)):
        return
    for (k_r, v_r), (k_o, v_o) in zip(to_replace.items(), original.items()):
        if isinstance(v_r, list) and isinstance(v_o, list):
            for i, j in zip(v_r, v_o):
                check_yml_attributes(i, j)
        for yml_key in YML_KEYS:
            if yml_key == k_r and yml_key == k_o and to_replace[yml_key] == '':
                to_replace[yml_key] = original[yml_key]
            elif k_r != k_o:
                logger.error("ERROR, ordered of the loaded yml file is not preserved %s" % k_r +':' + k_o)
                exit(1)


def replace_url(to_replace, original, lang, permalinks):
    """
    recursively add language to the original value of the key URL if the file with the given URL is translated and save it to the translated yaml file.
    if the file is not translated keep the original url
    it assumes that the order between original and translated files loaded as dictionary is preserved
    to_replace: the translated yaml content as a dictionary
    original: the oritignal yaml content as a dictionary
    lang: language, for example de
    permalinks: urls of the translated/downloaded files from transifex
    """
    if not (isinstance(to_replace,dict) and isinstance(original,dict)):
        return
    for (k_r, v_r), (k_o, v_o) in zip(to_replace.items(), original.items()):
        if isinstance(v_r, list) and isinstance(v_o, list):
            for i, j in zip(v_r, v_o):
                replace_url(i, j, lang, permalinks)
        elif URL_KEY == k_r and URL_KEY == k_o:
            val = original[k_r]
            if val is not None and '#' in val:
                tmp_val = val[0:val.find('#')]
                to_replace[URL_KEY]= SLASH + lang + val if (tmp_val in permalinks) else val
            else:
                to_replace[URL_KEY]= SLASH + lang + val if (val in permalinks) else val
        elif k_r != k_o:
            logger.error("ERROR, ordered of the loaded yml file is not preserved %s" % k_r +':' + k_o)
            exit(1)



def process_yml(source, translated, lang, permalinks):
    """
    for every given source-translated yml file pair add the language to the urls if they belong to already translated files,
    if not retain the original ones
    source: original yml file
    translated: translated yml file
    lang: language, for example de
    permalinks: all internal links (permalink and redirect_from) belonging to the files downloaded from transifex
    """
    docs = []
    try:
        with iopen(source) as fp, iopen(translated) as tp:
            docs_original = safe_load(fp)
            docs = safe_load(tp)
            if docs == None:
                logger.error("Empty translated file %s" %translated)
                exit(1)
            for a, b in zip(docs, docs_original):
                replace_url(a, b, lang, permalinks)
                check_yml_attributes(a, b)
    except FileNotFoundError as e:
        logger.debug('Following file was NOT updated/downloaded from transifex: %s' % e.filename)

    try:
        if len(docs)>0:
            with iopen(translated, 'w') as replace:
                ydump(docs, replace, sort_keys=False)
    except FileNotFoundError as e:
        logger.debug('do nothing for file: %s. it is OK.' % e.filename)


def get_all_the_hrefs(translated_dir):
    """
    traverse the already updated (via tx pull) root directory with all the translated files for a specific language 
    and get all the internal urls that are embedded in hmtl code in an href attribute
    translated_dir: root directory with all the translated files for a specific language
    return: set holding all the internal urls that are embedded in hmtl code in an href attribute
    """

    href = set()
    reg ='(?<=href=\").*?(?=\")'
    for dirname, subdirlist, filelist in walk(translated_dir):
        if dirname[0] == '.':
            continue
        for filename in filelist:
            if filename[0] == '.':
                continue
            filepath = dirname + SLASH + filename
            try:
                with iopen(filepath) as fp:
                    lines = fp.readlines()
                    for line in lines:
                        t = findall(reg, line)
                        if len(t)>0:
                            for i in t:
                                href.add(i)
            except FileNotFoundError as e:
                logger.error('problem opening a file in the translated dir: %s' %e.filename)
                exit(1)
    return href

def get_all_translated_permalinks_and_redirects(translated_dir,lang):
    """
    traverse the already updated (via tx pull) root directory with all the translated files for a specific language 
    and get their permalinks and redirects without the specific language
    translated_dir: root directory with all the translated files for a specific language
    lang: the specific language
    return: set holding the original (language code is removed) permalinks and redirects
    """

    perms = set()
    for dirname, subdirlist, filelist in walk(translated_dir):
        if dirname[0] == '.':
            continue
        for filename in filelist:
            if filename[0] == '.':
                continue
            filepath = dirname + SLASH + filename
            md = frontmatter.Post
            with iopen(filepath) as fp:
                md = frontmatter.load(fp)
                if md.get(PERMALINK_KEY) != None:
                    perms.add(md.get(PERMALINK_KEY)[len(lang)+1:] if md.get(PERMALINK_KEY).startswith(SLASH+lang +SLASH) else md.get(PERMALINK_KEY))
                else:
                    logger.error('no permalink in frontmatter for file %s' % filename)
                redirects = md.get(REDIRECT_KEY)
                if redirects != None:
                    if isinstance(redirects,list):
                        for r in redirects:
                            perms.add(r[len(lang)+1:] if r.startswith(SLASH + lang + SLASH) else r)
                    elif isinstance(redirects,str):
                        perms.add(redirects)
                    else:
                        logger.error('ERRROR: unexpected in redirect_from: %s' % redirects)
                        exit(1)
                else:
                    logger.debug('no redirect_from in frontmatter for file %s' % filepath)
    return perms

def create_dict_from_tx_config(mappingfile, lang):
    """
    read a tx.xonfig file containing only file_filter and source_file information store it in a dict and give it back
    mappingfile:  a tx.xonfig file containing only file_filter and source_file information
    return: a dict containing a mapping between an original file and its downloaded tx translation
    """
    mapping = {}
    with iopen(mappingfile) as fp:
        lines = fp.readlines()
        translated = ['./'+x.split('file_filter =')[1].strip().replace('<lang>',lang) for x in lines if lines.index(x)%2==0]
        source = ['./'+x.split('source_file =')[1].strip() for x in lines if lines.index(x)%2==1]

        for x in translated:
            mapping.update({source[translated.index(x)]:x})
    return mapping


def main(translated_dir, lang, yml, mapping, href_filename):
    perms = get_all_translated_permalinks_and_redirects(translated_dir, lang)
    log_debug('all translated permalinks/redirects', perms)
    
    hrefs = get_all_the_hrefs(args.translateddir)

    log_debug('all the hrefs', hrefs)
    write_to_file(href_filename, perms.intersection(hrefs))

    # for each pair of source and translated file postprocess the translated file 
    for key, item in mapping.items():
        if yml and item.endswith('.yml'):
            process_yml(key, item, lang, perms)
        #if not item.endswith('.yml') and not item.endswith('downloads.md'):
        if not item.endswith('.yml'):
            process_markdown(key, item, perms, lang)  



if __name__ == '__main__':

    # python _utils/postprocess_translation.py de _translated/de/ _utils/tx-mapping _utils/translated_hrefs_urls.txt --yml
    parser = ArgumentParser()
    # for which language should we do this
    parser.add_argument("language")
    # the directory containing the translated (downloaded via tx pull) files
    parser.add_argument("translateddir")
    # provide the mappingfile from tx configuration containing the file_filter to source_file mapping
    parser.add_argument("tx_mappingfile")
    # name of the file to contain/write to all the internal urls that are embedded in hmtl code in a href attribute 
    # for later processing postprocess_translation.sh 
    parser.add_argument("translated_hrefs_filename")
    # whether or not to process yml files
    parser.add_argument("--yml", action='store_true')
    args = parser.parse_args()


    if not isfile(args.tx_mappingfile):
        print("please check your transifex mapping file")
        exit(1)
        
    if not isdir(args.translateddir):
        print("please check your translated directory")
        exit(1)

    if not args.language in TRANSLATED_LANGS:
        print("language not in the expected translation languages")
        exit(1)

    configure_logging(LOG_FILENAME)

    
    log_debug('START', {})

    source_translation_mapping = create_dict_from_tx_config(args.tx_mappingfile, args.language)


    log_debug('source/translation file mapping', source_translation_mapping)

    main(args.translateddir, args.language, args.yml, source_translation_mapping, args.translated_hrefs_filename)
    


