\ ******************************************************************************
\
\       Name: PBUF
\       Type: Variable
\   Category: Drawing pixels
\    Summary: The pixel buffer to send with the OSWORD 241 command
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   pixbl               Points to the first byte of the PBUF block, which is
\                       where the OSWORD transmission size goes
\
\ ******************************************************************************

.pixbl

.PBUF

 EQUB 0                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45

  EQUB &20, &79, &55, &06, &64, &38, &66, &64   \ These bytes appear to be
  EQUB &D0, &17, &A9, &01, &85, &7C, &A9, &05   \ unused and just contain random
  EQUB &D0, &09, &06, &64, &38, &66, &64, &A5   \ workspace noise left over from
  EQUB &68, &38, &6A, &20, &1E, &44, &20, &79   \ the BBC Micro assembly process
  EQUB &55, &A5, &69, &10, &03, &20, &8C, &6D
  EQUB &A5, &86, &D0, &6D, &20, &FD, &6B, &20
  EQUB &7A, &2B, &90, &62, &AD, &90, &08, &F0
  EQUB &0A, &20, &82, &55, &A6, &83, &A0, &03
  EQUB &20, &64, &45, &A5, &43, &F0, &4F, &A2
  EQUB &0F, &20, &A5, &55, &A5, &8B, &C9, &02
  EQUB &F0, &3F, &C9, &1F, &90, &0A, &A5, &43
  EQUB &C9, &17, &D0, &35, &46, &43, &46, &43
  EQUB &A5, &68, &38, &E5, &43, &B0, &28, &06
  EQUB &64, &38, &66, &64, &A5, &8B, &C9, &07
  EQUB &D0, &10, &A5, &43, &C9, &32, &D0, &0A
  EQUB &20, &24, &4D, &A2, &08, &29, &03, &20
  EQUB &E4, &15, &A0, &04, &20, &D7, &15, &A0
  EQUB &05, &20, &D7, &15, &20, &96, &55, &85
  EQUB &68, &A5, &8B, &20, &00, &2C, &20, &4E
  EQUB &60, &A0, &23, &A5, &68, &91, &1F, &A5
  EQUB &69, &30, &2D, &A5, &64, &10, &2C, &29
  EQUB &20, &F0, &28, &A5, &69, &29, &40, &0D
  EQUB &D8, &08, &8D, &D8, &08, &AD, &96, &08
  EQUB &0D, &8D, &08, &D0, &13, &A0, &0A, &B1
  EQUB &1D, &F0, &0D, &AA, &C8, &B1, &1D, &A8
  EQUB &20, &08, &3E, &A9, &00, &20, &C7, &57
  EQUB &4C, &0F, &4B, &A5, &8B, &30, &05, &20
  EQUB &D8, &4F, &90, &F4, &A0, &1F, &A5, &64
  EQUB &91, &1F, &A6, &83, &E8, &4C, &D6, &12
  EQUB &AD, &CE, &08, &10, &10, &0E, &CE, &08
  EQUB &20, &FC, &6D, &A9, &83, &20, &EE, &FF
  EQUB &A9, &30, &20, &EE, &FF, &A5, &89, &29

 ELIF _EXECUTIVE

  EQUB &29, &50, &20, &A9, &55, &06, &64, &38   \ These bytes appear to be
  EQUB &66, &64, &D0, &17, &A9, &01, &85, &7C   \ unused and just contain random
  EQUB &A9, &05, &D0, &09, &06, &64, &38, &66   \ workspace noise left over from
  EQUB &64, &A5, &68, &38, &6A, &20, &43, &44   \ the BBC Micro assembly process
  EQUB &20, &A9, &55, &A5, &69, &10, &03, &20
  EQUB &8C, &6D, &A5, &86, &D0, &6D, &20, &FD
  EQUB &6B, &20, &96, &2B, &90, &62, &AD, &90
  EQUB &08, &F0, &0A, &20, &B2, &55, &A6, &83
  EQUB &A0, &03, &20, &89, &45, &A5, &43, &F0
  EQUB &4F, &A2, &0F, &20, &DA, &55, &A5, &8B
  EQUB &C9, &02, &F0, &3F, &C9, &1F, &90, &0A
  EQUB &A5, &43, &C9, &17, &D0, &35, &46, &43
  EQUB &46, &43, &A5, &68, &38, &E5, &43, &B0
  EQUB &28, &06, &64, &38, &66, &64, &A5, &8B
  EQUB &C9, &07, &D0, &10, &A5, &43, &C9, &32
  EQUB &D0, &0A, &20, &49, &4D, &A2, &08, &29
  EQUB &03, &20, &EB, &15, &A0, &04, &20, &DE
  EQUB &15, &A0, &05, &20, &DE, &15, &20, &CB
  EQUB &55, &85, &68, &A5, &8B, &20, &1C, &2C
  EQUB &20, &4E, &60, &A0, &23, &A5, &68, &91
  EQUB &1F, &A5, &69, &30, &2D, &A5, &64, &10
  EQUB &2C, &29, &20, &F0, &28, &A5, &69, &29
  EQUB &40, &0D, &D8, &08, &8D, &D8, &08, &AD
  EQUB &96, &08, &0D, &8D, &08, &D0, &13, &A0
  EQUB &0A, &B1, &1D, &F0, &0D, &AA, &C8, &B1
  EQUB &1D, &A8, &20, &2D, &3E, &A9, &00, &20
  EQUB &FC, &57, &4C, &34, &4B, &A5, &8B, &30
  EQUB &05, &20, &FD, &4F, &90, &F4, &A0, &1F
  EQUB &A5, &64, &91, &1F, &A6, &83, &E8, &4C
  EQUB &D8, &12, &AD, &CE, &08, &10, &10, &0E
  EQUB &CE, &08, &20, &FC, &6D, &A9, &83, &20
  EQUB &EE, &FF, &A9, &30, &20, &EE, &FF, &A5

 ELIF _SOURCE_DISC

  EQUB &20, &70, &55, &06, &64, &38, &66, &64   \ These bytes appear to be
  EQUB &D0, &17, &A9, &01, &85, &7C, &A9, &05   \ unused and just contain random
  EQUB &D0, &09, &06, &64, &38, &66, &64, &A5   \ workspace noise left over from
  EQUB &68, &38, &6A, &20, &18, &44, &20, &70   \ the BBC Micro assembly process
  EQUB &55, &A5, &69, &10, &03, &20, &8C, &6D
  EQUB &A5, &86, &D0, &6D, &20, &FD, &6B, &20
  EQUB &7A, &2B, &90, &62, &AD, &90, &08, &F0
  EQUB &0A, &20, &79, &55, &A6, &83, &A0, &03
  EQUB &20, &5E, &45, &A5, &43, &F0, &4F, &A2
  EQUB &0F, &20, &9C, &55, &A5, &8B, &C9, &02
  EQUB &F0, &3F, &C9, &1F, &90, &0A, &A5, &43
  EQUB &C9, &17, &D0, &35, &46, &43, &46, &43
  EQUB &A5, &68, &38, &E5, &43, &B0, &28, &06
  EQUB &64, &38, &66, &64, &A5, &8B, &C9, &07
  EQUB &D0, &10, &A5, &43, &C9, &32, &D0, &0A
  EQUB &20, &1E, &4D, &A2, &08, &29, &03, &20
  EQUB &E4, &15, &A0, &04, &20, &D7, &15, &A0
  EQUB &05, &20, &D7, &15, &20, &8D, &55, &85
  EQUB &68, &A5, &8B, &20, &00, &2C, &20, &4E
  EQUB &60, &A0, &23, &A5, &68, &91, &1F, &A5
  EQUB &69, &30, &2D, &A5, &64, &10, &2C, &29
  EQUB &20, &F0, &28, &A5, &69, &29, &40, &0D
  EQUB &D8, &08, &8D, &D8, &08, &AD, &96, &08
  EQUB &0D, &8D, &08, &D0, &13, &A0, &0A, &B1
  EQUB &1D, &F0, &0D, &AA, &C8, &B1, &1D, &A8
  EQUB &20, &02, &3E, &A9, &00, &20, &BE, &57
  EQUB &4C, &09, &4B, &A5, &8B, &30, &05, &20
  EQUB &D2, &4F, &90, &F4, &A0, &1F, &A5, &64
  EQUB &91, &1F, &A6, &83, &E8, &4C, &D6, &12
  EQUB &AD, &CE, &08, &10, &10, &0E, &CE, &08
  EQUB &20, &FC, &6D, &A9, &83, &20, &EE, &FF
  EQUB &A9, &30, &20, &EE, &FF, &A5, &89, &29

 ENDIF

ELSE

 SKIP 256               \ The pixel buffer to send with this command

ENDIF

