function! ChangeGitDir()
  let dot_git = finddir('.git', expand('%:p:h') . ';')
  let project_root = fnamemodify(dot_git, ':p:h:h')
  call chdir(project_root)
  echo getcwd()
endfunction
