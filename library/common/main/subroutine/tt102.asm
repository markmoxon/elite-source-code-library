\ ******************************************************************************
\
\       Name: TT102
\       Type: Subroutine
IF NOT(_NES_VERSION)
\   Category: Keyboard
\    Summary: Process function key, save key, hyperspace and chart key presses
ELIF _NES_VERSION
\   Category: Icon bar
\    Summary: Process icon bar controller choices
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\             and update the hyperspace counter
ENDIF
\
\ ------------------------------------------------------------------------------
IF NOT(_NES_VERSION)
\
\ Process function key presses, plus "@" (save commander), "H" (hyperspace),
\ "D" (show distance to system) and "O" (move chart cursor back to current
\ system). We can also pass cursor position deltas in X and Y to indicate that
ENDIF
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\ the cursor keys or joystick have been used (i.e. the values that are returned
\ by routine TT17).
ELIF _ELECTRON_VERSION
\ the cursor keys have been used (i.e. the values that are returned by routine
\ TT17).
ENDIF
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\
\ This routine also checks for the "F" key press (search for a system), which
\ applies to enhanced versions only.
ENDIF
IF _NES_VERSION \ Comment
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
ENDIF
\
\ ------------------------------------------------------------------------------
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
ELIF _C64_VERSION OR _APPLE_VERSION
\   A                   The key number of the key pressed
ELIF _NES_VERSION
\   A                   The button number of the chosen icon from the icon bar
ENDIF
\
\   X                   The amount to move the crosshairs in the x-axis
\
\   Y                   The amount to move the crosshairs in the y-axis
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
IF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA
\   BAD                 Work out how bad we are from the amount of contraband in
\                       our hold
\
ENDIF
IF NOT(_NES_VERSION)
\   T95                 Print the distance to the selected system
\
ENDIF
IF _NES_VERSION
\   ReturnFromSearch    Re-entry point following a system search in HME2
\
ENDIF
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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

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

ELIF _NES_VERSION

 CMP #0                 \ If no icon was chosen, jump to HME1 to skip all the
 BNE P%+5               \ icon checks below
 JMP HME1

 CMP #3                 \ If the Status Mode icon was chosen, jump to STATUS to
 BNE P%+5               \ show the Status Mode screen, returning from the
 JMP STATUS             \ subroutine using a tail call

 CMP #4                 \ If the Charts icon was chosen from the docked icon
 BEQ barb1              \ bar, jump to barb1 to show the correct chart

 CMP #36                \ If the Switch chart range icon from the Charts icon
 BNE barb2              \ bar was not chosen, jump to barb2 to keep checking

 LDA chartToShow        \ The Switch chart range icon from the Charts icon bar
 EOR #%10000000         \ was chosen, so flip bit 7 of chartToShow to toggle
 STA chartToShow        \ the chart between the Long-range and Short-range
                        \ Chart

.barb1

 LDA chartToShow        \ If chartToShow = 0 then jump to TT23 to show the
 BPL P%+5               \ Short-range Chart, otherwise jump to TT22 to show the
 JMP TT22               \ Long-range Chart, in either case returning from the
 JMP TT23               \ subroutine using a tail call

