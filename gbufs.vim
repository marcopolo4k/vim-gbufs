function! s:LoadGbufs()

" Visual Search originated by author of Practical Vim
" https://stackoverflow.com/questions/16783017/search-with-visual-select-in-vim/16783292
" Visual select the content you want to do search, then press the star key *, Voila !
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n','g')
    let @s = temp
endfunction

" Search And Replace (sar, snr) - [s]ubstitute extension
" See Plug section 'svermeulen/vim-subversive'
" '\siwip' - [s]earches for ([i]n) current [w]ord and replaces throughout ([i]n) [p]aragraph
let g:subversivePromptWithActualCommand=1

" these requires 2nd motion command
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
" shortcut for \siw without partial matches
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

" '\r' - search and [r]eplace partial matched word over [a]ll ([e]ntire) file (buffer)
" ae comes from vim-textobj-entire. [a]ll [e]ntire?
" [r]eplace [w]ord without punctuation. [r] is same, just takes longer
nmap <leader>rr <leader>siwae
nmap <leader>rw <leader>siwae
" [r]eplace [a]ll word with punctuation
nmap <leader>ra <leader>siWae
" [r]eplace from cursor to [e]nd of word
nmap <leader>re <leader>seae
" [r]eplace word in [s]ubroutine
nmap <leader>rs <leader>ssi{
" [r]eplace word in [p]aragraph
nmap <leader>rp <leader>ssip

" confirming each substitution, these require 2nd motion command
nmap <leader>cs <plug>(SubversiveSubstituteRangeConfirm)
xmap <leader>cs <plug>(SubversiveSubstituteRangeConfirm)
nmap <leader>css <plug>(SubversiveSubstituteWordRangeConfirm)

" an example. to delete (needs null register) next 3 words, with confirmation:
" "_\cs3wae

function! ReplaceVariableNameString()
    let l:wordUnderCursor = expand("<cword>")
    let l:replaceWord = input('Replace variable [$'. l:wordUnderCursor. '] with: $')
    echo "\r". '%s/\$\<'. l:wordUnderCursor. '\>/\$'. l:replaceWord. '/g'. "\r"
    execute '%s/\$\<'. l:wordUnderCursor. '\>/\$'. l:replaceWord. '/g'
endfunction
command! ReplaceVariableNameString call ReplaceVariableNameString()
nmap <leader>rvs :ReplaceVariableNameString<cr>

function! ReplaceVariableNameArray()
    let l:wordUnderCursor = expand("<cword>")
    let l:replaceWord = input('Replace variable [@'. l:wordUnderCursor. '] with: @')
    echo "\r". '%s/@\<'. l:wordUnderCursor. '\>/@'. l:replaceWord. '/g'. "\r"
    execute '%s/@\<'. l:wordUnderCursor. '\>/@'. l:replaceWord. '/g'
endfunction
command! ReplaceVariableNameArray call ReplaceVariableNameArray()
nmap <leader>rva :ReplaceVariableNameArray<cr>

function! ReplaceVariableNameHash()
    let l:wordUnderCursor = expand("<cword>")
    let l:replaceWord = input('Replace variable [%'. l:wordUnderCursor. '] with: %')
    echo "\r". '%s/%\<'. l:wordUnderCursor. '\>/%'. l:replaceWord. '/g'. "\r"
    execute '%s/%\<'. l:wordUnderCursor. '\>/%'. l:replaceWord. '/g'
    echo "\r". '%s/\$\<'. l:wordUnderCursor. '\>\({\|->\)/\$'. l:replaceWord. '\1/g'. "\r"
    execute '%s/\$\<'. l:wordUnderCursor. '\>\({\|->\)/\$'. l:replaceWord. '\1/g'
    execute "normal /". l:wordUnderCursor. "\\|". l:replaceWord."\<cr>"
endfunction
command! ReplaceVariableNameHash call ReplaceVariableNameHash()
nmap <leader>rvh :ReplaceVariableNameHash<cr>

" *** Search And Replace with Macro Q ***
"         Multiple Files at a time

" cdo - Macro Replace with Q - The QuickFix List - one line at a time
" macro q doesn't need the % in ':%s/TERM/REPLACE/g'
" easiest previewing using '/'
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
"      search with '/', then '\gbufs' ††
"        -OR-
"      :Gbufs SEARCHTERM
"
"        -OR-
"      cursor on word, then \gbufc
"        -OR-
"      cursor on word, '*' to auto-search, then \gbufs
"
" 3. make a macro labelled 'q' ('qq:s/OLD/NEW/g<ENTER>q')
"    cdo doesn't need a '%' b/c it'll search each line individually
"
" 4. the effects can be seen, file by file if desired, '@q' ':n' '\b' '/' '/sbv' '/sbh'
"
" 5. '\gbufq' (or any of the aliases) to do the remaining files
"
"
" †† Alternative to '/' to search and populate Quickfix list:
"   1. Highlight ('ctrl-v' then move cursor around everything to search for)
"   2. '*'
"
"   This allows for full punctuation, eg around variables, and more
"   This adds word boundaries, specifically: \<SEARCHTERM\>
"   Searching will be slower than \gbufc
"   You'll proly see some errors eventually (reproducible bug reports pls)
"
" ##########################

function! MacroReplaceQuickFixWithQOneLine()
    cdo execute "normal! @q" | w
endfunction
command! Mcrq call MacroReplaceQuickFixWithQOneLine()
nnoremap <leader>mrq :Mcrq<cr>
nnoremap <leader>gbufq :Mcrq<cr>
nnoremap <leader>cdoq :Mcrq<cr>

" bufdo - Macro Replace with Q - The Buffers List - entire file at a time
" does not need to mess with the QuickFix List
" macro requires '%' to search entire file at a time
"   qq:%s/OLD/NEW/g<ENTER>q
function! MacroReplaceQuickFixWithQEntireFile()
    cfdo execute "normal! @q" | w
endfunction
command! Mcfrq call MacroReplaceQuickFixWithQEntireFile()
" [c]fdo [r]eplace with macro [q]
nnoremap <leader>crq :Mcfrq<cr>
nnoremap <leader>cfdoq :Mcfrq<cr>

" Searching only buffer list, to open in Quickfix list
" Complimentary to brq & crq

" Search in all currently opened buffers ...
" ... for the last thing you search for
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
nnoremap <leader>gbufs :call VimgrepallSpecific()

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
nnoremap <leader>gbufa :call VimgrepallSpecificAndOpenThemAll()

" Search in all currently opened buffers ...
" ... for what's under the cursor
" https://vi.stackexchange.com/questions/2904/how-to-show-search-results-for-all-open-buffers
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
nnoremap <leader>gbufc :call GrepBuffersForWordOnCursor("<C-R><C-W>")<CR>

endfunction
