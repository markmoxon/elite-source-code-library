\ ******************************************************************************
\
\       Name: NOSPRITES
\       Type: Subroutine
\   Category: Missions
\    Summary: Disable all sprites and remove them from the screen
\
\ ******************************************************************************

.NOSPRITES

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

 LDA #%00000000         \ Clear bits 0 to 7 of VIC register &15 to disable all
 STA VIC+&15            \ eight sprites

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

.UKCHK2

 BIT VIC+&11            \ Loop back to UKCHK2 until bit 7 of VIC-II register &11
 BPL UKCHK2             \ (control register 1) is set
                        \
                        \ Bit 7 of register &11 contains the top bit of the
                        \ current raster line (which is a 9-bit value), so this
                        \ waits until the raster has reached at least line 256

 CMP VIC+&12            \ Loop back to UKCHK2 until VIC-II register &12 equals
 BNE UKCHK2             \ PALCK
                        \
                        \ VIC-II register &12 contains the bottom byte of the
                        \ current raster line (which is a 9-bit value), and we
                        \ only get here when the top bit of the raster line is
                        \ set, so this waits until we have reached raster line
                        \ 256 + PALCK

ENDIF

 LDA #%100              \ Set A = %100 and fall through into SETL1 to set the
                        \ 6510 input/output port to the following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

