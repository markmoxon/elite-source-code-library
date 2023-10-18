\ ******************************************************************************
\
\       Name: DrawCobraMkIII
\       Type: Subroutine
\   Category: Equipment
\    Summary: Draw the Cobra Mk III on the Equip Ship screen
\
\ ******************************************************************************

.DrawCobraMkIII

 LDA #20                \ Set XC and YC so the call to DrawImageNames draws the
 STA YC                 \ Cobra Mk III at text column 2 on row 20
 LDA #2
 STA XC

 LDA #26                \ Set K = 26 so the call to DrawImageNames draws 26
 STA K                  \ tiles in each row

 LDA #5                 \ Set K+1 = 5 so the call to DrawImageNames draws 5 rows
 STA K+1                \ of tiles

 LDA #HI(cobraNames)    \ Set V(1 0) = cobraNames, so the call to DrawImageNames
 STA V+1                \ draws the Cobra Mk III
 LDA #LO(cobraNames)
 STA V

 LDA #0                 \ Set K+2 = 0, so the call to DrawImageNames copies the
 STA K+2                \ entries directly from cobraNames to the nametable
                        \ buffer without adding an offset

 JSR DrawImageNames_b4  \ Draw the Cobra Mk III at text column 2 on row 20

 JMP DrawEquipment_b6   \ Draw the currently fitted equipment onto the Cobra Mk
                        \ III image, returning from the subroutine using a tail
                        \ call

