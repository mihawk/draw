#!/bin/bash

cat rel/reltool.config | grep "{rel" | grep draw | awk -F',' '{print $3}' | sed 's/ //g' | sed 's/"//g'
