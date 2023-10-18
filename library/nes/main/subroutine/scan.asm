\ ******************************************************************************
\
\       Name: SCAN
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Display the current ship on the scanner
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ Arguments:
\
\   INWK                The ship's data block
\
\ ******************************************************************************

.scan1

                        \ If we jump here, Y is set to the offset of the first
                        \ sprite for this ship on the scanner, so the three
                        \ sprites are at addresses ySprite0 + Y, ySprite1 + Y
                        \ and ySprite2 + Y

 LDA #240               \ Hide sprites Y to Y+2 in the sprite buffer by setting
 STA ySprite0,Y         \ their y-coordinates to 240, which is off the bottom
 STA ySprite1,Y         \ of the screen
 STA ySprite2,Y         \
                        \ So this removes the ship's scanner sprites from the
                        \ scanner

.scan2

 RTS                    \ Return from the subroutine

.SCAN

 LDA QQ11               \ If this is not the space view (i.e. QQ11 is non-zero)
 BNE scan2              \ then jump to scan2 to return from the subroutine as
                        \ there is no scanner to update

 LDX TYPE               \ Fetch the ship's type from TYPE into X

 BMI scan2              \ If this is the planet or the sun, then the type will
                        \ have bit 7 set and we don't want to display it on the
                        \ scanner, so jump to scan2 to return from the
                        \ subroutine as there is nothing to draw

 LDA INWK+33            \ Set A to ship byte #33, which contains the number of
                        \ this ship on the scanner

 BEQ scan2              \ If A = 0 then this ship is not being shown on the
                        \ scanner, so jump to scan2 to return from the
                        \ subroutine as there is nothing to draw

 TAX                    \ Set X to the number of this ship on the scanner

 ASL A                  \ Set Y = (A * 2 + A) * 4 + 44
 ADC INWK+33            \       = 44 + A * 3 * 4
 ASL A                  \
 ASL A                  \ This gives us the offset of the first sprite for this
 ADC #44                \ ship on the scanner within the sprite buffer, as each
 TAY                    \ ship has three sprites allocated to it, and there are
                        \ four bytes per sprite in the buffer, and the first
                        \ scanner sprite is sprite 11 (which is at offset 44 in
                        \ the buffer)
                        \
                        \ We will refer to the sprites that we will use to draw
                        \ the ship on the scanner as sprites Y, Y+1 and Y+2,
                        \ just to keep things simple

 LDA scannerColour,X    \ Set A to the scanner colour for this ship, which was
                        \ set to a sprite palette number in the NWSHP routine
                        \ when the ship was added to the local bubble of
                        \ universe

 STA attrSprite0,Y      \ Set the attributes for sprite Y to the value in A,
                        \ so the sprite's attributes are:
                        \
                        \   * Bits 0-1    = sprite palette number in A
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically
                        \
                        \ This ensures that the ship appears on the scanner in
                        \ the correct colour for the ship type
                        \
                        \ We will copy these attributes for use in the other two
                        \ sprites later

                        \ The following algorithm is the same as the FAROF2
                        \ routine, which calculates the distance from our ship
                        \ to the point (x_hi, y_hi, z_hi) to see if the ship is
                        \ close enough to be visible on the scanner
                        \
                        \ Note that it actually calculates half the distance to
                        \ the point (i.e. 0.5 * |x y z|) as this will ensure the
                        \ result fits into one byte

 LDA INWK+1             \ If x_hi >= y_hi, jump to scan3 to skip the following
 CMP INWK+4             \ instruction, leaving A containing the higher of the
 BCS scan3              \ two values

 LDA INWK+4             \ Set A = y_hi, which is the higher of the two values,
                        \ so by this point we have:
                        \
                        \   A = max(x_hi, y_hi)

.scan3

 CMP INWK+7             \ If A >= z_hi, jump to scan4 to skip the following
 BCS scan4              \ instruction, leaving A containing the higher of the
                        \ two values

 LDA INWK+7             \ Set A = z_hi, which is the higher of the two values,
                        \ so by this point we have:
                        \
                        \   A = max(x_hi, y_hi, z_hi)

