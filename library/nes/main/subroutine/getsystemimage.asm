\ ******************************************************************************
\
\       Name: GetSystemImage
\       Type: Subroutine
\   Category: Universe
\    Summary: Fetch the background image and foreground sprite for the current
\             system image and send them to the pattern buffers and PPU
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   picturePattern      The number of the pattern in the pattern table from
\                       which we store the image data for the background tiles
\
\ ******************************************************************************

.GetSystemImage

 JSR GetSystemBack      \ Fetch the first two sections of the system image data
                        \ for the current system, which contain the background
                        \ tiles for the image, and store them in the pattern
                        \ buffers, starting at pattern number picturePattern

 LDA #HI(16*69)         \ Set PPU_ADDR to the address of pattern 69 in pattern
 STA PPU_ADDR           \ table 0
 LDA #LO(16*69)         \
 STA PPU_ADDR           \ So we can unpack the rest of the system image data
                        \ into pattern 69 onwards in pattern table 0, so we can
                        \ display it as a foreground sprite on top of the
                        \ background tiles that we just unpacked

 JSR UnpackToPPU        \ Unpack the third section of the system image data to
                        \ the PPU

 JMP UnpackToPPU+2      \ Unpack the fourth section of the system image data to
                        \ the PPU, putting it just after the data we unpacked
                        \ in the previous call, returning from the subroutine
                        \ using a tail call

