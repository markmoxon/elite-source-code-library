\ ******************************************************************************
\
\       Name: SVE
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save the commander file
\  Deep dive: Commander save files
\             The competition code
\
\ ******************************************************************************

.SVE

                        \ The following remnants are all that remain of the SVE
                        \ routine, and they are not used by the demo, so
                        \ presumably removing the SVE routine from the demo was
                        \ only partially done

 STA CHK2               \ Store the checksum EOR &A9 in CHK2, the penultimate
                        \ byte of the last saved commander block

 STA &0AFF+NT%          \ Store the checksum EOR &A9 in the penultimate byte of
                        \ the save file at &0B00 (the equivalent of CHK2 in the
                        \ last saved block)

 LDY #&B                \ Set up an OSFILE block at &0C00, containing:
 STY &0C0B              \
 INY                    \ Start address for save = &00000B00 in &0C0A to &0C0D
 STY &0C0F              \
                        \ End address for save = &00000C00 in &0C0E to &0C11
                        \
                        \ Y is left containing &C which we use below