.scan4

 CMP #64                \ If A >= 64 then at least one of x_hi, y_hi and z_hi is
 BCS scan1              \ greater or equal to 64, so jump to scan1 to hide the
                        \ ship's scanner sprites and return from the subroutine,
                        \ as the ship is too far away to appear on the scanner

 STA SC2                \ Otherwise set SC2 = max(x_hi, y_hi, z_hi)
                        \
                        \ Let's call this max(x, y, z)

 LDA INWK+1             \ Set A = x_hi + y_hi + z_hi
 ADC INWK+4             \
 ADC INWK+7             \ Let's call this x + y + z
                        \
                        \ There is a risk that the addition will overflow here,
                        \ but presumably this isn't an issue

 BCS scan1              \ If the addition overflowed then A > 255, so jump to
                        \ scan1 to hide the ship's scanner sprites and return
                        \ from the subroutine, as the ship is too far away to
                        \ appear on the scanner

 SEC                    \ Set SC2+1 = A - SC2 / 4
 SBC SC2                \         = (x + y + z - max(x, y, z)) / 4
 LSR A
 LSR A
 STA SC2+1

 LSR A                  \ Set A = (SC2+1 / 4) + SC2+1 + SC2
 LSR A                  \       = 5/4 * SC2+1 + SC2
 ADC SC2+1              \       = 5 * (x + y + z - max(x, y, z)) / (8 * 4)
 ADC SC2                \          + max(x, y, z) / 2
                        \
                        \ If h is the longest of x, y, z, and a and b are the
                        \ other two sides, then we have:
                        \
                        \   max(x, y, z) = h
                        \
                        \   x + y + z - max(x, y, z) = a + b + h - h
                        \                            = a + b
                        \
                        \ So:
                        \
                        \   A = 5 * (a + b) / (8 * 4) + h / 2
                        \     = 5/32 * a + 5/32 * b + 1/2 * h
                        \
                        \ This estimates half the length of the (x, y, z)
                        \ vector, i.e. 0.5 * |x y z|, using an approximation
                        \ that estimates the length within 8% of the correct
                        \ value, and without having to do any multiplication
                        \ or take any square roots

 CMP #64                \ If A >= 64 then jump to scan1 to hide the ship's
 BCS scan1              \ scanner sprites and return from the subroutine, as the
                        \ ship is too far away to appear on the scanner

                        \ We now calculate the position of the ship on the
                        \ scanner, starting with the x-coordinate (see the deep
                        \ dive on "The 3D scanner" for an explanation of the
                        \ following)

 LDA INWK+1             \ Set A = x_hi

 CLC                    \ Clear the C flag so we can do addition below

 LDX INWK+2             \ Set X = x_sign

 BPL scan5              \ If x_sign is positive, skip the following

 EOR #%11111111         \ x_sign is negative, so flip the bits in A and add
 ADC #1                 \ 1 to make it a negative number

.scan5

 ADC #124               \ Set SC2 = 124 + (x_sign x_hi)
 STA SC2                \
                        \ So this gives us the x-coordinate of the ship on the
                        \ scanner

                        \ Next, we convert the z_hi coordinate of the ship into
                        \ the y-coordinate of the base of the ship's stick,
                        \ like this:
                        \
                        \   SC2+1 = 199 - (z_sign z_hi) / 4

 LDA INWK+7             \ Set A = z_hi / 4
 LSR A
 LSR A

 CLC                    \ Clear the C flag for the addition below

 LDX INWK+8             \ Set X = z_sign

 BMI scan6              \ If z_sign is negative, skip the following so we add
                        \ the magnitude of x_hi (which is the same as
                        \ subtracting a negative x_hi)

 EOR #%11111111         \ z_sign is positive, so flip the bits in A and set the
 SEC                    \ C flag. This makes A negative using two's complement,
                        \ and as we are about to do an ADC, the SEC effectively
                        \ add the 1 we need, giving A = -x_hi

