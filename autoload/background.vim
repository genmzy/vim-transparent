if exists('g:vim_transparent_enable') && g:vim_transparent_enable == 1
    let s:clear_background=1
else
    let s:clear_background=0
endif

function! s:get_highlight_colors(group)
    redir => highlight
    silent execute 'silent highlight ' . a:group
    redir END

    let link_matches = matchlist(highlight, 'links to \(\S\+\)')
    if len(link_matches) > 0
        return 'LINKED'
    endif

    let term_attr = s:match_highlight(highlight, 'term=\(\S\+\)')
    let gui_attr = s:match_highlight(highlight, 'gui=\(\S\+\)')
    let ctermfg = s:match_highlight(highlight, 'ctermfg=\([0-9A-Za-z]\+\)')
    let guifg = s:match_highlight(highlight, 'guifg=\([#0-9A-Za-z]\+\)')

    return [term_attr, gui_attr, ctermfg, guifg]
endfunction

function! s:match_highlight(highlight, pattern)
    let matches = matchlist(a:highlight, a:pattern)
    if len(matches) == 0
        return 'NONE'
    endif
    return matches[1]
endfunction

function! s:clear_bg(group)
    let highlights = s:get_highlight_colors(a:group)
    if type(highlights) == v:t_string && highlights == 'LINKED'
        return
    endif

    let [term_attr, gui_attr, ctermfg, guifg] = highlights

    execute 'hi ' . a:group . ' term=' . term_attr . ' ctermfg=' . ctermfg .  ' guifg=' . guifg .' ctermbg=NONE guibg=NONE'
endfunction

function! background#clear_background()
    if s:clear_background
        for group in ['Normal', 'Comment', 'Constant', 'Special', 'Identifier',
                    \'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String',
                    \'Function', 'Conditional', 'Repeat', 'Operator', 'Structure',
                    \'LineNr', 'NonText', 'SignColumn', 'CursorLineNr', 'EndOfBuffer']
            call s:clear_bg(group)
        endfor
    endif
endfunction

function! background#disable()
    let s:clear_background=0
    execute 'colorscheme ' . g:colors_name
endfunction

function! background#enable()
    let s:clear_background=1
    execute 'colorscheme ' . g:colors_name
endfunction

function! background#toggle()
    let s:clear_background=!s:clear_background
    execute 'colorscheme ' . g:colors_name
endfunction
