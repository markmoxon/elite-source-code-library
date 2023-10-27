\ ******************************************************************************
\
\       Name: SVE
\       Type: Subroutine
\   Category: Save and load
\    Summary: Display the Save and Load screen and process saving and loading of
\             commander files
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.SVE

 LDA #&BB               \ Clear the screen and set the view type in QQ11 to &BB
 JSR TT66_b0            \ (Save and load with the normal and highlight fonts
                        \ loaded)

 LDA #&8B               \ Set the view type in QQ11 to &8B (Save and load with
 STA QQ11               \ no fonts loaded)

 LDY #0                 \ Clear bit 7 of autoPlayDemo so we do not play the demo
 STY autoPlayDemo       \ automatically while the save screen is active

 STY QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

 STY YC                 \ Move the text cursor to row 0

 LDX languageIndex      \ Move the text cursor to the correct column for the
 LDA xSaveHeader,X      \ Stored Commanders title in the chosen language
 STA XC

 LDA saveHeader1Lo,X    \ Set V(1 0) to the address of the correct Stored
 STA V                  \ Commanders title for the chosen language
 LDA saveHeader1Hi,X
 STA V+1

 JSR PrintSaveHeader    \ Print the null-terminated string at V(1 0), which
                        \ prints the Stored Commanders title for the chosen
                        \ language at the top of the screen

 LDA #&BB               \ Set the view type in QQ11 to &BB (Save and load with
 STA QQ11               \ the normal and highlight fonts loaded)

 LDX languageIndex      \ Set V(1 0) to the address of the correct subheaders
 LDA saveHeader2Lo,X    \ for the Save and Load screen in the chosen language
 STA V                  \ (e.g. the "STORED POSITIONS" and "CURRENT POSITION"
 LDA saveHeader2Hi,X    \ subheaders in English)
 STA V+1

 JSR PrintSaveHeader    \ Print the null-terminated string at V(1 0), which
                        \ prints the subheaders

 JSR NLIN4              \ Draw a horizontal line on tile row 2 to box in the
                        \ title

 JSR SetScreenForUpdate \ Get the screen ready for updating by hiding all
                        \ sprites, after fading the screen to black if we are
                        \ changing view

                        \ We now draw the tall bracket image that sits between
                        \ the current and stored positions

 LDY #5*4               \ We are going to draw the bracket using sprites 5 to
                        \ 19, so set Y to the offset of sprite 5 in the sprite
                        \ buffer, where each sprite takes up four bytes

 LDA #57+YPAL           \ The top tile in the bracket is at y-coordinate 57, so
 STA T                  \ store this in T so we can use it as the y-coordinate
                        \ for each sprite as we draw the bracket downwards

 LDX #0                 \ The tile numbers are in the saveBracketPatts table, so
                        \ set X as an index to work our way through the table

.save1

 LDA #%00100010         \ Set the attributes for sprite Y / 4 as follows:
 STA attrSprite0,Y      \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA saveBracketPatts,X \ Set A to the X-th entry in the saveBracketPatts table

 BEQ save2              \ If A = 0 then we have reached the end of the tile
                        \ list, so jump to save2 to move on to the next stage

 STA pattSprite0,Y      \ Otherwise we have the next tile number, so set the
                        \ pattern number for sprite Y / 4 to A

 LDA #83                \ Set the x-coordinate for sprite Y / 4 to 83
 STA xSprite0,Y

 LDA T                  \ Set the x-coordinate for sprite Y / 4 to T
 STA ySprite0,Y

 CLC                    \ Set T = T + 8 so it points to the next row down (as
 ADC #8                 \ each row is eight pixels high)
 STA T

 INY                    \ Set Y = Y + 4 so it points to the next sprite in the
 INY                    \ sprite buffer (as each sprite takes up four bytes in
 INY                    \ the buffer)
 INY

 INX                    \ Increment the table index in X to point to the next
                        \ entry in the saveBracketPatts table

 JMP save1              \ Jump back to save1 to draw the next bracket tile

.save2

 STY CNT                \ Set CNT to the offset in the sprite buffer of the
                        \ next free sprite (i.e. the sprite after the last
                        \ sprite in the bracket) so we can pass it to
                        \ DrawSaveSlotMark below

                        \ We now draw dashes to the left of each of the save
                        \ slots on the right side of the screen

 LDY #7                 \ We are going to draw eight slot marks, so set a
                        \ counter in Y

.save3

 TYA                    \ Move the text cursor to row 6 + Y * 2
 ASL A                  \
 CLC                    \ So the slot marks are printed on even rows from row 6
 ADC #6                 \ to row 20 (though we print them from bottom to top)
 STA YC

 LDX #20                \ Move the text cursor to column 20, so we print the
 STX XC                 \ slot mark in column 20

 JSR DrawSaveSlotMark   \ Draw the slot mark for save slot Y

 DEY                    \ Decrement the counter in Y

 BPL save3              \ Loop back until we have printed all eight slot marks

 JSR DrawSmallLogo_b4   \ Set the sprite buffer entries for the small Elite logo
                        \ in the top-left corner of the screen

                        \ We now work through the save slots and print their
                        \ names

 LDA #0                 \ Set A = 0 to use as the save slot number in the
                        \ following loop (the loop runs from A = 0 to 8, but we
                        \ only print the name for A = 0 to 7, and do nothing for
                        \ A = 8)

.save4

 CMP #8                 \ If A = 8, jump to save5 to skip the following
 BEQ save5              \ instruction

 JSR PrintSaveName      \ Print the name of the commander file saved in slot A

.save5

 CLC                    \ Set A = A + 1 to move on to the next save slot
 ADC #1

 CMP #9                 \ Loop back to save4 until we have processed all nine
 BCC save4              \ slots, leaving A = 9

 JSR HighlightSaveName  \ Print the name of the commander file saved in slot 9
                        \ as a highlighted name, so this prints the current
                        \ commander name on the left of the screen, under the
                        \ "CURRENT POSITION" header, in the highlight font

 JSR UpdateView_b0      \ Update the view to draw all the sprites and tiles
                        \ on-screen

 LDA #9                 \ Set A = 9, which is the slot number we use for the
                        \ current commander name on the left of the screen, so
                        \ this sets the initial position of the highlighted name
                        \ to the current commander name on the left

                        \ Fall through into MoveInLeftColumn to start iterating
                        \ around the main loop for the Save and Load screen

