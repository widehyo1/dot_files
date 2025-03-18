#!/bin/bash
CHECK= # backup directory
WORKDIR= # working directory
tgzfile=`date '+%m%d'`.tgz
echo mkdir -p $CHECK/compare/before
mkdir -p $CHECK/compare/before
echo mkdir -p $CHECK/compare/current
mkdir -p $CHECK/compare/current
echo cd $CHECK
cd $CHECK
echo pwd
pwd
echo ls
ls
echo tar -czvf before.tgz -T before.txt
tar -czvf before.tgz -T before.txt
echo mv before.tgz before.txt compare/before
mv before.tgz before.txt compare/before
echo rm -rf compare/before/$WORKDIR
rm -rf compare/before/$WORKDIR
echo rm -rf compare/current/$WORKDIR
rm -rf compare/current/$WORKDIR
echo tar -xzvf $tgzfile
tar -xzvf $tgzfile
echo mv $tgzfile compare/current
mv $tgzfile compare/current
echo cd $CHECK/compare/before
cd $CHECK/compare/before
echo pwd
pwd
echo ls
ls
echo tar -xzvf before.tgz
tar -xzvf before.tgz
cd $CHECK/compare/current
echo pwd
pwd
echo ls
ls
echo tar -xzvf $tgzfile
tar -xzvf $tgzfile