.scan6

 ADC #199+YPAL          \ Set SC2+1 = 199 + A to give us the y-coordinate of the
 STA SC2+1              \ base of the ship's stick

                        \ Finally, we calculate Y1 to represent the height of
                        \ stick as:
                        \
                        \   Y1 = min(y_hi, 47)

 LDA INWK+4             \ Set A = y_hi

 CMP #48                \ If A < 48, jump to scan7 to skip the following
 BCC scan7              \ instruction

 LDA #47                \ Set A = 47, so A contains y_hi capped to a maximum
                        \ value of 47, i.e. A = min(y_hi, 47)

.scan7

 LSR A                  \ Set Y1 = A = min(y_hi, 47)
 STA Y1

 CLC                    \ Clear the C flag (though this has no effect)

                        \ We now have the following data:
                        \
                        \   * SC2 is the x-coordinate of the ship on the scanner
                        \
                        \   * SC2+1 is the y-coordinate of the base of the
                        \     ship's stick
                        \
                        \   * Y1 is the height of the stick
                        \
                        \ So now we draw the ship on the scanner, with the first
                        \ step being to work out whether we should draw the ship
                        \ above or below the 3D ellipse (and therefore in front
                        \ of or behind the background tiles that make up the 3D
                        \ ellipse on-screen)

 BEQ scan8              \ If A = 0 then y_hi must be 0, so the ship is exactly
                        \ on the 3D ellipse on the scanner (not above or below
                        \ it), so jump to scan8 to draw the ship in front of
                        \ the ellipse background

 LDX INWK+5             \ If y_sign is positive then the ship is above the 3D
 BPL scan8              \ ellipse on the scanner, so jump to scan8 to draw the
                        \ ship in front of the ellipse background

 JMP scan12             \ Otherwise the ship is below the 3D ellipse on the
                        \ scanner, so jump to scan12 to draw the ship behind
                        \ the ellipse background

.scan8

                        \ If we get here then we draw the ship in front of the
                        \ 3D ellipse

 LDA SC2+1              \ Set SC2+1 = SC2+1 - 8
 SEC                    \
 SBC #8                 \ This subtracts 8 from the y-coordinate of the bottom
 STA SC2+1              \ of the stick, and ensures that the bottom of the stick
                        \ looks as if it is touching the 3D ellipse

                        \ The ship is drawn on the scanner using up to three
                        \ sprites - sprites Y, Y+1 and Y+2
                        \
                        \ Sprite Y is the end of the stick that's furthest from
                        \ the ship dot (i.e. the "bottom" of the stick which
                        \ appears to touch the 3D ellipse)
                        \
                        \ Sprite Y+1 is the middle part of the stick
                        \
                        \ Sprite Y+2 is the big ship dot at the end of the stick
                        \ (i.e. the "top" of the stick)
                        \
                        \ If a stick is full height, then we show all three
                        \ sprites, if a stick is medium height we display
                        \ sprites Y+1 and Y+2, and if a stick is small we only
                        \ display sprite Y+2
                        \
                        \ We always draw sprite Y+2, so first we concentrate on
                        \ drawing sprites Y and Y+1, if required

 LDA Y1                 \ If Y1 < 16 then the stick is either medium or small,
 CMP #16                \ so jump to scan9 to skip the following
 BCC scan9

                        \ If we get here then the stick is full height, so we
                        \ draw both sprite Y and sprite Y+1

 LDA SC2                \ Set the x-coordinate of sprite Y to SC2
 STA xSprite0,Y

 STA xSprite1,Y         \ Set the x-coordinate of sprite Y+1 to SC2

 LDA SC2+1              \ Set the y-coordinate of sprite Y to SC2+1, as SC2+1
 STA ySprite0,Y         \ contains the y-coordinate of the bottom of the stick

 SEC                    \ Set the y-coordinate of sprite Y+1 to SC2+1 - 8, which
 SBC #8                 \ is eight pixels higher up the screen then sprite Y
 STA ySprite1,Y         \
                        \ This stacks the sprites one above the other, as each
                        \ sprite is eight pixels

 LDA attrSprite0,Y      \ Clear bits 2 to 7 of the attributes for sprite Y to
 AND #%00000011         \ ensure that the following attributes are set:
 STA attrSprite0,Y      \
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically
                        \
                        \ This makes sure we display the sprite in front of the
                        \ 3D ellipse, as the ship is above the ellipse in space

 STA attrSprite1,Y      \ Set the attributes for sprite Y+1 to the same as those
                        \ for sprite Y

 LDA SC2+1              \ Set SC2+1 = SC2+1 - 16
 SBC #16                \
 STA SC2+1              \ This subtracts 16 from the y-coordinate of the bottom
                        \ of the stick to give us the y-coordinate of the top
                        \ sprite in the stick

 BNE scan11             \ Jump to scan11 to draw sprite Y+2 at the top of the
                        \ stick (this BNE is effectively a JMP as A is never
                        \ zero)

