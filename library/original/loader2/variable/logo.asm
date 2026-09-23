\ ******************************************************************************
\
\       Name: LOGO
\       Type: Variable
\   Category: Loader
\    Summary: Tables containing the Acornsoft logo for the BBC Micro and Acorn
\             Electron
\
\ ******************************************************************************

.LOGO

 EQUB &A0, &A1          \ For the BBC Micro, the tables below consist of offsets
 EQUB &A2, &E0          \ into this top table, so the first three characters of
 EQUB &A5, &A7          \ the Acornsoft logo are &A0 (the &00-th entry in this
 EQUB &AB, &B0          \ table), then &FC (the &18-th entry in this table),
 EQUB &B1, &B4          \ then &B4 (the &09-th entry in this table) and so on
 EQUB &B5, &B7          \
 EQUB &BF, &A3          \ The Electron ignores this top table and just uses the
 EQUB &E8, &EA          \ values below, adding &E0 to get the number of the
 EQUB &EB, &EF          \ relevant user-defined character (so the first three
 EQUB &F0, &F3          \ characters are &E0, then &F8, then &E9 and so on)
 EQUB &F4, &F5          \
 EQUB &F8, &FA          \ The Acornsoft logo is made up of 5 rows with 38
 EQUB &FC, &FD          \ graphics characters on each row, which corresponds
 EQUB &FE, &FF          \ with the tables below

 EQUB &00, &00, &00, &18, &09, &03, &18, &18
 EQUB &07, &00, &16, &18, &14, &00, &18, &18
 EQUB &18, &07, &0E, &14, &00, &0E, &09, &16
 EQUB &18, &18, &07, &00, &1A, &1B, &09, &00
 EQUB &18, &18, &18, &18, &18, &18

 EQUB &00, &00, &17, &1B, &0A, &1B, &05, &06
 EQUB &1B, &0F, &0C, &0D, &11, &0A, &1B, &0D
 EQUB &10, &0A, &0F, &1B, &09, &0F, &0A, &1B
 EQUB &08, &06, &04, &0F, &1B, &1B, &1B, &00
 EQUB &1B, &0D, &0D, &0D, &1B, &0D

 EQUB &00, &0E, &0C, &10, &0A, &1B, &00, &00
 EQUB &00, &0F, &0A, &00, &0F, &0A, &1B, &18
 EQUB &1A, &04, &0F, &0C, &1B, &17, &0A, &06
 EQUB &1B, &19, &07, &1B, &1B, &1B, &1B, &0A
 EQUB &1B, &1B, &1B, &00, &1B, &00

 EQUB &03, &1B, &19, &1A, &0A, &1B, &07, &03
 EQUB &18, &0F, &15, &00, &17, &0A, &1B, &06
 EQUB &19, &00, &0F, &0A, &10, &1B, &0A, &12
 EQUB &00, &10, &1B, &13, &13, &13, &13, &08
 EQUB &1B, &00, &00, &00, &1B, &00

 EQUB &1A, &0B, &00, &0F, &0A, &06, &1B, &1B
 EQUB &05, &02, &11, &1B, &0C, &01, &1B, &00
 EQUB &10, &15, &0F, &0A, &00, &11, &0A, &11
 EQUB &1B, &1B, &04, &11, &1B, &1B, &1B, &04
 EQUB &1B, &00, &00, &00, &1B, &00

