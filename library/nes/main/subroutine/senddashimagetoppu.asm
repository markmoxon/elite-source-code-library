\ ******************************************************************************
\
\       Name: SendDashImageToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Unpack the dashboard image and send it to patterns 69 to 255 in
\             pattern table 0 in the PPU
\  Deep dive: Views and view types in NES Elite
\
\ ******************************************************************************

.SendDashImageToPPU

 LDA #HI(16*69)         \ Set PPU_ADDR to the address of pattern 69 in pattern
 STA PPU_ADDR           \ table 0
 LDA #LO(16*69)
 STA PPU_ADDR

 LDA #HI(dashImage)     \ Set V(1 0) = dashImage
 STA V+1                \
 LDA #LO(dashImage)     \ So we can unpack the image data for the dashboard into
 STA V                  \ into patterns 69 to 255 in pattern table 0

 JMP UnpackToPPU        \ Unpack the image data to the PPU, returning from the
                        \ subroutine using a tail call

