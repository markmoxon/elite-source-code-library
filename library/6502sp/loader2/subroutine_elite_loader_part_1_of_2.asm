\ ******************************************************************************
\       Name: Elite loader (Part 1 of 2)
\ ******************************************************************************

.ENTRY

 MVE DIALS, &7000, &E \Move Dials bit dump to screen
\MVE DATE, &6000, &1
 MVE ASOFT, &4200, &1
 MVE ELITE, &4600, &1
 MVE CpASOFT, &6C00, &1

 LDX #(MESS2 MOD256)
 LDY #(MESS2 DIV256)
 JSR SCLI \*RUN I-CODE

 LDX #(MESS3 MOD256)
 LDY #(MESS3 DIV256)
 JMP SCLI \*RUN P-CODE

