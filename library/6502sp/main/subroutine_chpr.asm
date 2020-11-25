\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: Send a character to the I/O processor to print on-screen
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

\PRINT

.CHPRD

 STA K3                 \ Store the character to print in K3

 CMP #' '               \ If A < ASCII " ", i.e. this is a control character,
 BCC P%+4               \ skip the following instruction so the text cursor
                        \ doesn't move to the right

 INC XC                 \ Increment XC to move the text cursor one character to
                        \ the right

 LDA QQ17               \ If all bits of QQ17 are set (i.e. text printing is
 INA                    \ disabled), the return from the subroutine, as rT9
 BEQ rT9                \ contains an RTS

 BIT printflag          \ If bit 7 of printflag is clear, jump to noprinter
 BPL noprinter

 LDA #printcode         \ Bit 7 of printflag is set, so send a printcode code
 JSR OSWRCH             \ to the I/O processor

.noprinter

 LDA K3                 \ Send the character we want to print to the I/O
 JSR OSWRCH             \ processor

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

