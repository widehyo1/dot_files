#!/bin/bash
echo find /home/widehyo/gitclone/dot_files/dot_config/nvim -type f | grep -E ".lua$|.vim$" | xargs -I@ rm @
find /home/widehyo/gitclone/dot_files/dot_config/nvim -type f | grep -E ".lua$|.vim$" | xargs -I@ rm @
echo find /home/widehyo/.config/nvim -type f | grep -E ".lua$|.vim$" | cut -c28- | tar -czvf /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz --directory /home/widehyo/.config/nvim/ --files-from -
find /home/widehyo/.config/nvim -type f | grep -E ".lua$|.vim$" | cut -c28- | tar -czvf /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz --directory /home/widehyo/.config/nvim/ --files-from -
echo find /home/widehyo/.config/nvim -type f | grep -E ".lua$|.vim$" | cut -c28- | tar -czvf /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz --directory /home/widehyo/.config/nvim/ --files-from -
find /home/widehyo/.config/nvim -type f | grep -E ".lua$|.vim$" | cut -c28- | tar -czvf /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz --directory /home/widehyo/.config/nvim/ --files-from -
echo tar -xzvf /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz --directory /home/widehyo/gitclone/dot_files/dot_config/nvim
tar -xzvf /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz --directory /home/widehyo/gitclone/dot_files/dot_config/nvim
echo rm /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz
rm /home/widehyo/gitclone/dot_files/dot_config/nvim/nvimconf.tgz