.barb2

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 CMP #f6                \ If red key f6 was pressed, call TT111 to select the
 BNE TT92               \ system nearest to galactic coordinates (QQ9, QQ10)
 JSR TT111              \ (the location of the chart crosshairs) and set ZZ to
 JMP TT25               \ the system number, and then jump to TT25 to show the
                        \ Data on System screen (along with an extended system
                        \ description for the system in ZZ if we're docked),
                        \ returning from the subroutine using a tail call

ELIF _NES_VERSION

 CMP #35                \ If the Data on System icon was chosen, call the
 BNE TT92               \ SetSelectedSystem routine to set the selected system
 JSR SetSelectedSystem  \ to the nearest system, if we don't already have a
 JMP TT25               \ selected system, and then jump to TT25 to show the
                        \ Data on System screen, returning from the subroutine
                        \ using a tail call

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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

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

ELIF _NES_VERSION

 CMP #8                 \ If the Inventory icon was chosen, jump to TT213 to
 BNE P%+5               \ show the Inventory screen, returning from the
 JMP TT213              \ subroutine using a tail call

 CMP #2                 \ If the Market Price icon was chosen, jump to TT167 to
 BNE P%+5               \ show the Market Price screen, returning from the
 JMP TT167              \ subroutine using a tail call

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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _ELITE_A_FLIGHT \ Comment

 CMP #f0                \ If red key f0 was pressed, jump to TT110 to launch our
 BNE fvw                \ ship (if docked), returning from the subroutine using
 JMP TT110              \ a tail call

ELIF _MASTER_VERSION

 CMP #f0                \ If red key f0 was pressed, jump to TT110 to launch our
 BNE fvw                \ ship (if docked), returning from the subroutine using
\JSR CTRL               \ a tail call
\BPL P%+5               \
\JMP HALL               \ Three instructions are commented out in the original
 JMP TT110              \ source, which would show the ship hangar instead of
                        \ launching if CTRL is held down, so presumably they
                        \ were put in for testing

ELIF _ELECTRON_VERSION

 CMP #func1             \ If FUNC-1 was pressed, jump to TT110 to launch our
 BNE fvw                \ ship (if docked), returning from the subroutine using
 JMP TT110              \ a tail call

ELIF _NES_VERSION

 CMP #1                 \ If the Launch icon was not chosen, jump to fvw to
 BNE fvw                \ skip the following launch code

                        \ The Launch icon was chosen, so we now attempt to
                        \ launch

 LDX QQ12               \ If QQ12 is zero then we are not docked, so jump to fvw
 BEQ fvw                \ as we can't launch from the station if we are already
                        \ in space

 JSR SelectNearbySystem \ Set the current system to the nearest system to
                        \ (QQ9, QQ10), which will be the system we are currently
                        \ docked at, and update the selected system flags
                        \ accordingly

 JMP TT110              \ Jump to TT110 to launch our ship, returning from the
                        \ subroutine using a tail call

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

IF _NES_VERSION

 CMP #17                \ If the Docking Computer icon was not chosen, jump to
 BNE barb8              \ barb8 to move on to the next icon

                        \ If we get here then the Docking Computer icon was
                        \ chosen

 LDX QQ12               \ If QQ12 is non-zero then we are docked, so jump to
 BNE barb8              \ barb8 to move on to the next icon as we can't engage
                        \ the docking computer if we aren't in space

 LDA auto               \ If the docking computer is already activated, jump
 BNE barb5              \ to barb5 to skip the docking fee calculations and
                        \ disable the docking computer (so the icon bar button
                        \ toggles it on and off)

 LDA SSPR               \ If we are not inside the space station safe zone, jump
 BEQ barb8              \ to barb8 to move on to the next icon as we can't
                        \ engage the docking computer if we aren't in the safe
                        \ zone

                        \ We now deduct a docking fee of 5.0 credits for using
                        \ the docking computer

 LDA DKCMP              \ If we have a docking computer fitted (DKCMP is
 ORA chargeDockingFee   \ non-zero) or we have already been charged a docking
 BNE barb4              \ fee (chargeDockingFee is non-zero), then jump to
                        \ barb4 to engage the docking computer without charging
                        \ a docking fee

                        \ Otherwise we do not have a docking computer fitted
                        \ or we have not yet been charged a docking fee, so
                        \ now we charge the docking fee

 LDY #0                 \ Set (Y X) = 50, so the docking fee is 5.0 credits
 LDX #50

 JSR LCASH              \ Subtract (Y X) cash from the cash pot, but only if
                        \ we have enough cash

 BCS barb3              \ If the C flag is set then we did have enough cash for
                        \ the transaction, so jump to barb3 to skip the
                        \ following instruction

                        \ If we get here then we don't have enough cash for the
                        \ docking fee, so make a beep and return from the
                        \ subroutine without engaging the docking computer

 JMP BOOP               \ Call the BOOP routine to make a long, low beep, and
                        \ return from the subroutine using a tail call

.barb3

 DEC chargeDockingFee   \ Set chargeDockingFee to &FF so we don't charge another
                        \ docking fee

 LDA #0                 \ Print control code 0 (current amount of cash and
 JSR MESS               \ newline) as an in-flight message, to show our balance
                        \ after the docking fee has been paid

