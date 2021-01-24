\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 2)
\       Type: Subroutine
\   Category: Loader
\    Summary: Move loading screen binaries into screen memory and load and run
\             the main game code
\
\ ******************************************************************************

.ENTRY

 MVE DIALS, &7000, &E   \ Move the binary at DIALS (the dashboard background) to
                        \ locations &7000-&7EFF in screen memory (14 pages)

\MVE DATE, &6000, &1    \ This instruction is commented out in the original
                        \ course, but it would move the binary at DATE to
                        \ locations &6000-&60FF in screen memory (1 page),
                        \ which would display the following message on the
                        \ loading screen: "2nd Pro ELITE -Finished 13/12/84"

 MVE ASOFT, &4200, &1   \ Move the binary at ASOFT (the "Acornsoft" heading) to
                        \ locations &4200-&42FF in screen memory (1 page)

 MVE ELITE, &4600, &1   \ Move the binary at ELITE (the "ELITE" heading) to
                        \ locations &4600-&46FF in screen memory (1 page)

 MVE CpASOFT, &6C00, &1 \ Move the binary at CpASOFT (the Acornsoft copyright
                        \ message) to locations &6C00-&6CFF in screen memory
                        \ (1 page)

 LDX #LO(MESS2)         \ Set (Y X) to point to MESS2 ("R.I.CODE")
 LDY #HI(MESS2)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS2, which *RUNs
                        \ the main I/O processor game code in I.CODE

 LDX #LO(MESS3)         \ Set (Y X) to point to MESS3 ("R.P.CODE")
 LDY #HI(MESS3)

 JMP OSCLI              \ Call OSCLI to run the OS command in MESS3, which *RUNs
                        \ the main parasite game code in P.CODE, returning from
                        \ the subroutine using a tail call

