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
tx config mapping-bulk -p qubes --source-language en  --type GITHUBMARKDOWN -f '.md' -d --source-file-dir _doc/en/_doc/ -i _dev --expression '_qubes-translated/<lang>/_doc/{filepath}/{filename}{extension}'   --execute
tx config mapping-bulk -p qubes --source-language en --type GITHUBMARKDOWN -f '.md' -d --source-file-dir pages --expression '_qubes-translated/<lang>/pages/{filepath}/{filename}{extension}' --execute
tx config mapping-bulk -p qubes --source-language en --type GITHUBMARKDOWN -f '.md' -d --source-file-dir news --expression '_qubes-translated/<lang>/news/{filepath}/{filename}{extension}' --execute

#HTML
tx config mapping -r qubes._doc_en__doc_introduction_intro --source-lang en  --type HTML --source-file _doc/en/_doc/introduction/intro.html '_qubes-translated/<lang>/_doc/introduction/intro.html' --execute
tx config mapping -r qubes.pages_partners --source-lang en  --type HTML --source-file pages/partners.html '_qubes-translated/<lang>/pages/partners.html' --execute
tx config mapping -r qubes.pages_home --source-lang en  --type HTML --source-file pages/home.html '_qubes-translated/<lang>/pages/home.html' --execute

tx config  mapping -r qubes.data_architecture --source-lang en --type YAML_GENERIC --source-file _data/architecture.yml --expression '_qubes-translated/<lang>/_data/<lang>/architecture.yml' --execute
tx config  mapping -r qubes.data_index --source-lang en --type YAML_GENERIC --source-file _data/index.yml --expression '_qubes-translated/<lang>/_data/<lang>/index.yml' --execute
tx config  mapping -r qubes.data_includes --source-lang en --type YAML_GENERIC --source-file _data/includes.yml --expression '_qubes-translated/<lang>/_data/<lang>/includes.yml' --execute
tx config  mapping -r qubes.data_teamtexts --source-lang en --type YAML_GENERIC --source-file _data/teamtexts.yml --expression '_qubes-translated/<lang>/_data/<lang>/teamtexts.yml' --execute
tx config  mapping -r qubes.data_team --source-lang en --type YAML_GENERIC --source-file _data/team.yml --expression '_qubes-translated/<lang>/_data/<lang>/team.yml' --execute
tx config  mapping -r qubes.data_experts --source-lang en --type YAML_GENERIC --source-file _data/experts.yml --expression '_qubes-translated/<lang>/_data/<lang>/experts.yml' --execute
tx config  mapping -r qubes.data_download --source-lang en --type YAML_GENERIC --source-file _data/download.yml --expression '_qubes-translated/<lang>/_data/<lang>/download.yml' --execute
tx config  mapping -r qubes.data_hcl --source-lang en --type YAML_GENERIC --source-file _data/hcl.yml --expression '_qubes-translated/<lang>/_data/<lang>/hcl.yml' --execute
tx config  mapping -r qubes.data_research --source-lang en --type YAML_GENERIC --source-file _data/research.yml --expression '_qubes-translated/<lang>/_data/<lang>/research.yml' --execute
tx config  mapping -r qubes.data_style_guide_content --source-lang en --type YAML_GENERIC --source-file _data/style_guide_content.yml --expression '_qubes-translated/<lang>/_data/<lang>/style_guide_content.yml' --execute

crudini --del .tx/config qubes._doc_en__doc_README
crudini --del .tx/config qubes._doc_en__doc_CONTRIBUTING

sed -i 's/_doc_en__doc/doc/g' .tx/config


echo "#####################################################################################"
echo "############# Please pay attention to the changes made to the current tx config #####"
echo "############# Do you have to delete some resources on transifex manually? ###########"
echo "############# left is the current, on the right is the old tx config ################"
echo "#####################################################################################"
diff .tx/config /tmp/tx_config_old --color
