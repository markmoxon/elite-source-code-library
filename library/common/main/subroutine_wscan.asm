\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Wait for the vertical sync
\
\ ------------------------------------------------------------------------------
\
\ Wait for vertical sync to occur on the video system - in other words, wait
\ for the screen to start its refresh cycle, which it does 50 times a second
\ (50Hz).
\
\ ******************************************************************************

.WSCAN

 LDA #0                 \ Set DL to 0
 STA DL

IF _CASSETTE_VERSION

 LDA DL                 \ Loop round these two instructions until DL is no
 BEQ P%-2               \ longer 0 (DL gets set to 30 in the LINSCN routine,
                        \ which is run when vertical sync has occurred on the
                        \ video system, so DL will change to a non-zero value
                        \ at the start of each screen refresh)

ELIF _6502SP_VERSION

.WSCAN1

 LDA DL                 \ Loop round these two instructions until DL is no
 BEQ WSCAN1             \ longer 0 (DL gets set to 30 in the LINSCN routine,
                        \ which is run when vertical sync has occurred on the
                        \ video system, so DL will change to a non-zero value
                        \ at the start of each screen refresh)

ENDIF

 RTS                    \ Return from the subroutine

