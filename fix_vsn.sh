#!/bin/bash

APP_DIR=../apps

for i in $(ls ${APP_DIR})
do
 F=${APP_DIR}/$i/ebin/$i.app
 cat ${F} | sed 's/\/bin\/sh: 1: \(.*\): not found/\1/' > ${F}.tmp
 mv ${F}.tmp ${F}
done
