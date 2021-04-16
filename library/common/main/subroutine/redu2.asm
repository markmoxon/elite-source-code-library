\ ******************************************************************************
\
\       Name: REDU2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Reduce the value of the pitch or roll dashboard indicator
\
\ ------------------------------------------------------------------------------
\
\ Reduce X by A, where X is either the current rate of pitch or the current
\ rate of roll.
\
\ The rate of pitch or roll ranges from 1 to 255 with 128 as the centre point.
\ This is the amount by which the pitch or roll is currently changing, so 1
\ means it is decreasing at the maximum rate, 128 means it is not changing,
\ and 255 means it is increasing at the maximum rate. These values correspond
\ to the line on the DC or RL indicators on the dashboard, with 1 meaning full
\ left, 128 meaning the middle, and 255 meaning full right.
\
\ If reducing X would bring it below 1, then X is set to 1.
\
\ If keyboard auto-recentre is configured and the result is greater than 128, we
\ reduce X down to the mid-point, 128. This is the equivalent of having a roll
\ or pitch in the right half of the indicator, when decreasing the roll or pitch
\ should jump us straight to the mid-point.
\
\ Other entry points:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
\   RE3+2               Auto-recentre the value in X, if keyboard auto-recentre
\                       is configured
ELIF _6502SP_VERSION
\   djd1                Auto-recentre the value in X, if keyboard auto-recentre
\                       is configured
ENDIF
\
\ ******************************************************************************

.REDU2

 STA T                  \ Store argument A in T so we can restore it later

 TXA                    \ Copy argument X into A

 SEC                    \ Set the C flag so we can do subtraction without the
                        \ C flag affecting the result

 SBC T                  \ Set X = A = argument X - argument A
 TAX

 BCS RE3                \ If the C flag is set, then we didn't underflow, so
                        \ jump to RE3 to auto-recentre and return the result

 LDX #1                 \ We have an underflow, so set X to the minimum possible
                        \ value, 1

.RE3

 BPL RE2+2              \ If X has bit 7 clear (i.e. the result < 128), then
                        \ jump to RE2+2 above to return the result as is,
                        \ because the result is on the left side of the centre
                        \ point of 128, so we don't need to auto-centre

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Label

                        \ Jumps to RE3+2 end up here

ELIF _6502SP_VERSION OR _MASTER_VERSION

.djd1

ENDIF

                        \ If we get here, then we need to apply auto-recentre,
                        \ if it is configured

 LDA DJD                \ If keyboard auto-recentre is disabled, then
 BNE RE2+2              \ jump to RE2+2 to restore A and return

 LDX #128               \ If keyboard auto-recentre is enabled, set X to 128
 BMI RE2+2              \ (the middle of our range) and jump to RE2+2 to
                        \ restore A and return

