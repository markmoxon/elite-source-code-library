\ ******************************************************************************
\
\       Name: TT163
\       Type: Subroutine
\   Category: Market
\    Summary: Print the headers for the table of market prices
\
\ ------------------------------------------------------------------------------
\
\ Print the column headers for the prices table in the Buy Cargo and Market
\ Price screens.
\
\ ******************************************************************************

.TT163

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDA #17                \ Move the text cursor in XC to column 17
 STA XC

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION

 LDA #17                \ Move the text cursor in XC to column 17
 JSR DOXC

ELIF _APPLE_VERSION

 LDA #17                \ Set A = 17 to denote column 17

IF _IB_DISK

 STA XC                 \ Move the text cursor in XC to column 17

ELIF _SOURCE_DISK

 JSR DOXC               \ Move the text cursor in XC to column 17

ENDIF

ELIF _NES_VERSION

 LDA #1                 \ Move the text cursor in XC to column 1
 STA XC

ENDIF

 LDA #255               \ Print recursive token 95 token ("UNIT  QUANTITY
 BNE TT162+2            \ {crlf} PRODUCT   UNIT PRICE FOR SALE{crlf}{lf}") by
                        \ jumping to TT162+2, which contains JMP TT27 (this BNE
                        \ is effectively a JMP as A will never be zero), and
                        \ return from the subroutine using a tail call

