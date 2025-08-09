#!/bin/bash
echo find /home/widehyo/.vim -type f | grep -v "bundle" | grep ".vim$" | cut -c20- | tar -czvf /home/widehyo/gitclone/dot_files/dot_vim/vimconf.tgz --directory /home/widehyo/.vim/ --files-from -
find /home/widehyo/.vim -type f | grep -v "bundle" | grep ".vim$" | cut -c20- | tar -czvf /home/widehyo/gitclone/dot_files/dot_vim/vimconf.tgz --directory /home/widehyo/.vim/ --files-from -
echo tar -xzvf /home/widehyo/gitclone/dot_files/dot_vim/vimconf.tgz --directory /home/widehyo/gitclone/dot_files/dot_vim
tar -xzvf /home/widehyo/gitclone/dot_files/dot_vim/vimconf.tgz --directory /home/widehyo/gitclone/dot_files/dot_vim
echo rm /home/widehyo/gitclone/dot_files/dot_vim/vimconf.tgz
rm /home/widehyo/gitclone/dot_files/dot_vim/vimconf.tgz
