#!/usr/bin/python3
'''
invoke: python tag_as_locked.py tx-resource-names.txt tx-sources-filenames.txt api-token --debug --manual 
param1: tx-resources-names.txt: provide the file from tx configuration containing the resource names 
param2: tx-sources-filenames.txt: provide the file from tx configuration containing only the original source filenames 
param3: api-token: provide the developer api transifex token for auth 
param4: debug: whether or not to write debug json files
param5: manual: whether or not to tag file by a file by waiting for a keyboard input
'''
from pycurl import Curl, HTTP_CODE, error, WRITEFUNCTION
from frontmatter import Post, load
from certifi import where
from io import BytesIO
from io import open as iopen
from os import environ
from os.path import isfile
from re import match
import sys
from sys import exit
from argparse import ArgumentParser
from json import loads, dumps
from jsonschema import validate 
from jsonschema.exceptions import ValidationError
from collections import deque
from logging import basicConfig, getLogger, DEBUG, Formatter, FileHandler

# TODO should we also mark notranslate as also reviewed ? it may need manual labor afterwards though ?
# Here should also go a comment that this snippet of code should be extended if the data files are to be altered and there are part that have to stay the same
# This can be done by fetching the strings from the tx api via curl:
# curl -i -L --user api:XXXXXXXXXXXXXXX -X GET https://www.transifex.com/api/2/project/qubes/resource/no_html_data_hcl/translation/en/strings/ 
# and searching for the key pattern that should be marked as locked and thus untranslatabel and immutable

KEY_REGEX_LOCK_PATTERNS = ['^\[(\d)*\](.sub-pages.)\[(\d)*\](.url)$', 
        '^\[(\d)*\](.sub-pages.)\[(\d)*\](.sub-pages.)\[(\d)*\](.url)$', 
        '^\[(\d)*\](.sub-pages.)\[(\d)*\](.icon)$', 
        '^(\[(\d)*\])(.url)$', '^(\[(\d)*\])(.icon)$','^(\[(\d)*\])(.category)$', 
        '^(\[(\d)*\])(.tech.)(\[(\d)*\])(.img)$', '^(\[(\d)*\])(.tech.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.award.)(\[(\d)*\])(.url)$', '^(\[(\d)*\])(.award.)(\[(\d)*\])(.img)$', 
        '^(\[(\d)*\])(.media.)(\[(\d)*\])(.img)$', '^(\[(\d)*\])(.media.)(\[(\d)*\])(.article)$', 
        '^(\[(\d)*\])(.attachment)$', '^(\[(\d)*\])(.expert.)(\[(\d)*\])(.tweet)$', 
        '^(\[(\d)*\])(.expert.)(\[(\d)*\])(.avatar)$', '^(\[(\d)*\])(.expert.)(\[(\d)*\])(.img)$', 
        '^(\[(\d)*\])(.htmlsection)$', '^(\[(\d)*\])(.folder)$','redirect_from.\[(\d)*\]', 
        '^(\[(\d)*\])(.links.)(\[(\d)*\])(.url)$', '^(\[(\d)*\])(.links.)(\[(\d)*\])(.id)$', 
        '^(\[(\d)*\])(.columns.)(\[(\d)*\])(.url)$', '^(\[(\d)*\])(.subsections.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.htmlsections.)(\[(\d)*\])(.url)$', '^(\[(\d)*\])(.partners.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.partners.)(\[(\d)*\])(.id)$', '^(\[(\d)*\])(.partners.)(\[(\d)*\])(.img)$', 
        '^(\[(\d)*\])(.partners.)(\[(\d)*\])(.paragraph.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.paragraphs.)(\[(\d)*\])(.paragraph.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.list.)(\[(\d)*\])(.item.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.releases.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.note.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.htmlsections.)(\[(\d)*\])(.htmlsection)$', 
        '^(\[(\d)*\])(.subsections.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.subsections.)(\[(\d)*\])(.section.)(\[(\d)*\])(.url)$', 
        '^(\[(\d)*\])(.paragraph.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', 
        '^categories.(\[(\d)*\])(.slug)$', '^papers.(\[(\d)*\])(.title)$','^papers.(\[(\d)*\])(.author)$', '^papers.(\[(\d)*\])(.url)$', '^papers.(\[(\d)*\])(.category)$',
        '^(\[(\d)*\])(.name)$', '^(\[(\d)*\])(.type)$', '^(\[(\d)*\])(.picture)$', '^(\[(\d)*\])(.email)$', '^(\[(\d)*\])(.fingerprint)$', '^(\[(\d)*\])(.github)$', '^(\[(\d)*\])(.website)$', 
        '^(\[(\d)*\])(.section.)(\[(\d)*\])(.snippets.)(\[(\d)*\])(.url)$', '^(\[(\d)*\])(.section)$', 
        '^(\[(\d)*\])(.releases.)(\[(\d)*\])(.r_version)$', '^(\[(\d)*\])(.section.)(\[(\d)*\])(.note)$']

