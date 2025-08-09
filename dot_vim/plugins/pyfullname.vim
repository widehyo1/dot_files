" Vim function to check for project root and generate .tags if not found
function! GenerateTagsIfNeeded()
    " Find the pyproject.toml file (project root)
    let project_root = findfile('pyproject.toml', expand("%:p:h") . ";")

    if project_root == ""
        echo "pyproject.toml not found!"
        return
    endif

    " Check if .tags file exists in the project root
    let tags_file = project_root . "/.tags"

    if !filereadable(tags_file)
        " If .tags doesn't exist, generate it using ctags
        echo "Generating .tags file..."
        let cmd = 'cd ' . project_root . ' && ctags -R --languages=Python -f .tags .'
        call system(cmd)
    else
        echo ".tags file found, skipping generation."
    endif
endfunction

" Vim function to generate .pyfullnames file
function! GenerateFullnames()
    " Find the project root and ensure .tags exists
    call GenerateTagsIfNeeded()

    " Get the current buffer's file path
    let current_file = expand("%:p")

    " Get the project root by finding pyproject.toml
    let project_root = findfile('pyproject.toml', expand("%:p:h") . ";")
    
    if project_root == ""
        echo "pyproject.toml not found!"
        return
    endif

    " Get the path to .tags file
    let tags_file = project_root . "/.tags"

    " Use the Python script to process imports
    let imports = system('python3 ' . expand('~/.vim/plugins/process_imports.py') . ' ' . current_file)

    " Process the .tags file with awk to generate class, method, and function names
    let awk_command = 'awk -f ~/.vim/plugins/ctags_to_fullnames.awk ' . tags_file
    let tags_fullnames = system(awk_command)

    " Create or overwrite the .pyfullnames file
    let pyfullnames_file = project_root . "/.pyfullnames"
    call writefile(split(imports, "\n") + split(tags_fullnames, "\n"), pyfullnames_file)

    echo "Generated .pyfullnames in " . pyfullnames_file
endfunction

" Bind the function to a keymap
nnoremap <leader>gf :call GenerateFullnames()<CR>
