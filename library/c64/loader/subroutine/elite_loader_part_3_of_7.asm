\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 7)
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure the memory layout and the CIA chips
\
\ ******************************************************************************

 LDA L1                 \ Set bits 0 to 2 of the 6510 port register at location
 AND #%11111000         \ L1 to %101 to set the input/output port to the
 ORA #%00000101         \ following:
 STA L1                 \
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

 LDA CIA2+2             \ Set bits 0-1 of CIA2 port A to the output direction
 ORA #%00000011         \ so we can write to the VIC-II bank selector, which is
 STA CIA2+2             \ mapped here (0 means input, 1 means output)

 LDA CIA2+0             \ Set bits 0-1 of CIA2 port A to configure the VIC-II to
 AND #%11111100         \ use bank 1 (&4000 to &7FFF)
 ORA #%00000010         \
 STA CIA2+0             \ The bank number is inverted, so setting bits 0-1 to
                        \ %10 actually sets bank %01

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
                        \   * Bit 7 clear = disable interupts whose
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
                        \   * Bit 7 clear = disable interupts whose
                        \                   corresponding bits are set
                        \
                        \ So this disables interrupts that are generated by
                        \ timer A underflow and timer B underflow, while leaving
                        \ other interrupts as they are
