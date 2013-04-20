" media viewer with vim
" Version: 0.0.1
" Author : supermomonga (@supermomonga)
" License: NYSL

if exists('g:loaded_sidecar')
  finish
endif
let g:loaded_sidecar = 1

let s:save_cpo = &cpo
set cpo&vim

" Default settings
let g:sidecar_script_path = substitute(substitute(expand('<sfile>'), '\.vim$', '.rb', ''), '\\', '/', 'g')


" Define commands
command! -nargs=1 Sidecar call sidecar#open(<q-args>)
command! SidecarStart call sidecar#start()
command! SidecarStop call sidecar#stop()

let &cpo = s:save_cpo
unlet s:save_cpo
