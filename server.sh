#!/bin/bash
ip=$(ipconfig getifaddr en1)
paths="./:./_tpl/:./_tpl/tpl-inc/:./_inc/"
sleep 1 && open "http://${ip}:8000/" &
php -d include_path="${paths}" -d open_basedir="${paths}" -d session.save_path="_session" -S "${ip}:8000"