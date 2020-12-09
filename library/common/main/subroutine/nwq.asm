\ ******************************************************************************
\
\       Name: nWq
\       Type: Subroutine
\   Category: Stardust
\    Summary: Create a random cloud of stardust
\
\ ------------------------------------------------------------------------------
\
\ Create a random cloud of stardust containing the correct number of dust
\ particles, i.e. NOSTM of them, which is 3 in witchspace and 18 (#NOST) in
\ normal space. Also clears the scanner and initialises the LSO block.
\
\ This is called by the DEATH routine when it displays our untimely demise.
\
\ ******************************************************************************

.nWq

 LDY NOSTM              \ Set Y to the current number of stardust particles, so
                        \ we can use it as a counter through all the stardust

.SAL4

 JSR DORND              \ Set A and X to random numbers

 ORA #8                 \ Set A so that it's at least 8

 STA SZ,Y               \ Store A in the Y-th particle's z_hi coordinate at
                        \ SZ+Y, so the particle appears in front of us

 STA ZZ                 \ Set ZZ to the particle's z_hi coordinate

 JSR DORND              \ Set A and X to random numbers

 STA SX,Y               \ Store A in the Y-th particle's x_hi coordinate at
                        \ SX+Y, so the particle appears in front of us

 STA X1                 \ Set X1 to the particle's x_hi coordinate

 JSR DORND              \ Set A and X to random numbers

 STA SY,Y               \ Store A in the Y-th particle's y_hi coordinate at
                        \ SY+Y, so the particle appears in front of us

 STA Y1                 \ Set Y1 to the particle's y_hi coordinate

 JSR PIXEL2             \ Draw a stardust particle at (X1,Y1) with distance ZZ

 DEY                    \ Decrement the counter to point to the next particle of
                        \ stardust

 BNE SAL4               \ Loop back to SAL4 until we have randomised all the
                        \ stardust particles

IF _6502SP_VERSION

 JSR PBFL               \ Call PBFL to send the contents of the pixel buffer to
                        \ the I/O processor for plotting on-screen

ENDIF

                        \ Fall through into WPSHPS to clear the scanner and
                        \ reset the LSO block