KEY_REGEX_PATTERNS = ['^\[\d\](.sub-pages.)\[\d\](.url)$', '^\[\d\](.sub-pages.)\[\d\](.sub-pages.)\[\d\](.url)$', '^\[\d\](.sub-pages.)\[\d\](.icon)$', '^(\[\d\])(.url)$', '^(\[\d\])(.icon)$','^(\[\d\])(.category)$', '^(\[\d\])(.tech.)(\[\d\])(.img)$', '^(\[\d\])(.tech.)(\[\d\])(.url)$', '^(\[\d\])(.award.)(\[\d\])(.url)$', '^(\[\d\])(.award.)(\[\d\])(.img)$', '^(\[\d\])(.media.)(\[\d\])(.img)$', '^(\[\d\])(.media.)(\[\d\])(.article)$', '^(\[\d\])(.attachment)$', '^(\[\d\])(.expert.)(\[\d\])(.tweet)$', '^(\[\d\])(.expert.)(\[\d\])(.avatar)$', '^(\[\d\])(.expert.)(\[\d\])(.img)$', '^(\[\d\])(.htmlsection)$', '^(\[\d\])(.folder)$','redirect_from.\[\d\]', '^(\[\d\])(.links.)(\[\d\])(.url)$', '^(\[\d\])(.links.)(\[\d\])(.id)$']

KEY_PATTERNS = ['lang', 'layout', 'permalink', 'redirect_from']
SOURCE_PATTERNS = ['* * * * *', '</a>']
# TODO use re2 per default?
# examples for the first regex:
# ![edit-button-mobile](/attachment/wiki/doc-edit/02-button1.png)
# ![commit](/attachment/wiki/doc-gel/07-commit-msg.png)
# for the second one a liquid include html line

SOURCE_REGEX_PATTERNS = [
        '^\!\[(\w{0,50}(-){0,50}(\.){0,2}\w{0,50}){0,10}\]\((\/(\w{0,50}(-){0,8}\w{0,50})){0,10}(\w{0,50}(-){0,50}\w{0,50}){0,10}.\w{0,10}\)',
        '{%[^\S\n]{1,8}include[\s\w-]*\.html[^\S\n]{1,8}%}'
        ]
START_END_PATTERNS = {'{%': '%}', '{{': '}}', '{{':'>', '<img src=': '>', '[':']', '<script':'</script>', '<noscript>':'</noscript>', '<object':'</object>', '<div class':'>', '<i class':'/i>', }

# tx resources keys
STRING_HASH_KEY = 'string_hash'
KEY_KEY = 'key'
SOURCE_STRING_KEY = 'source_string'
# markdown frontmatter keys
PERMALINK_KEY = 'permalink'
REDIRECT_KEY = 'redirect_from'
# comment and tag for tx source strings
UPDATE_TAGS = '{"comment": "Added notranslate tag via curl", "tags": ["notranslate"]}'

