\ ******************************************************************************
\
\       Name: SendViewToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Configure the PPU for the view type in QQ11
\  Deep dive: Views and view types in NES Elite
\
\ ******************************************************************************

.SendViewToPPU

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDA ppuCtrlCopy        \ Store the value of ppuCtrlCopy on the stack so we can
 PHA                    \ restore it at the end of the subroutine

 LDA #%00000000         \ Set A to use as the new value for PPU_CTRL below

 STA ppuCtrlCopy        \ Store the new value of PPU_CTRL in ppuCtrlCopy so we
                        \ can check its value without having to access the PPU

 STA PPU_CTRL           \ Configure the PPU by setting PPU_CTRL as follows:
                        \
                        \   * Bits 0-1    = base nametable address %00 (&2000)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 clear = background pattern table is at &0000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 clear = disable VBlank NMI generation

 STA setupPPUForIconBar \ Clear bit 7 of setupPPUForIconBar so we do nothing
                        \ when the PPU starts drawing the icon bar

 LDA #%00000000         \ Configure the PPU by setting PPU_MASK as follows:
 STA PPU_MASK           \
                        \   * Bit 0 clear = normal colour (not monochrome)
                        \   * Bit 1 clear = hide leftmost 8 pixels of background
                        \   * Bit 2 clear = hide sprites in leftmost 8 pixels
                        \   * Bit 3 clear = hide background
                        \   * Bit 4 clear = hide sprites
                        \   * Bit 5 clear = do not intensify greens
                        \   * Bit 6 clear = do not intensify blues
                        \   * Bit 7 clear = do not intensify reds

 LDA QQ11               \ If the view type in QQ11 is not &B9 (Equip Ship),
 CMP #&B9               \ jump to svip1 to keep checking for view types
 BNE svip1

 JMP svip7              \ Jump to svip7 to set up the Equip Ship screen

.svip1

 CMP #&9D               \ If the view type in QQ11 is &9D (Long-range Chart with
 BEQ svip6              \ the normal font loaded), jump to svip6

 CMP #&DF               \ If the view type in QQ11 is &DF (Start screen with the
 BEQ svip6              \ normal font loaded), jump to svip6

 CMP #&96               \ If the view type in QQ11 is not &96 (Data on System),
 BNE svip2              \ jump to svip2 to keep checking for view types

                        \ If we get here then this is the Data on System screen

 JSR GetSystemImage_b5  \ This is the Data on System view, so fetch the
                        \ background image and foreground sprite for the current
                        \ system image and send them to the pattern buffers and
                        \ PPU

 JMP svip10             \ Jump to svip10 to finish off setting up the view

.svip2

 CMP #&98               \ If the view type in QQ11 is not &98 (Status Mode),
 BNE svip3              \ jump to svip3 to keep checking for view types

                        \ If we get here then this is the Status Mode screen

 JSR GetCmdrImage_b4    \ This is the Status Mode view, so fetch the headshot
                        \ image for the commander and store it in the pattern
                        \ buffers, and send the face and glasses images to the
                        \ PPU

 JMP svip10             \ Jump to svip10 to finish off setting up the view

.svip3

 CMP #&BA               \ If the view type in QQ11 is not &BA (Market Price),
 BNE svip4              \ jump to svip4 to keep checking for view types

                        \ If we get here then this is the Market Price screen

 LDA #HI(16*69)         \ Set PPU_ADDR to the address of pattern 69 in pattern
 STA PPU_ADDR           \ table 0, so we load the missile image here
 LDA #LO(16*69)
 STA PPU_ADDR

 LDA #HI(inventoryIcon) \ Set SC(1 0) = inventoryIcon so we send the inventory
 STA SC+1               \ icon bar image to the PPU
 LDA #LO(inventoryIcon)
 STA SC

 LDA #245               \ Set imageSentToPPU = 245 to denote that we have sent
 STA imageSentToPPU     \ the inventory icon image to the PPU

 LDX #4                 \ Set X = 4 so we send four batches of 16 bytes to the
                        \ PPU in the call to SendInventoryToPPU below

 JMP svip9              \ Jump to svip9 to send the missile image to the PPU and
                        \ finish off setting up the view

