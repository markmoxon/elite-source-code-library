\ ******************************************************************************
\
\       Name: SetupViewInNMI
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Setup the view and configure the NMI to send both bitplanes to the
\             PPU during VBlank
\
\ ------------------------------------------------------------------------------
\
\ This routine is only ever called with the following bitplane flags in A:
\
\   * Bit 2 clear = send tiles up to configured numbers
\   * Bit 3 clear = don't clear buffers after sending
\   * Bit 4 clear = we've not started sending data yet
\   * Bit 5 clear = we have not yet sent all the data
\   * Bit 6 set   = send both pattern and nametable data
\   * Bit 7 set   = send data to the PPU
\
\ Bits 0 and 1 are ignored and are always clear.
\
\ This routine therefore configures the NMI to send both bitplanes to the PPU.
\
\ Arguments:
\
\   A                   The bitplane flags to set for the drawing bitplane
\
\ ******************************************************************************

.SetupViewInNMI

 PHA                    \ Store the bitplane flags on the stack so we can
                        \ retrieve them later

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA QQ11               \ If the view type in QQ11 is not &96 (Data on System),
 CMP #&96               \ jump to svin1 to keep checking for view types
 BNE svin1

                        \ If we get here then this is the Data on System screen

 JSR GetSystemBack_b5   \ Fetch the background image for the current system and
                        \ store it in the pattern buffers

 JMP svin2              \ Jump to svin2 to continue setting up the view

.svin1

 CMP #&98               \ If the view type in QQ11 is not &98 (Status Mode),
 BNE svin2              \ jump to svin2 to keep checking for view types

                        \ If we get here then this is the Status Mode screen

 JSR GetHeadshot_b4     \ Fetch the headshot image for the commander and store
                        \ it in the pattern buffers, starting at pattern number
                        \ picturePattern

.svin2

 LDA QQ11               \ If bit 6 of the view type is clear, then there is an
 AND #%01000000         \ icon bar, so jump to svin3 to skip the following
 BEQ svin3              \ instruction

 LDA #0                 \ There is no icon bar, so set showUserInterface to 0 to
 STA showUserInterface  \ indicate that there is no user interface

.svin3

 JSR SetupSprite0       \ Set the coordinates of sprite 0 so we can detect when
                        \ the PPU starts to draw the icon bar

 LDA #0                 \ Tell the NMI handler to send nametable entries from
 STA firstNameTile      \ tile 0 onwards

 LDA #37                \ Tell the NMI handler to send pattern entries from
 STA firstPattern       \ pattern 37 in the buffer

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries up to the
 STA lastPattern        \ first free pattern, for both bitplanes
 STA lastPattern+1

 LDA #%01010100         \ This instruction has no effect as we are about to pull
                        \ the value of A from the stack

 LDX #0                 \ This instruction has no effect as the call to
                        \ SetDrawPlaneFlags overwrites X with the value of the
                        \ drawing bitplane, though this could be remnants of
                        \ code to set the drawing bitplane to 0, as the
                        \ following code depends on this being the case

 PLA                    \ Retrieve the bitplane flags that were passed to this
                        \ routine and which we stored on the stack above

 JSR SetDrawPlaneFlags  \ Set the bitplane flags to A for the current drawing
                        \ bitplane, which must be bitplane 0 at this point
                        \ (though it is not entirely obvious why this is the
                        \ case)

 INC drawingBitplane    \ Increment drawingBitplane to 1

 JSR SetDrawPlaneFlags  \ Set the bitplane flags to A for bitplane 1

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA #80                \ Tell the PPU to send nametable entries up to tile
 STA lastNameTile       \ 80 * 8 = 640 (i.e. to the end of tile row 19) in both
 STA lastNameTile+1     \ bitplanes

 LDA QQ11               \ Set the old view type in QQ11a to the new view type
 STA QQ11a              \ in QQ11, to denote that we have now changed view to
                        \ the view in QQ11

 LDA firstFreePattern   \ Set clearingPattern for both bitplanes to the number
 STA clearingPattern    \ of the first free pattern, so the NMI handler only
 STA clearingPattern+1  \ clears patterns from this point onwards
                        \
                        \ This ensures that the tiles that have already been
                        \ sent to the PPU above don't get cleared out by the NMI
                        \ handler

 LDA #0                 \ Set A = 0, though this has no effect as we don't use
                        \ it

 LDX #0                 \ Hide bitplane 0, so:
 STX hiddenBitplane     \
                        \   * Colour %01 (1) is the hidden colour (black)
                        \   * Colour %10 (2) is the visible colour (cyan)

 STX nmiBitplane        \ Set nmiBitplane = 0 so bitplane 0 is the first to be
                        \ sent in the NMI handler

 JSR SetDrawingBitplane \ Set the drawing bitplane to bitplane 0

 LDA QQ11               \ If bit 6 of the view type is set, then there is no
 AND #%01000000         \ icon bar, so jump to svin4 to skip the following
 BNE svin4              \ instructions

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDA #%10000000         \ Set bit 7 of showUserInterface to denote that there is
 STA showUserInterface  \ a user interface

.svin4

 LDA screenFadedToBlack \ If bit 7 of screenFadedToBlack is clear then the
 BPL svin5              \ screen is visible and has not been faded to black, so
                        \ jump to svin5 to update the screen without fading it

 JMP FadeToColour_b3    \ Reverse-fade the screen from black to full colour over
                        \ the next four VBlanks, returning from the subroutine
                        \ using a tail call

.svin5

 LDA QQ11               \ Set X to the new view type in the low nibble of QQ11
 AND #%00001111
 TAX

 LDA paletteForView,X   \ Set A to the palette number used by the view from the
 CMP screenReset        \ paletteForView table, compare it to screenReset, set
 STA screenReset        \ the processor flags accordingly, and store the palette
                        \ number in screenReset
                        \
                        \ This has no effect, as screenReset is not read
                        \ anywhere and neither the value of A nor the processor
                        \ flags are used in the following

 JSR GetViewPalettes    \ Get the palette for the view type in QQ11a and store
                        \ it in a table at XX3

 DEC updatePaletteInNMI \ Decrement updatePaletteInNMI to a non-zero value so we
                        \ do send palette data from XX3 to the PPU during NMI,
                        \ which will ensure the screen updates with the colours
                        \ as we fade to black

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank) so we know the palette data has been sent
                        \ to the PPU

 INC updatePaletteInNMI \ Increment updatePaletteInNMI back to the value it had
                        \ before we decremented it above

 RTS                    \ Return from the subroutine

