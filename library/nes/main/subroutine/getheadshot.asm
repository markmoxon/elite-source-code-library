\ ******************************************************************************
\
\       Name: GetHeadshot
\       Type: Subroutine
\   Category: Status
\    Summary: Fetch the headshot image for the commander and store it in the
\             pattern buffers, starting at tile number pictureTile
\
\ ******************************************************************************

.GetHeadshot

 LDA #0                 \ Set (SC+1 A) = (0 pictureTile)
 STA SC+1               \              = pictureTile
 LDA pictureTile

 ASL A                  \ Set SC(1 0) = (SC+1 A) * 8
 ROL SC+1               \             = pictureTile * 8
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC

 STA SC2                \ Set SC2(1 0) = pattBuffer1 + SC(1 0)
 LDA SC+1               \              = pattBuffer1 + pictureTile * 8
 ADC #HI(pattBuffer1)
 STA SC2+1

 LDA SC+1               \ Set SC(1 0) = pattBuffer0 + SC(1 0)
 ADC #HI(pattBuffer0)   \             = pattBuffer0 + pictureTile * 8
 STA SC+1

 LDA imageSentToPPU     \ The value of imageSentToPPU was set in the STATUS
 ASL A                  \ routine to %1000xxxx, where %xxxx is the headshot
 TAX                    \ number (in the range 0 to 13), so set X to this
                        \ number * 2, so we can use it as an index into the
                        \ headOffset table, which has two bytes per entry

 LDA headOffset,X       \ Set V(1 0) = headOffset for image X + headCount
 CLC                    \
 ADC #LO(headCount)     \ So V(1 0) points to headImage0 when X = 0, headImage1
 STA V                  \ when X = 1, and so on up to headImage13 when X = 13
 LDA headOffset+1,X
 ADC #HI(headCount)
 STA V+1

 JSR UnpackToRAM        \ Unpack the data at V(1 0) into SC(1 0), updating
                        \ V(1 0) as we go
                        \
                        \ SC(1 0) is pattBuffer0 + pictureTile * 8, so this
                        \ unpacks the headshot pattern data into pattern buffer
                        \ 0, starting from pattern pictureTile

 LDA SC2                \ Set SC(1 0) = SC2(1 0)
 STA SC                 \             = pattBuffer1 + pictureTile * 8
 LDA SC2+1
 STA SC+1

 JSR UnpackToRAM        \ Unpack the data at V(1 0) into SC(1 0), updating
                        \ V(1 0) as we go
                        \
                        \ SC(1 0) is pattBuffer1 + pictureTile * 8, so this
                        \ unpacks the headshot pattern data into pattern buffer
                        \ 1, starting from pattern pictureTile

 RTS                    \ Return from the subroutine

