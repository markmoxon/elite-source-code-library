\ ******************************************************************************
\
\       Name: TRANTABLE
\       Type: Variable
\   Category: Keyboard
\    Summary: Translation table from internal key number to ASCII
\
\ ------------------------------------------------------------------------------
\
\ This is a copy of the MOS keyboard translation table. The value at offset n is
\ the ASCII value of the key with internal key number n, so for example the
\ value at offset 16 is &41 (65), or ASCII "A".
\
\ It is slightly quicker to do a table lookup in user RAM than in the MOS ROM,
\ which is probably why we have the table below.
\
\ ******************************************************************************

.TRANTABLE

 EQUB &03, &8C, &40, &FE, &A0, &7F, &8C, &43
 EQUB &FE, &8E, &4F, &FE, &AE, &4F, &FE, &60
 EQUB &71, &33, &34, &35, &84, &38, &87, &2D
 EQUB &5E, &8C, &84, &EC, &86, &ED, &60, &00
 EQUB &80, &77, &65, &74, &37, &69, &39, &30
 EQUB &5F, &8E, &6C, &FE, &FD, &6C, &FA, &00
 EQUB &31, &32, &64, &72, &36, &75, &6F, &70
 EQUB &5B, &8F, &2C, &B7, &D9, &6C, &28, &02
 EQUB &01, &61, &78, &66, &79, &6A, &6B, &40
 EQUB &3A, &0D, &00, &FF, &01, &02, &09, &0A
 EQUB &02, &73, &63, &67, &68, &6E, &6C, &3B
 EQUB &5D, &7F, &AC, &44, &02, &A2, &00, &60
 EQUB &00, &7A, &20, &76, &62, &6D, &2C, &2E
 EQUB &2F, &8B, &AE, &41, &02, &4C, &AD, &E1
 EQUB &1B, &81, &82, &83, &85, &86, &88, &89
 EQUB &5C, &8D, &6C, &20, &02, &D0, &EB, &A2
 EQUB &08

