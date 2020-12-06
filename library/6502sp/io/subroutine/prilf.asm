\ ******************************************************************************
\
\       Name: prilf
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Implement the #prilf command (print a blank line on the printer)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #prilf command. It prints a
\ blank line on the printer by printing two line feeds.
\
\ ******************************************************************************

.prilf

 LDA #2                 \ Send ASCII 2 to the printer using the non-vectored
 JSR NVOSWRCH           \ OSWRCH, which means "start sending characters to the
                        \ printer"

 LDA #10                \ Send ASCII 10 to the printer twice using the POSWRCH
 JSR POSWRCH            \ routine, which prints a blank line below the current
 JSR POSWRCH            \ line as ASCII 10 is the line feed character

 LDA #3                 \ Send ASCII 3 to the printer using the non-vectored
 JSR NVOSWRCH           \ OSWRCH, which means "stop sending characters to the
                        \ printer"

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

