\ ******************************************************************************
\
\       Name: LOADSCR
\       Type: Subroutine
\   Category: Loader
\    Summary: Show the mode 7 Acornsoft loading screen
\
\ ******************************************************************************

.LOADSCR

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) - (PROT1 - ECHAR)
 SEC                    \             = PROT1 - PROT1 + ECHAR
 SBC #LO(PROT1 - ECHAR) \             = ECHAR
 STA ZP
 LDA ZP+1
 SBC #HI(PROT1 - ECHAR)
 STA ZP+1

 LDX #0                 \ Set S = 0, to use as a flag denoting whether this is a
 STX S                  \ BBC Micro (0) or an Electron (&FF)

 LDY #&FF               \ Call OSBYTE with A = 129, X = 0 and Y = &FF to detect
 LDA #129               \ the machine type, which returns the following:
 JSR OSBYTE             \
                        \   * X = 1 if this is an Electron

 CPX #1                 \ If X <> 1 then this is not an Electron, so jump to bbc
 BNE bbc                \ to skip the following

 DEC S                  \ Decrement S to &FF, to denote that this is an Acorn
                        \ Electron

                        \ We now define a character set consisting of "fake"
                        \ mode 7 graphics characters so the Electron can print
                        \ its own version of the Acornsoft loading screen
                        \ despite not having the BBC Micro's teletext mode 7
                        \
                        \ The command to define a character is as follows:
                        \
                        \   VDU 23, n, b0, b1, b2, b3, b4, b5, b6, b7
                        \
                        \ where n is the character number and b0 through b7 are
                        \ the bytes for each pixel row in the character (there
                        \ are 8 rows of 8 pixels in a character)
                        \
                        \ So in the following, we perform the above command
                        \ for each character using the values from the ECHAR
                        \ table

 LDY #0                 \ Set Y to act as an index into the table at ECHAR

.eloop

 LDX #7                 \ Set a counter in X for the 8 bytes we need to print
                        \ from the table for each character definition (one byte
                        \ per pixel row)

 LDA #23                \ Print character 23 (i.e. VDU 23)
 JSR OSWRCH

 TYA                    \ We will increase Y by 8 for each character, so this
 LSR A                  \ sets A = Y / 8 to give the character number, starting
 LSR A                  \ from 0 and counting up by 1 for each new character
 LSR A

 ORA #&E0               \ This adds &E0 to A, so our new character set starts
                        \ with character number &E0, then character number &E1,
                        \ and so on

 JSR OSWRCH             \ Print the character number (so we have now done the
                        \ VDU 23, n part of the command)

.vloop

 LDA (ZP),Y             \ Print the Y-th byte from the ECHAR table (we set ZP to
 JSR OSWRCH             \ point to ECHAR above)

 INY                    \ Increment the index to point to the next byte in the
                        \ table

 DEX                    \ Decrement the byte counter

 BPL vloop              \ Loop back until we have printed 8 characters

 CPY #224               \ Loop back to do the next VDU 23 command until we have
 BNE eloop              \ printed out the whole table

.bbc

                        \ We now print the Acornsoft loading screen background
                        \ using mode 7 graphics (for the BBC Micro) or the
                        \ "fake" characters we just defined (for the Electron
                        \ version)

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) + LOGO - ECHAR
 CLC                    \             = ECHAR + LOGO - ECHAR
 ADC #(LOGO - ECHAR)    \             = LOGO
 STA ZP
 BCC P%+4
 INC ZP+1

 LDA #22                \ Switch to mode 7 using a VDU 22, 7 command
 JSR OSWRCH
 LDA #7
 JSR OSWRCH

.jsr1

 JSR prstr - PROT1      \ Call prstr to print the following characters,
                        \ restarting from the NOP instruction (this destination
                        \ address is modified by the code above that adds PROT1
                        \ to the address)

 EQUB 23, 0, 10, 32     \ Set 6845 register R10 = %00100000 = 32
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "cursor start" register, and bits 5 and 6
                        \ define the "cursor display mode", as follows:
                        \
                        \   * %00 = steady, non-blinking cursor
                        \
                        \   * %01 = do not display a cursor
                        \
                        \   * %10 = fast blinking cursor (blink at 1/16 of the
                        \           field rate)
                        \
                        \   * %11 = slow blinking cursor (blink at 1/32 of the
                        \           field rate)
                        \
                        \ We can therefore turn off the cursor completely by
                        \ setting cursor display mode %01, with bit 6 of R10
                        \ clear and bit 5 of R10 set

 NOP                    \ Marks the end of the VDU block

 LDA #145               \ Set T to teletext control code 145 (Red graphics) to
 STA T                  \ specify that the first Acornsoft is red

