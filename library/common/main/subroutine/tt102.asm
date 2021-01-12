\ ******************************************************************************
\
\       Name: TT102
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process function key, save, hyperspace and chart key presses
\
\ ------------------------------------------------------------------------------
\
\ Process function key presses, plus "@" (save commander), "H" (hyperspace),
\ "D" (show distance to system) and "O" (move chart cursor back to current
\ system). We can also pass cursor position deltas in X and Y to indicate that
\ the cursor keys or joystick have been used (i.e. the values that are returned
\ by routine TT17).
\
\ Arguments:
\
\   A                   The internal key number of the key pressed (see p.142 of
\                       the Advanced User Guide for a list of internal key
\                       numbers)
\
\   X                   The amount to move the crosshairs in the x-axis
\
\   Y                   The amount to move the crosshairs in the y-axis
\
IF _6502SP_VERSION
\ Other entry points:
\
\   T95                 Print the distance to the selected system
\
ENDIF
\ ******************************************************************************

.TT102

 CMP #f8                \ If red key f8 was pressed, jump to STATUS to show the
 BNE P%+5               \ Status Mode screen, returning from the subroutine
 JMP STATUS             \ using a tail call

 CMP #f4                \ If red key f4 was pressed, jump to TT22 to show the
 BNE P%+5               \ Long-range Chart, returning from the subroutine using
 JMP TT22               \ a tail call

 CMP #f5                \ If red key f5 was pressed, jump to TT23 to show the
 BNE P%+5               \ Short-range Chart, returning from the subroutine using
 JMP TT23               \ a tail call

 CMP #f6                \ If red key f6 was pressed, call TT111 to select the
 BNE TT92               \ system nearest to galactic coordinates (QQ9, QQ10)
 JSR TT111              \ (the location of the chart crosshairs) and jump to
 JMP TT25               \ TT25 to show the Data on System screen, returning
                        \ from the subroutine using a tail call

.TT92

 CMP #f9                \ If red key f9 was pressed, jump to TT213 to show the
 BNE P%+5               \ Inventory screen, returning from the subroutine
 JMP TT213              \ using a tail call

 CMP #f7                \ If red key f7 was pressed, jump to TT167 to show the
 BNE P%+5               \ Market Price screen, returning from the subroutine
 JMP TT167              \ using a tail call

 CMP #f0                \ If red key f0 was pressed, jump to TT110 to launch our
 BNE fvw                \ ship (if docked), returning from the subroutine using
 JMP TT110              \ a tail call

.fvw

 BIT QQ12               \ If bit 7 of QQ12 is clear (i.e. we are not docked, but
 BPL INSP               \ in space), jump to INSP to skip the following checks
                        \ for f1-f3 and "@" (save commander file) key presses

 CMP #f3                \ If red key f3 was pressed, jump to EQSHP to show the
 BNE P%+5               \ Equip Ship screen, returning from the subroutine using
 JMP EQSHP              \ a tail call

 CMP #f1                \ If red key f1 was pressed, jump to TT219 to show the
 BNE P%+5               \ Buy Cargo screen, returning from the subroutine using
 JMP TT219              \ a tail call

IF _CASSETTE_VERSION OR _DISC_VERSION

 CMP #&47               \ If "@" was pressed, jump to SVE to save the commander
 BNE P%+5               \ file, returning from the subroutine using a tail call
 JMP SVE

ELIF _6502SP_VERSION

 CMP #&47               \ If "@" was not pressed, skip to nosave
 BNE nosave

 JSR SVE                \ "@" was pressed, so call SVE to show the disc menu

 BCC P%+5               \ If the C flag was set by SVE, then we loaded a new
 JMP QU5                \ commander file, so jump to QU5 to restart the game
                        \ with the newly loaded commander

 JMP BAY                \ Otherwise the C flag was clear, so jump to BAY to go
                        \ to the docking bay (i.e. show the Status Mode screen)

.nosave

ENDIF

 CMP #f2                \ If red key f2 was pressed, jump to TT208 to show the
 BNE LABEL_3            \ Sell Cargo screen, returning from the subroutine using
 JMP TT208              \ a tail call

