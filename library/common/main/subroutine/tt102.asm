\ ******************************************************************************
\
\       Name: TT102
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process function key, save key, hyperspace and chart key presses
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Comment
\             and update the hyperspace counter
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Process function key presses, plus "@" (save commander), "H" (hyperspace),
\ "D" (show distance to system) and "O" (move chart cursor back to current
\ system). We can also pass cursor position deltas in X and Y to indicate that
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ the cursor keys or joystick have been used (i.e. the values that are returned
\ by routine TT17).
ELIF _ELECTRON_VERSION
\ the cursor keys have been used (i.e. the values that are returned by routine
\ TT17).
ENDIF
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\
\ This routine also checks for the "F" key press (search for a system), which
\ applies to enhanced versions only.
ENDIF
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   A                   The internal key number of the key pressed (see p.142 of
\                       the Advanced User Guide for a list of internal key
\                       numbers)
ELIF _ELECTRON_VERSION
\   A                   The internal key number of the key pressed (see p.40 of
\                       the Electron Advanced User Guide for a list of internal
\                       key numbers)
ENDIF
\
\   X                   The amount to move the crosshairs in the x-axis
\
\   Y                   The amount to move the crosshairs in the y-axis
\
\ Other entry points:
\
IF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA
\   BAD                 Work out how bad we are from the amount of contraband in
\                       our hold
\
ENDIF
\   T95                 Print the distance to the selected system
\
IF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA
\   TT107               Progress the countdown of the hyperspace counter
\
ENDIF
\ ******************************************************************************

IF _ELECTRON_VERSION \ Platform

.VKEYS

 EQUB func2             \ The key to press for showing view 1 (back)

 EQUB func3             \ The key to press for showing view 2 (left)

 EQUB func4             \ The key to press for showing view 3 (right)

ENDIF

.TT102

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 CMP #f8                \ If red key f8 was pressed, jump to STATUS to show the
 BNE P%+5               \ Status Mode screen, returning from the subroutine
 JMP STATUS             \ using a tail call

 CMP #f4                \ If red key f4 was pressed, jump to TT22 to show the
 BNE P%+5               \ Long-range Chart, returning from the subroutine using
 JMP TT22               \ a tail call

 CMP #f5                \ If red key f5 was pressed, jump to TT23 to show the
 BNE P%+5               \ Short-range Chart, returning from the subroutine using
 JMP TT23               \ a tail call

ELIF _ELECTRON_VERSION

 CMP #func9             \ If FUNC-9 was pressed, jump to STATUS to show the
 BNE P%+5               \ Status Mode screen, returning from the subroutine
 JMP STATUS             \ using a tail call

 CMP #func5             \ If FUNC-5 was pressed, jump to TT22 to show the
 BNE P%+5               \ Long-range Chart, returning from the subroutine using
 JMP TT22               \ a tail call

 CMP #func6             \ If FUNC-6 was pressed, jump to TT23 to show the
 BNE P%+5               \ Short-range Chart, returning from the subroutine using
 JMP TT23               \ a tail call

ELIF _ELITE_A_ENCYCLOPEDIA

 CMP #f8                \ If red key f8 was pressed, jump to info_menu to show
 BNE P%+5               \ the Encyclopedia screen, returning from the subroutine
 JMP info_menu          \ using a tail call

 CMP #f4                \ If red key f4 was pressed, jump to TT22 to show the
 BNE P%+5               \ Long-range Chart, returning from the subroutine using
 JMP TT22               \ a tail call

 CMP #f5                \ If red key f5 was pressed, jump to TT23 to show the
 BNE P%+5               \ Short-range Chart, returning from the subroutine using
 JMP TT23               \ a tail call

ENDIF

IF _CASSETTE_VERSION \ Comment

 CMP #f6                \ If red key f6 was pressed, call TT111 to select the
 BNE TT92               \ system nearest to galactic coordinates (QQ9, QQ10)
 JSR TT111              \ (the location of the chart crosshairs) and jump to
 JMP TT25               \ TT25 to show the Data on System screen, returning
                        \ from the subroutine using a tail call