.scan9

                        \ If we get here then the stick is either medium or
                        \ small height

 CMP #8                 \ If Y1 < 8 then the stick is small, so jump to scan10
 BCC scan10             \ to skip the following

                        \ If we get here then the stick is medium height, so we
                        \ draw sprite Y+1 and hide sprite Y

 LDA #240               \ Hide sprite Y by setting its y-coordinate to 240,
 STA ySprite0,Y         \ which moves it off the bottom of the screen

 LDA SC2                \ Set the x-coordinate of sprite Y+1 to SC2
 STA xSprite1,Y

 LDA SC2+1              \ Set the y-coordinate of sprite Y+1 to SC2+1, as SC2+1
 STA ySprite1,Y         \ contains the y-coordinate of the bottom of the stick
                        \ (which is the middle sprite in a medium height stick)

 LDA attrSprite0,Y      \ Clear bits 2 to 7 of the attributes for sprite Y+1 to
 AND #%00000011         \ ensure that the following attributes are set:
 STA attrSprite1,Y      \
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically
                        \
                        \ This makes sure we display the sprite in front of the
                        \ 3D ellipse, as the ship is above the ellipse in space
                        \
                        \ Note that we do this by copying the attributes we set
                        \ up for sprite Y into sprite Y+1, clearing the bits as
                        \ we do so

 LDA SC2+1              \ Set SC2+1 = SC2+1 - 8
 SBC #8                 \
 STA SC2+1              \ This subtracts 8 from the y-coordinate of the bottom
                        \ of the stick to give us the y-coordinate of the top
                        \ sprite in the stick

 BNE scan11             \ Jump to scan11 to draw sprite Y+2 at the top of the
                        \ stick (this BNE is effectively a JMP as A is never
                        \ zero)

.scan10

                        \ If we get here then the stick is small, so we hide
                        \ sprites Y and Y+1, leaving just sprite Y+2 visible on
                        \ the scanner

 LDA #240               \ Hide sprites Y and Y+1 from the scanner by setting
 STA ySprite0,Y         \ their y-coordinates to 240, which moves them off the
 STA ySprite1,Y         \ bottom of the screen

.scan11

                        \ We now draw sprite Y+2, which contains the ship dot at
                        \ the end of the stick

 LDA Y1                 \ Set A = Y1 mod 8
 AND #7                 \
                        \ This gives us the height of the top part of the stick,
                        \ as there are eight pixels in each sprite making up the
                        \ stick, so this is the remainder after sprites Y and
                        \ Y+1 are taken away

 CLC                    \ Set the tile pattern number for sprite Y+2 to 219 + A
 ADC #219               \
 STA tileSprite2,Y      \ Sprites 219 to 226 contain ship dots with trailing
                        \ sticks, starting with the dot at the bottom of the
                        \ pattern (in pattern 219) up to the dot at the top of
                        \ the pattern (in pattern 226), so this sets the tile
                        \ pattern for sprite Y+2 to the dot height given in A,
                        \ which is the correct pattern for the top of the ship's
                        \ stick

 LDA attrSprite0,Y      \ Clear bits 2 to 7 of the attributes for sprite Y+1 to
 AND #%00000011         \ ensure that the following attributes are set:
 STA attrSprite2,Y      \
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically
                        \
                        \ This makes sure we display the sprite in front of the
                        \ 3D ellipse, as the ship is above the ellipse in space
                        \
                        \ Note that we do this by copying the attributes we set
                        \ up for sprite Y into sprite Y+2, clearing the bits as
                        \ we do so

 LDA SC2                \ Set the x-coordinate of sprite Y+2 to SC2
 STA xSprite2,Y

 LDA SC2+1              \ Set the y-coordinate of sprite Y+2 to SC2+1, which by
 STA ySprite2,Y         \ now contains the y-coordinate of the top of the stick,

 RTS                    \ Return from the subroutine

