\ ******************************************************************************
\
\       Name: TRADEMODE
\       Type: Subroutine
\   Category: Drawing the screen
IF _6502SP_VERSION \ Comment
\    Summary: Clear the screen and set up a printable trading screen
ELIF _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION
\    Summary: Clear the screen and set up a trading screen
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _6502SP_VERSION \ Comment
\ Clear the top part of the screen, draw a white border, set the print flag if
\ CTRL is being pressed, set the palette for trading screens, and set the
\ current view type in QQ11 to A.
ELIF _MASTER_VERSION
\ Clear the top part of the screen, draw a white border, set the palette for
\ trading screens, and set the current view type in QQ11 to A.
ELIF _C64_VERSION
\ Clear the top part of the screen, draw a border and set the current view
\ type in QQ11 to A.
ELIF _APPLE_VERSION
\ Clear the top part of the screen.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The type of the new current view (see QQ11 for a list of
\                       view types)
\
IF _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TRADEMODE2          Set the palette for trading screens and switch the
\                       current colour to white
\
ENDIF
\ ******************************************************************************

.TRADEMODE

IF _6502SP_VERSION \ 6502SP: The 6502SP version implements printable trade screens by checking whether CTRL is being pressed before displaying the relevant screen

 PHA                    \ Store the view type on the stack so we can restore it
                        \ after the call to CTRL

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed

 STA printflag          \ Store the result in printflag, which will have bit 7
                        \ set (and will therefore enable printing) if CTRL is
                        \ being pressed

 PLA                    \ Restore the view type from the stack

ENDIF

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to A

IF _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Platform

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

ELIF _APPLE_VERSION

 JMP FLKB               \ Call FLKB to flush the keyboard buffer and return from
                        \ the subroutine using a tail call

ENDIF

IF _6502SP_VERSION \ Minor

 LDA #48                \ Send a #SETVDU19 48 command to the I/O processor to
 JSR DOVDU19            \ switch to the mode 1 palette for trading screens,
                        \ which is yellow (colour 1), magenta (colour 2) and
                        \ white (colour 3)

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JMP DOCOL              \ switch to colour 3, which is white in the trade view,
                        \ and return from the subroutine using a tail call

ELIF _MASTER_VERSION

.TRADEMODE2

 LDA #48                \ Switch to the mode 1 palette for trading screens,
 JSR DOVDU19            \ which is yellow (colour 1), magenta (colour 2) and
                        \ white (colour 3)

 LDA #CYAN              \ Switch to colour 3, which is white in the trade view
 STA COL

 RTS                    \ Return from the subroutine

ELIF _C64_VERSION

 LDA #48                \ Switch to the palette for trading screens, though this
 JSR DOVDU19            \ doesn't actually do anything in this version of Elite

\LDA #CYAN              \ These instructions are commented out in the original
\JMP DOCOL              \ source (they are left over from the 6502 Second
                        \ Processor version of Elite and would change the text
                        \ colour to white)

 RTS                    \ Return from the subroutine

ELIF _APPLE_VERSION

 RTS                    \ Return from the subroutine (though this instruction
                        \ has no effect as we already returned using a tail
                        \ call)

ENDIF

