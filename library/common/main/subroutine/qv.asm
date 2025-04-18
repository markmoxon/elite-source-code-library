\ ******************************************************************************
\
\       Name: qv
\       Type: Subroutine
\   Category: Equipment
\    Summary: Print a menu of the four space views, for buying lasers
\
\ ------------------------------------------------------------------------------
\
\ Print a menu in the bottom-middle of the screen, at row 16, column 12, that
\ lists the four available space views, like this:
\
\                 0 Front
\                 1 Rear
\                 2 Left
\                 3 Right
\
\ Also print a "View ?" prompt and ask for a view number. The menu is shown
\ when we choose to buy a new laser in the Equip Ship screen.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The chosen view number (0-3)
\
\ ******************************************************************************

.qv

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Standard: When buying a laser in the cassette version, the menu of available views is always shown below the equipment list. In the other versions, the list of equipment in systems with tech level 8 and above is too long to squeeze in the menu (due to the extra lasers you can buy in these versions), so when buying lasers in these systems, the whole screen is cleared and the menu is shown in the middle of the screen

 LDA tek                \ If the current system's tech level is less than 8,
 CMP #8                 \ skip the next two instructions, otherwise we clear the
 BCC P%+7               \ screen to prevent the view menu from clashing with the
                        \ longer equipment menu available in higher tech systems

 LDA #32                \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 32 (Equip
                        \ Ship screen)

ELIF _C64_VERSION

 LDA tek                \ If the current system's tech level is less than 8,
 CMP #8                 \ skip the next two instructions, otherwise we clear the
 BCC P%+7               \ screen to prevent the view menu from clashing with the
                        \ longer equipment menu available in higher tech systems

 LDA #32                \ Clear the screen, draw a border box, and set the
 JSR TT66               \ current view type in QQ11 to 32 (Equip Ship screen)

ELIF _APPLE_VERSION

 LDA tek                \ If the current system's tech level is less than 8,
 CMP #8                 \ skip the next two instructions, otherwise we clear the
 BCC P%+7               \ screen to prevent the view menu from clashing with the
                        \ longer equipment menu available in higher tech systems

 LDA #32                \ Clear the screen and set the current view type in QQ11
 JSR TT66               \ to 32 (Equip Ship screen)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED \ Tube

 LDY #16                \ Move the text cursor to row 16, and at the same time
 STY YC                 \ set Y to a counter going from 16 to 19 in the loop
                        \ below

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #16                \ Move the text cursor to row 16, and at the same time
 TAY                    \ set Y to a counter going from 16 to 19 in the loop
 JSR DOYC               \ below

ELIF _MASTER_VERSION

 LDA #16                \ Move the text cursor to row 16, and at the same time
 TAY                    \ set Y to a counter going from 16 to 19 in the loop
 STA YC                 \ below

ELIF _ELITE_A_VERSION

 LDY #16                \ Move the text cursor to row 16, and at the same time
 STY YC                 \ set YC to a counter going from 16 to 19 in the loop
                        \ below

ELIF _APPLE_VERSION

 LDA #16                \ Set A = 16 to denote row 16

 TAY                    \ Set Y to a counter going from 16 to 19 in the loop
                        \ below

IF _IB_DISK OR _4AM_CRACK

 STA YC                 \ Move the text cursor to row 16

ELIF _SOURCE_DISK

 JSR DOYC               \ Move the text cursor to row 16

ENDIF

ENDIF

.qv1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Tube

 LDX #12                \ Move the text cursor to column 12
 STX XC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #12                \ Move the text cursor to column 12
 JSR DOXC

ELIF _MASTER_VERSION

 LDA #12                \ Move the text cursor to column 12
 STA XC

ELIF _APPLE_VERSION

 LDA #12                \ Set A = 12 to denote column 12

IF _IB_DISK OR _4AM_CRACK

 STA XC                 \ Move the text cursor to column 12

ELIF _SOURCE_DISK

 JSR DOXC               \ Move the text cursor to column 12

ENDIF

ENDIF

IF NOT(_ELITE_A_VERSION)

 TYA                    \ Transfer the counter value from Y to A

