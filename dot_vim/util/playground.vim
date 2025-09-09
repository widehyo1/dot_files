function! TablineBuffers()
  let curBuf = bufnr('%')

  let bufNameList = []

  for buf in filter(getbufinfo(), 'v:val.listed')
    let bufName = ''
    if buf.name == ''
      let bufName = '[No Name]'
    else
      let bufName = fnamemodify(expand(buf.name), ':.:t')
    endif
    if buf.changed == 1
      let bufName = bufName .. ' +'
    endif
    if buf.bufnr == curBuf
      let bufName = '< ' .. bufName .. ' >'
    endif
    call add(bufNameList, bufName)
  endfor

  let bufNameStr = join(bufNameList, ' | ')
  return bufNameStr
endfunction

let result = TablineBuffers()
echo result
