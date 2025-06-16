setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
iabbrev <buffer> \dig; digraph {<CR>}
iabbrev <buffer> \gra; graph {<CR>}
iabbrev <buffer> \fontname; fontname="Helvetica,Arial,snas-serif"
iabbrev <buffer> \node; node [fontname="Helvetica,Arial,snas-serif"]
iabbrev <buffer> \edge; edge [fontname="Helvetica,Arial,snas-serif"]
iabbrev <buffer> \dinit; digraph{<CR>fontname="Helvetica,Arial,snas-serif"<CR>node [fontname="Helvetica,Arial,snas-serif"]<CR>edge [fontname="Helvetica,Arial,snas-serif"]<CR>}
iabbrev <buffer> \ginit; graph{<CR>fontname="Helvetica,Arial,snas-serif"<CR>node [fontname="Helvetica,Arial,snas-serif"]<CR>edge [fontname="Helvetica,Arial,snas-serif"]<CR>}
iabbrev <buffer> \statediag; graph{<CR>fontname="Helvetica,Arial,snas-serif"<CR>node [fontname="Helvetica,Arial,snas-serif"]<CR>edge [fontname="Helvetica,Arial,snas-serif"]<CR>node [shape="doublecircle"] n004<CR>node [shape="point"] n003<CR>node [shape="circle"]<CR>rankdir=LR;<CR>}
iabbrev <buffer> \lr; rankdir=LR;
iabbrev <buffer> \n; n000 [label=""]
iabbrev <buffer> \e; n000 -> n000 [label=""]
