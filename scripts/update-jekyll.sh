#!/bin/bash

# pico_base_dir: "/picoCTF"
# web_code_dir: "{{pico_base_dir}}/picoCTF-web"
# pico_web_api_dir:     "{{ web_code_dir }}"
# web_build_dir:        "/picoCTF-web-build"

#- name: Synchronize picoCTF-web to a directory on host
#  synchronize:
#    src: "{{ pico_web_api_dir }}/"
#    dest: "{{ web_build_dir }}"
#    delete: yes
#  delegate_to: "{{ inventory_hostname }}"

# Run Jekyll and rebuild new web
# cd {{ web_build_dir }}/web && jekyll build

POSTS_SRC_DIR="/picoCTF/picoCTF-web/web/_posts"
WEB_BUILD_DIR="/picoCTF-web-build/web"
POSTS_DST_DIR="$WEB_BUILD_DIR/_posts"

ssh -i ../.vagrant/machines/web/virtualbox/private_key -t vagrant@192.168.2.2 "rm -rf $POSTS_DST_DIR && cp -r $POSTS_SRC_DIR $WEB_BUILD_DIR && cd $WEB_BUILD_DIR && sudo jekyll build"
