\ ******************************************************************************
\
\       Name: DIALS (Part 1 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: speed indicator
\  Deep dive: The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ This routine updates the dashboard. First we draw all the indicators in the
\ right part of the dashboard, from top (speed) to bottom (energy banks), and
\ then we move on to the left part, again drawing from top (forward shield) to
\ bottom (altitude).
\
\ This first section starts us off with the speedometer in the top right.
\
\ ******************************************************************************

.DIALS

IF _6502SP_VERSION \ Platform

 LDA #%00000001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

ENDIF

IF _MASTER_VERSION \ Platform

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 LDA #1                 \ Set location &DDEB to 1. This location is in HAZEL,
 STA &DDEB              \ which contains the filing system RAM space, though
                        \ I'm not sure what effect this has

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA #&D0               \ Set SC(1 0) = &78D0, which is the screen address for
 STA SC                 \ the character block containing the left end of the
 LDA #&78               \ top indicator in the right part of the dashboard, the
 STA SC+1               \ one showing our speed

 JSR PZW                \ Call PZW to set A to the colour for dangerous values
                        \ and X to the colour for safe values

ELIF _ELECTRON_VERSION

 LDA #&F0               \ Set SC(1 0) = &76F0, which is the screen address for
 STA SC                 \ the character block containing the left end of the
 LDA #&76               \ top indicator in the right part of the dashboard, the
 STA SC+1               \ one showing our speed

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #&A0               \ Set SC(1 0) = &71A0, which is the screen address for
 STA SC                 \ the character block containing the left end of the
 LDA #&71               \ top indicator in the right part of the dashboard, the
 STA SC+1               \ one showing our speed

 JSR PZW2               \ Call PZW2 to set A to the colour for dangerous values
                        \ and X to the colour for safe values, suitable for
                        \ non-striped indicators

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 STX K+1                \ Set K+1 (the colour we should show for low values) to
                        \ X (the colour to use for safe values)

 STA K                  \ Set K (the colour we should show for high values) to
                        \ A (the colour to use for dangerous values)

                        \ The above sets the following indicators to show red
                        \ for high values and yellow/white for low values

 LDA #14                \ Set T1 to 14, the threshold at which we change the
 STA T1                 \ indicator's colour

ENDIF

 LDA DELTA              \ Fetch our ship's speed into A, in the range 0-40

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

\LSR A                  \ Draw the speed indicator using a range of 0-31, and
 JSR DIL-1              \ increment SC to point to the next indicator (the roll
                        \ indicator). The LSR is commented out as it isn't
                        \ required with a call to DIL-1, so perhaps this was
                        \ originally a call to DIL that got optimised

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 JSR DIL-1              \ Draw the speed indicator using a range of 0-31, and
                        \ increment SC to point to the next indicator (the roll
                        \ indicator)

ELIF _ELECTRON_VERSION

 JSR DIL                \ Draw the speed indicator using a range of 0-31, and
                        \ increment SC to point to the next indicator (the roll
                        \ indicator)

ENDIF

