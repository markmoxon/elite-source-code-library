\ ******************************************************************************
\
\       Name: SetLinePatterns
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Copy the patterns for horizontal line, vertical line and block
\             images into the pattern buffers, depending on the view
\  Deep dive: Drawing lines in the NES version
\
\ ******************************************************************************

.vpat1

 LDX #4                 \ This is the Start screen with no fonts loaded, so set
 STX firstFreePattern   \ firstFreePattern to 4

 RTS                    \ Return from the subroutine without copying anything to
                        \ the pattern buffers

.vpat2

 LDX #37                \ This is the Space view with the normal font loaded,
 STX firstFreePattern   \ so set firstFreePattern to 37

 RTS                    \ Return from the subroutine without copying anything to
                        \ the pattern buffers

.SetLinePatterns

 LDA QQ11               \ If the view type in QQ11 is &CF (Start screen with no
 CMP #&CF               \ font loaded), jump to vpat1 to set firstFreePattern to
 BEQ vpat1              \ 4 and return from the subroutine

 CMP #&10               \ If the view type in QQ11 is &10 (Space view with
 BEQ vpat2              \ the normal font loaded), jump to vpat2 to set
                        \ firstFreePattern to 37 and return from the subroutine

 LDX #66                \ Set X = 66 to use as the value of firstFreePattern
                        \ then there is no dashboard

 LDA QQ11               \ If bit 7 of the view type in QQ11 is set then there
 BMI vpat3              \ is no dashboard, so jump to vpat3 to keep X = 66

 LDX #60                \ There is a dashboard, so set X = 60 to use as the
                        \ value of firstFreePattern

.vpat3

 STX firstFreePattern   \ Set firstFreePattern to the value we set in X, so it
                        \ is 66 when there is no dashboard, or 60 when there is
                        \
                        \ We now load the image data for the horizontal line,
                        \ vertical line and block images, starting at pattern 37
                        \ and ending at the pattern in firstFreePattern (60 or
                        \ 66)

 LDA #HI(lineImage)     \ Set V(1 0) = lineImage so we copy the pattern data for
 STA V+1                \ the line images into the pattern buffers below
 LDA #LO(lineImage)
 STA V

 LDA #HI(pattBuffer0+8*37)  \ Set SC(1 0) to the address of pattern 37 in
 STA SC+1                   \ pattern buffer 0
 LDA #LO(pattBuffer0+8*37)
 STA SC

 LDA #HI(pattBuffer1+8*37)  \ Set SC2(1 0) to the address of pattern 37 in
 STA SC2+1                  \ pattern buffer 1
 LDA #LO(pattBuffer1+8*37)
 STA SC2

 LDY #0                 \ We are about to copy data into the pattern buffers,
                        \ so set an index counter in Y

 LDX #37                \ We are copying the image data into patterns 37 to 60,
                        \ so set a pattern counter in X

.vpat4

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We repeat the following code eight times, so it copies
                        \ eight bytes of each pattern into both pattern buffers

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC),Y             \ into pattern buffers 0 and 1, and increment the index
 STA (SC2),Y            \ in Y
 INY

 BNE vpat5              \ If we just incremented Y back around to 0, then
 INC V+1                \ increment the high bytes of V(1 0), SC(1 0) and
 INC SC+1               \ SC2(1 0) to point to the next page in memory
 INC SC2+1

.vpat5

 INX                    \ Increment the pattern counter in X

 CPX #60                \ Loop back until we have copied patterns 37 to 59
 BNE vpat4

.vpat6

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 CPX firstFreePattern   \ If the pattern counter in X matches firstFreePattern,
 BEQ vpat8              \ jump to vpat8 to exit the following loop

                        \ Otherwise we keep copying tiles until X matches
                        \ firstFreePattern

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the line image table
 STA (SC2),Y            \ into pattern buffer 1, zero the Y-th byte of pattern
 LDA #0                 \ buffer 0, and increment the index
 STA (SC),Y
 INY

 BNE vpat7              \ If we just incremented Y back around to 0, then
 INC V+1                \ increment the high bytes of V(1 0), SC(1 0) and
 INC SC+1               \ SC2(1 0) to point to the next page in memory
 INC SC2+1

.vpat7

 INX                    \ Increment the pattern counter in X

 JMP vpat6              \ Loop back to copy more patterns, if required

.vpat8

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ Finally, we reset the next six patterns (i.e. the ones
                        \ from firstFreePattern onwards), so we need to zero 48
                        \ bytes, as there are eight bytes in each pattern
                        \
                        \ We keep using the index in Y, as it already points to
                        \ the correct place in the buffers

 LDA #0                 \ Set A = 0 so we can zero the pattern buffers

 LDX #48                \ Set X as a byte counter

.vpat9

 STA (SC2),Y            \ Zero the Y-th byte of both pattern buffers
 STA (SC),Y

 INY                    \ Increment the index counter

 BNE vpat10             \ If we just incremented Y back around to 0, then
 INC SC2+1              \ increment the high bytes of SC(1 0) and SC2(1 0)
 INC SC+1               \ to point to the next page in memory

.vpat10

 DEX                    \ Decrement the byte counter

 BNE vpat9              \ Loop back until we have zeroed all 48 bytes

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS                    \ Return from the subroutine

