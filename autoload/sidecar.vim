" media viewer with vim
" Version: 0.0.1
" Author : supermomonga (@supermomonga)
" License: NYSL

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! sidecar#setpid(pid)
  let s:pid = a:pid
endfunction

function! sidecar#echopid()
  echo s:pid
endfunction

function! sidecar#open(target)
	let sock = vimproc#socket_open('localhost', g:sidecar_ruby_port)
	call sock.write(a:target)
	call sock.close()
endfunction

function! sidecar#start()
  if !sidecar#is_run()
    let s:pid = vimproc#popen2(join([g:sidecar_ruby_path, g:sidecar_script_path, g:sidecar_ruby_port], ' '))['pid']
    echo 'Sidecar launched. (pid:' . s:pid . ')'
  else
    echo 'Sidevar already launched. (pid:' . s:pid . ')'
  endif
endfunction

function! sidecar#stop()
  if sidecar#is_run()
    call vimproc#kill(s:pid, 3)
    echo 'Sidecar closed. (pid:' . s:pid . ')'
  endif
endfunction

function! sidecar#is_run()
  if exists('s:pid')
    return vimproc#kill(s:pid, 0) == 0
  else
    return 0
  endif
endfunction

function! sidecar#status()
  echo 'pid:' . s:pid . ' is ' . (sidecar#is_run() ? 'running' : 'not running' )
endfunction


" Initialize
let g:sidecar_ruby_path = get(g:, 'sidecar_ruby_path', 'ruby')
let g:sidecar_ruby_port = get(g:, 'sidecar_ruby_port', '12345')


let &cpo = s:save_cpo
unlet s:save_cpo
