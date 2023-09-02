# gbufs.vim

SOMEWHAT EXPERIMENTAL, SOMEWHAT JUST SHOWING WHEN TO USE CDO, CFDO, BUFDO.

---

# Description

Shortcuts to "**grep** all open **buffers**" (open files), and **search & replace** on the results or the open files themselves.

## Why?

* Searching takes too long?
* Maybe you're using a **huge repo** or fighting a slow connection?
* Vim search/replacing confusing?
* Using an old vim or fanciest plugins have errors?

When searching and replacing files takes too long ([even when using rg](https://dev.to/hayden/optimizing-your-workflow-with-fzf-ripgrep-2eai)), this plugin helps you search through only the files you have open.  It could also help teach some of vim's search/replace capababilities.

# Quick Instructions

| Search Opened Files / Show Quickfix Window | Mapping | Note |
| ----------- | ----------- | ----------- |
| Search buffers for the last thing you searched for | `<leader>gbufs` | `/` to search in page |
| Search buffers for whatever is under the **cursor** † | `<leader>gbufc` | Additional install |
| Search buffers for what you have highlighted † | `<leader>gbufs` | Additional install |

| Search And Replace Multiple Files - using Macro `q` | Mapping | Macro | Best For |
| ----------- | ----------- | ----------- | ----------- |
| Search And Replace all loaded files | `<leader>gbufq` | `qq:%s/OLD/NEW/g<ENTER>q` | convenience - no QF needed |
| Search/Replace QuickFix files, full page | `<leader>bigq` | `qq:%s/OLD/NEW/g<ENTER>q` | big files/lots of results |
| Search/Replace QuickFix files, line-by-line | `<leader>finish` | `qq:s//NEW/g<ENTER>q` | previewing a lot

### Basic Universal Instructions

1. load files in buffers
2. load files in a quickfix list (optional)
3. make a macro labelled `q` (eg `qq:%s/OLD/NEW/gENTERq`)
4. `\gbufq` to run the macro on all the files

There's more workflows, but these 3 are the most common I've found.

### Example of the `finish` Workflow

![Example of \finish](https://i.imgur.com/Dc9dVFO.gif)

In this video:
1. Load a bunch of files into vim buffers using pattern: `vim $( find . )`
2. Search for `get_`, don't find it in first file.
3. Search all open buffers using `\gbufs`. Results are displayed in the QuickFix screen.
4. Record macro `qq:s//set_/gjq`
  * `qq` - record macro named `q`
  * `:` - vim command mode
  * `s//set_/g` - it's empty, so search for last search term (`get_`), replace with `set_`, globally for each line
  * `q` - stop macro recording
5. `n` around, `@q`, then `@@` to try the macro on different pages.
6. `\finish` to run the macro on all results found.

# Table of Contents
1. [Installation](#installation)
1. [Prerequisites](#prerequisites)
1. [Learn real vim](#learn-real-vim)
1. [Long Instructions for Workflow - `finish`](#long-instructions-for-finish-workflow-search-and-preview-a-lot-before-replacing-on-all-the-files)
1. [More Workflows](#more-workflows)
   1. Simple search and view results - `gbufs`
   1. A lot of searching/replacing of big files - `bigq`
1. [Recommended Plugins instead of gbufs](#recommended-plugins-instead-of-gbufs)
1. [Recommended Plugins/Additions complimentary to gbufs](#recommended-pluginsadditions-complimentary-to-gbufs)

# Installation

### ~/.vimrc, just the most basic
```
Plug 'marcopolo4k/vim-gbufs'
nnoremap <leader>gbufs :call BufdoVimgrepaddCopen()
nnoremap <leader>gbufq :MacroRplceBuffersWithQEntireFile <cr>
nnoremap <leader>bigq :MacroReplaceQuickFixWithQEntireFile<cr>
nnoremap <leader>finish :MacroRplceQckFxWithQOneLine <cr>
```

### Full vimrc: more aliases, functionality, and comment explanations:
```
Plug 'marcopolo4k/vim-gbufs'

" *** Gbufs - Search And Replace with Macro Q ***
"         Multiple Files at a time
"
" cdo - Macro Replace with Q - The QuickFix List - one line at a time
"  macro q does NOT need the % in ':%s/TERM/REPLACE/g'
"  macro q DOES need the TERM in ':s/TERM/REPLACE/g'
"  This makes for the easiest previewing using '/'
"
" TODO Pick one or two freakin shortcuts to go with for each
" [m]acro [r]eplace with simple macro [q]
nnoremap <leader>mrq :MacroRplceQckFxWithQOneLine <cr>
" for memorizing
nnoremap <leader>cdoq :MacroRplceQckFxWithQOneLine <cr>
" [q]uick[f]ix replace with [q]
nnoremap <leader>qfq :MacroRplceQckFxWithQOneLine <cr>
nnoremap <leader>fixq :MacroRplceQckFxWithQOneLine <cr>
" if already previewed a bunch of changes, just need to [finish]
nnoremap <leader>finish :MacroRplceQckFxWithQOneLine <cr>

" Replace in all buffers instead of Quickfix list
" [g]rep [buf]fers and replace with full-page macro [q]
nnoremap <leader>gbufq :MacroRplceBuffersWithQEntireFile <cr>
" [b]ufdo [r]eplace with macro [q]
nnoremap <leader>brq :MacroRplceBuffersWithQEntireFile<cr>
" for memorizing
nnoremap <leader>bufdoq :MacroRplceBuffersWithQEntireFile<cr>

" cfdo - Macro Replace with Q - The QuickFix List - entire file at a time
"  Runs fastest on large files
"   since QF list should have less files than Buffer List
"  Macro requires '%' to search entire file at a time
"  qq:%s/OLD/NEW/gENTERq
"
" [c]fdo [r]eplace with macro [q]
nnoremap <leader>crq :MacroReplaceQuickFixWithQEntireFile<cr>
" for memorizing
nnoremap <leader>cfdoq :MacroReplaceQuickFixWithQEntireFile<cr>
nnoremap <leader>bigq :MacroReplaceQuickFixWithQEntireFile<cr>

" Search all open buffers -- for the last thing you search for --
"  Maybe your last search has word boundaries, or not. Check with '/↑'
" https://vim.fandom.com/wiki/Search_on_all_opened_buffers
nnoremap <leader>gbufs :call BufdoVimgrepaddCopen()
" 2nd option: Search and then open them all in horizontal window panes
nnoremap <leader>gbufa :call BufdoVimgrepaddCopenAndOpenThemAll()
" 3rd option: Type out a specific search term by command line
"   :Gbufs SEARCH_TERM
" for memorizing
nnoremap <leader>bufdovimgrep :call BufdoVimgrepaddCopen()

" Search all open buffers -- for what's under the cursor --
"  No word boundaries default, depending on your config
"  Requires either VSetSearch or SearchParty †‡
"  Loads search result files into Quickfix List
"  Does NOT save the search in last search reg
nnoremap <leader>gbufc :call GrepBuffersForWordOnCursor("<C-R><C-W>")<CR>
```

### HIGHLY RECOMMENDED additions for quicker searching:
†‡ EITHER Install Plugin OR add a function to ~/.vimrc, choose one of these two:
  * `VSetSearch`, see [this stack convo](https://stackoverflow.com/a/42776237/9009249)
  * Plug [dahu/SearchParty](https://github.com/dahu/SearchParty) (choose option 2 for the global var)

# Prerequisites
* To do multi-file search/replacing in vim, you need to understand [buffers](https://dev.to/iggredible/using-buffers-windows-and-tabs-efficiently-in-vim-56jc), and preferably the [quickfix window](https://freshman.tech/vim-quickfix-and-location-list/).
* See those highly recommended additions at the end of the installation section, those might almost be considered prereqs.

# Learn real vim

If you want to stop using this plugin, you can start with these mappings to help memorize the commands.  It's just a lot of typing, and what do we think of unnecessary typing?

| Search And Replace Multiple Files | Mapping | Macro | Best For |
| ----------- | ----------- | ----------- | ----------- |
| Search And Replace all loaded files | `<leader>bufdoq` | `qq:%s/OLD/NEW/g<ENTER>q` | convenience - no QF needed |
| `:bufdo execute "normal! @q" \| w` |
| Search/Replace QuickFix files, line-by-line | `<leader>cdoq` | `qq:s//NEW/g<ENTER>q` | previewing a lot
| `:cdo execute "normal! @q" \| w` |
| Search/Replace QuickFix files, full page | `<leader>cfdoq` | `qq:%s/OLD/NEW/g<ENTER>q` | big files |
| `:cfdo execute "normal! @q" \| w` |
| Argdo runs on the original open file list | no macro yet | author of gbufs is lazy and | ? |
| `:argdo execute "normal! @q" \| w` |  | hasn't needed this one yet |

# Long Instructions for `finish` Workflow: Search and Preview a lot before replacing on all the files

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

5. The effects can be seen, file by file if desired, with vim commands: `@q` `:n` `/` etc
   1. Search on a single buffer with `/`, hit `n` a few times to look around.
   2. Unless it exists, make macro `q`, like `qq:s//NEW/g<ENTER>j`
      * OLD is left empty since the last search is used by default.
      * j goes to next line, in the interest of step v.
   3. Run `@q` to replace the line you're looking at.
   4. `n` to find the next result, `@@` to run macro on that.
   5. `:n` to see the next page.  Or better, use quickfix list to see all results. Repeat steps i & iii.
   6. Maybe look around your buffer list if there's any file that might be different.

7. When happy, run the macro on the rest of the files: `<leader>finish`

## †‡ Both these 2 alternatives require either one of two additional installations
See additional installation instructions †‡

### † Alternative 1:
  1. Highlight some text (`ctrl-v` then move cursor around everything to search for)
  1. `*`
  1. `<leader>gbufs`

  * This does NOT add word boundaries in the search.

  * pro: Allows for full punctuation, eg around variables, sets of words and symbols, etc
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


# More Workflows

## Simple search and view results - `gbufs`

Just searching and seeing something you might want to replace is common.  If you're not ready to replace anything, it's fastest to search for the word without word boundaries.  I use the default `\` for my leader key.

1. `ve` visual highlight from beginning to end of word, then `*`. †
1. `\gbufs` to search current buffers for the term, it opens the Quickfix window.
1. Use window pane navigation to go to different files and see the usage.

## A lot of searching/replacing of big files - `bigq`

Sometimes files are big or there's lots of results on each page, and you need the search itself to be fast.  Instead of line by line, this searches each file in the Quickfix list, just once with one macro `q` (vs `finish` that executes the macro on every occurrance).

1. Load buffers, let's choose `vim $( rg -l SEARCHTERM )`, with optional use of `rg` to preview which files you're getting. (rg is ripgrep, highly recommended)
1. Record macro: `qq:%s/SEARCH/REPLACE/gq`
1. `/SEARCH` on the first page, then preview the change: `@q`, then `n` and `@@` for more on the first page.
1. Load Quickfix list, let's choose `\gbufs`
1. `\bigq` to search/replace once on every file in the Quickfix list.

# Available upon request

I could add functions to specifically open or NOT open the QuickFix preview window for any of these.

# Recommended Plugins instead of gbufs
* [vim-esearch](vim-esearch) is way more powerful, since `gbufs` is just a couple simple maps.  But I haven't been able to get `esearch` to work on anything but vim9 yet, so for me at least, `gbufs` will be used on old vim8 systems. `gbufs` might also still be preferred if you want simple maps that help you memorize the full vim commands, or just don't want larger plugins.
* If you use Neovim, `gbufs` won't work, but there's so many search and replace plugins (besides `esearch`, which is supposed to work on both):
  * [nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
  * [telescope](https://github.com/nvim-telescope/telescope.nvim)
  * [muren](https://github.com/AckslD/muren.nvim)
  * [replacer](https://github.com/gabrielpoca/replacer.nvim)

# Recommended Plugins/Additions complimentary to gbufs
* [Subversive](https://github.com/svermeulen/vim-subversive) vim plugin.  I have a bunch of mapping for that I almost put here for single-page search & replace.
* [FZF](https://duckduckgo.com/?q=fzf+vim&ia=web) vim plugin
* [ripgrep](https://duckduckgo.com/?q=ripgrep+vim&ia=web)
* custom window navigation mappings
* [dahu/SearchParty](https://github.com/dahu/SearchParty) - practically a requirement for `gbufs`
