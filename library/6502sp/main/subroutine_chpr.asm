\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: Write a character to the I/O processor for processing
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.CHPR

.CHPRD                  \ This label is in the original source but is not used
                        \ anywhere

 STA K3                 \ Store the character to print in K3

 CMP #' '               \ If A < ASCII " ", i.e. this is a control character,
 BCC P%+4               \ skip the following instruction so the text cursor
                        \ doesn't move to the right

 INC XC                 \ We are printing a visible character, so increment XC
                        \ to move the text cursor one character to the right

 LDA QQ17               \ If all bits of QQ17 are set, i.e. text printing is
 INA                    \ disabled, then return from the subroutine without
 BEQ rT9                \ printing anything (as rT9 contains an RTS)

 BIT printflag          \ If bit 7 of printflag is clear (printer output is not
 BPL noprinter          \ enabled), jump to noprinter

 LDA #printcode         \ Bit 7 of printflag is set, which means we should send
 JSR OSWRCH             \ the output to the printer as well as the screen, so
                        \ write a #printcode character to the I/O processor to
                        \ do this

.noprinter

 LDA K3                 \ Send the character we want to print to the I/O
 JSR OSWRCH             \ processor

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