UPDATE_TAGS_LOCKED = '{"comment": "Added locked tags via curl", "tags": ["locked"]}'
DATA_TO_URL_MAPPING = \
{
        'hcl': 'Strings are taken from this page: https://www.qubes-os.org/hcl/',
        'download': 'Strings are taken from this page: https://www.qubes-os.org/downloads/',
        'experts': 'Strings are taken from this page: https://www.qubes-os.org/experts/',
        'home': 'Strings are taken from this page: https://www.qubes-os.org/',
        'index': 'Strings are taken from this page: https://www.qubes-os.org/doc/',
        'intro': 'Strings are taken from this page: https://www.qubes-os.org/intro/',
        'partners': 'Strings are taken from this page: https://www.qubes-os.org/partners/',
        'style_guide_content': 'Strings are taken from this page: https://www.qubes-os.org/doc/style-guide/',
        'teamtexts': 'Strings are taken from this page: https://www.qubes-os.org/team/',
        'videos': 'Strings are taken from this page: https://www.qubes-os.org/video-tours/',
        }

# transifex schema
TX_JSON_SCHEMA = {
        "type":"array",
        "items":
        [
         {
                "type":"object",
                "required": ["comment", "context", "key","string_hash","reviewed","pluralized","source_string","translation"],
                "properties":
                {
                        "comment": {"type" : "string"},
                        "context": {"type" : "string"},
                        "key": {"type" : "string"},
                        "string_hash": {"type" : "string"},
                        "reviewed": {"type" : "boolean"},
                        "pluralized": {"type" : "boolean"},
                        "source_string": {"type" : "string"},
                        "translation": {"type" : "string"}
                }
         }
        ]
 }

tagged_locked = dict()

basicConfig(level=DEBUG)
logger = getLogger(__name__)
LOG_FILE_NAME='/tmp/tag_strings_as_locked.log'

def configure_logging(logname):
    handler = FileHandler(logname)
    handler.setLevel(DEBUG)
    formatter = Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)

def check_reg(string, reg):
    ''' 
    check if the given string complies the given regular expression
    string: string to check
    reg: regular expression
    return true if it is the case
    '''
    
    g = match(reg, string)
    return g != None

def manual_break():
    prompt = input("press c + hit enter to continue: ")
    if prompt == 'c':
        return
    else:
        manual_break()

def check_for_liquid_expression(item):
    return any (item.startswith(start) and item.endswith(end) for start, end in START_END_PATTERNS.items())  

def get_all_original_permalinks_and_redirects(sourcenamesfiles):
    '''
    get the permalinks and redirects from all the original to be translated files
    sourcenamesfiles: a file containing all the source original file names from the tx config
    return: a set containing the original (language code is removed) permalinks and redirects
    '''
    sources = []
    with iopen(sourcenamesfiles) as fp:
        lines = fp.readlines()
        sources = ['./'+x.split('source_file =')[1].strip() for x in lines if lines.index(x)%2==1]
    
    perms_and_redirects = set()
    for filepath in sources:
        logger.debug('reading %s' % filepath)
        md = Post
        with iopen(filepath) as fp:
            md = load(fp)
            if md.get(PERMALINK_KEY) != None:
                perms_and_redirects.add(md.get(PERMALINK_KEY))
            else:
                logger.error('no permalink in frontmatter for file %s' % filepath)
            redirects = md.get(REDIRECT_KEY)
            if redirects != None:
                if isinstance(redirects,list):
                    for r in redirects:
                        perms_and_redirects.add(r)
                elif isinstance(redirects,str):
                    perms_and_redirects.add(redirects)
                else:
                    logger.error('ERROR: unexpected in redirect_from:  %s' % filepath)
                    exit(1)
            else:
                logger.debug('no redirect_from in frontmatter for file %s' % filepath)
    return perms_and_redirects