ELIF _ELECTRON_VERSION

 CMP #func7             \ If FUNC-7 was pressed, call TT111 to select the
 BNE TT92               \ system nearest to galactic coordinates (QQ9, QQ10)
 JSR TT111              \ (the location of the chart crosshairs) and jump to
 JMP TT25               \ TT25 to show the Data on System screen, returning
                        \ from the subroutine using a tail call

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 CMP #f6                \ If red key f6 was pressed, call TT111 to select the
 BNE TT92               \ system nearest to galactic coordinates (QQ9, QQ10)
 JSR TT111              \ (the location of the chart crosshairs) and set ZZ to
 JMP TT25               \ the system number, and then jump to TT25 to show the
                        \ Data on System screen (along with an extended system
                        \ description for the system in ZZ if we're docked),
                        \ returning from the subroutine using a tail call

ELIF _ELITE_A_ENCYCLOPEDIA

 CMP #f6                \ If red key f6 was not pressed, jump to TT92 to check
 BNE TT92               \ for the next key

 JSR CTRL               \ Red key f6 was pressed, so check whether CTRL was
 BPL jump_data          \ also pressed, and if it wasn't pressed, jump to
                        \ jump_data to skip the following instruction

 JMP launch             \ CTRL-f6 was pressed, so jump to launch to load and run
                        \ the main docked code (i.e. to exit the encyclopedia)

.jump_data

 JSR TT111              \ Red key f6 was pressed on its own, so call TT111 to
                        \ select the system nearest to galactic coordinates
                        \ (QQ9, QQ10) (the location of the chart crosshairs) and
                        \ set ZZ to the system number

 JMP TT25               \ Jump to TT25 to show the Data on System screen, along
                        \ with an extended system description for the system in
                        \ ZZ, returning from the subroutine using a tail call

ENDIF

.TT92

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 CMP #f9                \ If red key f9 was pressed, jump to TT213 to show the
 BNE P%+5               \ Inventory screen, returning from the subroutine
 JMP TT213              \ using a tail call

 CMP #f7                \ If red key f7 was pressed, jump to TT167 to show the
 BNE P%+5               \ Market Price screen, returning from the subroutine
 JMP TT167              \ using a tail call

ELIF _ELECTRON_VERSION

 CMP #func0             \ If FUNC-0 was pressed, jump to TT213 to show the
 BNE P%+5               \ Inventory screen, returning from the subroutine
 JMP TT213              \ using a tail call

 CMP #func8             \ If FUNC-8 was pressed, jump to TT167 to show the
 BNE P%+5               \ Market Price screen, returning from the subroutine
 JMP TT167              \ using a tail call

ELIF _ELITE_A_ENCYCLOPEDIA

 CMP #f9                \ If red key f9 was pressed, jump to info_menu to show
 BNE not_invnt          \ the Encyclopedia screen, returning from the subroutine
 JMP info_menu          \ using a tail call

.not_invnt

 CMP #f7                \ If red key f7 was pressed, jump to info_menu to show
 BNE not_price          \ the Encyclopedia screen, returning from the subroutine
 JMP info_menu          \ using a tail call

.not_price

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _ELITE_A_FLIGHT \ Comment

 CMP #f0                \ If red key f0 was pressed, jump to TT110 to launch our
 BNE fvw                \ ship (if docked), returning from the subroutine using
 JMP TT110              \ a tail call

ELIF _ELECTRON_VERSION

 CMP #func1             \ If FUNC-1 was pressed, jump to TT110 to launch our
 BNE fvw                \ ship (if docked), returning from the subroutine using
 JMP TT110              \ a tail call

ELIF _ELITE_A_DOCKED

 CMP #f0                \ If red key f0 was not pressed, jump to fvw to check
 BNE fvw                \ for the next key

 JSR CTRL               \ Red key f0 was pressed, so check whether CTRL was
 BMI jump_stay          \ also pressed, and if so, jump to jump_stay to skip the
                        \ following instruction

 JMP TT110              \ Red key f0 was pressed on its own, so jump to TT110 to
                        \ launch our ship, returning from the subroutine using a
                        \ tail call

.jump_stay

 JMP stay_here          \ CTRL-f0 was pressed, so jump to stay_here to pay the
                        \ docking fee and refresh prices

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

.fvw

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 BIT QQ12               \ If bit 7 of QQ12 is clear (i.e. we are not docked, but
 BPL INSP               \ in space), jump to INSP to skip the following checks
                        \ for f1-f3 and "@" (save commander file) key presses

ELIF _ELECTRON_VERSION

 BIT QQ12               \ If bit 7 of QQ12 is clear (i.e. we are not docked, but
 BPL INSP               \ in space), jump to INSP to skip the following checks
                        \ for FUNC-2 to FUNC-4 and "@" (save commander file) key
                        \ presses

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION \ Platform

 CMP #f3                \ If red key f3 was pressed, jump to EQSHP to show the
 BNE P%+5               \ Equip Ship screen, returning from the subroutine using
 JMP EQSHP              \ a tail call

 CMP #f1                \ If red key f1 was pressed, jump to TT219 to show the
 BNE P%+5               \ Buy Cargo screen, returning from the subroutine using
 JMP TT219              \ a tail call

ELIF _ELECTRON_VERSION

 CMP #func4             \ If FUNC-4 was pressed, jump to EQSHP to show the
 BNE P%+5               \ Equip Ship screen, returning from the subroutine using
 JMP EQSHP              \ a tail call

 CMP #func2             \ If FUNC-2 was pressed, jump to TT219 to show the
 BNE P%+5               \ Buy Cargo screen, returning from the subroutine using
 JMP TT219              \ a tail call

ENDIF

IF _CASSETTE_VERSION \ Enhanced: Group A: Pressing "@" brings up the disc access menu in the enhanced versions

 CMP #&47               \ If "@" was pressed, jump to SVE to save the commander
 BNE P%+5               \ file, returning from the subroutine using a tail call
 JMP SVE

ELIF _ELECTRON_VERSION

 CMP #&48               \ If "@" was pressed, jump to SVE to save the commander
 BNE P%+5               \ file, returning from the subroutine using a tail call
 JMP SVE

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED

 CMP #&47               \ If "@" was not pressed, skip to nosave
 BNE nosave

ELIF _MASTER_VERSION

 CMP #&40               \ If "@" was not pressed, skip to nosave
 BNE nosave

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION \ Enhanced: See group A

 JSR SVE                \ "@" was pressed, so call SVE to show the disc access
                        \ menu

 BCC P%+5               \ If the C flag was set by SVE, then we loaded a new
 JMP QU5                \ commander file, so jump to QU5 to restart the game
                        \ with the newly loaded commander

 JMP BAY                \ Otherwise the C flag was clear, so jump to BAY to go
                        \ to the docking bay (i.e. show the Status Mode screen)

.nosave

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION \ Platform

 CMP #f2                \ If red key f2 was pressed, jump to TT208 to show the
 BNE LABEL_3            \ Sell Cargo screen, returning from the subroutine using
 JMP TT208              \ a tail call

.INSP

ELIF _ELECTRON_VERSION

 CMP #func3             \ If FUNC-3 was pressed, jump to TT208 to show the Sell
 BNE LABEL_3            \ Cargo screen, returning from the subroutine using a
 JMP TT208              \ tail call

.INSP

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

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
                        \ to switch to view X (rear, left or right), returning
                        \ from the subroutine using a tail call

ELIF _ELECTRON_VERSION

 STX T                  \ Store X in T so we can retrieve it after the following

 LDX #3                 \ We are about to loop through the key presses for the
                        \ four views, so set a counter in X, starting with a
                        \ value of X = 3 (for the right view)

.LOOKL

 CMP VKEYS-1,X          \ If the key pressed does not match the value in VKEYS
 BNE P%+5               \ for view X, skip the following instruction

 JMP LOOK1              \ The key pressed matches the key in position X, so jump
                        \ to LOOK1 to switch to view X (rear, left or right),
                        \ returning from the subroutine using a tail call

 DEX                    \ Decrement the view number in X, so we start with view
                        \ 3 (right), then work backwards through 2 (left) and
                        \ 1 (rear)

 BNE LOOKL              \ Loop back to check the next key until we have checked
                        \ for f3, f2 and f1

 LDX T                  \ Fetch the value of X that we stored in T above

ELIF _MASTER_VERSION

 CMP #f1                \ If red key f1 was pressed, jump to BVIEW
 BEQ chview1

 CMP #f2                \ If red key f2 was pressed, jump to LVIEW
 BEQ chview2

 CMP #f3                \ If red key f3 was not pressed, jump to LABEL_3 to keep
 BNE LABEL_3            \ checking for which key was pressed

 LDX #3                 \ Red key f3 was pressed, so set the view number in X to
                        \ 3 for the right view

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &02, or BIT &02A2, which does nothing apart
                        \ from affect the flags

.chview2

 LDX #2                 \ If we jump to here, red key f2 was pressed, so set the
                        \ view number in X to 2 for the left view

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &01, or BIT &02A2, which does nothing apart
                        \ from affect the flags

.chview1

 LDX #1                 \ If we jump to here, red key f1 was pressed, so set the
                        \ view number in X to 1 for the rear view

 JMP LOOK1              \ Jump to LOOK1 to switch to view X (rear, left or
                        \ right), returning from the subroutine using a tail
                        \ call

ELIF _ELITE_A_ENCYCLOPEDIA

 CMP #f0                \ If red key f0 was pressed, jump to jump_menu to show
 BEQ jump_menu          \ the Encyclopedia screen

 CMP #f1                \ If red key f1 was pressed, jump to jump_menu to show
 BEQ jump_menu          \ the Encyclopedia screen

 CMP #f2                \ If red key f2 was pressed, jump to jump_menu to show
 BEQ jump_menu          \ the Encyclopedia screen

 CMP #f3                \ If red key f3 was not pressed, jump to LABEL_3 to
 BNE LABEL_3            \ skip the following and keep checking for other keys

.jump_menu

 JMP info_menu          \ Jump to info_menu to show the Encyclopedia screen

ENDIF

.LABEL_3

IF _6502SP_VERSION \ Label

                        \ In the 6502 Second Processor version, the LABEL_3
                        \ label is actually `` (two backticks), but that doesn't
                        \ compile in BeebAsm and it's pretty cryptic, so instead
                        \ this version sticks with the label LABEL_3 from the
                        \ cassette version

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform: When docked in the disc version, the screen-clearing and DOCKED printing is done here rather than in hyp and hy6, but the code is the same

 CMP #&54               \ If "H" was pressed, jump to hyp to do a hyperspace
 BNE P%+5               \ jump (if we are in space), returning from the
 JMP hyp                \ subroutine using a tail call

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 CMP #&54               \ If "H" was not pressed, jump to NWDAV5 to skip the
 BNE NWDAV5             \ following

 JSR CLYNS              \ "H" was pressed, so clear the bottom three text rows
                        \ of the upper screen, and move the text cursor to
                        \ column 1 on row 21, i.e. the start of the top row of
                        \ the three bottom rows

 LDA #15                \ Move the text cursor to column 15 (the middle of the
 STA XC                 \ screen)

 LDA #205               \ Print extended token 205 ("DOCKED") and return from
 JMP DETOK              \ the subroutine using a tail call

