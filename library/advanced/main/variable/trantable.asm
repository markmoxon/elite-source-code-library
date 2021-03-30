\ ******************************************************************************
\
\       Name: TRANTABLE
\       Type: Variable
\   Category: Keyboard
\    Summary: Translation table from internal key number to ASCII
\
\ ------------------------------------------------------------------------------
\
\ This is a copy of the keyboard translation table from the BBC Micro's MOS 1.20
\ ROM. The value at offset n is the lower-case ASCII value of the key with
\ internal key number n, so for example the value at offset &10 is &71, which is
\ 113, or ASCII "q", so internal key number &10 is the key number of the "Q"
\ key.
\
\ Valid internal key numbers are Binary Coded Decimal (BCD) numbers in the range
\ &10 top &79, so they're in the ranges &10 to &19, then &20 to &29, then &30 to
\ &39, and so on. This means that the other locations - i.e. &1A to &1F, &2A to
\ &2F and so on - aren't used by the lookup table, but the MOS doesn't let this
\ space go to waste; instead, those gaps contain MOS code, which is replicated
\ below as TRANTABLE contains a copy of this entire block of the MOS, not just
\ the table entries.
\
\ This table allows code running on the parasite to convert internal key numbers
\ into ASCII codes in an efficient way. Without this table we would have to do a
\ lookup from the table in the I/O processor's MOS ROM, which we would have to
\ access from across the Tube, and this would be a lot slower than doing a
\ simple table lookup in the parasite's user RAM.
\
\ ******************************************************************************

.TRANTABLE

IF _6502SP_VERSION

 EQUB &03, &8C, &40     \ MOS code
 EQUB &FE, &A0, &7F
 EQUB &8C, &43, &FE
 EQUB &8E, &4F, &FE
 EQUB &AE, &4F, &FE
 EQUB &60

                        \ Internal key numbers &10 to &19:
                        \
 EQUB &71, &33          \ Q             3
 EQUB &34, &35          \ 4             5
 EQUB &84, &38          \ f4            8
 EQUB &87, &2D          \ f7            -
 EQUB &5E, &8C          \ ^             Left arrow

 EQUB &84, &EC, &86     \ MOS code
 EQUB &ED, &60, &00

                        \ Internal key numbers &20 to &29:
                        \
 EQUB &80, &77          \ f0            W
 EQUB &65, &74          \ E             T
 EQUB &37, &69          \ 7             I
 EQUB &39, &30          \ 9             0
 EQUB &5F, &8E          \ _             Down arrow

 EQUB &6C, &FE, &FD     \ MOS code
 EQUB &6C, &FA, &00

                        \ Internal key numbers &30 to &39:
                        \
 EQUB &31, &32          \ 1             2
 EQUB &64, &72          \ D             R
 EQUB &36, &75          \ 6             U
 EQUB &6F, &70          \ O             P
 EQUB &5B, &8F          \ [             Up arrow

 EQUB &2C, &B7, &D9     \ MOS code
 EQUB &6C, &28, &02

                        \ Internal key numbers &40 to &49:
                        \
 EQUB &01, &61          \ CAPS LOCK     A
 EQUB &78, &66          \ X             F
 EQUB &79, &6A          \ Y             J
 EQUB &6B, &40          \ K             @
 EQUB &3A, &0D          \ :             RETURN

 EQUB &00, &FF, &01     \ MOS code
 EQUB &02, &09, &0A

                        \ Internal key numbers &50 to &59:
                        \
 EQUB &02, &73          \ SHIFT LOCK    S
 EQUB &63, &67          \ C             G
 EQUB &68, &6E          \ H             N
 EQUB &6C, &3B          \ L             ;
 EQUB &5D, &7F          \ ]             DELETE

 EQUB &AC, &44, &02     \ MOS code
 EQUB &A2, &00, &60

                        \ Internal key numbers &60 to &69:
                        \
 EQUB &00, &7A          \ TAB           Z
 EQUB &20, &76          \ SPACE         V
 EQUB &62, &6D          \ B             M
 EQUB &2C, &2E          \ ,             .
 EQUB &2F, &8B          \ /             COPY

 EQUB &AE, &41, &02     \ MOS code
 EQUB &4C, &AD, &E1

                        \ Internal key numbers &70 to &79:
                        \
 EQUB &1B, &81          \ ESCAPE        f1
 EQUB &82, &83          \ f2            f3
 EQUB &85, &86          \ f5            f6
 EQUB &88, &89          \ f8            f9
 EQUB &5C, &8D          \ \             Right arrow

 EQUB &6C, &20, &02     \ MOS code
 EQUB &D0, &EB, &A2
 EQUB &08

ELIF _MASTER_VERSION

 EQUB &00               \ ???

 EQUB &40,&FE,&A0,&5F,&8C,&43,&FE,&8E
 EQUB &4F,&FE,&EA,&AE,&4F,&FE,&60,&51
 EQUB &33,&34,&35,&84,&38,&87,&2D,&5E
 EQUB &8C,&36,&37,&BC,&00,&FC,&60,&80
 EQUB &57,&45,&54,&37,&49,&39,&30,&5F
 EQUB &8E,&38,&39,&BC,&00,&FD,&60,&31
 EQUB &32,&44,&52,&36,&55,&4F,&50,&5B
 EQUB &8F,&81,&82,&0D,&4C,&20,&02,&01
 EQUB &41,&58,&46,&59,&4A,&4B,&40,&3A
 EQUB &0D,&83,&7F,&AE,&4C,&FE,&FD,&02
 EQUB &53,&43,&47,&48,&4E,&4C,&3B,&5D
 EQUB &7F,&85,&84,&86,&4C,&FA,&00,&00
 EQUB &5A,&20,&56,&42,&4D,&2C,&2E,&2F
 EQUB &8B,&30,&31,&33,&00,&00,&00,&1B
 EQUB &81,&82,&83,&85,&86,&88,&89,&5C
 EQUB &8D,&34,&35,&32,&2C,&4E,&E3

ENDIF

