if exists('g:loadedGbufs')
	finish
endif
let g:loadedGbufs = 1

" *** Search And Replace with Macro Q ***
"         Multiple Files at a time

" cdo - Macro Replace with Q - The QuickFix List - one line at a time
" macro q doesn't need the % in ':%s/TERM/REPLACE/g'
" easiest previewing using '/'
function! MacroReplaceQuickFixWithQOneLine()
    cdo execute "normal! @q" | w
endfunction
command! MacroRplceQckFxWithQOneLine call MacroReplaceQuickFixWithQOneLine()
command! Mcrq call MacroReplaceQuickFixWithQOneLine()

" bufdo - Macro Replace with Q - The Buffers List - entire file at a time
" does not need to mess with the QuickFix List
" macro requires '%' to search entire file at a time
"   qq:%s/OLD/NEW/g<ENTER>q
function! MacroReplaceBuffersWithQEntireFile()
    bufdo execute "normal! @q" | w
endfunction
command! MacroRplceBuffersWithQEntireFile call MacroReplaceBuffersWithQEntireFile()
command! Mbrq call MacroReplaceBuffersWithQEntireFile()

" bufdo - Macro Replace with Q - The Buffers List - entire file at a time
" does not need to mess with the QuickFix List
" macro requires '%' to search entire file at a time
"   qq:%s/OLD/NEW/g<ENTER>q
function! MacroReplaceQuickFixWithQEntireFile()
    cfdo execute "normal! @q" | w
endfunction
command! MacroReplaceQuickFixWithQEntireFile call MacroReplaceQuickFixWithQEntireFile()
command! Mcfrq call MacroReplaceQuickFixWithQEntireFile()

" Searching only buffer list, to open in Quickfix list
" Complimentary to brq & crq
"
" BufdoVimgrepaddCopen
" Search in all open buffers for -- the last thing you search for --
" ... or give it a specific search term by command line
" https://vim.fandom.com/wiki/Search_on_all_opened_buffers
function! ClearQuickfixList()
  call setqflist([])
endfunction

function! BufdoVimgrepaddCopen(...)
  let l:optional_arg = get(a:, 1, 0)
  call ClearQuickfixList()
  let l:search_term = ''
  " this works on A9 8.0.1763, and == is close, but should proly be 'if l:optional_arg'
  if l:optional_arg is 0
      " default is last search term, saved in register @/
      let l:search_term = getreg("/")
  else
      let l:search_term = l:optional_arg
  endif
  exe 'bufdo vimgrepadd "' . l:search_term . '" %'
  exe 'copen'
  " cnext " not sure what this was supposed to do
endfunction
command! -nargs=* Gbufs call BufdoVimgrepaddCopen(<f-args>)
command! -nargs=* GrepBuffers call BufdoVimgrepaddCopen(<f-args>)

" see BufdoVimgrepaddCopen for comments
function! BufdoVimgrepaddCopenAll(...)
  let l:optional_arg = get(a:, 1, 0)
  call ClearQuickfixList()
  let l:search_term = ''
  if l:optional_arg is 0
      let l:search_term = getreg("/")
  else
      let l:search_term = l:optional_arg
  endif
  exe 'bufdo vimgrepadd ' . l:search_term . ' % | copen'
endfunction
command! -nargs=* Gbufsall call BufdoVimgrepaddCopenAll(<f-args>)
command! -nargs=* GrepBuffersall call BufdoVimgrepaddCopenAll(<f-args>)

" Search in all open buffers for -- what's under the cursor --
function! BuffersList()
  let all = range(0, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction

" seems same as gbufs, gets partial matches
function! GrepBuffersForWordOnCursor (expression)
  call ClearQuickfixList()
  exec 'vimgrep/'.a:expression.'/ '.join(BuffersList())
  exec 'copen'
endfunction
command! -nargs=+ GrepBufs call GrepBuffersForWordOnCursor(<q-args>)