def create_hash_and_tags_mapping(tx_resources, tx_api_token, debug, perms_and_redirects, manual):
    '''
    for every given file uploaded to transifex, get its resource strings, check if they need to be marked as locked and
    save their hashes for further processing if this is the case
    tx_resources: a list containing all the uploaded transifex files 
    tx_api_token: transifex API token
    debug: if true be verbose
    manual: if true the upload will be done file by file under the supervision of the developer
    return a dictionary containing the string hash and resource name
    '''

    hash_and_tags_mapping=dict()
    for res in tx_resources:
        url = 'https://www.transifex.com/api/2/project/qubes/resource/' + res + '/translation/en/strings/'
        logger.info('will fetch url %s via curl' % url)
        if manual:
            manual_break()

        buf = BytesIO()
        c = Curl()
        c.setopt(c.URL, url)
        c.setopt(c.WRITEDATA, buf)
        c.setopt(c.CAINFO, where())
        c.setopt(c.USERPWD, 'api:' + tx_api_token)
        c.setopt(c.FOLLOWLOCATION, True)
        try:
            c.perform()
        except error as pe:
            logger.error("Pycurl: ", exc_info=True)
            c.close()
            exit(1)
        if c.getinfo(HTTP_CODE) == 404:
            logger.error("Following resource was not found in transifex: %s." % res)
            logger.error("Response: %s", buf.getvalue())
            c.close()
            continue
        if c.getinfo(HTTP_CODE) != 200:
            logger.error("Following resource could not be fetched: %s." % res)
            logger.error("Response: %s", buf.getvalue())
            c.close()
            continue
        c.close()

        body = loads(buf.getvalue())
        try:
            validate(body, TX_JSON_SCHEMA)
        except ValidationError as e:
            logger.error("SEVERE! invalid json input for res: %s, url: %s" %(res, url))
            logger.error("ValidationError: ", exc_info=True)
            exit(1)

        if debug:
            logger.debug("___________________________")
            logger.debug("resource strings for file %s" % res)

        if isinstance(body, list):

            for item in body:
                if isinstance(item, dict):
                    if any( item[KEY_KEY] == k for k in KEY_PATTERNS ) \
                            or (item[SOURCE_STRING_KEY].startswith('![') and item[SOURCE_STRING_KEY].endswith('.png)')) \
                            or any( check_reg(item[KEY_KEY], kr) for kr in KEY_REGEX_LOCK_PATTERNS ) \
                            or any( item[SOURCE_STRING_KEY] == s for s in SOURCE_PATTERNS ) \
                            or any( item[SOURCE_STRING_KEY] == s for s in perms_and_redirects ) \
                            or any( check_reg(item[SOURCE_STRING_KEY], sr) for sr in  SOURCE_REGEX_PATTERNS ) \
                            or check_for_liquid_expression( item[SOURCE_STRING_KEY] ):

                                hash_and_tags_mapping.update( {res + '.' + item[STRING_HASH_KEY] : res} )
                                to_debug = {res + "." + item[STRING_HASH_KEY] : [item[KEY_KEY], item[SOURCE_STRING_KEY]]}
                                tagged_locked.update(to_debug)
                                if debug:
                                    logger.debug("The following resource string will be tagged as 'locked' %s" % to_debug)
                else:
                    logger.error("got some weird stuff from transifex: %s" % item)
                    exit(1)
        else:
            logger.error("got some weird stuff from transifex: %s" % body)
            exit(1)

    return hash_and_tags_mapping 
         
