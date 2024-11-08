\ ******************************************************************************
\
\       Name: LoadShipFiles
\       Type: Subroutine
\   Category: Loader
\    Summary: Load all the ship blueprint files into sideways RAM
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   ZP(1 0)             The address in sideways RAM to load the ship files
\
\ ******************************************************************************

.LoadShipFiles

 LDA #'A'               \ Set the ship filename to D.MOA, so we start the
 STA shipFilename+4     \ loading process from this file

.ship1

 LDA #'.'               \ Print a full stop to show progress during loading
 JSR OSWRCH

 LDA #LO(XX21)          \ Set the load address in bytes 2 and 3 of the OSFILE
 STA osfileBlock+2      \ block to XX21, which is where ship blueprint files
 LDA #HI(XX21)          \ get loaded in the normal disc version
 STA osfileBlock+3      \
 LDA #&FF               \ We set the address to the form &FFFFxxxx to ensure
 STA osfileBlock+4      \ that the files are loaded into the I/O Processor
 STA osfileBlock+5

 LDA #0                 \ Set byte 6 to zero to terminate the block
 STA osfileBlock+6

 LDX #LO(osfileBlock)   \ Set (Y X) = osfileBlock
 LDY #HI(osfileBlock)

 LDA #&FF               \ Call OSFILE with A = &FF to load the file specified
 JSR OSFILE             \ in the block, so this loads the ship blueprint file
                        \ to XX21

                        \ We now loop through each blueprint in the currently
                        \ loaded ship file, processing each one in turn to
                        \ merge them into one big ship blueprint file

 LDX #0                 \ Set a loop counter in X to work through the ship
                        \ blueprints

.ship2

 TXA                    \ Store the blueprint counter on the stack so we can
 PHA                    \ retrieve it after the call to ProcessBlueprint

 JSR ProcessBlueprint   \ Process blueprint entry X from the loaded blueprint
                        \ file, copying the blueprint into sideways RAM if it
                        \ hasn't already been copied

 PLA                    \ Restore the blueprint counter
 TAX

 INX                    \ Increment the blueprint counter

 CPX #31                \ Loop back until we have processed all 31 blueprint
 BNE ship2              \ entries in the blueprint file

 INC shipFilename+4     \ Increment the fifth character of the ship blueprint
                        \ filename so we step through them from D.MOA to D.MOP

 LDA shipFilename+4     \ Loop back until we have processed files D.MOA through
 CMP #'Q'               \ D.MOP
 BNE ship1

 RTS                    \ Return from the subroutine

