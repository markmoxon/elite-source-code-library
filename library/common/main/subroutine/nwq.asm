\ ******************************************************************************
\
\       Name: nWq
\       Type: Subroutine
\   Category: Stardust
\    Summary: Create a random cloud of stardust
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ Create a random cloud of stardust containing the correct number of dust
\ particles, i.e. NOSTM of them, which is 3 in witchspace and 18 (#NOST) in
\ normal space. Also clears the scanner and initialises the LSO block.
ELIF _NES_VERSION
\ Create a random cloud of stardust containing the correct number of dust
\ particles, i.e. NOSTM of them, which is 3 in witchspace and 20 (#NOST) in
\ normal space. Also hides ships from the screen.
ENDIF
\
\ This is called by the DEATH routine when it displays our untimely demise.
\
\ ******************************************************************************

.nWq

IF _MASTER_VERSION \ Screen

 LDA #DUST              \ Switch to stripe 3-2-3-2, which is cyan/red in the
 STA COL                \ space view

ENDIF

IF _NES_VERSION

 LDA nmiCounter         \ Set the random number seeds to a fairly random state
 CLC                    \ that's based on the NMI counter (which increments
 ADC RAND               \ every VBlank, so will be pretty random)
 STA RAND
 LDA nmiCounter
 STA RAND+1

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: The Electron version has no witchspace, so the number of stardust particles shown is always the same, so the value is hard-coded rather than needing to use a location (which the other versions need so they can vary the number of particles when in witchspace)

 LDY NOSTM              \ Set Y to the current number of stardust particles, so
                        \ we can use it as a counter through all the stardust

ELIF _ELECTRON_VERSION

 LDY #NOST              \ Set Y to the number of stardust particles, so we can
                        \ use it as a counter through all the stardust

ENDIF

.SAL4

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 JSR DORND              \ Set A and X to random numbers

 ORA #8                 \ Set A so that it's at least 8

 STA SZ,Y               \ Store A in the Y-th particle's z_hi coordinate at
                        \ SZ+Y, so the particle appears in front of us

 STA ZZ                 \ Set ZZ to the particle's z_hi coordinate

 JSR DORND              \ Set A and X to random numbers

IF _NES_VERSION

 ORA #16                \ Set A so that it's at least 16

 AND #%11111000         \ Zero bits 0 to 2 of A so that it's a multiple of 8

ENDIF

 STA SX,Y               \ Store A in the Y-th particle's x_hi coordinate at
                        \ SX+Y, so the particle appears in front of us

IF NOT(_NES_VERSION)

 STA X1                 \ Set X1 to the particle's x_hi coordinate

ENDIF

 JSR DORND              \ Set A and X to random numbers

 STA SY,Y               \ Store A in the Y-th particle's y_hi coordinate at
                        \ SY+Y, so the particle appears in front of us

IF NOT(_NES_VERSION)

 STA Y1                 \ Set Y1 to the particle's y_hi coordinate

 JSR PIXEL2             \ Draw a stardust particle at (X1,Y1) with distance ZZ

ELIF _NES_VERSION

 STA SXL,Y              \ Store A in the low bytes of the Y-th particle's three
 STA SYL,Y              \ coordinates
 STA SZL,Y

ENDIF

 DEY                    \ Decrement the counter to point to the next particle of
                        \ stardust

 BNE SAL4               \ Loop back to SAL4 until we have randomised all the
                        \ stardust particles

IF _6502SP_VERSION \ Tube

 JSR PBFL               \ Call PBFL to send the contents of the pixel buffer to
                        \ the I/O processor for plotting on-screen

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

\JSR PBFL               \ This instruction is commented out in the original
                        \ source

ENDIF

IF NOT(_NES_VERSION)

                        \ Fall through into WPSHPS to clear the scanner and
                        \ reset the LSO block

ELIF _NES_VERSION

                        \ Fall through into WPSHPS to hide ships from the screen

ENDIF

