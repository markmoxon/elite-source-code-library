\ ******************************************************************************
\
\       Name: HideIconBar
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Remove the icon bar from the screen by replacing it with
\             background tiles
\
\ ******************************************************************************

.HideIconBar

 LDA #HI(nameBuffer0+27*32) \ Set SC(1 0) to the address of the first tile on
 STA SC+1                   \ tile row 27 in nametable buffer 0
 LDA #LO(nameBuffer0+27*32)
 STA SC

 LDA #HI(nameBuffer1+27*32) \ Set SC2(1 0) to the address of the first tile on
 STA SC2+1                  \ tile row 27 in nametable buffer 1
 LDA #LO(nameBuffer1+27*32)
 STA SC2

 LDY #63                \ Set Y as an index, which will count down from 63 to 1,
                        \ so we blank tile 1 to 63 of the icon bar in the
                        \ following loop

 LDA #0                 \ Set A = 0 to store in the nametable buffers, as tile 0
                        \ is the empty background tile

.hbar1

 STA (SC),Y             \ Set the Y-th nametable entry for the icon bar to the
 STA (SC2),Y            \ empty tile in A

 DEY                    \ Decrement the index counter

 BNE hbar1              \ Loop back until we have replaced all 63 tiles with the
                        \ background tile

 LDA #32                \ Set A = 32 as the tile pattern number to show at the
                        \ start of row 27 (though I don't know why we do this,
                        \ as pattern 32 is part of the icon bar pattern, so this
                        \ seems a bit strange)

 LDY #0                 \ Set the first nametable entry on tile row 27 to A
 STA (SC),Y
 STA (SC2),Y

 RTS                    \ Return from the subroutine

