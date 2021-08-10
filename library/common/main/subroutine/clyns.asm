\ ******************************************************************************
\
\       Name: CLYNS
\       Type: Subroutine
\   Category: Utility routines
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Clear the bottom three text rows of the mode 4 screen
ELIF _6502SP_VERSION
\    Summary: Implement the #clyns command (clear the bottom of the screen)
ENDIF
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Comment
\ ------------------------------------------------------------------------------
\
\ This routine clears some space at the bottom of the screen and moves the text
\ cursor to column 1, row 21. 
\
ELIF _ELITE_A_6502SP_IO
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a clr_line command. It clears some
\ space at the bottom of the screen and moves the text cursor to column 1, row
\ 21.
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Specifically, it zeroes the following screen locations:
\
\   &7507 to &75F0
\   &7607 to &76F0
\   &7707 to &77F0
\
\ which clears the three bottom text rows of the mode 4 screen (rows 21 to 23),
\ clearing each row from text column 1 to 30 (so it doesn't overwrite the box
\ border in columns 0 and 32, or the last usable column in column 31).
\
\ Returns:
\
\   A                   A is set to 0
\
\   Y                   Y is set to 0
\
ENDIF
\ ******************************************************************************

.CLYNS

IF _MASTER_VERSION \ Platform

 STZ DLY                \ Set the delay in DLY to 0, to indicate that we are
                        \ no longer showing an in-flight message, so any new
                        \ in-flight messages will be shown instantly

 STZ de                 \ Clear de, the flag that appends " DESTROYED" to the
                        \ end of the next text token, so that it doesn't

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Platform

 LDA #%11111111         \ Set DTW2 = %11111111 to denote that we are not
 STA DTW2               \ currently printing a word

ENDIF

IF _MASTER_VERSION \ Platform

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

ENDIF

IF _ELECTRON_VERSION \ Platform

 JSR BORDER             \ Redraw the space view's border, which removes it
                        \ from the screen

 LDX #&71               \ Call LYN with X = &71 to clear the screen from page
 JSR LYN                \ &71 to page &75, which clears the bottom three lines
                        \ of the screen

 JSR BORDER             \ Redraw the space view's border

ENDIF

IF NOT(_ELITE_A_6502SP_IO)

 LDA #20                \ Move the text cursor to row 20, near the bottom of
 STA YC                 \ the screen

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Screen

 JSR TT67               \ Print a newline, which will move the text cursor down
                        \ a line (to row 21) and back to column 1

 LDA #&75               \ Set the two-byte value in SC to &7507
 STA SC+1
 LDA #7
 STA SC

ELIF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT

 LDA #&75               \ Set the two-byte value in SC to &7507
 STA SC+1
 LDA #7
 STA SC

 JSR TT67               \ Print a newline, which will move the text cursor down
                        \ a line (to row 21) and back to column 1

ELIF _ELECTRON_VERSION

 JSR TT67               \ Print a newline, which will move the text cursor down
                        \ a line (to row 21) and back to column 1

ELIF _6502SP_VERSION

 LDA #&6A               \ Set SC+1 = &6A, for the high byte of SC(1 0)
 STA SC+1

 JSR TT67               \ Print a newline

 LDA #0                 \ Set SC = 0, so now SC(1 0) = &6A00
 STA SC

ELIF _MASTER_VERSION

 JSR TT67_DUPLICATE     \ Print a newline

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 LDA #&6A               \ Set SC+1 = &6A, for the high byte of SC(1 0)
 STA SC+1

 LDA #0                 \ Set SC = 0, so now SC(1 0) = &6A00
 STA SC

ELIF _ELITE_A_6502SP_IO

 LDA #&75               \ Set the two-byte value in SC to &7507
 STA SC+1
 LDA #7
 STA SC

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Screen

 LDA #0                 \ Call LYN to clear the pixels from &7507 to &75F0
 JSR LYN

 INC SC+1               \ Increment SC+1 so SC points to &7607

 JSR LYN                \ Call LYN to clear the pixels from &7607 to &76F0

 INC SC+1               \ Increment SC+1 so SC points to &7707

 INY                    \ Move the text cursor to column 1 (as LYN sets Y to 0)
 STY XC

                        \ Fall through into LYN to clear the pixels from &7707
                        \ to &77F0

