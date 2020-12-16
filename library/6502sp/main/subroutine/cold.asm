\ ******************************************************************************
\
\       Name: COLD
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy the recursive tokens and ship blueprints to their correct
\             locations
\
\ ******************************************************************************

.COLD

                        \ First we copy the 4 pages of recursive tokens from F%
                        \ to QQ18

 LDA #LO(F%)            \ Set V(1 0) = F%
 STA V
 LDA #HI(F%)
 STA V+1

 LDA #LO(QQ18)          \ Set SC(1 0) = QQ18
 STA SC
 LDA #HI(QQ18)
 STA SC+1

 LDX #4                 \ Set X = 4 to act as a counter for copying 4 pages

 JSR mvblock            \ Call mvblock to copy the recursive tokens

                        \ And then we copy the &22 pages of ship blueprints from
                        \ F% + &0400 to D%

 LDA #LO(F%)            \ Set V(1 0) = F% + &0400
 STA V
 LDA #HI(F%)+4
 STA V+1

 LDA #LO(D%)            \ Set SC(1 0) = D%
 STA SC
 LDA #HI(D%)
 STA SC+1

 LDX #&22               \ Set X = &22 to act as a counter for copying &22 pages

                        \ Fall through into mvblock to copy the ship blueprints

.mvblock

 LDY #0                 \ Set Y = 0 to count through the bytes in each page

.mvbllop

 LDA (V),Y              \ Copy the Y-th byte of V(1 0) to the Y-th byte of
 STA (SC),Y             \ SC(1 0)

 INY                    \ Increment the byte counter to point to the next byte

 BNE mvbllop            \ Loop back to mvbllop until we have copied a whole page

 INC V+1                \ Increment the high byte of V(1 0) to point to the next
                        \ page to copy from

 INC SC+1               \ Increment the high byte of SC(1 0) to point to the
                        \ next page to copy into

 DEX                    \ Decrement the page counter in X

 BNE mvbllop            \ Loop back to copy the next page until we have copied
                        \ all of them

 RTS                    \ Return from the subroutine

