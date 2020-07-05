" Only do this when not yet done for this buffer
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Specify format for comments
setlocal comments+=fb://
let &l:commentstring = '// %s'
let b:undo_ftplugin = 'setlocal comments< commentstring<'
