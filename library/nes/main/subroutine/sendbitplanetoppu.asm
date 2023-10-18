\ ******************************************************************************
\
\       Name: SendBitplaneToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send a bitplane to the PPU immediately
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the bitplane to configure to be sent to
\                       the PPU in the NMI handler
\
\ ******************************************************************************

.SendBitplaneToPPU

 STX drawingBitplane    \ Set the drawing bitplane and the NMI bitplane to the
 STX nmiBitplane        \ argument in X, so all the following operations apply
                        \ to the specified bitplane

 STX hiddenBitplane     \ Hide bitplane X so it isn't visible on-screen while
                        \ we do the following

 LDA #0                 \ Tell the NMI handler to send nametable entries from
 STA firstNametableTile \ tile 0 onwards

 LDA QQ11               \ If the view type in QQ11 is not &DF (Start screen with
 CMP #&DF               \ the normal font loaded), then jump to sbit1 to skip
 BNE sbit1              \ the following and start sending pattern data from
                        \ pattern 37 onwards

 LDA #4                 \ This is the Start screen with font loaded in bitplane
 BNE sbit2              \ 0, so set A = 4 so we start sending pattern data
                        \ from pattern 4 onwards

.sbit1

 LDA #37                \ So set A = 37 so we start sending pattern data from
                        \ pattern 37 onwards

.sbit2

 STA firstPatternTile   \ Tell the NMI handler to send pattern entries from
                        \ pattern A in the buffer

 LDA firstFreeTile      \ Tell the NMI handler to send pattern entries up to the
 STA lastPatternTile,X  \ first free tile, for the drawing bitplane in X

 LDA #%11000100         \ Set the bitplane flags for the drawing bitplane to the
 JSR SetDrawPlaneFlags  \ following:
                        \
                        \   * Bit 2 set   = send tiles up to end of the buffer
                        \   * Bit 3 clear = don't clear buffers after sending
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 set   = send both pattern and nametable data
                        \   * Bit 7 set   = send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear
                        \
                        \ This configures the NMI to send nametable and pattern
                        \ data for the drawing bitplane to the PPU during VBlank

 JSR SendDataNowToPPU   \ Send the drawing bitplane buffers to the PPU
                        \ immediately, without trying to squeeze it into VBlanks

 LDA firstFreeTile      \ Set clearingPattTile for the drawing bitplane to the
 STA clearingPattTile,X \ number of the first free tile, so the NMI handler only
                        \ clears tiles from this point onwards
                        \
                        \ This ensures that the tiles that we just sent to the
                        \ PPU don't get cleared out by the NMI handler

 RTS                    \ Return from the subroutine