ELIF _ELECTRON_VERSION

 LDY #1                 \ Move the text cursor to column 1
 STY XC

 DEY                    \ Set Y = 0, so the subroutine returns with this value
 TYA

.SC5

 RTS                    \ Return from the subroutine

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 LDA #0                 \ Call LYN to clear the pixels from &7507 to &75F0
 JSR LYN

 INC SC+1               \ Increment SC+1 so SC points to &7607

 INY                    \ Move the text cursor to column 1 (as LYN sets Y to 0)
 STY XC

                        \ Fall through into LYN to clear the pixels from &7707
                        \ to &77F0

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX #3                 \ We want to clear three text rows, so set a counter in
                        \ X for 3 rows

.CLYL

 LDY #8                 \ We want to clear each text row, starting from the
                        \ left, but we don't want to overwrite the border, so we
                        \ start from the second character block, which is byte
                        \ #8 from the edge, so set Y to 8 to act as the byte
                        \ counter within the row

.EE2

 STA (SC),Y             \ Zero the Y-th byte from SC(1 0), which clears it by
                        \ setting it to colour 0, black

 INY                    \ Increment the byte counter in Y

 BNE EE2                \ Loop back to EE2 to blank the next byte along, until
                        \ we have done one page's worth (from byte #8 to #255)

 INC SC+1               \ We have just finished the first page - which covers
                        \ the left half of the text row - so we increment SC+1
                        \ so SC(1 0) points to the start of the next page, or
                        \ the start of the right half of the row

 STA (SC),Y             \ Clear the byte at SC(1 0), as that won't be caught by
                        \ the next loop

 LDY #247               \ The second page covers the right half of the text row,
                        \ and as before we don't want to overwrite the border,
                        \ which we can do by starting from the last-but-one
                        \ character block and working our way left towards the
                        \ centre of the row. The last-but-one character block
                        \ ends at byte 247 (that's 255 - 8, as each character
                        \ is 8 bytes), so we put this in Y to act as a byte
                        \ counter, as before

ELIF _ELITE_A_6502SP_IO

 LDA #0                 \ Call LYN to clear the pixels from &7507 to &75F0
 JSR LYN

 INC SC+1               \ Increment SC+1 so SC points to &7607

 JSR LYN                \ Call LYN to clear the pixels from &7607 to &76F0

 INC SC+1               \ Increment SC+1 so SC points to &7707

                        \ Fall through into LYN to clear the pixels from &7707
                        \ to &77F0

ENDIF

IF _6502SP_VERSION \ Platform

.EE3

 STA (SC),Y             \ Zero the Y-th byte from SC(1 0), which clears it by
                        \ setting it to colour 0, black

 DEY                    \ Decrement the byte counter in Y

 BNE EE3                \ Loop back to EE2 to blank the next byte to the left,
                        \ until we have done one page's worth (from byte #247 to
                        \ #1)

ELIF _MASTER_VERSION

{
.EE3                    \ This label is a duplicate of a label in TT23 (which is
                        \ why we need to surround it with braces, as BeebAsm
                        \ doesn't allow us to redefine labels, unlike BBC
                        \ BASIC)

 STA (SC),Y             \ Zero the Y-th byte from SC(1 0), which clears it by
                        \ setting it to colour 0, black

 DEY                    \ Decrement the byte counter in Y

 BNE EE3                \ Loop back to EE2 to blank the next byte to the left,
                        \ until we have done one page's worth (from byte #247 to
                        \ #1)
}

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 INC SC+1               \ We have now blanked a whole text row, so increment
                        \ SC+1 so that SC(1 0) points to the next row

 DEX                    \ Decrement the row counter in X

 BNE CLYL               \ Loop back to blank another row, until we have done the
                        \ number of rows in X

ENDIF

IF _6502SP_VERSION \ Comment

\INX                    \ These instructions are commented out in the original
\STX SC                 \ source

ENDIF

IF _6502SP_VERSION \ Platform

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ELIF _MASTER_VERSION

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 LDA #0                 \ Set A = 0 as this is a return value for this routine

 RTS                    \ Return from the subroutine

ENDIF

