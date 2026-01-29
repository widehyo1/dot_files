function! PopupFilter(winid, key) abort
    " when you use single quote like '<cr>', it does not works
    " if you want to match special chars in vimscript, use double quote
    if a:key ==# "j"
        call win_execute(a:winid, "normal! j")
    elseif a:key ==# "k"
        call win_execute(a:winid, "normal! k")
    elseif a:key ==# "u"
        call win_execute(a:winid, "normal! \<c-b>")
    elseif a:key ==# "v"
        call win_execute(a:winid, "normal! v")
    elseif a:key ==# "V"
        call win_execute(a:winid, "normal! V")
    elseif a:key ==# "y"
        call win_execute(a:winid, "normal! y")
    elseif a:key ==# "G"
        call win_execute(a:winid, "normal! G")
    elseif a:key ==# "g"
        call win_execute(a:winid, "normal! gg")
    elseif a:key ==# "\<cr>"
        let [_, line, _, _, _] = getcurpos(a:winid)
        call popup_close(a:winid, line)
    elseif a:key ==# "\<c-d>"
        call win_execute(a:winid, "normal! \<c-d>")
    elseif a:key ==# "\<c-u>"
        call win_execute(a:winid, "normal! \<c-u>")
    elseif a:key ==# "\<c-f>"
        call win_execute(a:winid, "normal! \<c-f>")
    elseif a:key ==# "\<c-b>"
        call win_execute(a:winid, "normal! \<c-b>")
    elseif a:key ==# "\<space>"
        call win_execute(a:winid, "normal! \<c-f>")
    elseif a:key ==# "q"
        call popup_close(a:winid)
    else
        return v:false
    endif
    return v:true
endfunction



