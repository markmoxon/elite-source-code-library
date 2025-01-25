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

 JSR write              \ Call the write routine to write a sector's worth of
                        \ data from buffr2 to the specified track and sector,
                        \ which will save the entire commander file as it fits
                        \ into one sector
                        \
                        \ Note that the data in buffr2 is in the 6-bit nibble
                        \ format, as we pre-nibblized it in the trytrk routine

 BCC rttrk3             \ If there was no write error then the write routine
                        \ will have cleared the C flag, so jump to rttrk3 to
                        \ return from the RWTS code with no error reported

 LDA #1                 \ Set A = 1 to return as the error number for the "Disk
                        \ write protected" error

 BPL drver2p            \ Jump to drver2p to restore the stack pointer and
                        \ return from the RWTS code with an error number of 1
                        \ and the C flag set to indicate an error (this BPL is
                        \ effectively a JMP as A is always positive)