ELIF _MASTER_VERSION

 LDA KL                 \ If "H" was not pressed, jump to NWDAV5 to skip the
 CMP #'H'               \ following
 BNE NWDAV5

 JMP hyp                \ Jump to hyp to do a hyperspace jump (if we are in
                        \ space), returning from the subroutine using a tail
                        \ call

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Label

.NWDAV5

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 CMP #&32               \ If "D" was pressed, jump to T95 to print the distance
 BEQ T95                \ to a system (if we are in one of the chart screens)

ELIF _MASTER_VERSION

 CMP #&44               \ If "D" was pressed, jump to T95 to print the distance
 BEQ T95                \ to a system (if we are in one of the chart screens)

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Enhanced: Group A: Pressing "F" in the enhanced versions when viewing a chart lets us search for systems by name

 CMP #&43               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems

ELIF _MASTER_VERSION

 CMP #&46               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems

ELIF _ELITE_A_FLIGHT

 CMP #&43               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to toggle the compass display

ELIF _ELITE_A_6502SP_PARA

 CMP #&43               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems (when
                        \ docked) or toggle the compass display (when flying)

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDA QQ12               \ If QQ12 = 0 (we are not docked), we can't search for
 BEQ t95                \ systems, so return from the subroutine (as t95
                        \ contains an RTS)

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Enhanced: See group A

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ t95                \ t95 contains an RTS)

 JMP HME2               \ Jump to HME2 to let us search for a system, returning
                        \ from the subroutine using a tail call