.jsr2

 JSR jsr6 - PROT1       \ Call jsr6, which calls jsr7, which calls LOGOS (this
                        \ destination address is modified by the code above that
                        \ adds PROT1 to the address)

IF _DISC_VERSION \ Platform

 BIT S                  \ If bit 7 of S is set (this is an Electron), jump to
 BMI jsr5               \ jsr5

.jsr4

                        \ If we get here then this is a BBC Micro, so we can
                        \ show the game's name in the mode 7 screen

ELIF _ELECTRON_VERSION

 BIT S                  \ If bit 7 of S is set (this is an Electron), jump to
 BMI jsr4               \ jsr4

.jsr3

                        \ If we get here then this is a BBC Micro, so we can
                        \ show the game's name in the mode 7 screen

 JSR prstr - PROT1      \ Call prstr to print the following characters,
                        \ restarting from the NOP instruction (this destination
                        \ address is modified by the code above that adds PROT1
                        \ to the address)

 EQUB 28                \ Define a text window as follows:
 EQUB 15, 13, 23, 10    \
                        \   * Left = 15
                        \   * Right = 23
                        \   * Top = 10
                        \   * Bottom = 13
                        \
                        \ i.e. 3 rows high, 8 columns wide at (15, 10)

 EQUB 12                \ Clear the text area

 EQUB 10                \ Move the cursor down one row

 EQUB 135               \ Teletext control code 135 (Select white text)

 EQUB 141               \ Teletext control code 141 (Double height)

 EQUS "ELITE"           \ The top half of the game's name

 EQUB 140               \ Teletext control code 140 (Turn off double height)

 EQUB 146               \ Teletext control code 146 (Select green graphics)

 EQUB 135               \ Teletext control code 135 (Select white text)

 EQUB 141               \ Teletext control code 141 (Double height)

 EQUS "ELITE"           \ The bottom half of the game's name

 EQUB 28                \ Define a text window as follows:
 EQUB 9, 23, 31, 20    \
                        \   * Left = 9
                        \   * Right = 31
                        \   * Top = 20
                        \   * Bottom = 23
                        \
                        \ i.e. 3 rows high, 22 columns wide at (9, 20)

 EQUB 135               \ Teletext control code 135 (Select white text)

 EQUB 13                \ Move the cursor down one row
 EQUB 10

 EQUB 8                 \ Backspace cursor one character

 EQUB 148               \ Teletext control code 148 (Select blue graphics)

 EQUB 135               \ Teletext control code 135 (Select white text)

 EQUB 13                \ Move the cursor down one row
 EQUB 10

 EQUB 8                 \ Backspace cursor one character

 EQUB 148               \ Teletext control code 148 (Select blue graphics)

 EQUB 135               \ Teletext control code 135 (Select white text)

 EQUB 8                 \ Backspace cursor one character

 EQUB 8                 \ Backspace cursor one character

 EQUB 10                \ Move the cursor down one row

 EQUB 148               \ Teletext control code 148 (Select blue graphics)

 EQUB 28                \ Define a text window as follows:
 EQUB 10, 22, 30, 20    \
                        \   * Left = 10
                        \   * Right = 30
                        \   * Top = 20
                        \   * Bottom = 22
                        \
                        \ i.e. 2 rows high, 20 columns wide at (10, 20)

 EQUB 12                \ Clear the text area to create a window for the loading
                        \ progress

 NOP                    \ Marks the end of the VDU block

 RTS                    \ Return from the PROT1 subroutine

.jsr4

                        \ If we get here then this is an Electron

ENDIF

 JSR prstr - PROT1      \ Call prstr to print the following characters,
                        \ restarting from the NOP instruction (this destination
                        \ address is modified by the code above that adds PROT1
                        \ to the address)

