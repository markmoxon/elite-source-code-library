\ ******************************************************************************
\
\       Name: COLD
\       Type: Subroutine
\   Category: Loader
\    Summary: Initialise the screen mode, clear memory and set up interrupt
\             handlers
\
\ ******************************************************************************

.COLD

 JSR HGR                \ Switch to the high-resolution graphics screen mode

                        \ We start by zeroing two pages of memory from &0800
                        \ to &09FF, so that zeroes the following:
                        \
                        \   * The disk sector buffer from &0800 to &08FF
                        \
                        \   * The disk 6-bit nibble buffer from &0900 to &09FF
                        \
                        \ So this initialises the disk buffers at buffer and
                        \ buffer2

 LDA #8                 \ Set the high byte of SC(1 0) to 8
 STA SC+1

 LDX #2                 \ Set X = 2 to act as a page counter, so we zero two
                        \ whole pages of memory

 LDA #0                 \ Set A = 0 so we can use this to zero memory locations

 STA SC                 \ Set the low byte of SC(1 0) to zero, so SC is now set
                        \ to &0800

 TAY                    \ Set Y = 0 to act as a byte counter within each page

.zerowksploop

 STA (SC),Y             \ Zero the Y-th byte of SC(1 0)

 INY                    \ Increment the byte counter

 BNE zerowksploop       \ Loop back until we have zeroed a whole page of memory

 INC SC+1               \ Increment the high byte of SC(1 0) to point to the
                        \ next page in memory

 DEX                    \ Decrement the page counter in X

 BNE zerowksploop       \ Loop back until we have zeroed all three pages

                        \ Next, we zero the page of memory from &0200 to &02FF,
                        \ so that zeroes the following:
                        \
                        \   * The UP from workspace &0200 to &02FF (though it
                        \     doesn't zero the last two bytes of the workspace
                        \     at &0300 and &0301)
                        \
                        \ At this point Y = 0, so we can use that as a byte
                        \ counter

.zerowkl2

 STA &0200,Y            \ Zero the Y-th byte of &0200

 DEY                    \ Decrement the byte counter

 BNE zerowkl2           \ Loop back until we have zeroed the whole page

 LDA #LO(NMIpissoff)    \ Set the NMI interrupt vector in NMIV to point to the
 STA NMIV               \ NMIpissoff routine, which acknowledges NMI interrupts
 LDA #HI(NMIpissoff)    \ and ignores them
 STA NMIV+1

 LDA #LO(CHPR2)         \ Set the CHRV interrupt vector in CHRV to point to the
 STA CHRV               \ CHPR2 routine, which prints valid ASCII characters
 LDA #HI(CHPR2)         \ using the CHPR routine (so this replaces the normal
 STA CHRV+1             \ text-printing routine with Elite's own CHPR routine)

 SEI                    \ Disable interrupts (though they will be re-enabled by
                        \ the first non-maskable interrupt that is handled by
                        \ NMIpissoff, so this probably won't disable interrupts
                        \ for long)

 RTS                    \ Return from the subroutine

