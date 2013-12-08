
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
  let list    = []
  let histmap = {}

  for v in range(0, histnr(":"))
    let cmd = histget(':', v)
    let cmd = substitute(cmd, '\s\+$', '', '')
    if cmd != ''
      if !has_key(histmap, ':' . cmd)
        call add(list, { "word" : ':' . cmd  })
        let histmap[':' . cmd] = 1
      endif
    endif
  endfor

  call reverse(list)

  let file    = fnamemodify('~/.vim_histeric', ':p')
  if filereadable(file)
    for cmd in reverse(readfile(file))
      let cmd = substitute(cmd, '\s\+$', '', '')
      if has_key(histmap, cmd)
        continue
      endif
      let histmap[cmd] = 1
      call add(list, { "word" : cmd  })
    endfor
  endif
  return list
endfunction

let s:source.action_table.execute = {'description' : 'execute history'}
function! s:source.action_table.execute.func(candidate)
  execute a:candidate.word
endfunction
