
augroup histeric-save
  autocmd!
  autocmd VimLeavePre * call s:save_history()
augroup END

function! s:save_history()
  let histmap   = {}
  let histories = []
  for v in range(0, histnr(":"))
    let cmd = histget(':', v)
    let cmd = substitute(cmd, '\s\+$', '', '')
    if cmd != ''
      if !has_key(histmap, ':' . cmd)
        call add(histories, ':' . cmd)
        let histmap[':' . cmd] = 1
      endif
    endif
  endfor

  call s:filter(histories, histmap, '~/.vim_histeric')
  call s:filter(histories, histmap, '~/.viminfo')
  
  call writefile(histories,  fnamemodify('~/.vim_histeric', ':p'))
endfunction

function! s:filter(histories, histmap, file)
  let file = fnamemodify(a:file, ':p')
  if !filereadable(file)
    return
  endif

  let histories = a:histories
  let histmap   = a:histmap

  for cmd in readfile(file)
    let cmd = substitute(cmd, '\s\+$', '', '')
    if cmd =~ '^:' && !has_key(histmap, cmd)
      call add(histories, cmd)
      let histmap[cmd] = 1
    endif
  endfor
endfunction
