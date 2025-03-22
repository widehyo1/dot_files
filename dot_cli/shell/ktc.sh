#!/bin/bash

kt_file_name=${1##*/}
jar_file_name=${kt_file_name/.kt/.jar}
echo kotlinc $1 -include-runtime -d $jar_file_name
kotlinc $1 -include-runtime -d $jar_file_name
