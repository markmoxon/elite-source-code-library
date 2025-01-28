\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Drawing the screen
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\    Summary: Wait for the vertical sync
ELIF _6502SP_VERSION OR _MASTER_VERSION
\    Summary: Implement the #wscn command (wait for the vertical sync)
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Wait for vertical sync to occur on the video system - in other words, wait
\ for the screen to start its refresh cycle, which it does 50 times a second
\ (50Hz).
\
\ ******************************************************************************

.WSCAN

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 LDA #0                 \ Set DL to 0
 STA DL

ELIF _MASTER_VERSION

 STZ DL                 \ Set DL to 0

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

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

ELIF _MASTER_VERSION

.DELL1K                 \ This label is a duplicate of a label in the DELT
                        \ routine
                        \
                        \ In the original source this label is DELL1, but
                        \ because BeebAsm doesn't allow us to redefine labels,
                        \ I have renamed it to DELL1K

 LDA DL                 \ Loop round these two instructions until DL is no
 BEQ DELL1K             \ longer 0 (DL gets set to 30 in the LINSCN routine,
                        \ which is run when vertical sync has occurred on the
                        \ video system, so DL will change to a non-zero value
                        \ at the start of each screen refresh)

ENDIF

 RTS                    \ Return from the subroutine

