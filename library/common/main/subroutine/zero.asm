\ ******************************************************************************
\
\       Name: ZERO
\       Type: Subroutine
\   Category: Utility routines
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\    Summary: Zero-fill pages &9, &A, &B, &C and &D
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _NES_VERSION
\    Summary: Reset the local bubble of universe and ship status
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This resets the following workspaces to zero:
\
IF _CASSETTE_VERSION \ Comment
\   * The ship data blocks ascending from K% at &0900
\
\   * The ship line heap descending from WP at &0D40
\
\   * WP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status variables
\     (only a portion of the LSX/LSO sun line heap is cleared)
ELIF _ELECTRON_VERSION
\   * The ship data blocks ascending from K% at &0900
\
\   * The ship line heap descending from WP at &0BE0
\
\   * WP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status variables
\     (only a portion of the LSO space station line heap is cleared)
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\   * WP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status variables
\     (only a portion of the LSX/LSO sun line heap is cleared)
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   * UP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status variables
ELIF _NES_VERSION
\   * WP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status
\     variables, including the MANY block
ENDIF
\
\ ******************************************************************************

.ZERO

IF _CASSETTE_VERSION \ Platform

 LDX #&D                \ Point X to page &D

.ZEL

 JSR ZES1               \ Call ZES1 to zero-fill the page in X

 DEX                    \ Decrement X to point to the next page

 CPX #9                 \ If X is > 9 (i.e. is &A, &B or &C), then loop back
 BNE ZEL                \ up to clear the next page

                        \ Then fall through into ZES1 with X set to 9, so we
                        \ clear page &9 too

ELIF _ELECTRON_VERSION

 LDX #&B                \ Point X to page &B

 JSR ZES1               \ Call ZES1 to zero-fill the page in X

 DEX                    \ Decrement X to point to the next page (&A)

 JSR ZES1               \ Call ZES1 to zero-fill the page in X

 DEX                    \ Decrement X to point to the next page

                        \ Then fall through into ZES1 with X set to 9, so we
                        \ clear page &9 too

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDX #(de-FRIN)         \ We're going to zero the UP workspace variables from
                        \ FRIN to de, so set a counter in X for the correct
                        \ number of bytes

 LDA #0                 \ Set A = 0 so we can zero the variables

.ZEL2

 STA FRIN,X             \ Zero the X-th byte of FRIN to de

 DEX                    \ Decrement the loop counter

 BPL ZEL2               \ Loop back to zero the next variable until we have done
                        \ them all

 RTS                    \ Return from the subroutine

ELIF _NES_VERSION

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #(de-FRIN+1)       \ We're going to zero the WP workspace variables from
                        \ FRIN to de, so set a counter in X for the correct
                        \ number of bytes

 LDA #0                 \ Set A = 0 so we can zero the variables

.ZEL

 STA FRIN-1,X           \ Zero byte X-1 of FRIN to de

 DEX                    \ Decrement the loop counter

 BNE ZEL                \ Loop back to zero the next variable until we have done
                        \ them all from FRIN to FRIN+42

 LDX #NTY               \ We're now going to zero the NTY bytes in the MANY
                        \ block, so set a counter in X for the correct number of
                        \ bytes

.ZEL2

 STA MANY,X             \ Zero the X-th byte of MANY

 DEX                    \ Decrement the loop counter

 BPL ZEL2               \ Loop back to zero the next variable until we have done
                        \ them all from MANY to MANY+33

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS                    \ Return from the subroutine

ENDIF