.svip4

 CMP #&BB               \ If the view type in QQ11 is not &BB (Save and load
 BNE svip5              \ with the normal and highlight fonts loaded), jump to
                        \ svip5 to keep checking for view types

                        \ If we get here then this is the Save and Load screen
                        \ with the normal and highlight fonts loaded

 LDA #HI(16*69)         \ Set PPU_ADDR to the address of pattern 69 in pattern
 STA PPU_ADDR           \ table 0, so we load the small logo image here
 LDA #LO(16*69)
 STA PPU_ADDR

 LDA #HI(smallLogoImage)    \ Set V(1 0) = smallLogoImage
 STA V+1                    \
 LDA #LO(smallLogoImage)    \ So we can unpack the image data for the small
 STA V                      \ Elite logo into pattern 69 onwards in pattern
                            \ table 0

 LDA #3                 \ Set A = 3 so we only unpack the image data below when
                        \ imageSentToPPU does not equal 3 (i.e. if we haven't
                        \ already sent the small logo image to the PPU)

 BNE svip8              \ Jump to svip8 to unpack the image data (this BNE is
                        \ effectively a JMP as A is never zero)

.svip5

                        \ If we get here then this not one of these views:
                        \
                        \   * Equip Ship
                        \   * Long-range Chart with the normal font loaded
                        \   * Start screen with the normal font loaded
                        \   * Data on System
                        \   * Status Mode
                        \   * Market Price
                        \   * Save and load with normal and highlight fonts
                        \     loaded
                        \
                        \ so now we load the dashboard image, if we haven't
                        \ already

 LDA #0                 \ Set A = 0 to set as the new value of imageSentToPPU
                        \ below

 CMP imageSentToPPU     \ If imageSentToPPU = 0 then we have already sent the
 BEQ svip10             \ dashboard image to the PPU, so jump to svip10 to
                        \ finish off setting up the view without sending the
                        \ dashboard image again

 STA imageSentToPPU     \ Set imageSentToPPU = 0 to denote that we have sent the
                        \ dashboard image to the PPU

 JSR SendDashImageToPPU \ Unpack the dashboard image and send it to patterns 69
                        \ to 255 in pattern table 0 in the PPU

 JMP svip10             \ Jump to svip10 to finish off setting up the view