.barb4

 LDA #1                 \ Set A = 1 to pass to the ChooseMusic routine to play
                        \ the docking music (The Blue Danube)

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 JSR ChooseMusic_b6     \ Select and play the docking music (tune 1, "The Blue
                        \ Danube")

 LDA #&FF               \ Set A = &FF to set as the value of auto below, so the
                        \ docking computer is flagged as being enabled

 BNE barb6              \ Jump to barb6 to store A in auto (this BNE is
                        \ effectively a JMP as A is never zero)

.barb5

                        \ If we get here then we need to turn off the docking
                        \ computer

 JSR ResetMusicAfterNMI \ Wait for the next NMI before resetting the current
                        \ tune to 0 (no tune) and stopping the docking music

 LDA #0                 \ Set A = 0 to set as the value of auto below, so the
                        \ docking computer is flagged as being disabled

.barb6

 STA auto               \ Set auto to the value in A, to disable or enable the
                        \ docking computer as required

 LDA QQ11               \ If this is the space view, jump to barb7 to return
 BEQ barb7              \ from the subroutine

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the two bottom rows

 JSR DrawScreenInNMI    \ Configure the NMI handler to draw the screen, so the
                        \ screen gets updated

.barb7

 RTS                    \ Return from the subroutine

.barb8

 JSR CheckForPause      \ If the Start button has been pressed then process the
                        \ pause menu and set the C flag, otherwise clear it

 CMP #21                \ If the "Front space view" icon was not chosen, jump to
 BNE barb11             \ barb11 to move on to the next icon

                        \ If we get here then the "Front space view" icon was
                        \ chosen

 LDA QQ12               \ If QQ12 is zero then we are not docked and in space,
 BPL barb9              \ so jump to barb9 to process the "Front space view"
                        \ icon

 RTS                    \ Otherwise the icon does nothing, so return from the
                        \ subroutine

.barb9

                        \ If we get here then the "Front space view" icon was
                        \ chosen and we are in space

 LDA #0                 \ Set A = 0 to use as the view number if we jump to
                        \ barb10 to show the front space view (i.e. view 0)

 LDX QQ11               \ If this is not the space view, jump to barb10 to show
 BNE barb10             \ the front space view

 LDA VIEW               \ Otherwise add 1 to the view number in VIEW and wrap it
 CLC                    \ round using mod 4, so VIEW goes from 0 to 3 and back
 ADC #1                 \ to 0 again (i.e. front, rear, left, right and back to
 AND #3                 \ front again)

.barb10

 TAX                    \ Set X to the view number to show

 JMP LOOK1              \ Jump to LOOK1 to switch to view X (front, rear, left
                        \ or right), returning from the subroutine using a tail
                        \ call

.barb11

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 BIT QQ12               \ If bit 7 of QQ12 is clear (i.e. we are not docked, but
 BPL INSP               \ in space), jump to INSP to skip the following checks
                        \ for f1-f3 and "@" (save commander file) key presses

ELIF _ELECTRON_VERSION

 BIT QQ12               \ If bit 7 of QQ12 is clear (i.e. we are not docked, but
 BPL INSP               \ in space), jump to INSP to skip the following checks
                        \ for FUNC-2 to FUNC-4 and "@" (save commander file) key
                        \ presses

ELIF _NES_VERSION

 BIT QQ12               \ If bit 7 of QQ12 is clear (i.e. we are not docked, but
 BPL LABEL_3            \ in space), jump to LABEL_3 to skip the following
                        \ checks for the save commander file key press

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

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

ELIF _NES_VERSION

 CMP #5                 \ If the Equip Ship icon was chosen, jump to TT219 to
 BNE P%+5               \ show the Equip Ship screen, returning from the
 JMP EQSHP              \ subroutine using a tail call

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

ELIF _C64_VERSION

 CMP #&12               \ ???
 BNE nosave

ELIF _APPLE_VERSION

 CMP #'I'               \ If "I" was not pressed, skip to nosave
 BNE nosave

ELIF _NES_VERSION

 CMP #6                 \ If the Save and Load icon was chosen, jump to SVE to
 BNE LABEL_3            \ show the Save and Load screen, returning from the
 JMP SVE_b6             \ subroutine using a tail call

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Enhanced: See group A

 JSR SVE                \ "@" was pressed, so call SVE to show the disc access
                        \ menu

 BCC P%+5               \ If the C flag was set by SVE, then we loaded a new
 JMP QU5                \ commander file, so jump to QU5 to restart the game
                        \ with the newly loaded commander

 JMP BAY                \ Otherwise the C flag was clear, so jump to BAY to go
                        \ to the docking bay (i.e. show the Status Mode screen)

.nosave

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

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

 CMP #f1                \ If red key f1 was pressed, jump to chview1
 BEQ chview1

 CMP #f2                \ If red key f2 was pressed, jump to chview2
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

ELIF _C64_VERSION

 CMP #f12               \ If key ??? was pressed, jump to chview1
 BEQ chview1

 CMP #f22               \ If key ??? was pressed, jump to chview2
 BEQ chview2

 CMP #f32               \ If key ??? was not pressed, jump to LABEL_3 to keep
 BNE LABEL_3            \ checking for which key was pressed

 LDX #3                 \ Key ??? was pressed, so set the view number in X to
                        \ 3 for the right view

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &02, or BIT &02A2, which does nothing apart
                        \ from affect the flags

.chview2

 LDX #2                 \ If we jump to here, key ??? was pressed, so set the
                        \ view number in X to 2 for the left view

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &01, or BIT &02A2, which does nothing apart
                        \ from affect the flags

.chview1

 LDX #1                 \ If we jump to here, key ??? was pressed, so set the
                        \ view number in X to 1 for the rear view

 JMP LOOK1              \ Jump to LOOK1 to switch to view X (rear, left or
                        \ right), returning from the subroutine using a tail
                        \ call

ELIF _APPLE_VERSION

 CMP #f12               \ If key ??? was pressed, jump to chview1
 BEQ chview1

 CMP #f22               \ If key ??? was pressed, jump to chview2
 BEQ chview2

 CMP #f32               \ If key ??? was not pressed, jump to LABEL_3 to keep
 BNE LABEL_3            \ checking for which key was pressed

 LDX #3                 \ Key ??? was pressed, so set the view number in X to
                        \ 3 for the right view

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &02, or BIT &02A2, which does nothing apart
                        \ from affect the flags

.chview2

 LDX #2                 \ If we jump to here, key ??? was pressed, so set the
                        \ view number in X to 2 for the left view

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &01, or BIT &02A2, which does nothing apart
                        \ from affect the flags

.chview1

 LDX #1                 \ If we jump to here, key ??? was pressed, so set the
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

ELIF _C64_VERSION

 BIT KLO+HINT           \ ???
 BPL P%+5
 JMP hyp

ELIF _APPLE_VERSION

 LDA KL                 \ ???
 CMP #'H'
 BNE P%+5
 JMP hyp
 CMP #'G'
 BNE P%+5
 JMP hyp

ELIF _NES_VERSION

 CMP #22                \ If the Hyperspace icon was chosen, jump to hyp to do
 BNE P%+5               \ a hyperspace jump (if we are in space), returning from
 JMP hyp                \ the subroutine using a tail call

 CMP #41                \ If the Galactic Hyperspace icon was chosen, jump to
 BNE P%+5               \ GalacticHyperdrive to do a galactic hyperspace jump,
 JMP GalacticHyperdrive \ returning from the subroutine using a tail call

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Label

.NWDAV5

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 CMP #&32               \ If "D" was pressed, jump to T95 to print the distance
 BEQ T95                \ to a system (if we are in one of the chart screens)

ELIF _MASTER_VERSION OR _APPLE_VERSION

 CMP #'D'               \ If "D" was pressed, jump to T95 to print the distance
 BEQ T95                \ to a system (if we are in one of the chart screens)

ELIF _C64_VERSION

 CMP #DINT              \ If "D" was pressed, jump to T95 to print the distance
 BEQ T95                \ to a system (if we are in one of the chart screens)

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Enhanced: Group A: Pressing "F" in the enhanced versions when viewing a chart lets us search for systems by name

 CMP #&43               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems

ELIF _MASTER_VERSION OR _APPLE_VERSION

 CMP #'F'               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems

ELIF _C64_VERSION

 CMP #FINT              \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems

ELIF _ELITE_A_FLIGHT

 CMP #&43               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to toggle the compass display

ELIF _ELITE_A_6502SP_PARA

 CMP #&43               \ If "F" was not pressed, jump down to HME1, otherwise
 BNE HME1               \ keep going to process searching for systems (when
                        \ docked) or toggle the compass display (when flying)

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 LDA QQ12               \ If QQ12 = 0 (we are not docked), we can't search for
 BEQ t95                \ systems, so return from the subroutine (as t95
                        \ contains an RTS)

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Enhanced: See group A

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ t95                \ t95 contains an RTS)

 JMP HME2               \ Jump to HME2 to let us search for a system, returning
                        \ from the subroutine using a tail call

