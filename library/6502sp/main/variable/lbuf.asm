\ ******************************************************************************
\
\       Name: LBUF
\       Type: Variable
\   Category: Drawing lines
\    Summary: The multi-segment line buffer used by LOIN
\
\ ------------------------------------------------------------------------------
\
\ This buffer contains a hidden message containing the authors' names, which is
\ overwritten when the buffer is used.
\
\ ******************************************************************************

.LBUF

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45

  EQUS "By Ian Bell & David Braben"
  EQUB 10
  EQUB 13

  EQUB &00, &A5, &05, &65, &02, &CD, &8E, &81   \ These bytes appear to be
  EQUB &D0, &FC, &34, &75, &54, &07, &65, &23   \ unused and just contain random
  EQUB &45, &00, &8D, &20, &DE, &10, &20, &57   \ workspace noise left over from
  EQUB &81, &20, &DB, &6B, &4C, &8E, &50, &EA   \ the BBC Micro assembly process
  EQUB &A0, &00, &84, &05, &A2, &13, &86, &06
  EQUB &98, &51, &05, &49, &75, &91, &05, &88
  EQUB &D0, &F4, &E8, &E0, &A0, &D0, &EF, &4C
  EQUB &7B, &11, &20, &79, &4C, &20, &EE, &2C
  EQUB &64, &7C, &64, &2E, &9C, &93, &08, &A9
  EQUB &FF, &8D, &F1, &08, &8D, &F2, &08, &8D
  EQUB &F3, &08, &20, &B2, &26, &A0, &2C, &20
  EQUB &61, &6D, &AD, &A4, &08, &29, &03, &D0
  EQUB &0E, &AD, &EC, &08, &F0, &54, &AD, &B3
  EQUB &08, &4A, &D0, &4E, &4C, &C2, &32, &C9
  EQUB &03, &D0, &03, &4C, &AE, &32, &AD, &B3
  EQUB &08, &C9, &02, &D0, &3D, &AD, &A4, &08
  EQUB &29, &0F, &C9, &02, &D0, &0A, &AD, &EC
  EQUB &08, &C9, &05, &90, &2D, &4C, &7C, &32
  EQUB &C9, &06, &D0, &11, &AD, &A5, &08, &C9
  EQUB &D7, &D0, &1F, &AD, &A6, &08, &C9, &54
  EQUB &D0, &18, &4C, &8C, &32, &C9, &0A, &D0
  EQUB &11, &AD, &A5, &08, &C9, &3F, &D0, &0A
  EQUB &AD, &A6, &08, &C9, &48, &D0, &03, &4C
  EQUB &9A, &32, &4C, &0B, &51, &A9, &ED, &78
  EQUB &8D, &02, &02, &A9, &4F, &8D, &03, &02
  EQUB &58, &60, &AD, &00, &82, &85, &00, &AE
  EQUB &98, &08, &20, &4C, &31, &20, &4C, &31
  EQUB &8A, &49, &80, &A8, &29, &80, &85, &31
  EQUB &8E, &98, &08, &49

 ELIF _EXECUTIVE

  EQUS "- By Ian Bell & David Braben"
  EQUB 10
  EQUB 13

  EQUB &00, &A5, &05, &65, &02, &CD, &E6, &82   \ These bytes appear to be
  EQUB &D0, &FC, &34, &75, &54, &07, &65, &23   \ unused and just contain random
  EQUB &45, &00, &8D, &20, &E0, &10, &20, &AF   \ workspace noise left over from
  EQUB &82, &20, &DB, &6B, &4C, &B3, &50, &EA   \ the BBC Micro assembly process
  EQUB &A0, &00, &84, &05, &A2, &13, &86, &06
  EQUB &98, &51, &05, &49, &75, &91, &05, &88
  EQUB &D0, &F4, &E8, &E0, &A0, &D0, &EF, &4C
  EQUB &7D, &11, &20, &9E, &4C, &20, &0A, &2D
  EQUB &64, &7C, &64, &2E, &9C, &93, &08, &A9
  EQUB &FF, &8D, &F1, &08, &8D, &F2, &08, &8D
  EQUB &F3, &08, &20, &CE, &26, &A0, &2C, &20
  EQUB &61, &6D, &AD, &A4, &08, &29, &03, &D0
  EQUB &0E, &AD, &EC, &08, &F0, &54, &AD, &B3
  EQUB &08, &4A, &D0, &4E, &4C, &D8, &32, &C9
  EQUB &03, &D0, &03, &4C, &C4, &32, &AD, &B3
  EQUB &08, &C9, &02, &D0, &3D, &AD, &A4, &08
  EQUB &29, &0F, &C9, &02, &D0, &0A, &AD, &EC
  EQUB &08, &C9, &05, &90, &2D, &4C, &92, &32
  EQUB &C9, &06, &D0, &11, &AD, &A5, &08, &C9
  EQUB &D7, &D0, &1F, &AD, &A6, &08, &C9, &54
  EQUB &D0, &18, &4C, &A2, &32, &C9, &0A, &D0
  EQUB &11, &AD, &A5, &08, &C9, &3F, &D0, &0A
  EQUB &AD, &A6, &08, &C9, &48, &D0, &03, &4C
  EQUB &B0, &32, &4C, &3E, &51, &A9, &12, &78
  EQUB &8D, &02, &02, &A9, &50, &8D, &03, &02
  EQUB &58, &60, &AD, &00, &85, &85, &00, &AE
  EQUB &98, &08, &20, &68, &31, &20, &68, &31
  EQUB &8A, &49, &80, &A8, &29, &80, &85, &31
  EQUB &8E, &98

 ELIF _SOURCE_DISC

  EQUS "By Ian Bell & David Braben"
  EQUB 10
  EQUB 13

  EQUB &00, &A5, &05, &65, &02, &CD, &AF, &81   \ These bytes appear to be
  EQUB &D0, &FC, &34, &75, &54, &07, &65, &23   \ unused and just contain random
  EQUB &45, &00, &8D, &20, &DE, &10, &20, &78   \ workspace noise left over from
  EQUB &81, &20, &DB, &6B, &4C, &88, &50, &EA   \ the BBC Micro assembly process
  EQUB &A0, &00, &84, &05, &A2, &13, &86, &06
  EQUB &98, &51, &05, &49, &75, &91, &05, &88
  EQUB &D0, &F4, &E8, &E0, &A0, &D0, &EF, &4C
  EQUB &7B, &11, &20, &73, &4C, &20, &EE, &2C
  EQUB &64, &7C, &64, &2E, &9C, &93, &08, &A9
  EQUB &FF, &8D, &F1, &08, &8D, &F2, &08, &8D
  EQUB &F3, &08, &20, &B2, &26, &A0, &2C, &20
  EQUB &61, &6D, &AD, &A4, &08, &29, &03, &D0
  EQUB &0E, &AD, &EC, &08, &F0, &54, &AD, &B3
  EQUB &08, &4A, &D0, &4E, &4C, &BC, &32, &C9
  EQUB &03, &D0, &03, &4C, &A8, &32, &AD, &B3
  EQUB &08, &C9, &02, &D0, &3D, &AD, &A4, &08
  EQUB &29, &0F, &C9, &02, &D0, &0A, &AD, &EC
  EQUB &08, &C9, &05, &90, &2D, &4C, &76, &32
  EQUB &C9, &06, &D0, &11, &AD, &A5, &08, &C9
  EQUB &D7, &D0, &1F, &AD, &A6, &08, &C9, &54
  EQUB &D0, &18, &4C, &86, &32, &C9, &0A, &D0
  EQUB &11, &AD, &A5, &08, &C9, &3F, &D0, &0A
  EQUB &AD, &A6, &08, &C9, &48, &D0, &03, &4C
  EQUB &94, &32, &4C, &05, &51, &A9, &E7, &78
  EQUB &8D, &02, &02, &A9, &4F, &8D, &03, &02
  EQUB &58, &60, &AD, &00, &82, &85, &00, &AE
  EQUB &98, &08, &20, &4C, &31, &20, &4C, &31
  EQUB &8A, &49, &80, &A8, &29, &80, &85, &31
  EQUB &8E, &98, &08, &49

 ENDIF

ELSE

 SKIP 256               \ The line buffer to send with this command

ENDIF

