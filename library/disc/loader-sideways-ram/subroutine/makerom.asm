\ ******************************************************************************
\
\       Name: MakeRom
\       Type: Subroutine
\   Category: Loader
\    Summary: Create a ROM image in sideways RAM that contains all the ship
\             blueprint files
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The bank number of sideways RAM to use for Elite
\
\ ******************************************************************************

.MakeRom

 LDA &F4                \ Switch to the sideways RAM bank in X, storing the
 PHA                    \ current ROM bank on the stack
 STX &F4
 STX VIA+&30

                        \ We start by copying 256 bytes from romHeader into the
                        \ sideways RAM bank at address ROM, and zeroing the next
                        \ 256 bytes at ROM + &100
                        \
                        \ This sets up the sideways RAM bank with the ROM header
                        \ needed for our sideways RAM image

 LDY #0                 \ Set a loop counter in Y to step through the 256 bytes

.mrom1

 LDA romHeader,Y        \ Copy the Y-th byte from romHeader to ROM
 STA ROM,Y

 LDA #0                 \ Zero the Y-th byte at ROM + &100
 STA ROM_XX21,Y
 INY                    \ Increment the loop counter

 BNE mrom1              \ Loop back until we have copied and zeroed all 256
                        \ bytes

                        \ Next we load all the ship blueprint files into our
                        \ sideways RAM image, from D.MOA to D.MOP, combining
                        \ them into a single, complete set of ship blueprints

 LDA #LO(ROM+&200)      \ Set ZP(1 0) = ROM + &200
 STA ZP                 \
 LDA #HI(ROM+&200)      \ So the call to LoadShipFiles loads the ship blueprint
 STA ZP+1               \ files to location &200 in the sideways RAM image

 JSR LoadShipFiles      \ Load all the ship blueprint files into the sideways
                        \ RAM image to the location in ZP(1 0)

                        \ Now that we have created our sideways RAM image, we
                        \ intercept calls to OSFILE so they call our custom file
                        \ handler routine, FileHandler, in sideways RAM
                        \
                        \ For this we need to use the extended vectors, which
                        \ work like the normal vectors, except they switch to a
                        \ specified ROM bank before calling the handler, and
                        \ switch back afterwards

 LDA XFILEV             \ Copy the extended vector XFILEV into XIND1V so we can
 STA XIND1V             \ pass any calls to XFILEV down the chain by calling
 LDA XFILEV+1           \ the IND1 vector
 STA XIND1V+1
 LDA XFILEV+2
 STA XIND1V+2

 LDA #LO(FileHandler)   \ Set the extended vector XFILEV to point to the
 STA XFILEV             \ FileHandler routine in the sideways RAM bank that we
 LDA #HI(FileHandler)   \ are building
 STA XFILEV+1           \ 
 LDA &F4                \ The format for the extended vector is the address of
 STA XFILEV+2           \ the handler in the first two bytes, followed by the
                        \ ROM bank number in the third byte, which we can fetch
                        \ from &F4

 LDA #LO(OSXIND1)       \ Point IND1V to IND1V's extended vector handler, so we
 STA IND1V              \ can pass any calls to XFILEV down the chain by calling
 LDA #HI(OSXIND1)       \ JMP (IND1V) from our custom file handler in the
 STA IND1V+1            \ FileHandler routine

 PLA                    \ Switch back to the ROM bank number that we saved on
 STA &F4                \ the stack at the start of the routine
 STA VIA+&30

 RTS                    \ Return from the subroutine

