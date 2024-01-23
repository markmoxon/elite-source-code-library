\ ******************************************************************************
\
\       Name: SwitchToCharSet
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Switch the MOS character definitions into memory at &C000 on a BBC
\             Master
\
IF _ELITE_A_DOCKED
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SwitchToCharSet+5   Switch the character set irrespective of the value of
\                       CATF
\
ENDIF
\ ******************************************************************************

IF _BUG_FIX

IF _ELITE_A_DOCKED OR _ELITE_A_6502SP_IO

.wsstatecopy

 EQUB 0                 \ We store a copy of the wstate here so we know which
                        \ state to switch back to after printing

ENDIF

.SwitchToCharSet

IF _ELITE_A_DOCKED

                        \ This routine switches the MOS character definitions
                        \ into memory at &C000 on a BBC Master when CATF is
                        \ non-zero
                        \
                        \ Call it at SwitchToCharSet+5 to switch the character
                        \ set irrespective of the value of CATF

 LDX CATF               \ If CATF = 0, jump to char1, otherwise we are
 BEQ char1              \ printing a disc catalogue

ELIF _ELITE_A_6502SP_IO OR _ELITE_A_ENCYCLOPEDIA

                        \ This routine switches the MOS character definitions
                        \ into memory at &C000 on a BBC Master

ENDIF

 LDA #0                 \ Call OSBYTE with A = 0 and X = 1 to fetch bit 0 of the
 LDX #1                 \ operating system version into X
 JSR OSBYTE

 CPX #3                 \ If X =< 3 then this is not a BBC Master, so jump to
 BCC char1              \ char1 to continue drawing the character

IF _ELITE_A_DOCKED OR _ELITE_A_6502SP_IO

 LDA wsstate            \ Copy wsstate into wsstatecopy
 STA wsstatecopy

ENDIF

 JSR savews             \ Call savews to put the character set in the correct
                        \ place

.char1

IF _ELITE_A_DOCKED OR _ELITE_A_6502SP_IO

 LDA K3                 \ Set A to the character to print

ENDIF

 RTS                    \ Return from the subroutine

ENDIF

