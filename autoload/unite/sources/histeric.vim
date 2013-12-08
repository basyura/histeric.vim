
function! unite#sources#histeric#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'histeric',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'default_action' : {'common' : 'execute'},
      \ }

function! s:source.gather_candidates(args, context)
  let list = []
  if filereadable(fnamemodify('~/.vim_histeric', ':p'))
    for cmd in reverse(readfile(fnamemodify('~/.vim_histeric', ':p')))
      let cmd = substitute(cmd, '\s\+$', '', '')
      call add(list, {
            \ "word" : cmd ,
            \ })
    endfor
  endif

  return list
endfunction

let s:source.action_table.execute = {'description' : 'execute history'}
function! s:source.action_table.execute.func(candidate)
  execute a:candidate.word
endfunction
