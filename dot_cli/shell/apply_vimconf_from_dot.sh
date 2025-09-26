#!/bin/bash
echo find /home/widehyo/._vim -type f | grep -v "bundle" | grep ".vim$" | cut -c20- | xargs -I@ rm @
find /home/widehyo/._vim -type f | grep -v "bundle" | grep ".vim$" | cut -c20- | xargs -I@ rm @
echo find /home/widehyo/gitclone/dot_files/dot_vim -type f | grep -E ".vim$" | cut -c42- | tar -czvf /home/widehyo/.vim/vimconf.tgz --directory /home/widehyo/.vim --files-from -
find /home/widehyo/gitclone/dot_files/dot_vim -type f | grep -E ".vim$" | cut -c42- | tar -czvf /home/widehyo/.vim/vimconf.tgz --directory /home/widehyo/.vim --files-from -
echo tar -xzvf /home/widehyo/.vim/vimconf.tgz --directory /home/widehyo/.vim
tar -xzvf /home/widehyo/.vim/vimconf.tgz --directory /home/widehyo/.vim
echo rm /home/widehyo/.vim/vimconf.tgz
rm /home/widehyo/.vim/vimconf.tgz
