#!/bin/bash
echo find /home/widehyo/.config/nvim -type f | grep -E ".lua$|.vim$" | xargs -I@ rm @
find /home/widehyo/.config/nvim -type f | grep -E ".lua$|.vim$" | xargs -I@ rm @
echo find /home/widehyo/gitclone/dot_files/dot_config/nvim -type f | grep -E ".lua$|.vim$" | cut -c50- | tar -czvf /home/widehyo/.config/nvim/nvimconf.tgz --directory /home/widehyo/gitclone/dot_files/dot_config/nvim/ --files-from -
find /home/widehyo/gitclone/dot_files/dot_config/nvim -type f | grep -E ".lua$|.vim$" | cut -c50- | tar -czvf /home/widehyo/.config/nvim/nvimconf.tgz --directory /home/widehyo/gitclone/dot_files/dot_config/nvim/ --files-from -
echo tar -xzvf /home/widehyo/.config/nvim/nvimconf.tgz --directory /home/widehyo/.config/nvim
tar -xzvf /home/widehyo/.config/nvim/nvimconf.tgz --directory /home/widehyo/.config/nvim
echo rm /home/widehyo/.config/nvim/nvimconf.tgz
rm /home/widehyo/.config/nvim/nvimconf.tgz
