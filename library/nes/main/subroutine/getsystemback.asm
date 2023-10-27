\ ******************************************************************************
\
\       Name: GetSystemBack
\       Type: Subroutine
\   Category: Universe
\    Summary: Fetch the background image for the current system and store it in
\             the pattern buffers
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   picturePattern      The number of the pattern in the pattern table from
\                       which we store the image data
\
\ ******************************************************************************

.GetSystemBack

 LDA #0                 \ Set (SC+1 A) = (0 picturePattern)
 STA SC+1               \              = picturePattern
 LDA picturePattern

 ASL A                  \ Set SC(1 0) = (SC+1 A) * 8
 ROL SC+1               \             = picturePattern * 8
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC

 STA SC2                \ Set SC2(1 0) = pattBuffer1 + SC(1 0)
 LDA SC+1               \              = pattBuffer1 + picturePattern * 8
 ADC #HI(pattBuffer1)
 STA SC2+1

 LDA SC+1               \ Set SC(1 0) = pattBuffer0 + SC(1 0)
 ADC #HI(pattBuffer0)   \             = pattBuffer0 + picturePattern * 8
 STA SC+1

 LDA QQ15+1             \ Set X to a number between 0 and 15 that is generated
 EOR QQ15+4             \ from the high bytes of the 16-bit seeds for the
 EOR QQ15+3             \ selected system (s0_hi, s1_hi and s2_hi)
 AND #&0F
 TAX

 CPX systemCount        \ If X < systemCount, skip the following two
 BCC gsys1              \ instructions

 LDX systemCount        \ Set X = systemCount - 1 so X has a maximum value of 14
 DEX                    \ (as systemCount is 15)

.gsys1

 TXA                    \ Set imageSentToPPU to %1100xxxx where %xxxx is the
 ORA #%11000000         \ system number in the range 0 to 14, to indicate that
 STA imageSentToPPU     \ we have unpacked the system background image into the
                        \ buffers

 TXA                    \ Set X = X * 2 so we can use it as an index into the
 ASL A                  \ table of 16-bit addresses at systemOffset
 TAX

 LDA systemOffset,X     \ Set V(1 0) = systemOffset for image X + systemCount
 ADC #LO(systemCount)   \
 STA V                  \ So V(1 0) points to systemImage0 when X = 0,
 LDA systemOffset+1,X   \ systemImage1 when X = 1, and so on up to systemImage14
 ADC #HI(systemCount)   \ when X = 14
 STA V+1

 JSR UnpackToRAM        \ Unpack the first section of image data from V(1 0)
                        \ into SC(1 0), updating V(1 0) as we go
                        \
                        \ SC(1 0) is pattBuffer0 + picturePattern * 8, so this
                        \ unpacks the data for pattern number picturePattern
                        \ into pattern buffer 0

 LDA SC2                \ Set SC(1 0) = SC2(1 0)
 STA SC                 \             = pattBuffer1 + picturePattern * 8
 LDA SC2+1
 STA SC+1

 JMP UnpackToRAM        \ Unpack the second section of image data from V(1 0)
                        \ into SC(1 0), updating V(1 0) as we go
                        \
                        \ SC(1 0) is pattBuffer1 + picturePattern * 8, so this
                        \ unpacks the data for pattern number picturePattern
                        \ into pattern buffer 1
                        \
                        \ When done, we return from the subroutine using a tail
                        \ call