.svip6

                        \ If we get here then QQ11 is &9D (Long-range Chart with
                        \ the normal font loaded) or &DF (Start screen with
                        \ the normal font loaded), so now we load the font
                        \ images, starting at pattern 68 in the PPU

 LDA #36                \ Set asciiToPattern = 36, so we add 36 to an ASCII code
 STA asciiToPattern     \ in the CHPR routine to get the pattern number in the
                        \ PPU of the corresponding character image (as we are
                        \ about to load the font at pattern 68, and the font
                        \ starts with a space character, which is ASCII 32, and
                        \ 32 + 36 = 68)

 LDA #1                 \ Set A = 1 to set as the new value of imageSentToPPU
                        \ below

 CMP imageSentToPPU     \ If imageSentToPPU = 1 then we have already sent the
 BEQ svip10             \ font image to the PPU, so jump to svip10 to finish off
                        \ setting up the view without sending the font image
                        \ again

 STA imageSentToPPU     \ Set imageSentToPPU = 1 to denote that we have sent the
                        \ font image to the PPU

 LDA #HI(16*68)         \ Set PPU_ADDR to the address of pattern 68 in pattern
 STA PPU_ADDR           \ table 0
 LDA #LO(16*68)
 STA PPU_ADDR

 LDX #95                \ Set X = 95 so the call to SendFontImageToPPU sends 95
                        \ font patterns to the PPU as a colour 1 font on a black
                        \ background (though the 95th character is full of
                        \ random junk, so it never gets used)

 LDA #HI(fontImage)     \ Set SC(1 0) = fontImage so we send the font image in
 STA SC+1               \ the call to SendFontImageToPPU
 LDA #LO(fontImage)
 STA SC

 JSR SendFontImageToPPU \ Send the 95 font patterns to the PPU as a colour 1
                        \ font on a black background

 LDA QQ11               \ If the view type in QQ11 is not &DF (Start screen with
 CMP #&DF               \ the normal font loaded), then jump to svip10 to
 BNE svip10             \ finish off setting up the view without loading the
                        \ logo ball image

 LDA #HI(16*227)        \ Set PPU_ADDR to the address of pattern 227 in pattern
 STA PPU_ADDR           \ table 0
 LDA #LO(16*227)
 STA PPU_ADDR

 LDA #HI(logoBallImage) \ Set V(1 0) = logoBallImage
 STA V+1                \
 LDA #LO(logoBallImage) \ So we can unpack the image data for the ball at the
 STA V                  \ bottom of the big Elite logo into pattern 227 onwards
                        \ in pattern table 0

 JSR UnpackToPPU        \ Unpack the image data to the PPU

 JMP svip10             \ Jump to svip10 to finish off setting up the view

.svip7

                        \ If we get here then this is the Equip Ship screen

 LDA #HI(16*69)         \ Set PPU_ADDR to the address of pattern 69 in pattern
 STA PPU_ADDR           \ table 0
 LDA #LO(16*69)
 STA PPU_ADDR

 LDA #HI(cobraImage)    \ Set V(1 0) = cobraImage
 STA V+1                \
 LDA #LO(cobraImage)    \ So we can unpack the image data for the Cobra Mk III
 STA V                  \ image into pattern 69 onwards in pattern table 0

 LDA #2                 \ Set A = 2 so we only unpack the image data when
                        \ imageSentToPPU does not equal 2, i.e. if we have not
                        \ already sent the Cobra image to the PPU

.svip8

                        \ If we get here then A determines which image we should
                        \ be loading (the Cobra Mk III image when A = 2, or the
                        \ small logo image when A = 3)

 CMP imageSentToPPU     \ If imageSentToPPU = A then we have already sent the
 BEQ svip10             \ image specified in A to the PPU

 STA imageSentToPPU     \ Set imageSentToPPU = A to denote that we have sent the
                        \ relevant image to the PPU

 JSR UnpackToPPU        \ Unpack the image data to the PPU

 JMP svip10             \ Jump to svip10 to finish off setting up the view

.svip9

 JSR SendInventoryToPPU \ Send X batches of 16 bytes from SC(1 0) to the PPU
                        \
                        \ We only get here with the following values:
                        \
                        \   SC(1 0) = inventoryIcon
                        \
                        \   X = 4
                        \
                        \ So this sends 16 * 4 = 64 bytes from inventoryIcon to
                        \ the PPU, which sends the inventory icon bar image

.svip10

                        \ We have finished setting up any view-specific images
                        \ and settings, so now we finish off with some settings
                        \ that apply to all views

 JSR SetupSprite0       \ Set the coordinates of sprite 0 so we can detect when
                        \ the PPU starts to draw the icon bar

                        \ We now send patterns 0 to 4 to the PPU, which contain
                        \ the box edges

 LDA #HI(PPU_PATT_1+16*0)   \ Set PPU_ADDR to the address of pattern 0 in
 STA PPU_ADDR               \ pattern table 1
 LDA #LO(PPU_PATT_1+16*0)
 STA PPU_ADDR

 LDY #0                 \ We are about to send a batch of bytes to the PPU, so
                        \ set an index counter in Y

 LDX #80                \ There are 80 bytes of pattern data in the five tile
                        \ patterns (5 * 16 bytes), so set a byte counter in X

.svip11

 LDA boxEdgeImages,Y    \ Send the Y-th byte from boxEdgeImages to the PPU
 STA PPU_DATA

 INY                    \ Increment the index counter in Y

 DEX                    \ Decrement the byte counter in X

 BNE svip11             \ Loop back until we have sent all 80 bytes to the PPU

                        \ We now zero pattern 255 in pattern table 1 so it is
                        \ a full block of background colour

 LDA #HI(PPU_PATT_1+16*255) \ Set PPU_ADDR to the address of pattern 255 in
 STA PPU_ADDR               \ pattern table 1
 LDA #LO(PPU_PATT_1+16*255)
 STA PPU_ADDR

 LDA #0                 \ We are going to zero the pattern, so set A = 0 to send
                        \ to the PPU

 LDX #16                \ There are 16 bytes in a pattern, so set a byte counter
                        \ in X

.svip12

 STA PPU_DATA           \ Send a zero to the PPU

 DEX                    \ Decrement the byte counter in X

 BNE svip12             \ Loop back until we have sent all 16 zeroes to the PPU

 JSR MakeSoundsAtVBlank \ Wait for the next VBlank and make the current sounds
                        \ (music and sound effects)

 LDX #0                 \ Configure bitplane 0 to be sent to the PPU in the NMI,
 JSR SendBitplaneToPPU  \ so the patterns and nametables will be sent to the PPU
                        \ during the next few VBlanks

 LDX #1                 \ Configure bitplane 1 to be sent to the PPU in the NMI
 JSR SendBitplaneToPPU  \ so the patterns and nametables will be sent to the PPU
                        \ during the next few VBlanks

 LDX #0                 \ Hide bitplane 0, so:
 STX hiddenBitplane     \
                        \   * Colour %01 (1) is the hidden colour (black)
                        \   * Colour %10 (2) is the visible colour (cyan)

 STX nmiBitplane        \ Set nmiBitplane = 0 so bitplane 0 is the first to be
                        \ sent in the NMI handler

 JSR SetDrawingBitplane \ Set the drawing bitplane to bitplane 0

 JSR MakeSoundsAtVBlank \ Wait for the next VBlank and make the current sounds
                        \ (music and sound effects)

 LDA QQ11               \ Set the old view type in QQ11a to the new view type in
 STA QQ11a              \ QQ11, to denote that we have now changed view to the
                        \ view in QQ11

 AND #%01000000         \ If bit 6 of the view type is clear, then there is an
 BEQ svip13             \ icon bar, so jump to svip13 to set showUserInterface
                        \ to denote there is a user interface

 LDA QQ11               \ If the view type in QQ11 is &DF (Start screen with
 CMP #&DF               \ the normal font loaded), jump to svip13 to set bit 7
 BEQ svip13             \ of showUserInterface so that the nametable and palette
                        \ table get set to 0 when sprite 0 is drawn, even though
                        \ there is no icon bar (this ensures that the part of
                        \ the Start screen below x-coordinate 166 is always
                        \ drawn using nametable 0, which covers the interface
                        \ part of the screen where the language gets chosen)

                        \ If we get here then there is no user interface and
                        \ and this is not the Start screen with the normal font
                        \ loaded

 LDA #0                 \ Clear bit 7 of A so we can set showUserInterface to
 BEQ svip14             \ denote that there is no user interface, and jump
                        \ to svip14 to set the value (this BEQ is effectively
                        \ a JMP as A is always zero)

.svip13

 LDA #%10000000         \ Set bit 7 of A so we can set showUserInterface to
                        \ denote that there is a user interface

.svip14

 STA showUserInterface  \ Set showUserInterface to the value of A that we just
                        \ set for the view

 PLA                    \ Restore the copy of ppuCtrlCopy that we put on the
 STA ppuCtrlCopy        \ stack so it's preserved across the call to the
                        \ subroutine

 STA PPU_CTRL           \ Set PPU_CTRL to the copy we made, so it's also
                        \ preserved across the call

 JMP FadeToColour_b3    \ Reverse-fade the screen from black to full colour over
                        \ the next four VBlanks, returning from the subroutine
                        \ using a tail call

