# gbufs.vim

EXPERIMENTAL

Don't use this. I'm bound to change the name, place, mappings. Could go away soon too.

Sir Chin Riplace I, esquire

--- 

# Description

Mapping shortcuts to Grep through Buffers (open files), and search/replace at will.

| Search And Replace Multiple Files | Mapping |
| ----------- | ----------- |
| Search And Replace with Macro `q` | `<leader>gbufq` |
| Search And Replace with the last thing you searched for | `<leader>gbufs` |
| Search And Replace what you have highlighted † | `<leader>gbufs` |
| Search And Replace with whatever is under the cursor † | `<leader>gbufc` |

# Quick Instructions
1. load files in buffers
2. load files in a quickfix list
3. make a macro labelled `q`
4. `\gbufq` (or your own mapping) to run the macro on all the quickfix files

Keep reading for a bunch of different workflows, this one seems the most universal.

# Installation

~/.vimrc:
```
Plug 'marcopolo4k/vim-gbufs'

" *** Gbufs - Search And Replace with Macro Q ***
"         Multiple Files at a time
" https://github.com/marcopolo4k/vim-gbufs
"
" cdo - Macro Replace with Q - The QuickFix List - one line at a time
" macro q doesn't need the % in ':%s/TERM/REPLACE/g'
" easiest previewing using '/'
nnoremap <leader>gbufq :Mcrq<cr>
" alias, hinting you don't really need this plugin to do this part:
nnoremap <leader>cdoq :Mcrq<cr>

" [b]ufdo [r]eplace with macro [q]
nnoremap <leader>brq :Mbrq<cr>

" cfdo - Macro Replace with Q - The QuickFix List - entire file at a time
" runs fastest
"   since QF list should have less files than Buffer List
" macro requires '%' to search entire file at a time
"   qq:%s/OLD/NEW/gENTERq
"
" [c]fdo [r]eplace with macro [q]
nnoremap <leader>crq :Mcfrq<cr>
nnoremap <leader>cfdoq :Mcfrq<cr>

" Searching only buffer list, to open in Quickfix list
" Complimentary to brq & crq

" Search in all open buffers for -- the last thing you search for --
" https://vim.fandom.com/wiki/Search_on_all_opened_buffers
nnoremap <leader>gbufs :call VimgrepallSpecific()
nnoremap <leader>gbufa :call VimgrepallSpecificAndOpenThemAll()
" or give it a specific search term by command line
"   :Gbufs SEARCH_TERM

" Search all open buffers for -- what's under the cursor --
" similar to gbufs but no word boundaries
nnoremap <leader>gbufc :call GrepBuffersForWordOnCursor("<C-R><C-W>")<CR>
```

### Highly recommended additions: 
See †‡

# Long Instructions

1. Load files in buffers

   `:grep SEARCHTERM` can use `rg`, and also populates quickfix list at same time

2. Load the [quickfix list](https://freshman.tech/vim-quickfix-and-location-list/) (when done from the buffers, it's fast)

   Only if you loaded files without populating the quickfix list, choose one of:
   * search with `/`, then `\gbufs` †
   * `:Gbufs SEARCHTERM`
   * cursor on word, then `\gbufc` (does NOT include word boundaries) ‡

3. Make a macro labelled `q` (`qq:s/OLD/NEW/g<ENTER>q`)
   cdo doesn't need a `%` b/c it'll search each line individually

4. The effects can be seen, file by file if desired, see vim commands: `@q` `:n` `\b` `/`

5. `\gbufq` (or any of the aliases) to do the remaining files

## †‡ 2 alternatives require one of two additions:
Install Plugin or add function to ~/.vimrc, one of these two:
* `VSetSearch`, see [this stack convo](https://vi.stackexchange.com/questions/42804/highlight-the-full-text-searched-on-vi-editor/42809#42809)
* Plug `dahu/SearchParty` (choose option 2 for the global var)

### † Alternative to `/` to search and populate Quickfix list:
  1. Highlight some text (`ctrl-v` then move cursor around everything to search for)
  2. `*`

 * This allows for full punctuation, eg around variables, and more
 * This adds word boundaries, specifically: `\<SEARCHTERM\>`
 * Searching will be slower than `\gbufc`
 * You`ll proly see some errors eventually (reproducible bug reports pls)

### ‡ Alternatives to `gbufc`, which DOES include word boundaries
  2. Put cursor on the word to search, then `*` to auto-search, then `\gbufs`.
      * pro: You don't have to `cntrl-v` to highlight the word, so your manual part is faster
      * con: It's usually slower to execute
      * pro OR con: This opens the Quickfix window

# More Details

" lorem impsom cdo - Macro Replace with Q - The QuickFix List - one line at a time
" macro q doesn't need the % in ':%s/TERM/REPLACE/g'
" easiest previewing using '/'

# Recommended Plugins/Additions
* Subversive vim plugin.  I have a bunch of mapping for that I almost put here.
* FZF vim plugin
* ripgrep
* custom window navigation mappings
* `dahu/SearchParty` (although it messed up my window navigation mappings, so I had to just use Visual Search snippet from Practical Vim)
