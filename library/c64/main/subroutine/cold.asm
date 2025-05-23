\ ******************************************************************************
\
\       Name: COLD
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure memory, set up interrupt handlers and configure the
\             VIC-II, SID and CIA chips
\  Deep dive: The split-screen mode in Commodore 64 Elite
\
\ ******************************************************************************

.COLD

                        \ We start by zeroing three pages of memory from &0400
                        \ to &05FF, so that zeroes the following:
                        \
                        \   * The UP from workspace &0400 to &0540
                        \
                        \   * The WP from workspace &0580 to &06FB
                        \
                        \ So this initialises all the variables in the UP and WP
                        \ workspaces

 LDA #4                 \ Set the high byte of SC(1 0) to 4
 STA SC+1

 LDX #3                 \ Set X = 3 to act as a page counter, so we zero three
                        \ whole pages of memory

 LDA #0                 \ Set A = 0 so we can use this to zero memory locations

 STA SC                 \ Set the low byte of SC(1 0) to zero, so SC is now set
                        \ to &0400

 TAY                    \ Set Y = 0 to act as a byte counter within each page

.zerowksploop

 STA (SC),Y             \ Zero the Y-th byte of SC(1 0)

 INY                    \ Increment the byte counter

 BNE zerowksploop       \ Loop back until we have zeroed a whole page of memory

 INC SC+1               \ Increment the high byte of SC(1 0) to point to the
                        \ next page in memory

 DEX                    \ Decrement the page counter in X

 BNE zerowksploop       \ Loop back until we have zeroed all three pages

 LDA #LO(NMIpissoff)    \ Set the NMI interrupt vector in NMIV to point to the
 STA NMIV               \ NMIpissoff routine, which acknowledges NMI interrupts
 LDA #HI(NMIpissoff)    \ and ignores them
 STA NMIV+1

 LDA #LO(CHPR2)         \ Set the CHRV interrupt vector in CHRV to point to the
 STA CHRV               \ CHPR2 routine, which prints valid ASCII characters
 LDA #HI(CHPR2)         \ using the CHPR routine (so this replaces the normal
 STA CHRV+1             \ text-printing routine with Elite's own CHPR routine)

 LDA #%101              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ "Commodore 64 Programmer's Reference Guide", published
                        \ by Commodore
 SEI                    \ Disable interrupts while we configure the VIC-II, CIA
                        \ and SID chips and update the interrupt handlers

