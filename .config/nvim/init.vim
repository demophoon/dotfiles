source ~/.vimrc

nnoremap <leader><leader> :CocAction<cr>

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
