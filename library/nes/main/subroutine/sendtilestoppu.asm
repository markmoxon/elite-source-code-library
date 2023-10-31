\ ******************************************************************************
\
\       Name: SendTilesToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Set up the variables needed to send the tile nametable and pattern
\             data to the PPU, and then send them
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The current value of nmiBitplane
\
\ ******************************************************************************

.SendTilesToPPU

 TXA                    \ Set nmiBitplane8 = X << 3
 ASL A                  \                  = nmiBitplane * 8
 ASL A                  \
 ASL A                  \ So nmiBitplane has the following values:
 STA nmiBitplane8       \
                        \   * 0 when nmiBitplane is 0
                        \
                        \   * 8 when nmiBitplane is 1

 LSR A                  \ Set A = nmiBitplane << 2
                        \
                        \ So A has the following values:
                        \
                        \   * 0 when nmiBitplane is 0
                        \
                        \   * 4 when nmiBitplane is 1

 ORA #HI(PPU_NAME_0)    \ Set the high byte of ppuNametableAddr(1 0) to
 STA ppuNametableAddr+1 \ HI(PPU_NAME_0) + A, which will be:
                        \
                        \   * HI(PPU_NAME_0)         when nmiBitplane is 0
                        \
                        \   * HI(PPU_NAME_0) + &04   when nmiBitplane is 1

 LDA #HI(PPU_PATT_1)    \ Set ppuPatternTableHi to point to the high byte of
 STA ppuPatternTableHi  \ pattern table 1 in the PPU

 LDA #0                 \ Zero the low byte of ppuNametableAddr(1 0), so we end
 STA ppuNametableAddr   \ up with ppuNametableAddr(1 0) set to:
                        \
                        \   * PPU_NAME_0 (&2000)     when nmiBitplane = 0
                        \
                        \   * PPU_NAME_1 (&2400)     when nmiBitplane = 1
                        \
                        \ So ppuNametableAddr(1 0) points to the correct PPU
                        \ nametable address for this bitplane

 LDA firstNametableTile \ Set sendingNameTile for this bitplane to the value of
 STA sendingNameTile,X  \ firstNametableTile, which contains the number of the
                        \ first tile to send to the PPU nametable

 STA clearingNameTile,X \ Set clearingNameTile for this bitplane to the same
                        \ value, so we start to clear tiles from the same point
                        \ once they have been sent to the PPU nametable

 LDA firstPattern       \ Set sendingPattern for this bitplane to the value of
 STA sendingPattern,X   \ firstPattern, which contains the number of the first
                        \ pattern to send to the PPU pattern table

 STA clearingPattern,X  \ Set clearingPattern for this bitplane to the same
                        \ value, so we start to clear patterns from the same
                        \ point once they have been sent to the PPU pattern
                        \ table

 LDA bitplaneFlags,X    \ Set bit 4 in the bitplane flags to indicate that we
 ORA #%00010000         \ are now sending tile data to the PPU in the NMI
 STA bitplaneFlags,X    \ handler (so we can detect this in the next VBlank if
                        \ we have to split the process across multiple VBlanks)

 LDA #0                 \ Set (addr A) to sendingPattern for this bitplane,
 STA addr               \ which we just set to the number of the first pattern
 LDA sendingPattern,X   \ to send to the PPU pattern table

 ASL A                  \ Set (addr A) = (pattBufferHiAddr 0) + (addr A) * 8
 ROL addr               \              = pattBufferX + sendingPattern * 8
 ASL A                  \
 ROL addr               \ Starting with the low bytes
 ASL A                  \
                        \ In the above, pattBufferX is either pattBuffer0 or
                        \ pattBuffer1, depending on the bitplane in X, as these
                        \ are the values stored in the pattBufferHiAddr variable

 STA patternBufferLo,X  \ Store the low byte in patternBufferLo for this
                        \ bitplane

 LDA addr               \ We now add the high bytes, storing the result in
 ROL A                  \ patternBufferHi for this bitplane
 ADC pattBufferHiAddr,X \
 STA patternBufferHi,X  \ So we now have the following for this bitplane:
                        \
                        \   (patternBufferHi patternBufferLo) =
                        \                      pattBufferX + sendingPattern * 8
                        \
                        \ which points to the data for pattern sendingPattern in
                        \ the pattern buffer for bitplane X

 LDA #0                 \ Set (addr A) to sendingNameTile for this bitplane,
 STA addr               \ which we just set to the number of the first tile to
 LDA sendingNameTile,X  \ send to the PPU nametable

 ASL A                  \ Set (addr A) = (nameBufferHiAddr 0) + (addr A) * 8
 ROL addr               \              = nameBufferX + sendingNameTile * 8
 ASL A                  \
 ROL addr               \ Starting with the low bytes
 ASL A                  \
                        \ In the above, nameBufferX is either nameBuffer0 or
                        \ nameBuffer1, depending on the bitplane in X, as these
                        \ are the values stored in the nameBufferHiAddr variable

 STA nameTileBuffLo,X   \ Store the low byte in nameTileBuffLo for this bitplane

 ROL addr               \ We now add the high bytes, storing the result in
 LDA addr               \ nameTileBuffHi for this bitplane
 ADC nameBufferHiAddr,X \
 STA nameTileBuffHi,X   \ So we now have the following for this bitplane:
                        \
                        \   (nameTileBuffHi nameTileBuffLo) =
                        \                      nameBufferX + sendingNameTile * 8
                        \
                        \ which points to the data for tile sendingNameTile in
                        \ the nametable buffer for bitplane X

 LDA ppuNametableAddr+1 \ Set the high byte of the following calculation:
 SEC                    \
 SBC nameBufferHiAddr,X \   (ppuToBuffNameHi 0) = (ppuNametableAddr+1 0)
 STA ppuToBuffNameHi,X  \                          - (nameBufferHiAddr 0)
                        \
                        \ So ppuToBuffNameHi for this bitplane contains a high
                        \ byte that we can add to a nametable buffer address to
                        \ get the corresponding address in the PPU nametable

 JMP SendPatternsToPPU  \ Now that we have set up all the variables needed, we
                        \ can jump to SendPatternsToPPU to move on to the next
                        \ stage of sending patterns to the PPU

