\ ******************************************************************************
\
\       Name: TT151
\       Type: Subroutine
\   Category: Market
\    Summary: Print the name, price and availability of a market item
\  Deep dive: Market item prices and availability
\             Galaxy and system seeds
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the market item to print, 0-16 (see QQ23
\                       for details of item numbers)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   QQ19+1              Byte #1 from the market prices table for this item
\
\   QQ24                The item's price / 4
\
\   QQ25                The item's availability
\
\ ******************************************************************************

IF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Advanced: Group A: In the advanced versions, the Market Price screen doesn't list any prices when you're in witchspace, while the other versions still show the prices from the system you jumped from

.TT151q

                        \ We jump here from below if we are in witchspace

 PLA                    \ Restore the item number from the stack

 RTS                    \ Return from the subroutine

ENDIF

.TT151

 PHA                    \ Store the item number on the stack and in QQ19+4
 STA QQ19+4

 ASL A                  \ Store the item number * 4 in QQ19, so this will act as
 ASL A                  \ an index into the market prices table at QQ23 for this
 STA QQ19               \ item (as there are four bytes per item in the table)

IF _NES_VERSION

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Advanced: See group A

 LDA MJ                 \ If we are in witchspace, we can't trade items, so jump
 BNE TT151q             \ up to TT151q to return from the subroutine

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _NES_VERSION \ Tube

 LDA #1                 \ Move the text cursor to column 1, for the item's name
 STA XC

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION

 LDA #1                 \ Move the text cursor to column 1, for the item's name
 JSR DOXC

ELIF _APPLE_VERSION

 LDA #1                 \ Set A = 1 to denote column 1

IF _IB_DISK OR _4AM_CRACK

 STA XC                 \ Move the text cursor to column 1, for the item's name

ELIF _SOURCE_DISK

 JSR DOXC               \ Move the text cursor to column 1, for the item's name

ENDIF

ENDIF

IF _NES_VERSION

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

ENDIF

 PLA                    \ Restore the item number

IF NOT(_NES_VERSION)

 ADC #208               \ Print recursive token 48 + A, which will be in the
 JSR TT27               \ range 48 ("FOOD") to 64 ("ALIEN ITEMS"), so this
                        \ prints the item's name

ELIF _NES_VERSION

 CLC                    \ Print recursive token 48 + A, which will be in the
 ADC #208               \ range 48 ("FOOD") to 64 ("ALIEN ITEMS"), so this
 JSR TT27_b2            \ prints the item's name

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _APPLE_VERSION \ Tube

 LDA #14                \ Move the text cursor to column 14, for the price
 STA XC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #14                \ Move the text cursor to column 14, for the price
 JSR DOXC

ELIF _NES_VERSION

                        \ We now move the text cursor to column 14 by printing
                        \ spaces until the cursor column in XC reaches 14

.aval1

 LDA #' '               \ Print a space
 JSR TT27_b2

 LDA XC                 \ Loop back to print another space until XC = 14
 CMP #14
 BNE aval1

ENDIF

 LDX QQ19               \ Fetch byte #1 from the market prices table (units and
 LDA QQ23+1,X           \ economic_factor) for this item and store in QQ19+1
 STA QQ19+1

 LDA QQ26               \ Fetch the random number for this system visit and
 AND QQ23+3,X           \ AND with byte #3 from the market prices table (mask)
                        \ to give:
                        \
                        \   A = random AND mask

 CLC                    \ Add byte #0 from the market prices table (base_price),
 ADC QQ23,X             \ so we now have:
 STA QQ24               \
                        \   A = base_price + (random AND mask)

 JSR TT152              \ Call TT152 to print the item's unit ("t", "kg" or
                        \ "g"), padded to a width of two characters

 JSR var                \ Call var to set QQ19+3 = economy * |economic_factor|
                        \ (and set the availability of alien items to 0)

 LDA QQ19+1             \ Fetch the byte #1 that we stored above and jump to
 BMI TT155              \ TT155 if it is negative (i.e. if the economic_factor
                        \ is negative)

 LDA QQ24               \ Set A = QQ24 + QQ19+3
 ADC QQ19+3             \
                        \       = base_price + (random AND mask)
                        \         + (economy * |economic_factor|)
                        \
                        \ which is the result we want, as the economic_factor
                        \ is positive

 JMP TT156              \ Jump to TT156 to multiply the result by 4