.HME1

ELIF _NES_VERSION

 CMP #39                \ If the "Search for system" icon was not chosen, jump
 BNE HME1               \ to HME1 to move on to the next icon

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

 BNE t95                \ If it is non-zero, return from the subroutine (as t95
                        \ contains an RTS), as there is a countdown in progress

 LDA QQ11               \ If the view in QQ11 is not %0000110x (i.e. 12 or 13,
 AND #%00001110         \ which are the Short-range Chart and Long-range Chart),
 CMP #%00001100         \ jump to t95 to return from the subroutine (as t95
 BNE t95                \ contains an RTS)

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

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

ELIF _NES_VERSION

 LDA QQ11               \ If the view in QQ11 is not %0000110x (i.e. 12 or 13,
 AND #%00001110         \ which are the Short-range Chart and Long-range Chart),
 CMP #%00001100         \ jump to TT107 to skip the following and move on to
 BNE TT107              \ updating the hyperspace

 LDA QQ22+1             \ If the on-screen hyperspace counter is non-zero,
 BNE TT107              \ then we are already counting down, so jump to TT107
                        \ to skip the following

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 LDA T1                 \ Restore the original value of A (the key that's been
                        \ pressed) from T1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 CMP #&36               \ If "O" was pressed, do the following three jumps,
 BNE ee2                \ otherwise skip to ee2 to continue

ELIF _MASTER_VERSION OR _APPLE_VERSION

 CMP #'O'               \ If "O" was pressed, do the following three jumps,
 BNE ee2                \ otherwise skip to ee2 to continue

ELIF _C64_VERSION

 CMP #OINT              \ If "O" was pressed, do the following three jumps,
 BNE ee2                \ otherwise skip to ee2 to continue

ELIF _NES_VERSION

 CMP #38                \ If the "Return pointer to current system" icon was not
 BNE ee2                \ chosen, jump to ee2 to skip the following

ELIF _ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_ENCYCLOPEDIA

 CMP #&36               \ If "O" was pressed, do the following three jumps,
 BNE not_home           \ otherwise skip to not_home to continue checking key
                        \ presses

ELIF _ELITE_A_6502SP_PARA

 CMP #&36               \ If "O" was pressed, do the following, otherwise skip
 BNE not_home           \ to not_home to continue checking key presses

 LDA QQ11               \ If bits 6 and 7 of the view type are both clear - so
 AND #%11000000         \ this is not the Short-range or Long-range Chart - then
 BEQ t95                \ jump to t95 to return from the subroutine, otherwise
                        \ do the following three jumps

ENDIF

IF NOT(_NES_VERSION)

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

ENDIF

 JSR ping               \ Set the target system to the current system (which
                        \ will move the location in (QQ9, QQ10) to the current
                        \ home system

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Other: This might be a bug fix? If "O" is pressed in the advanced versions, then the target system is set to home, and the routine terminates, which is different to the other versions; they stick around for one more move of the cursor, so presumably this fixes a bug where pressing "O" might not always move the cursor exactly to the current system

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 JMP TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system, and return from the subroutine using a tail
                        \ call

ELIF _NES_VERSION

.ReturnFromSearch

 ASL selectedSystemFlag \ Clear bit 7 of selectedSystemFlag to indicate that
 LSR selectedSystemFlag \ there is no currently selected system, so the call to
                        \ SetSelectedSystem selects the system in (QQ9, QQ10)

 JMP SetSelectedSystem  \ Jump to SetSelectedSystem to update the message on
                        \ the chart that shows the current system, returning
                        \ from the subroutine using a tail call

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

.ee2

 JSR TT16               \ Call TT16 to move the crosshairs by the amount in X
                        \ and Y, which were passed to this subroutine as
                        \ arguments

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

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

ELIF _NES_VERSION

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

 LDA #5                 \ Reset the internal hyperspace counter to 5
 STA QQ22

 DEC QQ22+1             \ Decrement the on-screen hyperspace countdown

 BEQ barb12             \ If the countdown is zero, jump to barb12 to do the
                        \ jump

 LDA #250               \ Print in-flight token 250, which is the hyperspace
 JMP MESS               \ countdown, and return from the subroutine using a
                        \ tail call

.barb12

 JMP TT18               \ The countdown has finished, so jump to TT18 to do a
                        \ hyperspace jump, returning from the subroutine using
                        \ a tail call

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

 LDA QQ11               \ If bits 6 and 7 of the view type are both clear - so
 AND #%11000000         \ this is not the Short-range or Long-range Chart - then
 BEQ t95                \ jump to t95 to return from the subroutine, otherwise
                        \ do the following three jumps

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

IF NOT(_NES_VERSION)

.T95

                        \ If we get here, "D" was pressed, so we need to show
                        \ the distance to the selected system (if we are in a
                        \ chart view)

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ t95                \ t95 contains an RTS)

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

ELIF _C64_VERSION

\LDA #CYAN              \ These instructions are commented out in the original
\JSR DOCOL              \ source (they are left over from the 6502 Second
                        \ Processor version of Elite and would change the colour
                        \ to white)

ENDIF

IF NOT(_NES_VERSION)

 JSR hm                 \ Call hm to move the crosshairs to the target system
                        \ in (QQ9, QQ10), returning with A = 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 STA QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

ELIF _MASTER_VERSION OR _APPLE_VERSION

\STA QQ17               \ This instruction is commented out in the original
                        \ source

ENDIF

IF NOT(_NES_VERSION)

 JSR cpl                \ Print control code 3 (the selected system name)

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _NES_VERSION)

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

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #12                \ Print a line feed to move the text cursor down a line
 JSR TT26

ENDIF

IF _C64_VERSION

\LDA #10                \ These instructions are commented out in the original
\JSR TT26               \ source
\LDA #1
\JSR DOXC
\JSR INCYC

ENDIF

IF NOT(_NES_VERSION)

 JMP TT146              \ Print the distance to the selected system and return
                        \ from the subroutine using a tail call

ENDIF

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

