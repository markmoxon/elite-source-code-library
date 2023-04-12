\ ******************************************************************************
\
\       Name: cntr
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Apply damping to the pitch or roll dashboard indicator
\
\ ------------------------------------------------------------------------------
\
\ Apply damping to the value in X, where X ranges from 1 to 255 with 128 as the
\ centre point (so X represents a position on a centre-based dashboard slider,
\ such as pitch or roll). If the value is in the left-hand side of the slider
\ (1-127) then it bumps the value up by 1 so it moves towards the centre, and
\ if it's in the right-hand side, it reduces it by 1, also moving it towards the
\ centre.
\
\ ******************************************************************************

.cntr

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Enhanced: When the docking computer takes over the controls in the enhanced versions, keyboard damping is disabled, so it can make finer course corrections during docking

 LDA auto               \ If the docking computer is currently activated, jump
 BNE cnt2               \ to cnt2 to skip the following as we always want to
                        \ enable damping for the docking computer

ENDIF

 LDA DAMP               \ If DAMP is non-zero, then keyboard damping is not
 BNE RE1                \ enabled, so jump to RE1 to return from the subroutine

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Label

.cnt2

ENDIF

 TXA                    \ If X < 128, then it's in the left-hand side of the
 BPL BUMP               \ dashboard slider, so jump to BUMP to bump it up by 1,
                        \ to move it closer to the centre

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 DEX                    \ Otherwise X >= 128, so it's in the right-hand side
 BMI RE1                \ of the dashboard slider, so decrement X by 1, and if
                        \ it's still >= 128, jump to RE1 to return from the
                        \ subroutine, otherwise fall through to BUMP to undo
                        \ the bump and then return

ELIF _MASTER_VERSION

 DEX                    \ Otherwise X >= 128, so it's in the right-hand side
 BMI ARSR1              \ of the dashboard slider, so decrement X by 1, and if
                        \ it's still >= 128, jump to ARSR1 to return from the
                        \ subroutine, otherwise fall through to BUMP to undo
                        \ the bump and then return

ENDIF

.BUMP

 INX                    \ Bump X up by 1, and if it hasn't overshot the end of
 BNE RE1                \ the dashboard slider, jump to RE1 to return from the
                        \ subroutine, otherwise fall through to REDU to drop
                        \ it down by 1 again

.REDU

 DEX                    \ Reduce X by 1, and if we have reached 0 jump up to
 BEQ BUMP               \ BUMP to add 1, because we need the value to be in the
                        \ range 1 to 255

.RE1

 RTS                    \ Return from the subroutine