.TT155

 LDA QQ24               \ Set A = QQ24 - QQ19+3
 SEC                    \
 SBC QQ19+3             \       = base_price + (random AND mask)
                        \         - (economy * |economic_factor|)
                        \
                        \ which is the result we want, as economic_factor
                        \ is negative

.TT156

 STA QQ24               \ Store the result in QQ24 and P
 STA P

 LDA #0                 \ Set A = 0 and call GC2 to calculate (Y X) = (A P) * 4,
 JSR GC2                \ which is the same as (Y X) = P * 4 because A = 0

 SEC                    \ We now have our final price, * 10, so we can call pr5
 JSR pr5                \ to print (Y X) to 5 digits, including a decimal
                        \ point, as the C flag is set

 LDY QQ19+4             \ We now move on to availability, so fetch the market
                        \ item number that we stored in QQ19+4 at the start

IF NOT(_NES_VERSION)

 LDA #5                 \ Set A to 5 so we can print the availability to 5
                        \ digits (right-padded with spaces)

ELIF _NES_VERSION

 LDA #3                 \ Set A to 3 so we can print the availability to 3
                        \ digits (right-padded with spaces)

ENDIF

 LDX AVL,Y              \ Set X to the item's availability, which is given in
                        \ the AVL table

 STX QQ25               \ Store the availability in QQ25

 CLC                    \ Clear the C flag

 BEQ TT172              \ If none are available, jump to TT172 to print a tab
                        \ and a "-"

 JSR pr2+2              \ Otherwise print the 8-bit number in X to 5 digits,
                        \ right-aligned with spaces. This works because we set
                        \ A to 5 above, and we jump into the pr2 routine just
                        \ after the first instruction, which would normally
                        \ set the number of digits to 3

IF NOT(_NES_VERSION)

 JMP TT152              \ Print the unit ("t", "kg" or "g") for the market item,
                        \ with a following space if required to make it two
                        \ characters long, and return from the subroutine using
                        \ a tail call

ELIF _NES_VERSION

 JSR TT152              \ Print the unit ("t", "kg" or "g") for the market item,
                        \ with a following space if required to make it two
                        \ characters long

 JMP PrintNumberInHold  \ Print the number of units of this item that we have in
                        \ the hold, returning from the subroutine using a tail
                        \ call

ENDIF

.TT172

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDA XC                 \ Move the text cursor in XC to the right by 4 columns,
 ADC #4                 \ so the cursor is where the last digit would be if we
 STA XC                 \ were printing a five-digit availability number

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION

 LDA #25                \ Move the text cursor to column 25
 JSR DOXC

ELIF _APPLE_VERSION

 LDA #25                \ Set A = 25 to denote column 25

IF _IB_DISK OR _4AM_CRACK

 STA XC                 \ Move the text cursor to column 25

ELIF _SOURCE_DISK

 JSR DOXC               \ Move the text cursor to column 25

ENDIF

ELIF _NES_VERSION

 JSR PrintSpacedHyphen  \ Print two spaces, then a "-", and then another two
                        \ spaces

 JMP PrintNumberInHold  \ Print the number of units of this item that we have in
                        \ the hold, returning from the subroutine using a tail
                        \ call

ENDIF

IF NOT(_NES_VERSION)

 LDA #'-'               \ Print a "-" character by jumping to TT162+2, which
 BNE TT162+2            \ contains JMP TT27 (this BNE is effectively a JMP as A
                        \ will never be zero), and return from the subroutine
                        \ using a tail call

ENDIF

