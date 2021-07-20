\ ******************************************************************************
\
\       Name: savews
\       Type: Subroutine
\   Category: Loader
\    Summary: Save the filing system workspace in a safe place and replace it
\             with the MOS character set
\
\ ******************************************************************************

.savews

 PHP                    \ Store the status register, A, X and Y on the stack, so
 PHA                    \ we can retrieve them later to preserve them across
 PHX                    \ calls to the subroutine
 PHY

 LDA #%00001000         \ Set bit 3 of the Access Control Register at SHEILA &34
 TSB VIA+&34            \ to map the filing system RAM space into &C000-&DFFF
                        \ (HAZEL), in place of the MOS VDU workspace (the TSB
                        \ instruction applies the accumulator to the memory
                        \ location using an OR)

                        \ We now want to copy the first three pages from &C000
                        \ to the safe place that we obtained in the loader, and
                        \ whose location we poked directly into the put0, put1
                        \ and put2 instructions below, back in part 1 of the
                        \ loader

 LDX #0                 \ Set a byte counter in X so we can copy an entire page
                        \ of bytes, starting from 0

.putws

 LDA &C000,X            \ Fetch the X-th byte from the first page of the &C000
                        \ workspace

.put0

 STA &C000,X            \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it points to the first page of the safe
                        \ place where we can copy the filing system workspace

 LDA &C100,X            \ Fetch the X-th byte from the second page of the &C000
                        \ workspace (i.e. &C100)

.put1

 STA &C100,X            \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it points to the second page of the safe
                        \ place where we can copy the filing system workspace

 LDA &C200,X            \ Fetch the X-th byte from the third page of the &C000
                        \ workspace (i.e. &C200)

.put2

 STA &C200,X            \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it points to the third page of the safe
                        \ place where we can copy the filing system workspace

 INX                    \ Increment the byte counter

 BNE putws              \ Loop back until we have copied a whole page of bytes
                        \ (three times)

 LDA LATCH              \ Fetch the RAM copy of the currently selected paged ROM
 PHA                    \ from LATCH and save it on the stack so we can restore
                        \ it below

 LDA #%10000000         \ Set the RAM copy of the currently selected paged ROM
 STA LATCH              \ so it matches the paged ROM selection latch at SHEILA
                        \ &30 that we are about to set

 STA VIA+&30            \ Set bit 7 of the ROM Select latch at SHEILA &30, to
                        \ map the MOS ROM to &8000-&8FFF in RAM (ANDY)

                        \ We now want to copy the three pages of MOS character
                        \ definitions from the MOS ROM to &C000, so the
                        \ character printing routines can use them

 LDX #0                 \ Set a byte counter in X so we can copy an entire page
                        \ of bytes, starting from 0

.copych

 LDA &8900,X            \ Copy the X-th byte of the first page of MOS character
 STA &C000,X            \ definitions at &8900 into the X-th byte of &C000

 LDA &8A00,X            \ Copy the X-th byte of the second page of MOS character
 STA &C100,X            \ definitions at &8A00 into the X-th byte of &C100

 LDA &8B00,X            \ Copy the X-th byte of the third page of MOS character
 STA &C200,X            \ definitions at &8B00 into the X-th byte of &C100

 INX                    \ Increment the byte counter

 BNE copych             \ Loop back until we have copied a whole page of bytes
                        \ (three times)

 PLA                    \ Restore the paged ROM number that we saved on the
 STA LATCH              \ stack and store it in LATCH so it matches the paged
                        \ ROM selection latch at SHEILA &30 that we are about
                        \ to set

 STA VIA+&30            \ Store the same value in SHEILA &30, to switch back to
                        \ the ROM that was selected before we changed it above

 PLY                    \ Restore the status register, A, X and Y from the
 PLX                    \ stack, so they are preserved by the subroutine
 PLA
 PLP

 RTS                    \ Return from the subroutine

