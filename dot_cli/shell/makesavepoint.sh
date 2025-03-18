#!/bin/bash
CHECK= # backup directory
echo tar -czvf `date '+%m%d'`.tgz -T temp.txt
tar -czvf `date '+%m%d'`.tgz -T temp.txt
echo mv `date '+%m%d'`.tgz $CHECK
mv `date '+%m%d'`.tgz $CHECK
echo cp temp.txt $CHECK/before.txt
cp temp.txt $CHECK/before.txt