.INSP

 CMP #f1                \ If the key pressed is < red key f1 or > red key f3,
 BCC LABEL_3            \ jump to LABEL_3 (so only do the following if the key
 CMP #f3+1              \ pressed is f1, f2 or f3)
 BCS LABEL_3

 AND #3                 \ If we get here then we are either in space, or we are
 TAX                    \ docked and none of f1-f3 were pressed, so we can now
 JMP LOOK1              \ process f1-f3 with their in-flight functions, i.e.
                        \ switching space views
                        \
                        \ A will contain &71, &72 or &73 (for f1, f2 or f3), so
                        \ set X to the last digit (1, 2 or 3) and jump to LOOK1
                        \ to switch to view X (back, left or right), returning
                        \ from the subroutine using a tail call

.LABEL_3

IF _6502SP_VERSION

                        \ In the 6502 Second Processor version, the LABEL_3
                        \ label is actually `` (two backticks), but that doesn't
                        \ compile in BeebAsm and it's pretty cryptic, so instead
                        \ this version sticks with the label LABEL_3 from the
                        \ cassette version

ENDIF

 CMP #&54               \ If "H" was pressed, jump to hyp to do a hyperspace
 BNE P%+5               \ jump (if we are in space), returning from the
 JMP hyp                \ subroutine using a tail call

IF _6502SP_VERSION

.NWDAV5

ENDIF

 CMP #&32               \ If "D" was pressed, jump to T95 to print the distance
 BEQ T95                \ to a system (if we are in one of the chart screens)

IF _6502SP_VERSION

 CMP #&43               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems

 LDA QQ12               \ If QQ12 = 0 (we are not docked), we can't search for
 BEQ t95                \ systems, so return from the subroutine (as t95
                        \ contains an RTS)

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ t95                \ t95 contains an RTS)

 JMP HME2               \ Jump to HME2 to let us search for a system, returning
                        \ from the subroutine using a tail call

.HME1

ENDIF

 STA T1                 \ Store A (the key that's been pressed) in T1

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise jump down to TT107 to skip the
 BEQ TT107              \ following

 LDA QQ22+1             \ If the on-screen hyperspace counter is non-zero,
 BNE TT107              \ then we are already counting down, so jump to TT107
                        \ to skip the following

 LDA T1                 \ Restore the original value of A (the key that's been
                        \ pressed) from T1

 CMP #&36               \ If "O" was pressed, do the following three JSRs,
 BNE ee2                \ otherwise jump to ee2 to skip the following

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

 JSR ping               \ Set the target system to the current system (which
                        \ will move the location in (QQ9, QQ10) to the current
                        \ home system

IF _CASSETTE_VERSION OR _DISC_VERSION

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

ELIF _6502SP_VERSION

 JMP TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system, and return from the subroutine using a tail
                        \ call

ENDIF

.ee2

 JSR TT16               \ Call TT16 to move the crosshairs by the amount in X
                        \ and Y, which were passed to this subroutine as
                        \ arguments

.TT107

 LDA QQ22+1             \ If the on-screen hyperspace counter is zero, return
 BEQ t95                \ from the subroutine (as t95 contains an RTS), as we
                        \ are not currently counting down to a hyperspace jump

 DEC QQ22               \ Decrement the internal hyperspace counter

 BNE t95                \ If the internal hyperspace counter is still non-zero,
                        \ then we are still counting down, so return from the
                        \ subroutine (as t95 contains an RTS)

                        \ If we get here then the internal hyperspace counter
                        \ has just reached zero and it wasn't zero before, so
                        \ we need to reduce the on-screen counter and update
                        \ the screen. We do this by first printing the next
                        \ number in the countdown sequence, and then printing
                        \ the old number, which will erase the old number
                        \ and display the new one because printing uses EOR
                        \ logic

 LDX QQ22+1             \ Set X = the on-screen hyperspace counter - 1
 DEX                    \ (i.e. the next number in the sequence)

 JSR ee3                \ Print the 8-bit number in X at text location (0, 1)

 LDA #5                 \ Reset the internal hyperspace counter to 5
 STA QQ22

 LDX QQ22+1             \ Set X = the on-screen hyperspace counter (i.e. the
                        \ current number in the sequence, which is already
                        \ shown on-screen)

 JSR ee3                \ Print the 8-bit number in X at text location (0, 1),
                        \ i.e. print the hyperspace countdown in the top-left
                        \ corner

 DEC QQ22+1             \ Decrement the on-screen hyperspace countdown

 BNE t95                \ If the countdown is not yet at zero, return from the
                        \ subroutine (as t95 contains an RTS)

 JMP TT18               \ Otherwise the countdown has finished, so jump to TT18
                        \ to do a hyperspace jump, returning from the subroutine
                        \ using a tail call

.t95

 RTS                    \ Return from the subroutine

.T95

                        \ If we get here, "D" was pressed, so we need to show
                        \ the distance to the selected system (if we are in a
                        \ chart view)

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ t95                \ t95 contains an RTS)

IF _6502SP_VERSION

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

ENDIF

 JSR hm                 \ Call hm to move the crosshairs to the target system
                        \ in (QQ9, QQ10), returning with A = 0

 STA QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

 JSR cpl                \ Print control code 3 (the selected system name)

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case, with the
 STA QQ17               \ next letter in capitals

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA #1                 \ Move the text cursor to column 1 and down one line
 STA XC                 \ (in other words, to the start of the next line)
 INC YC

ELIF _6502SP_VERSION

 LDA #10                \ Print a line feed to move the text cursor down a line
 JSR TT26

 LDA #1                 \ Move the text cursor to column 1
 JSR DOXC

 JSR INCYC              \ Move the text cursor down one line

ENDIF

 JMP TT146              \ Print the distance to the selected system and return
                        \ from the subroutine using a tail call