.HME1

ELIF _ELITE_A_FLIGHT

 LDA finder             \ Set the value of A to finder, which determines whether
                        \ the compass is configured to show the sun or the
                        \ planet

 EOR #NI%               \ The value of finder is 0 (show the planet) or NI%
                        \ (show the sun), so this toggles the value between the
                        \ two

 STA finder             \ Store the toggled value in finder

 JMP WSCAN              \ Jump to WSCAN to wait for the vertical sync and return
                        \ from the subroutine using a tail call

.HME1

ELIF _ELITE_A_6502SP_PARA

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise jump to n_finder
 BEQ n_finder

 LDA dockedp            \ If dockedp is non-zero, then we are not docked and
 BNE t95                \ can't search for a system, so return from the
                        \ subroutine (as t95 contains an RTS)

 JMP HME2               \ Jump to HME2 to let us search for a system, returning
                        \ from the subroutine using a tail call

.n_finder

 LDA dockedp            \ If dockedp is zero, then we are docked and we can't
 BEQ t95                \ change the compass configuration, so return from the
                        \ subroutine (as t95 contains an RTS)

 LDA finder             \ Set the value of A to finder, which determines whether
                        \ the compass is configured to show the sun or the
                        \ planet

 EOR #NI%               \ The value of finder is 0 (show the planet) or NI%
                        \ (show the sun), so this toggles the value between the
                        \ two

 STA finder             \ Store the toggled value in finder


 JMP WSCAN              \ Jump to WSCAN to wait for the vertical sync and return
                        \ from the subroutine using a tail call

