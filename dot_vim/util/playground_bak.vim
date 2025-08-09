function s:popup_filter(winid, key) abort
    if a:key ==# "\<c-j>"
        call win_execute(a:winid, "normal! \<c-e>")
    elseif a:key ==# "\<c-k>"
        call win_execute(a:winid, "normal! \<c-y>")
    elseif a:key ==# "\<c-g>"
        call win_execute(a:winid, "normal! G")
    elseif a:key ==# "\<c-t>"
        call win_execute(a:winid, "normal! gg")
    elseif a:key ==# 'q'
        call popup_close(a:winid)
    else
        return v:false
    endif
    return v:true
endfunction

call range(100)
        \ ->map('string(v:val)')
        \ ->popup_create({
        \   'border': [],
        \   'moved': 'any',
        \   'minwidth': 60,
        \   'maxwidth': 60,
        \   'minheight': 10,
        \   'maxheight': 10,
        \   'filter': funcref('s:popup_filter'),
        \   'filtermode': 'n',
        \   'mapping': v:false
        \ })
