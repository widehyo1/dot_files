function! SetRegisterCwordFirstChar()
  let [_, _, curcol, _, _] =  getcurpos()
  if curcol == 1
    normal vy
  else
    normal viwbhvyl
  endif
endfunction

function! ToggleBackTick()
  call SetRegisterCwordFirstChar()
  if @" == "`"
    call UnSurrondBackTick()
  else
    call SurrondBackTick()
  endif
endfunction

function! SurrondBackTick()
  " Get cursor infomations
  normal ciw``PT`
endfunction

function! UnSurrondBackTick()
  normal F`xf`xb
endfunction

function! ToggleQuote()
  call SetRegisterCwordFirstChar()
  if @" == "'"
    call UnSurrondQuote()
  else
    call SurrondQuote()
  endif
endfunction

function! SurrondQuote()
  " Get cursor infomations
  normal ciw''PT'
endfunction

function! UnSurrondQuote()
  normal F'xf'xb
endfunction

function! ToggleDoubleQuote()
  call SetRegisterCwordFirstChar()
  if @" == '"'
    call UnSurrondDoubleQuote()
  else
    call SurrondDoubleQuote()
  endif
endfunction

function! SurrondDoubleQuote()
  " Get cursor infomations
  normal ciw""PT"
endfunction

function! UnSurrondDoubleQuote()
  normal F"xf"xb
endfunction

function! ToggleRoundBraket()
  call SetRegisterCwordFirstChar()
  if @" == "("
    call UnSurrondRoundBraket()
  else
    call SurrondRoundBraket()
  endif
endfunction

function! SurrondRoundBraket()
  " Get cursor infomations
  normal ciw()PT(
endfunction

function! UnSurrondRoundBraket()
  normal F(xf)xb
endfunction

function! ToggleAngleBraket()
  call SetRegisterCwordFirstChar()
  if @" == "<"
    call UnSurrondAngleBraket()
  else
    call SurrondAngleBraket()
  endif
endfunction

function! SurrondAngleBraket()
  " Get cursor infomations
  normal ciw<>PT<
endfunction

function! UnSurrondAngleBraket()
  normal F<xf>xb
endfunction

function! ToggleCurlyBraket()
  call SetRegisterCwordFirstChar()
  if @" == "{"
    call UnSurrondCurlyBraket()
  else
    call SurrondCurlyBraket()
  endif
endfunction

function! SurrondCurlyBraket()
  " Get cursor infomations
  normal ciw{}PT{
endfunction

function! UnSurrondCurlyBraket()
  normal F{xf}xb
endfunction

function! ToggleSquareBraket()
  call SetRegisterCwordFirstChar()
  if @" == "["
    call UnSurrondSquareBraket()
  else
    call SurrondSquareBraket()
  endif
endfunction

function! SurrondSquareBraket()
  " Get cursor infomations
  normal ciw[]PT[
endfunction

function! UnSurrondSquareBraket()
  normal F[xf]xb
endfunction
