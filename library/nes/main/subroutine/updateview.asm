\ ******************************************************************************
\
\       Name: UpdateView
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Update the view
\
\ ******************************************************************************

.UpdateView

 LDA firstFreePattern   \ If firstFreePattern = 0, set firstFreePattern = 255
 BNE upvw1              \
 LDA #255               \ This ensures that the call to CopyNameBuffer0To1 below
 STA firstFreePattern   \ tells the NMI handler to send pattern entries up to
                        \ the first free pattern, or to send patterns up to the
                        \ very end if we have run out of free patterns (in which
                        \ case firstFreePattern was zero)

.upvw1

 LDA #0                 \ Tell the NMI handler to send nametable entries from
 STA firstNameTile      \ tile 0 onwards

 LDA #108               \ Tell the NMI handler to only clear nametable entries
 STA maxNameTileToClear \ up to tile 108 * 8 = 864 (i.e. up to the end of tile
                        \ row 26)

 STA lastNameTile       \ Tell the PPU to send nametable entries up to tile
 STA lastNameTile+1     \ 108 * 8 = 864 (i.e. to the end of tile row 26) in both
                        \ bitplanes

 LDX #37                \ Set X = 37 to use as the first pattern for when there
                        \ is an icon bar

 LDA QQ11               \ If bit 6 of the view type is clear, then there is an
 AND #%01000000         \ icon bar, so jump to upvw2 to skip the following
 BEQ upvw2              \ instruction

 LDX #4                 \ Set X = 4 to use as the first pattern for when there
                        \ is no icon bar

.upvw2

 STX firstPattern       \ Tell the NMI handler to send pattern entries from
                        \ pattern X in the buffer (i.e. from pattern 4 if there
                        \ is no icon bar, or from pattern 37 if there is an
                        \ icon bar)

 JSR DrawBoxEdges       \ Draw the left and right edges of the box along the
                        \ sides of the screen, drawing into the nametable buffer
                        \ for the drawing bitplane

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer

 LDA QQ11               \ If the new view in QQ11 is the same as the old view in
 CMP QQ11a              \ QQ11a, then jump to upvw6 to call UpdateScreen before
 BEQ upvw6              \ jumping back to upvw3 (which will either call
                        \ SendViewToPPU to update the view straight away, if
                        \ it's been faded to black, otherwise it will call
                        \ SetupFullViewInNMI to update the view in VBlank, to
                        \ prevent screen corruption)

 JSR SendViewToPPU_b3   \ Otherwise the view is changing, so it has already been
                        \ faded out and we can call SendViewToPPU to update the
                        \ view straight away without caring about screen
                        \ corruption

.upvw3

 LDX #&FF               \ Set X = &FF to use as the value of showIconBarPointer
                        \ below (i.e. show the icon bar pointer)

 LDA QQ11               \ If the view type in QQ11 is &95 (Trumble mission
 CMP #&95               \ briefing), jump to upvw4 to set showIconBarPointer to
 BEQ upvw4              \ 0 (i.e. hide the icon bar pointer)

 CMP #&DF               \ If the view type in QQ11 is &DF (Start screen with
 BEQ upvw4              \ the normal font loaded), jump to upvw4 to set
                        \ showIconBarPointer to 0 (i.e. hide the icon bar
                        \ pointer)

 CMP #&92               \ If the view type in QQ11 is &92 (Mission 1 rotating
 BEQ upvw4              \ ship briefing), jump to upvw4 to set
                        \ showIconBarPointer to 0 (i.e. hide the icon bar
                        \ pointer)

 CMP #&93               \ If the view type in QQ11 is &93 (Mission 1 text
 BEQ upvw4              \ briefing), jump to upvw4 to set showIconBarPointer
                        \ to 0 (i.e. hide the icon bar pointer)

 ASL A                  \ If bit 6 of the view type in QQ11 is clear, then there
 BPL upvw5              \ is an icon bar, so jump to upvw5 to set
                        \ showIconBarPointer to &FF (i.e. show the icon bar
                        \ pointer)

.upvw4

 LDX #0                 \ Set X = 0 to use as the value of showIconBarPointer
                        \ below (i.e. hide the icon bar pointer)

.upvw5

 STX showIconBarPointer \ Set showIconBarPointer to X, so we set it as follows:
                        \
                        \   * 0 if the view is a mission briefing, or the Start
                        \     screen with the normal font loaded, or has no
                        \     icon bar (in which case we hide the icon bar
                        \     pointer)
                        \
                        \   * &FF otherwise (in which case we show the icon bar
                        \     pointer)

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries from the
 STA firstPattern       \ first free pattern onwards, so we don't waste time
                        \ resending the static patterns we have already sent

 RTS                    \ Return from the subroutine

.upvw6

 JSR UpdateScreen       \ Update the screen by sending data to the PPU, either
                        \ immediately or during VBlank, depending on whether
                        \ the screen is visible

 JMP upvw3              \ Jump back to upvw3 to continue updating the view

