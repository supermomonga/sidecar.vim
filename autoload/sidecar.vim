" media viewer with vim
" Version: 0.0.1
" Author : supermomonga (@supermomonga)
" License: NYSL

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" function! sidecar#setpid(pid)
"   let s:process.pid = a:pid
" endfunction

function! sidecar#echopid()
  echo s:process.pid
endfunction

function! sidecar#open(target)
  if !sidecar#is_run()
    echo 'You need to start sidecar first.'
    " call sidecar#start()
  else
    let sock = vimproc#socket_open('localhost', g:sidecar_ruby_port)
    call sock.write(a:target)
    call sock.close()
  endif
endfunction

function! sidecar#start()
  if !sidecar#is_run()
    let s:process = vimproc#popen2(join([g:sidecar_ruby_path, g:sidecar_script_path, g:sidecar_ruby_port], ' '))
    echo 'Sidecar launched. (pid:' . s:process.pid . ')'
  else
    echo 'Sidecar already launched. (pid:' . s:process.pid . ')'
  endif
endfunction

function! sidecar#stop()
  if sidecar#is_run()
    call s:process.kill(3)
    call s:process.waitpid()
    echo 'Sidecar closed. (pid:' . s:process.pid . ')'
    " debug for vimproc#kill
    " kill seems make zombie process...
    " echo 'last errmsg : ' . vimproc#get_last_errmsg()
    " echo 'last status : ' . vimproc#get_last_status()
    unlet s:process
  endif
endfunction

function! sidecar#is_run()
  if exists('s:process')
    return s:process.kill(0) == 0
  else
    return 0
  endif
endfunction

function! sidecar#status()
  echo 'pid:' . s:process.pid . ' is ' . (sidecar#is_run() ? 'running' : 'not running' )
endfunction


" Initialize
let g:sidecar_ruby_path = get(g:, 'sidecar_ruby_path', 'ruby')
let g:sidecar_ruby_port = get(g:, 'sidecar_ruby_port', '12345')


let &cpo = s:save_cpo
unlet s:save_cpo
