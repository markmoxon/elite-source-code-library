\ ******************************************************************************
\
\       Name: GetCmdrImage
\       Type: Subroutine
\   Category: Status
\    Summary: Fetch the headshot image for the commander and store it in the
\             pattern buffers, and send the face and glasses images to the PPU
\
\ ******************************************************************************

.GetCmdrImage

 JSR GetHeadshot        \ Fetch the headshot image for the commander and store
                        \ it in the pattern buffers, starting at pattern number
                        \ picturePattern

 LDA imageSentToPPU     \ The value of imageSentToPPU was set in the STATUS
 ASL A                  \ routine to %1000xxxx, where %xxxx is the headshot
 TAX                    \ number (in the range 0 to 13), so set X to this
                        \ number * 2, so we can use it as an index into the
                        \ faceOffset table, which has two bytes per entry

 CLC                    \ Set V(1 0) = faceOffset for image X + faceCount
 LDA faceOffset,X       \
 ADC #LO(faceCount)     \ So V(1 0) points to faceImage0 when X = 0, faceImage1
 STA V                  \ when X = 1, and so on up to faceImage13 when X = 13
 LDA faceOffset+1,X
 ADC #HI(faceCount)
 STA V+1

 LDA #HI(16*69)         \ Set PPU_ADDR to the address of pattern 69 in pattern
 STA PPU_ADDR           \ table 0
 LDA #LO(16*69)         \
 STA PPU_ADDR           \ So we can unpack the image data for the relevant face
                        \ image into pattern 69 onwards in pattern table 0

 JSR UnpackToPPU        \ Unpack the image data to the PPU

 LDA #HI(glassesImage)  \ Set V(1 0) = glassesImage
 STA V+1                \
 LDA #LO(glassesImage)  \ So we can unpack the image data for the glasses into
 STA V                  \ the next few pattern bytes in pattern table 0

 JMP UnpackToPPU        \ Unpack the image data to the PPU, returning from the
                        \ subroutine using a tail call

