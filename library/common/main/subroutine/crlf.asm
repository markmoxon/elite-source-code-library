\ ******************************************************************************
\
\       Name: crlf
\       Type: Subroutine
\   Category: Text
\    Summary: Tab to column 21 and print a colon
\
\ ------------------------------------------------------------------------------
\
\ Print control code 9 (tab to column 21 and print a colon). The subroutine
\ name is pretty misleading, as it doesn't have anything to do with carriage
\ returns or line feeds.
\
\ ******************************************************************************

.crlf

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDA #21                \ Set the X-column in XC to 21
 STA XC

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #21                \ Set the X-column in XC to 21
 JSR DOXC

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 BNE TT73               \ Jump to TT73, which prints a colon (this BNE is
                        \ effectively a JMP as A will never be zero)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JMP TT73               \ Jump to TT73, which prints a colon (this BNE is
                        \ effectively a JMP as A will never be zero)

ENDIF