.t95

 RTS                    \ Return from the subroutine

.HME1

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 STA T1                 \ Store A (the key that's been pressed) in T1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Platform

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise jump down to TT107 to skip the
 BEQ TT107              \ following

 LDA QQ22+1             \ If the on-screen hyperspace counter is non-zero,
 BNE TT107              \ then we are already counting down, so jump to TT107
                        \ to skip the following

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise jump down to t95 to return from
 BEQ t95                \ the subroutine

 LDA QQ22+1             \ If the on-screen hyperspace counter is non-zero,
 BNE t95                \ then we are already counting down, so jump down to t95
                        \ to return from the subroutine

ELIF _ELITE_A_FLIGHT

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise jump down to TT107 to skip the
 BEQ TT107              \ following and move on to updating the hyperspace
                        \ counter

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 LDA T1                 \ Restore the original value of A (the key that's been
                        \ pressed) from T1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 CMP #&36               \ If "O" was pressed, do the following three jumps,
 BNE ee2                \ otherwise skip to ee2 to continue

ELIF _MASTER_VERSION

 CMP #&4F               \ If "O" was pressed, do the following three jumps,
 BNE ee2                \ otherwise skip to ee2 to continue

ELIF _ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_ENCYCLOPEDIA

 CMP #&36               \ If "O" was pressed, do the following three jumps,
 BNE not_home           \ otherwise skip to not_home to continue checking key
                        \ presses

ELIF _ELITE_A_6502SP_PARA

 CMP #&36               \ If "O" was pressed, do the following, otherwise skip
 BNE not_home           \ to not_home to continue checking key presses

 LDA QQ11               \ If both bits 6 or 7 of the view number are clear - so
 AND #%11000000         \ this is not the Short-range or Long-range Chart -
 BEQ t95                \ then jump to t95 to return from the subroutine,
                        \ otherwise do the following three jumps

ENDIF

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

 JSR ping               \ Set the target system to the current system (which
                        \ will move the location in (QQ9, QQ10) to the current
                        \ home system

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Other: This might be a bug fix? If "O" is pressed in the advanced versions, then the target system is set to home, and the routine terminates, which is different to the other versions; they stick around for one more move of the cursor, so presumably this fixes a bug where pressing "O" might not always move the cursor exactly to the current system

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 JMP TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system, and return from the subroutine using a tail
                        \ call

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

.ee2

 JSR TT16               \ Call TT16 to move the crosshairs by the amount in X
                        \ and Y, which were passed to this subroutine as
                        \ arguments

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Platform

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

ENDIF

IF _ELITE_A_FLIGHT

.BAD

 LDA QQ20+3             \ Set A to the number of tonnes of slaves in the hold

 CLC                    \ Clear the C flag so we can do addition without the
                        \ C flag affecting the result

 ADC QQ20+6             \ Add the number of tonnes of narcotics in the hold

 ASL A                  \ Double the result and add the number of tonnes of
 ADC QQ20+10            \ firearms in the hold

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

.t95

 RTS                    \ Return from the subroutine

ENDIF

IF _ELITE_A_VERSION

.not_home

 CMP #&21               \ If "W" was pressed, continue on to move the crosshairs
 BNE ee2                \ to the special cargo destination, otherwise skip to
                        \ ee2 to continue

ENDIF

IF _ELITE_A_6502SP_PARA

 LDA QQ11               \ If both bits 6 or 7 of the view number are clear - so
 AND #%11000000         \ this is not the Short-range or Long-range Chart -
 BEQ t95                \ then jump to t95 to return from the subroutine,
                        \ otherwise do the following three jumps

 LDA cmdr_cour          \ If there is no special cargo delivery mission in
 ORA cmdr_cour+1        \ progress, then the mission timer in cmdr_cour(1 0)
 BEQ t95                \ will be zero, so return from the subroutine (as t95
                        \ contains an RTS)

ELIF _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 LDA cmdr_cour          \ If there is no special cargo delivery mission in
 ORA cmdr_cour+1        \ progress, then the mission timer in cmdr_cour(1 0)
 BEQ ee2                \ will be zero, so skip to ee2 to continue

ENDIF

IF _ELITE_A_VERSION

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

 LDA cmdr_courx         \ Set the galactic coordinates in (QQ9, QQ10) to the
 STA QQ9                \ current special cargo delivery destination in
 LDA cmdr_coury         \ (cmdr_courx, cmdr_coury)
 STA QQ10

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

ENDIF

.T95

                        \ If we get here, "D" was pressed, so we need to show
                        \ the distance to the selected system (if we are in a
                        \ chart view)

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ t95                \ t95 contains an RTS)

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

ENDIF

 JSR hm                 \ Call hm to move the crosshairs to the target system
                        \ in (QQ9, QQ10), returning with A = 0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 STA QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

ENDIF

 JSR cpl                \ Print control code 3 (the selected system name)

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_FLIGHT)

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case, with the
 STA QQ17               \ next letter in capitals