.scan12

                        \ If we get here then we draw the ship behind the 3D
                        \ ellipse
                        \
                        \ We jump here with A set to Y1, the height of the
                        \ stick, which we now need to clip to ensure it doesn't
                        \ fall off the bottom of the screen

 CLC                    \ Set A = Y1 + SC2+1
 ADC SC2+1

 CMP #220+YPAL          \ If A < 220, jump to scan13 to skip the following
 BCC scan13             \ instruction

 LDA #220+YPAL          \ Set A = 220, so A is a maximum of 220

.scan13

 SEC                    \ Set Y1 = A - SC2+1
 SBC SC2+1              \
 STA Y1                 \ So this leaves Y1 alone unless Y1 + SC2+1 >= 220, in
                        \ which case Y1 is clipped so that Y1 + SC2+1 = 220 (so
                        \ this moves the "top" of the stick so that the ship dot
                        \ doesn't go off the bottom of the screen)

                        \ The ship is drawn on the scanner using up to three
                        \ sprites - sprites Y, Y+1 and Y+2
                        \
                        \ Sprite Y is the end of the stick that's furthest from
                        \ the ship dot (i.e. the "bottom" of the stick which
                        \ appears to touch the 3D ellipse, though as we are
                        \ drawing the stick below the ellipse, this is the part
                        \ of the stick that is highest up the screen)
                        \
                        \ Sprite Y+1 is the middle part of the stick
                        \
                        \ Sprite Y+2 is the big ship dot at the end of the stick
                        \ (i.e. the "top" of the stick, though as we are
                        \ drawing the stick below the ellipse, this is the part
                        \ of the stick that is furthest down the screen)
                        \
                        \ If a stick is full height, then we show all three
                        \ sprites, if a stick is medium height we display
                        \ sprites Y+1 and Y+2, and if a stick is small we only
                        \ display sprite Y+2
                        \
                        \ We always draw sprite Y+2, so first we concentrate on
                        \ drawing sprites Y and Y+1, if required

 CMP #16                \ If Y1 < 16 then the stick is either medium or small,
 BCC scan14             \ so jump to scan14 to skip the following

                        \ If we get here then the stick is full height, so we
                        \ draw both sprite Y and sprite Y+1

 LDA SC2                \ Set the x-coordinate of sprite Y to SC2
 STA xSprite0,Y

 STA xSprite1,Y         \ Set the x-coordinate of sprite Y+1 to SC2

 LDA SC2+1              \ Set the y-coordinate of sprite Y to SC2+1, as SC2+1
 STA ySprite0,Y         \ contains the y-coordinate of the "bottom" of the stick

 CLC                    \ Set the y-coordinate of sprite Y+1 to SC2+1 + 8, which
 ADC #8                 \ is eight pixels lower down the screen then sprite Y
 STA ySprite1,Y         \
                        \ This stacks the sprites one below the other, as each
                        \ sprite is eight pixels

 LDA attrSprite0,Y      \ Set bit 5 of the attributes for sprite Y to ensure
 ORA #%00100000         \ that the following attribute is set:
 STA attrSprite0,Y      \
                        \   * Bit 5 set   = show behind background
                        \
                        \ This makes sure we display the sprite behind the
                        \ 3D ellipse, as the ship is below the ellipse in space

 STA attrSprite1,Y      \ Set the attributes for sprite Y+1 to the same as those
                        \ for sprite Y

 LDA SC2+1              \ Set SC2+1 = SC2+1 + 16
 CLC                    \
 ADC #16                \ This adds 16 to the y-coordinate of the "bottom" of
 STA SC2+1              \ the stick to give us the y-coordinate of the "top"
                        \ sprite in the stick

 BNE scan16             \ Jump to scan16 to draw sprite Y+2 at the "top" of the
                        \ stick (this BNE is effectively a JMP as A is never
                        \ zero)

.scan14

                        \ If we get here then the stick is either medium or
                        \ small height

 CMP #8                 \ If Y1 < 8 then the stick is small, so jump to scan15
 BCC scan15             \ to skip the following

                        \ If we get here then the stick is medium height, so we
                        \ draw sprite Y+1 and hide sprite Y

 LDA #240               \ Hide sprite Y by setting its y-coordinate to 240,
 STA ySprite0,Y         \ which moves it off the bottom of the screen

 LDA SC2                \ Set the x-coordinate of sprite Y+1 to SC2
 STA xSprite1,Y

 LDA SC2+1              \ Set the y-coordinate of sprite Y+1 to SC2+1, as SC2+1
 STA ySprite1,Y         \ contains the y-coordinate of the bottom of the stick
                        \ (which is the middle sprite in a medium height stick)

 LDA attrSprite0,Y      \ Set bit 5 of the attributes for sprite Y to ensure
 ORA #%00100000         \ that the following attribute is set:
 STA attrSprite1,Y      \
                        \   * Bit 5 set   = show behind background
                        \
                        \ This makes sure we display the sprite behind the
                        \ 3D ellipse, as the ship is below the ellipse in space
                        \
                        \ Note that we do this by copying the attributes we set
                        \ up for sprite Y into sprite Y+1, clearing the bits as
                        \ we do so

 LDA SC2+1              \ Set SC2+1 = SC2+1 + 8
 ADC #7                 \
 STA SC2+1              \ This adds 8 to the y-coordinate of the "bottom" of the
                        \ stick to give us the y-coordinate of the "top" sprite
                        \ in the stick
                        \
                        \ The addition works as we know the C flag is set, as we
                        \ passed through a BCS above, so the ADC #7 actually
                        \ adds 8

 BNE scan16             \ Jump to scan16 to draw sprite Y+2 at the "top" of the
                        \ stick (this BNE is effectively a JMP as A is never
                        \ zero)

.scan15

                        \ If we get here then the stick is small, so we hide
                        \ sprites Y and Y+1, leaving just sprite Y+2 visible on
                        \ the scanner

 LDA #240               \ Hide sprites Y and Y+1 from the scanner by setting
 STA ySprite0,Y         \ their y-coordinates to 240, which moves them off the
 STA ySprite1,Y         \ bottom of the screen

.scan16

                        \ We now draw sprite Y+2, which contains the ship dot at
                        \ the end of the stick

 LDA Y1                 \ Set A = Y1 mod 8
 AND #7                 \
                        \ This gives us the height of the top part of the stick,
                        \ as there are eight pixels in each sprite making up the
                        \ stick, so this is the remainder after sprites Y and
                        \ Y+1 are taken away

 CLC                    \ Set the tile pattern number for sprite Y+2 to 219 + A
 ADC #219               \
 STA tileSprite2,Y      \ Sprites 219 to 226 contain ship dots with trailing
                        \ sticks, starting with the dot at the bottom of the
                        \ pattern (in pattern 219) up to the dot at the top of
                        \ the pattern (in pattern 226), so this sets the tile
                        \ pattern for sprite Y+2 to the dot height given in A,
                        \ which is the correct pattern for the top of the ship's
                        \ stick

 LDA attrSprite0,Y      \ Set bits 5 to 7 of the attributes for sprite Y to
 ORA #%11100000         \ ensure that the following attributes are set:
 STA attrSprite2,Y      \
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 set   = flip vertically
                        \
                        \ This makes sure we display the sprite behind the
                        \ 3D ellipse, as the ship is below the ellipse in space,
                        \ and that the dot end of the stick is at the bottom of
                        \ the sprite, not the top
                        \
                        \ Note that we do this by copying the attributes we set
                        \ up for sprite Y into sprite Y+1, clearing the bits as
                        \ we do so

 LDA SC2                \ Set the x-coordinate of sprite Y+2 to SC2
 STA xSprite2,Y

 LDA SC2+1              \ Set the y-coordinate of sprite Y+2 to SC2+1, which by
 STA ySprite2,Y         \ now contains the y-coordinate of the top of the stick,

 RTS                    \ Return from the subroutine

