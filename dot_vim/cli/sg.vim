" sg
nnoremap <leader>sgs <cmd>e ~/script.yaml<CR>
nnoremap <leader>sgp i```<cr>```k<cmd>read !sg scan -r ~/script.yaml --json \| jq -r -f ~/.cli/jq/extract_sg_result.jq<cr>