ELIF _ELITE_A_DOCKED OR _ELITE_A_FLIGHT

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case, with the next
                        \ letter in capitals

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDA #1                 \ Move the text cursor to column 1 and down one line
 STA XC                 \ (in other words, to the start of the next line)
 INC YC

ELIF _6502SP_VERSION

 LDA #10                \ Print a line feed to move the text cursor down a line
 JSR TT26

 LDA #1                 \ Move the text cursor to column 1
 JSR DOXC

 JSR INCYC              \ Move the text cursor down one line

ELIF _MASTER_VERSION

 LDA #12                \ Print a line feed to move the text cursor down a line
 JSR TT26

ENDIF

 JMP TT146              \ Print the distance to the selected system and return
                        \ from the subroutine using a tail call

IF _ELITE_A_6502SP_PARA

.ee2

 BIT dockedp            \ If bit 7 of dockedp is set, then we are not docked, so
 BMI flying             \ jump to flying

 CMP #f0                \ If red key f0 was not pressed, jump to fvw to check
 BNE fvw                \ for the next key

 JSR CTRL               \ Red key f0 was pressed, so check whether CTRL was
 BMI jump_stay          \ also pressed, and if so, jump to jump_stay to skip the
                        \ following instruction

 JMP RSHIPS             \ Red key f0 was pressed on its own, so jump to RSHIPS
                        \ to launch our ship, returning from the subroutine
                        \ using a tail call

.jump_stay

 JMP stay_here          \ CTRL-f0 was pressed, so jump to stay_here to pay the
                        \ docking fee and refresh prices

