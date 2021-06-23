\ ******************************************************************************
\
\       Name: Unused block 2
\       Type: Variable
\   Category: Utility routines
\    Summary: These bytes appear to be unused
\
\ ******************************************************************************

IF _STH_DISC

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
 EQUB &45, &E6

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
 EQUB &34, &B3

ENDIF

