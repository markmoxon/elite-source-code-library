\ ******************************************************************************
\
\       Name: rttrk
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read or write a sector on the current track
\
\ ******************************************************************************

.rttrk

 LDY sector             \ Use the scttab lookup table to set A to the physical
 LDA scttab,Y           \ sector number of logical sector Y

 CMP idfld+1            \ If the physical sector number doesn't match the sector
 BNE trytr4             \ ID, jump to trytr4 to try reading the track again

 PLP                    \ Fetch the read/write status into the C flag from the
                        \ stack

 BCS rttrk2             \ If the C flag is set then we are writing a sector, so
                        \ jump to rttrk2 to write the sector to the disk

 JSR read               \ Otherwise we are reading a sector, so call the read
                        \ routine to read the current sector into the buffer at
                        \ buffr2, which will load the entire commander file as
                        \ it fits into one sector
                        \
                        \ Note that this loads the file straight from disk, so
                        \ it is in the 6-bit nibble format

 PHP                    \ Store the status flags on the stack, so if we take the
                        \ following branch, the stack will be in the correct
                        \ state, with the read/write status on top

 BCS trytr4             \ If there was an error then the read routine will have
                        \ set the C flag, so if this is the case, jump to trytr4
                        \ to try reading the track again

 PLP                    \ Otherwise there was no error, so pull the status flags
                        \ back off the stack as we don't need them there any
                        \ more

 JSR pstnib             \ Call pstnib to convert the sector data that we just
                        \ read into 8-bit bytes, processing the 6-bit nibbles in
                        \ buffr2 into 8-bit bytes in buffer

 JMP rttrk3             \ Jump to rttrk3 to return from the RWTS code with no
                        \ error reported

.rttrk2

 JSR write              \ This does nothing except clear the C flag, as we do
                        \ not need to write anything to disk in the game loader

 LDA #1                 \ Set A = 1 to return as the error number for the "Disk
                        \ write protected" error

 BCS rttrk4             \ This beanch is never taken as the call to write clears
                        \ the C flag

                        \ Fall through into rttrk3 to successfully return from
                        \ the RWTS code with no error reported