IF _DISC_VERSION \ Platform

 EQUB 28                \ Define a text window as follows:
 EQUB 13, 13, 25, 10    \
                        \   * Left = 13
                        \   * Right = 25
                        \   * Top = 10
                        \   * Bottom = 13
                        \
                        \ i.e. 3 rows high, 12 columns wide at (13, 10)

 EQUB 12                \ Clear the text area

 EQUB 10                \ Move the cursor down one row

 EQUB 135               \ Teletext control code 135 (Select white text)

 EQUB 141               \ Teletext control code 141 (Double height)

 EQUS "E L I T E"       \ The top half of the game's name

 EQUB 140               \ Teletext control code 140 (Turn off double height)

 EQUB 146               \ Teletext control code 146 (Select green graphics)

 EQUB 135               \ Teletext control code 135 (Select white text)

 EQUB 141               \ Teletext control code 141 (Double height)

 EQUS "E L I T E"       \ The bottom half of the game's name

 NOP                    \ Marks the end of the VDU block

 RTS                    \ Return from the PROT1 subroutine

 EQUS "      "          \ These bytes appear to be unused
 EQUB 140, 146
 EQUB 135, 141
 EQUS "      "
 EQUS "      "
 EQUS "      "
 EQUS "      "
 EQUS "      "
 NOP
 RTS

ELIF _ELECTRON_VERSION

 EQUB 28                \ Define a text window as follows:
 EQUB 15, 12, 23, 10    \
                        \   * Left = 15
                        \   * Right = 23
                        \   * Top = 10
                        \   * Bottom = 12
                        \
                        \ i.e. 2 rows high, 8 columns wide at (15, 10)

 EQUB 12                \ Clear text area

 EQUB 26                \ Restore default windows

 EQUB 31, 17, 11        \ Move text cursor to (17, 11)

 EQUS "ELITE"           \ The game name

 NOP                    \ Marks the end of the VDU block

ENDIF

.jsr5

                        \ If we get here then this is an Electron

 JSR prstr - PROT1      \ Call prstr to print the following characters,
                        \ restarting from the NOP instruction (this destination
                        \ address is modified by the code above that adds PROT1
                        \ to the address)

IF _DISC_VERSION \ Platform

 EQUB 28                \ Define a text window as follows:
 EQUB 13, 12, 25, 10    \
                        \   * Left = 13
                        \   * Right = 25
                        \   * Top = 10
                        \   * Bottom = 12
                        \
                        \ i.e. 2 rows high, 12 columns wide at (13, 10)

 EQUB 12                \ Clear the text area

 EQUB 26                \ Restore default windows

 EQUB 31, 15, 11        \ Move text cursor to 15, 11

 EQUS "E L I T E"       \ The name of the game

 NOP                    \ Marks the end of the VDU block

 RTS                    \ Return from the PROT1 subroutine

 EQUS "         "       \ These bytes appear to be unused
 EQUS "          "
 NOP
 RTS

ELIF _ELECTRON_VERSION

 EQUB 28                \ Define a text window as follows:
 EQUB 10, 22, 30, 20    \
                        \   * Left = 10
                        \   * Right = 30
                        \   * Top = 20
                        \   * Bottom = 22
                        \
                        \ i.e. 2 rows high, 20 columns wide at (10, 20)

IF _DISC

 EQUB 0                 \ If this is the disc version then do nothing, so we
                        \ don't show a window for the loading progress

ELSE

 EQUB 12                \ If this is the cassette version then clear the text
                        \ area to create a window for the loading progress

ENDIF

 NOP                    \ Marks the end of the VDU block

 RTS                    \ Return from the PROT1 subroutine

ENDIF

.jsr6

 JSR jsr7 - PROT1       \ Call jsr7 (this destination address is modified by the
                        \ code above that adds PROT1 to the address). This calls
                        \ the LOGOS routine twice to print two Acornsoft logos,
                        \ with a newline between then

 JSR OSNEWL             \ Print two newlines
 JSR OSNEWL

.jsr7

 JSR LOGOS - PROT1      \ Call LOGOS (this destination address is modified by
                        \ the code above that adds PROT1 to the address). This
                        \ prints a third Acornsoft logo

 JSR OSNEWL             \ Print a newline

                        \ Fall through into LOGOS to print a fourth Acornsoft
                        \ logo and return from the subroutine using a tail call

