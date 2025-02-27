function! CopyPwd()
    redir @"
    execute 'echo fnamemodify(expand("%"), ":~:.")'
    redir END
    let @+ = @"
endfunction

function! JqYankVisual()
    let l:sel = join(getline("'<", "'>"), "\n")
    let l:result = system('jq -f ~/script.jq', l:sel)
    call setreg('+', l:result)
endfunction

function! AwkYankVisual()
    let l:sel = join(getline("'<", "'>"), "\n")
    let l:result = system('awk -f ~/script.awk', l:sel)
    call setreg('+', l:result)
endfunction
