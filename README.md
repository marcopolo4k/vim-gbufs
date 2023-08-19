# gbufs.vim

SOMEWHAT EXPERIMENTAL

---

# Description

* Searching takes too long?
* Maybe you're using a huge repo or fighting a slow connection?

When searching and replacing files takes too long ([even when using rg](https://dev.to/hayden/optimizing-your-workflow-with-fzf-ripgrep-2eai)), this plugin helps you search through only the files you have open.

It maps shortcuts in order to "grep all open buffers" (open files), then you can search & replace on the results.

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

There's different workflows available, this one seems the most universal, allowing many places to stop & inspect what you're doing.

# Installation

~/.vimrc:
```
Plug 'marcopolo4k/vim-gbufs'

" *** Gbufs - Search And Replace with Macro Q ***
"         Multiple Files at a time
" https://github.com/marcopolo4k/vim-gbufs
"
" cdo - Macro Replace with Q - The QuickFix List - one line at a time
"  macro q does NOT need the % in ':%s/TERM/REPLACE/g'
"  macro q DOES need the TERM in ':%s/TERM/REPLACE/g'
"  This makes for the easiest previewing using '/'
"  Aliases: mrq, cdoq, gbufq
nnoremap <leader>mrq :MacroRplceQckFxWithQOneLine <cr>
nnoremap <leader>cdoq :MacroRplceQckFxWithQOneLine <cr>
nnoremap <leader>gbufq :MacroRplceQckFxWithQOneLine <cr>

" Replace in all buffers instead of Quickfix list
" [b]ufdo [r]eplace with macro [q]
nnoremap <leader>brq :MacroRplceBuffersWithQEntireFile<cr>
" another alias
nnoremap <leader>bufdoq :MacroRplceBuffersWithQEntireFile<cr>

" cfdo - Macro Replace with Q - The QuickFix List - entire file at a time
"  Runs fastest
"   since QF list should have less files than Buffer List
"  Macro requires '%' to search entire file at a time
"  qq:%s/OLD/NEW/gENTERq
"
" [c]fdo [r]eplace with macro [q]
nnoremap <leader>crq :MacroReplaceQuickFixWithQEntireFile<cr>
" another alias
nnoremap <leader>cfdoq :MacroReplaceQuickFixWithQEntireFile<cr>

" Searching only buffer list, to open in Quickfix list
" Complimentary to brq & crq

" Search in all open buffers for -- the last thing you search for --
"  Maybe your last search has word boundaries, or not. Check with '/↑'
" https://vim.fandom.com/wiki/Search_on_all_opened_buffers
nnoremap <leader>gbufs :call VimgrepallSpecific()
" ... and open them all in windows
nnoremap <leader>gbufa :call VimgrepallSpecificAndOpenThemAll()
" 3rd option: Type out a specific search term by command line
"   :Gbufs SEARCH_TERM

" Search all open buffers for -- what's under the cursor --
"  No word boundaries default, depending on your config
"  Requires either VSetSearch or SearchParty †‡
"  Loads search result files into Quickfix List
"  Does NOT save the search in last search reg
nnoremap <leader>gbufc :call GrepBuffersForWordOnCursor("<C-R><C-W>")<CR>
```

### HIGHLY RECOMMENDED additions for quicker searching:
†‡ Install Plugin or add function to ~/.vimrc, one of these two:
  1. `VSetSearch`, see [this stack convo](https://stackoverflow.com/a/42776237/9009249)
  1. Plug `dahu/SearchParty` (choose option 2 for the global var)

# Long Instructions for searching and previewing along the way

1. Load files in buffers.

   Choose one of:
   * Inside vim, `:grep SEARCHTERM` populates the quickfix list.  Downside is that it may take some time (seconds of your life!), especially if you don't use ripgrep.
   * Before starting vim, shell tools help load files.  These do NOT populate the quickfix list.  Couple examples:
     *  a repo search: `vim $( rg -l SEARCHTERM )`
     *  all the files in current folder: `vim $( \ls )`

2. Populate the [quickfix list](https://freshman.tech/vim-quickfix-and-location-list/) (skip this step if you already loaded the exact files you want with `:grep SEARCHTERM`)

   Choose one of:
   * `:Gbufs SEARCHTERM`
   * search with `/`, then `\gbufs` †
   * cursor on word, then `\gbufc` ‡

4. Make a macro labelled `q` (`qq:s/OLD/NEW/g<ENTER>q`)
   cdo doesn't need a `%` b/c it'll search each line individually

5. The effects can be seen, file by file if desired, see vim commands: `@q` `:n` `/`

6. `\gbufq` to do the remaining files

## †‡ Both these 2 alternatives require either one of two additional installations
See additional installation instructions †‡

### † Alternative 1:
  1. Highlight some text (`ctrl-v` then move cursor around everything to search for)
  1. `*`
  1. `<leader>gbufs`

  * This does NOT add word boundaries in the search.

  * pro: Allows for full punctuation, eg around variables, and more
  * pro: Faster to run the search.
  * con: Slower to select what you want & start searching.

### ‡ Alternative 2
  1. Put cursor on the word to search
  1. `*` to auto-search
  1. `<leader>gbufs`

  * This opens the Quickfix window
  * This adds word boundaries around the word, like: `\<SEARCHTERM\>`

  * pro: Faster to start searching.
  * con: Slower to run the search.


# Specific Workflows

## Simple search and view results

Just searching and seeing something you might want to replace is common.  If you're not ready to replace anything, it's fastest to search for the word without word boundaries.  I use the default `\` for my leader key.

1. `cntrl-v` highlight from beginning to end of word, then `*`.
1. `\gbufs` to search current buffers for the term, it opens the Quickfix window.
1. Use window pane navigation to go to different files and see the usage.

## A lot of searching/replacing of big files

Sometimes files are big, and you want the search itself to be fast.  Instead of line by line, this searches every file in the Quickfix list with one macro (instead of line-by-line like gbufq does):

1. Load buffers, let's choose `vim $( rg -l SEARCHTERM )`, with optional use of `rg` to preview which files you're getting.
1. Record macro: `qq:%s/SEARCH/REPLACE/gq`
1. `/SEARCH` on the first page, then preview the change: `@q`, then `n` and `@@` for more on the first page.
1. Load Quickfix list, let's choose `\gbufs`
1. `\crq` to search/replace once on every file in the Quickfix list. This is the fastest way to do this in vim for big files.

# Available upon request

I could add functions to open or not open the quickfix preview window to anything seen on this plugin.

# Recommended Plugins/Additions
* [Subversive](https://github.com/svermeulen/vim-subversive) vim plugin.  I have a bunch of mapping for that I almost put here.
* [FZF](https://duckduckgo.com/?q=fzf+vim&ia=web) vim plugin
* [ripgrep](https://duckduckgo.com/?q=ripgrep+vim&ia=web)
* custom window navigation mappings
* `dahu/SearchParty` (although it messed up my window navigation mappings, so I had to just use Visual Search snippet from Practical Vim)

