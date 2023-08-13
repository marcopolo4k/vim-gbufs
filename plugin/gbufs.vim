if exists('g:loadedGbufs')
	finish
endif
let g:loadedGbufs = 1

" *** Search And Replace with Macro Q ***
"         Multiple Files at a time
"
" Quick Instructions
" 1. load files in buffers
" 2. load files in quickfix list
" 3. make a macro labelled 'q'
" 4. '\cdoq' to run the macro on all the quickfix files
"
" ##########################
" Long Instructions
"
" 1. load files in buffers
"    ':grep SEARCHTERM' uses rg, and also populates quickfix list at same time
"
" 2. load quickfix list (from buffers is fast)
"    only if you loaded files without populating the quickfix list, choose one of:
"      search with '/', then '\gbufs' †
"        -OR-
"      :Gbufs SEARCHTERM
"        -OR-
"      cursor on word, then \gbufc (does NOT include word boundaries) ‡
"
" 3. make a macro labelled 'q' ('qq:s/OLD/NEW/g<ENTER>q')
"    cdo doesn't need a '%' b/c it'll search each line individually
"
" 4. the effects can be seen, file by file if desired, see vim commands: '@q' ':n' '\b' '/'
"      I have other mappings for opening windows, watch this space for: '/sbv' '/sbh'
"
" 5. '\gbufq' (or any of the aliases) to do the remaining files
"
"
" † Alternative to '/' to search and populate Quickfix list:
"   1. Highlight ('ctrl-v' then move cursor around everything to search for)
"   2. '*'
"
"   This allows for full punctuation, eg around variables, and more
"   This adds word boundaries, specifically: \<SEARCHTERM\>
"   Searching will be slower than \gbufc
"   You'll proly see some errors eventually (reproducible bug reports pls)
"
" ‡ Alternatives to gbufc, which DOES include word boundaries
"   1. Install Plugin or add function to ~/.vimrc, one of:
"       a.) VSetSearch, see https://vi.stackexchange.com/questions/42804/highlight-the-full-text-searched-on-vi-editor/42809#42809
"       b.) Plug 'dahu/SearchParty' (choose option 2 for the global var)
"   2. cursor on word, '*' to auto-search, then \gbufs.
"       * pro: you don't have to cntrl-v to highlight the word, your manual part is faster
"       * con: it's usually slower to execute
"
" ##########################

" cdo - Macro Replace with Q - The QuickFix List - one line at a time
" macro q doesn't need the % in ':%s/TERM/REPLACE/g'
" easiest previewing using '/'
function! MacroReplaceQuickFixWithQOneLine()
    cdo execute "normal! @q" | w
endfunction
command! Mcrq call MacroReplaceQuickFixWithQOneLine()

" bufdo - Macro Replace with Q - The Buffers List - entire file at a time
" does not need to mess with the QuickFix List
" macro requires '%' to search entire file at a time
"   qq:%s/OLD/NEW/g<ENTER>q
function! MacroReplaceBuffersWithQEntireFile()
    bufdo execute "normal! @q" | w
endfunction
command! Mbrq call MacroReplaceBuffersWithQEntireFile()

" bufdo - Macro Replace with Q - The Buffers List - entire file at a time
" does not need to mess with the QuickFix List
" macro requires '%' to search entire file at a time
"   qq:%s/OLD/NEW/g<ENTER>q
function! MacroReplaceQuickFixWithQEntireFile()
    cfdo execute "normal! @q" | w
endfunction
command! Mcfrq call MacroReplaceQuickFixWithQEntireFile()

" Searching only buffer list, to open in Quickfix list
" Complimentary to brq & crq
"
" VimgrepallSpecific
" Search in all open buffers for -- the last thing you search for --
" ... or give it a specific search term by command line
" https://vim.fandom.com/wiki/Search_on_all_opened_buffers
function! ClearQuickfixList()
  call setqflist([])
endfunction

function! VimgrepallSpecific(...)
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
command! -nargs=* Gbufs call VimgrepallSpecific(<f-args>)
command! -nargs=* GrepBuffers call VimgrepallSpecific(<f-args>)

" see VimgrepallSpecific for comments
function! VimgrepallSpecificAndOpenThemAll(...)
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
command! -nargs=* Gbufsall call VimgrepallSpecificAndOpenThemAll(<f-args>)
command! -nargs=* GrepBuffersall call VimgrepallSpecificAndOpenThemAll(<f-args>)

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
