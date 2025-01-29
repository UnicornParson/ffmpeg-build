#!/bin/bash
set -e
LOGFILE=build.$(date +%s%N).log
touch $LOGFILE
echo $LOGFILE
cmake CMakeLists.txt 2>&1 | tee -ai $LOGFILE
make 2>&1 | tee -ai $LOGFILE | grep --color=always -E 'error:|$'

