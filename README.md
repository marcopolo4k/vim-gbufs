# gbufs.vim

EXPERIMENTAL

Don't use this. I'm bound to change the name, place, mappings. Could go away soon too.

Sir Chin Riplace I, esquire

--- 

*** Search And Replace with Macro Q ***
        Multiple Files at a time

Quick Instructions
1. load files in buffers
2. load files in quickfix list
3. make a macro labelled 'q'
4. '\cdoq' to run the macro on all the quickfix files

##########################
Long Instructions

1. load files in buffers
   ':grep SEARCHTERM' uses rg, and also populates quickfix list at same time

2. load quickfix list (from buffers is fast)
   only if you loaded files without populating the quickfix list, choose one of:
     search with '/', then '\gbufs' †
       -OR-
     :Gbufs SEARCHTERM
       -OR-
     cursor on word, then \gbufc (does NOT include word boundaries) ‡

3. make a macro labelled 'q' ('qq:s/OLD/NEW/g<ENTER>q')
   cdo doesn't need a '%' b/c it'll search each line individually

4. the effects can be seen, file by file if desired, see vim commands: '@q' ':n' '\b' '/'
     I have other mappings for opening windows, watch this space for: '/sbv' '/sbh'

5. '\gbufq' (or any of the aliases) to do the remaining files


† Alternative to '/' to search and populate Quickfix list:
  1. Highlight ('ctrl-v' then move cursor around everything to search for)
  2. '*'

  This allows for full punctuation, eg around variables, and more
  This adds word boundaries, specifically: \<SEARCHTERM\>
  Searching will be slower than \gbufc
  You'll proly see some errors eventually (reproducible bug reports pls)

‡ Alternatives to gbufc, which DOES include word boundaries
  1. Install Plugin or add function to ~/.vimrc, one of:
      a.) VSetSearch, see https://vi.stackexchange.com/questions/42804/highlight-the-full-text-searched-on-vi-editor/42809#42809
      b.) Plug 'dahu/SearchParty' (choose option 2 for the global var)
  2. cursor on word, '*' to auto-search, then \gbufs.
      * pro: you don't have to cntrl-v to highlight the word, your manual part is faster
      * con: it's usually slower to execute

##########################

" cdo - Macro Replace with Q - The QuickFix List - one line at a time
" macro q doesn't need the % in ':%s/TERM/REPLACE/g'
" easiest previewing using '/'
