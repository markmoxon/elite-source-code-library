\ ******************************************************************************
\
\       Name: Checksum
\       Type: Variable
\   Category: Copy protection
IF NOT(_ELITE_A_DOCKED)
\    Summary: Contains a checksum at &55FF that is checked by the loader
ELIF _ELITE_A_DOCKED
\    Summary: Copy protection is disabled in Elite-A, so this block is unused
ENDIF
\
\ ******************************************************************************

IF NOT(_ELITE_A_DOCKED)

IF _STH_DISC OR _SRAM_DISC

 EQUB &45, &4E          \ These bytes appear to be unused
 EQUB &44, &2D
 EQUB &45, &4E
 EQUB &44, &2D
 EQUB &45, &4E
 EQUB &44, &52
 EQUB &50, &53
 EQUB &00, &8E
 EQUB &11, &D8
 EQUB &00, &00
 EQUB &06, &56
 EQUB &52, &49
 EQUB &45

 EQUB &E6               \ This checksum is at location &55FF, and is checked in
                        \ the LOAD routine in elite-loader3.asm

ELIF _IB_DISC

 EQUB &45, &4E          \ These bytes appear to be unused
 EQUB &44, &2D
 EQUB &45, &4E
 EQUB &44, &2D
 EQUB &45, &4E
 EQUB &44, &8E
 EQUB &13, &1C
 EQUB &00, &00
 EQUB &73, &56
 EQUB &52, &49
 EQUB &53, &00
 EQUB &8E, &13
 EQUB &34

 EQUB &B3               \ This checksum is at location &55FF, and is checked in
                        \ the LOAD routine in elite-loader3.asm

ENDIF

ELIF _ELITE_A_DOCKED

 EQUB &56, &05          \ These bytes appear to be unused
 EQUB &EA, &32
 EQUB &00, &00
 EQUB &06, &4C
 EQUB &5F, &33
 EQUB &36, &43
 EQUB &35, &56
 EQUB &57

ENDIF

