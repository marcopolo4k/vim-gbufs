# gbufs.vim

EXPERIMENTAL

Don't use this. I'm bound to change the name, place, mappings. Could go away soon too.

Sir Chin Riplace I, esquire

--- 

# Description

When searching and replacing files takes too long ([even when using rg](https://dev.to/hayden/optimizing-your-workflow-with-fzf-ripgrep-2eai)), this plugin helps you search through only the files you already have open.

It maps shortcuts to "grep all open buffers" (open files), and search & replace on the results.

| Search And Replace Multiple Files | Mapping |
| ----------- | ----------- |
| Search buffers for the last thing you searched for (/) | `<leader>gbufs` |
| Search buffers for what you have highlighted † | `<leader>gbufs` |
| Search buffers for whatever is under the cursor † | `<leader>gbufc` |
| ----------- | ----------- |
| Search And Replace all previously found files with Macro `q` | `<leader>gbufq` |

# Quick Instructions
1. load files in buffers
2. load files in a quickfix list
3. make a macro labelled `q` (eg `qq:%s/OLD/NEW/gENTERq`)
4. `\gbufq` (or your own mapping) to run the macro on all the quickfix files

Keep reading for a bunch of different workflows, this one seems the most universal, allowing many places to stop & inspect what you're doing.

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

1. Load files in buffers.
   
   Choose one of:
   * Inside vim, `:grep SEARCHTERM` populates the quickfix list.  Downside is that it may take some time (seconds of your life!), especially if you don't use ripgrep.
   * Before starting vim, shell tools help load files.  These do NOT populate the quickfix list.  Couple examples:
     *  a repo search: `vim $( rg -l SEARCHTERM )`
     *  all the files in current folder: `vim $( \ls )`

2. Populate the [quickfix list](https://freshman.tech/vim-quickfix-and-location-list/) (skip this step if you already loaded the exact files you want with `:grep SEARCHTERM`)

   Choose one of:
   * search with `/`, then `\gbufs` †
   * `:Gbufs SEARCHTERM`
   * cursor on word, then `\gbufc` ‡

4. Make a macro labelled `q` (`qq:s/OLD/NEW/g<ENTER>q`)
   cdo doesn't need a `%` b/c it'll search each line individually

5. The effects can be seen, file by file if desired, see vim commands: `@q` `:n` `\b` `/`

6. `\gbufq` to do the remaining files

## †‡ 2 alternatives require one of two additions:
Install Plugin or add function to ~/.vimrc, one of these two:
1. `VSetSearch`, see [this stack convo](https://vi.stackexchange.com/questions/42804/highlight-the-full-text-searched-on-vi-editor/42809#42809)
1. Plug `dahu/SearchParty` (choose option 2 for the global var)

### † Alternative to `/` to search and populate Quickfix list:
  1. Highlight some text (`ctrl-v` then move cursor around everything to search for)
  2. `*`

 * This allows for full punctuation, eg around variables, and more
 * This does NOT add word boundaries.
 * Searching will be slower than `\gbufc`

### ‡ Alternative to `gbufc`, includes word boundaries
Put cursor on the word to search, then `*` to auto-search, then `\gbufs`.
 * pro: You don't have to `cntrl-v` to highlight the word, so your manual part is faster
 * con: It's usually slower to execute
 * pro OR con: This opens the Quickfix window
 * pro OR con: This adds word boundaries around the word, so: `\<SEARCHTERM\>`

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
