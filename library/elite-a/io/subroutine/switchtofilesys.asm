\ ******************************************************************************
\
\       Name: SwitchToFileSys
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Restore the filing system workspace to &C000 on a BBC Master
\
\ ******************************************************************************

IF _BUG_FIX

.SwitchToFileSys

IF _ELITE_A_DOCKED

                        \ This routine restores the filing system workspace to
                        \ &C000 on a BBC Master, but only if CATF is non-zero
                        \ and we overwrote it in SwitchToCharSet
                        \
                        \ Call it at SwitchToFileSys+5 to restore the workspace
                        \ irrespective of the value of CATF

 LDX CATF               \ If CATF = 0, jump to file1, otherwise we are
 BEQ file1              \ printing a disc catalogue

ELIF _ELITE_A_6502SP_IO

                        \ This routine restores the filing system workspace to
                        \ &C000 on a BBC Master, but only if we overwrote it in
                        \ SwitchToCharSet

ENDIF

 LDA #0                 \ Call OSBYTE with A = 0 and X = 1 to fetch bit 0 of the
 LDX #1                 \ operating system version into X
 JSR OSBYTE

 CPX #3                 \ If X =< 3 then this is not a BBC Master, so jump to
 BCC file1              \ file1 to continue drawing the character

 BIT wsstatecopy        \ If bit 7 of wsstatecopy is set then the character set
 BMI file1              \ was already present before this call, so skip the
                        \ following so we don't change that

 JSR restorews          \ Call restorews to restore the filing system workspace

.file1

 RTS                    \ Return from the subroutine

ENDIF