IF NOT(USA%)

                        \ We only include this code if USA% is FALSE
                        \
                        \ It is designed to slow down PAL machines to match the
                        \ speed of NTSC machines (though the GMA86 PAL version
                        \ doesn't actually include this code)
                        \
                        \ Specifically, it waits until raster line 256 + PALCK
                        \ is reached before continuing

 LDA #PALCK             \ Set A = PALCK, which contains the bottom byte of the
                        \ the raster line that we want to wait for

.UKCHK

 BIT VIC+&11            \ Loop back to UKCHK until bit 7 of VIC-II register &11
 BPL UKCHK              \ (control register 1) is set
                        \
                        \ Bit 7 of register &11 contains the top bit of the
                        \ current raster line (which is a 9-bit value), so this
                        \ waits until the raster has reached at least line 256

 CMP VIC+&12            \ Loop back to UKCHK until VIC-II register &12 equals
 BNE UKCHK              \ PALCK
                        \
                        \ VIC-II register &12 contains the bottom byte of the
                        \ current raster line (which is a 9-bit value), and we
                        \ only get here when the top bit of the raster line is
                        \ set, so this waits until we have reached raster line
                        \ 256 + PALCK

ENDIF

 LDA #%00000011         \ Set CIA1 register &0D to enable and disable interrupts
 STA CIA+&D             \ as follows:
                        \
                        \   * Bit 0 set = configure interrupts generated by
                        \                 timer A underflow
                        \
                        \   * Bit 1 set = configure interrupts generated by
                        \                 timer B underflow
                        \
                        \   * Bits 2-4 clear = do not change configuration of
                        \                      other interrupts
                        \
                        \   * Bit 7 clear = disable interrupts whose
                        \                   corresponding bits are set
                        \
                        \ So this disables interrupts that are generated by
                        \ timer A underflow and timer B underflow, while leaving
                        \ other interrupts as they are

 STA CIA2+&D            \ Set CIA2 register &0D to enable and disable interrupts
                        \ as follows:
                        \
                        \   * Bit 0 set = configure interrupts generated by
                        \                 timer A underflow
                        \
                        \   * Bit 1 set = configure interrupts generated by
                        \                 timer B underflow
                        \
                        \   * Bits 2-4 clear = do not change configuration of
                        \                      other interrupts
                        \
                        \   * Bit 7 clear = disable interrupts whose
                        \                   corresponding bits are set
                        \
                        \ So this disables interrupts that are generated by
                        \ timer A underflow and timer B underflow, while leaving
                        \ other interrupts as they are

\LDA #2                 \ These instructions are commented out in the original
\STA VIC+&20            \ source

 LDA #%00001111         \ Set SID register &18 to control the sound as follows:
 STA SID+&18            \
                        \   * Bits 0-3: set the volume to 15 (maximum)
                        \
                        \   * Bit 4 clear: disable the low-pass filter
                        \
                        \   * Bit 5 clear: disable the bandpass filter
                        \
                        \   * Bit 6 clear: disable the high-pass filter
                        \
                        \   * Bit 7 clear: enable voice 3

 LDX #0                 \ Set the raster count to 0 to initialise the raster
 STX RASTCT             \ effects in the COMIRQ handler (such as the split
                        \ screen)

 INX                    \ Set bit 0 of VIC register &1A and clear bits 1-3 to
 STX VIC+&1A            \ configure the following interrupts:
                        \
                        \   * Bit 0 = enable raster interrupt
                        \
                        \   * Bit 1 = disable sprite-background collision
                        \             interrupt
                        \
                        \   * Bit 2 = disable sprite-sprite collision interrupt
                        \
                        \   * Bit 3 = disable light pen interrupt

 LDA VIC+&11            \ Clear bit 7 of VIC register &11, to clear the top bit
 AND #%01111111         \ of the raster line that generates the interrupt (as
 STA VIC+&11            \ the line number is a 9-bit value, with bits 0-7 in VIC
                        \ register &12)

 LDA #40                \ Set VIC register &11 to 40, so along with bit 7 of VIC
 STA VIC+&12            \ register &10, this sets the raster interrupt to be
                        \ generated when the raster reaches line 40

 LDA l1                 \ Set bits 0 to 2 of the 6510 port register at location
 AND #%11111000         \ l1 to %100 to set the input/output port to the
 ORA #%00000100         \ following:
 STA l1                 \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ and return from the subroutine using a tail call
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ "Commodore 64 Programmer's Reference Guide", published
                        \ by Commodore
 LDA #%100              \ Set L1M to %100, so the default action of the SETL1
 STA L1M                \ routine will configure memory as above

 LDA #LO(NMIpissoff)    \ Set the NMI interrupt service hardware vector at &FFFA
 STA &FFFA              \ to point to the NMIpissoff routine, which acknowledges
 LDA #HI(NMIpissoff)    \ NMI interrupts and ignores them
 STA &FFFB              \
                        \ This ensures that even if the Kernal is not paged into
                        \ memory, NMIs will be processed

 LDA #HI(COMIRQ1)       \ Set the IRQ interrupt service hardware vector at &FFFE
 STA &FFFF              \ to point to COMIRQ1, so it gets called to handle all
 LDA #LO(COMIRQ1)       \ IRQ interrupts and BRK instructions (COMIRQ1 plays the
 STA &FFFE              \ background music and manages the split screen)
                        \
                        \ This ensures that even if the Kernal is not paged into
                        \ memory, IRQs will be processed

 CLI                    \ Re-enable interrupts

 RTS                    \ Return from the subroutine

