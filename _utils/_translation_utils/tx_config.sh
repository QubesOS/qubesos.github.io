#!/bin/bash
# to be run from the git root
#to incoporate them back, no need

# add ref & lang attributes to newly created files
python3 _utils/_translation_utils/prepare_for_translation.py en _doc/ _utils/_translation_utils/COUNTER.txt

# because there is apparently a feature in tx config that doe snot update an existing configuration, every time everythin will be done from scratch:
# delete current tx configuration

mv .tx/config /tmp/tx_config_old

#init a tx configuration
tx init --skipsetup


# map the files with tx config
tx config mapping-bulk -p qubes --source-language en --type GITHUBMARKDOWN -f '.md' -d --source-file-dir _doc -i _dev --expression '_translated/<lang>/_doc/{filepath}/{filename}{extension}' --execute
tx config mapping-bulk -p qubes --source-language en --type GITHUBMARKDOWN -f '.md' -d --source-file-dir pages --expression '_translated/<lang>/pages/{filepath}/{filename}{extension}' --execute
tx config mapping-bulk -p qubes --source-language en --type GITHUBMARKDOWN -f '.md' -d --source-file-dir news --expression '_translated/<lang>/news/{filepath}/{filename}{extension}' --execute

#HTML
tx config mapping -r qubes._doc_introduction_intro --source-lang en  --type HTML --source-file _doc/introduction/intro.md '_translated/<lang>/_doc/introduction/intro.md' --execute
tx config mapping -r qubes.pages_partners --source-lang en  --type HTML --source-file pages/partners.html '_translated/<lang>/pages/partners.html' --execute
tx config mapping -r qubes.pages_home --source-lang en  --type HTML --source-file pages/home.html '_translated/<lang>/pages/home.html' --execute

tx config mapping -r qubes.data_architecture --source-lang en --type YAML_GENERIC --source-file _data/architecture.yml --expression '_translated/<lang>/_data/<lang>/architecture.yml' --execute
tx config mapping -r qubes.data_doc_index --source-lang en --type YAML_GENERIC --source-file _data/doc-index.yml --expression '_translated/<lang>/_data/<lang>/doc-index.yml' --execute
tx config mapping -r qubes.data_includes --source-lang en --type YAML_GENERIC --source-file _data/includes.yml --expression '_translated/<lang>/_data/<lang>/includes.yml' --execute
tx config mapping -r qubes.data_team-page --source-lang en --type YAML_GENERIC --source-file _data/team-page.yml --expression '_translated/<lang>/_data/<lang>/team-page.yml' --execute
tx config mapping -r qubes.data_team --source-lang en --type YAML_GENERIC --source-file _data/team.yml --expression '_translated/<lang>/_data/<lang>/team.yml' --execute
tx config mapping -r qubes.data_experts --source-lang en --type YAML_GENERIC --source-file _data/experts.yml --expression '_translated/<lang>/_data/<lang>/experts.yml' --execute
tx config mapping -r qubes.data_downloads_page --source-lang en --type YAML_GENERIC --source-file _data/downloads-page.yml --expression '_translated/<lang>/_data/<lang>/downloads-page.yml' --execute
tx config mapping -r qubes.data_hcl --source-lang en --type YAML_GENERIC --source-file _data/hcl.yml --expression '_translated/<lang>/_data/<lang>/hcl.yml' --execute
tx config mapping -r qubes.data_research --source-lang en --type YAML_GENERIC --source-file _data/research.yml --expression '_translated/<lang>/_data/<lang>/research.yml' --execute
tx config mapping -r qubes.data_style_guide_page --source-lang en --type YAML_GENERIC --source-file _data/style-guide-page.yml --expression '_translated/<lang>/_data/<lang>/style-guide-page.yml' --execute

crudini --del .tx/config qubes._doc_README
crudini --del .tx/config qubes._doc_CONTRIBUTING

sed -i 's/\._doc_/.doc_/' .tx/config

echo "#####################################################################################"
echo "############# Please pay attention to the changes made to the current tx config #####"
echo "############# Do you have to delete some resources on transifex manually? ###########"
echo "############# left is the current, on the right is the old tx config ################"
echo "#####################################################################################"
diff .tx/config /tmp/tx_config_old --color
