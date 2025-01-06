\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
IF NOT(_ELITE_A_VERSION)
\    Summary: Load and run the main docked code in T.CODE
ELIF _ELITE_A_VERSION
\    Summary: Load and run the main docked code in 1.D
ENDIF
\  Deep dive: Swapping between the docked and flight code
\
\ ******************************************************************************

.INBAY

IF NOT(_ELITE_A_VERSION)

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.T.CODE", which gets
 LDY #HI(LTLI)          \ modified to "R.T.CODE" in the DOENTRY routine)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which *RUNs
                        \ the main docked code in T.CODE
                        \
                        \ Note that this is a JSR rather than a JMP, so if LTLI
                        \ is still set to "L.T.CODE" (rather than "R.T.CODE"),
                        \ then once the command has been run and the docked code
                        \ has loaded, execution will continue from the next
                        \ instruction
                        \
                        \ By this point the T.CODE binary has loaded over the
                        \ top of this one, so we don't fall through into the
                        \ LTLI variable (as that's in the flight code), but
                        \ instead we fall through into the DOBEGIN routine in
                        \ the docked code)
                        \
                        \ This means that if the LTLI command is unchanged, then
                        \ we load the docked code and fall through into DOBEGIN
                        \ to restart the game from the title screen, so by
                        \ default, loading the docked code will restart the game
                        \
                        \ However if we call DOENTRY in the flight code first,
                        \ then the command in LTLI is changed to the "R.T.CODE"
                        \ version, which *RUNs the docked code and starts
                        \ execution from the start of the docked binary at S%,
                        \ which contains a JMP DOENTRY instruction that docks at
                        \ the station instead

ELIF _ELITE_A_FLIGHT

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.1.D", which gets
 LDY #HI(LTLI)          \ modified to "R.1.D" in the DOENTRY routine)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which *RUNs
                        \ the main docked code in 1.D
                        \
                        \ Note that this is a JSR rather than a JMP, so if LTLI
                        \ is still set to "L.1.D" (rather than "R.1.D"),
                        \ then once the command has been run and the docked code
                        \ has loaded, execution will continue from the next
                        \ instruction
                        \
                        \ By this point the 1.D binary has loaded over the
                        \ top of this one, so we don't fall through into the
                        \ LTLI variable (as that's in the flight code), but
                        \ instead we fall through into the DOBEGIN routine in
                        \ the docked code)
                        \
                        \ This means that if the LTLI command is unchanged, then
                        \ we load the docked code and fall through into DOBEGIN
                        \ to restart the game from the title screen, so by
                        \ default, loading the docked code will restart the game
                        \
                        \ However if we call DOENTRY in the flight code first,
                        \ then the command in LTLI is changed to the "R.1.D"
                        \ version, which *RUNs the docked code and starts
                        \ execution from the start of the docked binary at S%,
                        \ which contains a JMP DOENTRY instruction that docks at
                        \ the station instead

ELIF _ELITE_A_ENCYCLOPEDIA

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.1.D", which gets
 LDY #HI(LTLI)          \ modified to "R.1.D" in the launch routine)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which *RUNs
                        \ the main docked code in 1.D
                        \
                        \ Note that this is a JSR rather than a JMP, so if LTLI
                        \ is still set to "L.1.D" (rather than "R.1.D"),
                        \ then once the command has been run and the docked code
                        \ has loaded, execution will continue from the next
                        \ instruction
                        \
                        \ By this point the 1.D binary has loaded over the
                        \ top of this one, so we don't fall through into the
                        \ LTLI variable (as that's in the flight code), but
                        \ instead we fall through into the DOBEGIN routine in
                        \ the docked code)
                        \
                        \ This means that if the LTLI command is unchanged, then
                        \ we load the docked code and fall through into DOBEGIN
                        \ to restart the game from the title screen, so by
                        \ default, loading the docked code will restart the game
                        \
                        \ However if we call DOENTRY in the flight code first,
                        \ then the command in LTLI is changed to the "R.1.D"
                        \ version, which *RUNs the docked code and starts
                        \ execution from the start of the docked binary at S%,
                        \ which contains a JMP DOENTRY instruction that docks at
                        \ the station instead

ENDIF