ELIF _ELITE_A_VERSION

 LDA YC                 \ Fetch the counter value from YC into A

ENDIF

 CLC                    \ Print ASCII character "0" - 16 + A, so as A goes from
 ADC #'0'-16            \ 16 to 19, this prints "0" through "3" followed by a
 JSR spc                \ space

 LDA YC                 \ Print recursive text token 80 + YC, so as YC goes from
 CLC                    \ 16 to 19, this prints "FRONT", "REAR", "LEFT" and
 ADC #80                \ "RIGHT"
 JSR TT27

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _MASTER_VERSION OR _ELITE_A_VERSION \ Tube

 INC YC                 \ Move the text cursor down a row, and increment the
                        \ counter in YC at the same time

ELIF _6502SP_VERSION OR _C64_VERSION

 JSR INCYC              \ Move the text cursor down a row, and increment the
                        \ counter in YC at the same time

ELIF _APPLE_VERSION

IF _IB_DISK OR _4AM_CRACK

 INC YC                 \ Move the text cursor down a row, and increment the
                        \ counter in YC at the same time

ELIF _SOURCE_DISK

 JSR INCYC              \ Move the text cursor down a row, and increment the
                        \ counter in YC at the same time

ENDIF

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDY YC                 \ Update Y with the incremented counter in YC

 CPY #20                \ If Y < 20 then loop back up to qv1 to print the next
 BCC qv1                \ view in the menu

ELIF _ELITE_A_VERSION

 LDA new_mounts         \ Set A = new_mounts + 16, so A now contains a value of
 ORA #16                \ 17, 18 or 20, depending on the number of laser mounts
                        \ that our current ship supports (in other words, it's
                        \ one more than the corresponding value in the YC
                        \ counter, which is going from 16 to 19, not 17 to 20)

 CMP YC                 \ If the loop counter in YC hasn't yet reached the
 BNE qv1                \ value in A, then loop back up to qv1 to print the next
                        \ view in the menu, so this loops us back until we have
                        \ printed all of the laser mounts defined by the value
                        \ of new_mounts

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

.qv3

ENDIF

IF NOT(_APPLE_VERSION)

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

ELIF _APPLE_VERSION

 JSR CLYNS              \ Clear two text rows at the bottom of the screen, and
                        \ move the text cursor to the first cleared row

ENDIF

.qv2

 LDA #175               \ Print recursive text token 15 ("VIEW ") followed by
 JSR prq                \ a question mark

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A (and X)

 SEC                    \ Subtract ASCII "0" from the key pressed, to leave the
 SBC #'0'               \ numeric value of the key in A (if it was a number key)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CMP #4                 \ If the number entered in A >= 4, then it is not a
 BCS qv3                \ valid view number, so jump back to qv3 to try again

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION OR _C64_VERSION

 CMP #4                 \ If the number entered in A < 4, then it is a valid
 BCC qv3                \ view number, so jump down to qv3 as we are done

 JSR CLYNS              \ Otherwise we didn't get a valid view number, so clear
                        \ the bottom three text rows of the upper screen, and
                        \ move the text cursor to column 1 on row 21

 JMP qv2                \ Jump back to qv2 to try again

.qv3

ELIF _APPLE_VERSION

 CMP #4                 \ If the number entered in A < 4, then it is a valid
 BCC qv3                \ view number, so jump down to qv3 as we are done

 JSR CLYNS              \ Otherwise we didn't get a valid view number, so clear
                        \ two text rows at the bottom of the screen, and
                        \ move the text cursor to column 1 on row 21

 JMP qv2                \ Jump back to qv2 to try again

.qv3

ELIF _ELITE_A_VERSION

 CMP new_mounts         \ If A < new_mounts, then our current ship supports this
 BCC qv3                \ view number, so jump down to qv3 as we are done

 JSR CLYNS              \ Otherwise we didn't get a valid view number, so clear
                        \ the bottom three text rows of the upper screen, and
                        \ move the text cursor to column 1 on row 21

 JMP qv2                \ Jump back to qv2 to try again

.qv3

ENDIF

 TAX                    \ We have a valid view number, so transfer it to X

 RTS                    \ Return from the subroutine

