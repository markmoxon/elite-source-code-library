\ ******************************************************************************
\
\       Name: stopbd
\       Type: Subroutine
\   Category: Sound
\    Summary: Stop playing the docking music
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   stopat              Stop playing the current music
\
\   coffeeex            Restore the memory configuration and return from the
\                       subroutine
\
\ ******************************************************************************

.stopbd

IF _GMA_RELEASE

 BIT MULIE              \ If bit 7 of MULIE is set then we got here via the call
 BMI itsoff             \ to the RESET routine from the TITLE routine
                        \
                        \ When this is the case, we do not want to stop the
                        \ title music from playing, so jump to itsoff to return
                        \ from the subroutine without doing anything (as itsoff
                        \ contains an RTS)

ENDIF

 BIT MUFOR              \ If bit 7 of MUFOR is set then the docking music is
 BMI startbd            \ configured so that it cannot be disabled, so jump to
                        \ startbd to start playing the docking music instead

.stopat

 BIT MUPLA              \ If bit 7 of MUPLA is clear then no music is currently
 BPL itsoff             \ playing, so jump to itsoff to return from the
                        \ subroutine (as itsoff contains an RTS)

 JSR SOFLUSH            \ Call SOFLUSH to reset the sound buffers

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
                        \ Programmer's Reference Guide

 LDA #0                 \ Set MUPLA to 0 to indicate that no music is playing
 STA MUPLA

 LDX #&18               \ We now want to zero SID registers &00 to &18, so set
                        \ an index counter in X

 SEI                    \ Disable interrupts while we update the SID registers

.coffeeloop

 STA SID,X              \ Zero the X-th SID register

 DEX                    \ Decrement the loop counter

 BPL coffeeloop         \ Loop back until we have zeroed all SID registers from
                        \ &18 down to &00

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

 CLI                    \ Enable interrupts again

.coffeeex

 LDA #%100              \ Call SETL1 to set the 6510 input/output port to the
 JMP SETL1              \ following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ and return from the subroutine using a tail call
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