def tag_strings_as_locked(hash_and_tag, tx_api_token, debug):
    '''
    upload locked tags for given string hashes for given strings for given files
    hash_and_tag: dicitonary containing {string_hash: filename}
    tx_api_token: transifex API token
    debug: if true be verbose
    '''

    for stringreshash, filename in hash_and_tag.items():
        res_hash = stringreshash.split('.')
        stringhash = res_hash[1]
        url = 'https://www.transifex.com/api/2/project/qubes/resource/' + filename + '/source/' + stringhash + '/'
        logger.info('put tag %s via curl' % url)
        buf = BytesIO()
        c = Curl()
        c.setopt(c.URL, url)
        c.setopt(WRITEFUNCTION, buf.write)
        c.setopt(c.CUSTOMREQUEST, 'PUT')
        c.setopt(c.POST, 1)
        c.setopt(c.USERPWD, 'api:' + tx_api_token)
        c.setopt(c.FOLLOWLOCATION, True)

        #c.setopt(c.POSTFIELDS, UPDATE_TAGS)
        if any(filename.endswith(i) for i in DATA_TO_URL_MAPPING) and '_data_' in filename:
            spl = filename.split('_data_')
            comment = DATA_TO_URL_MAPPING[spl[len(spl)-1]]
            tags = '{"comment": "' + comment + '", "tags": ["locked"]}'
            c.setopt(c.POSTFIELDS, tags)
            c.setopt(c.HTTPHEADER, ['Content-Type: application/json',
                                'Content-Length: ' + str(len(tags)) ])
        else:
            c.setopt(c.POSTFIELDS, UPDATE_TAGS_LOCKED)
            c.setopt(c.HTTPHEADER, ['Content-Type: application/json',
                                'Content-Length: ' + str(len(UPDATE_TAGS_LOCKED)) ])
                                #'Content-Length: ' + str(len(UPDATE_TAGS)) ])

        try:
            c.perform()
        except error as pe:
            logger.error("Pycurl: ", exc_info=True)
            c.close()
            exit(1)
        if c.getinfo(HTTP_CODE) == 404:
            logger.error("Following string hash %s for file %s could not be tagged as 'locked'." % (stringhash, filename))
            logger.error("Response: %s", buf.getvalue())
            c.close()
            continue
        if c.getinfo(HTTP_CODE) != 200:
            logger.error("Following string hash %s for file %s could not be tagged as 'locked'" % (stringhash, filename))
            logger.error("Response: %s", buf.getvalue())
            c.close()
            continue
        c.close()

        if debug:
            logger.debug('---------------------')
            logger.debug(buf.getvalue())

if __name__ == '__main__':
    # python _utils/tag_as_locked.py _utils/tx-resource-names _utils/tx-sourcesnames api-token --debug --manual 
    parser = ArgumentParser()
    # provide the file from tx configuration containing the resource names 
    parser.add_argument("tx_resourcenamesfile")
    # provide the file from tx configuration containing only the original source filenames 
    parser.add_argument("tx_sourcesnamesfile")
    # whether or not to write debug json files
    parser.add_argument("--debug", action='store_true')
    # whether or not to tag file by a file
    parser.add_argument("--manual", action='store_true')


    args = parser.parse_args()
    configure_logging(LOG_FILE_NAME)

    manual = args.manual

    if not isfile(args.tx_resourcenamesfile):
        print("please check your transifex resource names file")
        logger.error("please check your transifex resource names file")
        sys.exit(1)

    if not isfile(args.tx_sourcesnamesfile):
        print("please check your transifex original sourcenames file")
        logger.error("please check your transifex original sourcenames file")
        sys.exit(1)

    tx_resources = []
    with iopen(args.tx_resourcenamesfile) as f:
        tx_resources = f.readlines()
    tx_resources = [ t.rstrip() for t in tx_resources] 


    # testing on
    if manual:
        manual_break()

    if 'TX_TOKEN' not in environ:
        parser.error('TX_TOKEN variable not set')
    tx_api_token = environ['TX_TOKEN']
    perms_and_redirects = get_all_original_permalinks_and_redirects(args.tx_sourcesnamesfile)
    hash_and_tags_mapping = create_hash_and_tags_mapping(tx_resources, tx_api_token, args.debug, perms_and_redirects, manual)

    if args.debug:
        logger.debug("------------------------------------------------")
        logger.debug("----------HASH 2 TAG NOTRANSLATE MAPPING--------")
        logger.debug("------------------------------------------------")
        logger.debug(dumps(hash_and_tags_mapping, indent=4))
        logger.debug("------------------------------------------------")
        logger.debug("------------------------------------------------")
        logger.debug("------------------------------------------------")
        logger.debug("-------------STRINGS TAGGED NOTRANSLATE---------")
        logger.debug("------------------------------------------------")
        logger.debug("------------------------------------------------")
        logger.debug(dumps(tagged_locked, indent=4))
        logger.debug("------------------------------------------------")
        logger.debug("------------------------------------------------")
        logger.debug("------------------------------------------------")

    tag_strings_as_locked(hash_and_tags_mapping, tx_api_token, args.debug)