.fvw

 CMP #f3                \ If red key f3 was pressed, jump to EQSHP to show the
 BNE P%+5               \ Equip Ship screen, returning from the subroutine using
 JMP EQSHP              \ a tail call

 CMP #f1                \ If red key f1 was pressed, jump to TT219 to show the
 BNE P%+5               \ Buy Cargo screen, returning from the subroutine using
 JMP TT219              \ a tail call

 CMP #&47               \ If "@" was not pressed, skip to nosave
 BNE nosave

 JSR SVE                \ "@" was pressed, so call SVE to show the disc access
                        \ menu

 BCC P%+5               \ If the C flag was set by SVE, then we loaded a new
 JMP QU5                \ commander file, so jump to QU5 to restart the game
                        \ with the newly loaded commander

 JMP BAY                \ Otherwise the C flag was clear, so jump to BAY to go
                        \ to the docking bay (i.e. show the Status Mode screen)

.nosave

 CMP #f2                \ If red key f2 was pressed, jump to TT208 to show the
 BNE not_sell           \ Sell Cargo screen, returning from the subroutine using
 JMP TT208              \ a tail call

.not_sell

 CMP #&54               \ If "H" was not pressed, jump to NWDAV5 to skip the
 BNE NWDAV5             \ following

 JSR CLYNS              \ "H" was pressed, so clear the bottom three text rows
                        \ of the upper screen, and move the text cursor to
                        \ column 1 on row 21, i.e. the start of the top row of
                        \ the three bottom rows

 LDA #15                \ Move the text cursor to column 15 (the middle of the
 STA XC                 \ screen)

 LDA #205               \ Print extended token 205 ("DOCKED") and return from
 JMP DETOK              \ the subroutine using a tail call

.flying

 CMP #&20               \ If "D" was pressed, jump to TT110 to print the
 BNE P%+5               \ distance to a system (if we are in one of the chart
 JMP TT110              \ screens)

 CMP #f1                \ If the key pressed is < red key f1 or > red key f3,
 BCC d_4143             \ jump to d_4143 (so only do the following if the key
 CMP #f3+1              \ pressed is f1, f2 or f3)
 BCS d_4143

 AND #3                 \ If we get here then we are either in space, or we are
 TAX                    \ docked and none of f1-f3 were pressed, so we can now
 JMP LOOK1              \ process f1-f3 with their in-flight functions, i.e.
                        \ switching space views
                        \
                        \ A will contain &71, &72 or &73 (for f1, f2 or f3), so
                        \ set X to the last digit (1, 2 or 3) and jump to LOOK1
                        \ to switch to view X (rear, left or right), returning
                        \ from the subroutine using a tail call

.d_4143

 CMP #&54               \ If "H" was not pressed, jump to NWDAV5 to skip the
 BNE NWDAV5             \ following

 JMP hyp                \ Jump to hyp to do a hyperspace jump (if we are in
                        \ space), returning from the subroutine using a tail
                        \ call

.TT107

 LDA QQ22+1             \ If the on-screen hyperspace counter is zero, return
 BEQ d_418a             \ from the subroutine (as d_418a contains an RTS), as we
                        \ are not currently counting down to a hyperspace jump

 DEC QQ22               \ Decrement the internal hyperspace counter

 BNE d_418a             \ If the internal hyperspace counter is still non-zero,
                        \ then we are still counting down, so return from the
                        \ subroutine (as d_418a contains an RTS)

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

 BNE d_418a             \ If the countdown is not yet at zero, return from the
                        \ subroutine (as d_418a contains an RTS)

 JMP TT18               \ Otherwise the countdown has finished, so jump to TT18
                        \ to do a hyperspace jump, returning from the subroutine
                        \ using a tail call

.BAD

 LDA QQ20+3             \ Set A to the number of tonnes of slaves in the hold

 CLC                    \ Clear the C flag so we can do addition without the
                        \ C flag affecting the result

 ADC QQ20+6             \ Add the number of tonnes of narcotics in the hold

 ASL A                  \ Double the result and add the number of tonnes of
 ADC QQ20+10            \ firearms in the hold

.d_418a

 RTS                    \ Return from the subroutine

.NWDAV5

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ d_418a             \ d_418a contains an RTS)

 JMP TT16               \ Jump to TT16 to move the crosshairs by the amount in X
                        \ and Y, which were passed to this subroutine as
                        \ arguments, and return from the subroutine using a tail
                        \ call

ENDIF

