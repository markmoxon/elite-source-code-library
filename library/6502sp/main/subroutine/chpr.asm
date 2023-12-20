\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: Send a character to the I/O processor for printing or processing
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   CHPRD               Make a beep even if speech is enabled (Executive version
\                       only)
\
\ ******************************************************************************

.CHPR

IF _6502SP_VERSION \ 6502SP: If speech is enabled in the Executive version, the main character routine at CHPR doesn't make standard system beeps any more (though the BELL routine still does)

IF _EXECUTIVE

 CMP #7                 \ If this is not a beep character, jump to CHPRD to
 BNE CHPRD              \ print the character

 BIT SPEAK              \ If speech is disabled, jump to CHPRD to print the
 BPL CHPRD              \ character

 RTS                    \ If we get here then this is a beep character and
                        \ speech is enabled, so return from the subroutine to
                        \ prevent the beep from being made

ENDIF

ENDIF

.CHPRD

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
                        \ send a #printcode command to the I/O processor to do
                        \ this

.noprinter

 LDA K3                 \ Send the character we want to print to the I/O
 JSR OSWRCH             \ processor

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

