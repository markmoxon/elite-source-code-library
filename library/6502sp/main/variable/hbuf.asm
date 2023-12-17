\ ******************************************************************************
\
\       Name: HBUF
\       Type: Variable
\   Category: Drawing lines
\    Summary: The horizontal line buffer to send with the OSWORD 247 command
\
\ ******************************************************************************

.HBUF

 EQUB 0                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45

  EQUB &D7, &08, &F0, &0F, &A0, &0C, &20, &62   \ These bytes appear to be
  EQUB &45, &A9, &28, &20, &C3, &55, &A9, &00   \ unused and just contain random
  EQUB &8D, &90, &08, &A5, &44, &10, &12, &AD   \ workspace noise left over from
  EQUB &4B, &08, &F0, &0D, &AE, &D7, &08, &F0   \ the BBC Micro assembly process
  EQUB &08, &8D, &90, &08, &A0, &0F, &20, &91
  EQUB &45, &AD, &4D, &08, &F0, &07, &A5, &44
  EQUB &30, &3F, &20, &E1, &2B, &AD, &49, &08
  EQUB &F0, &03, &0E, &CE, &08, &AD, &51, &08
  EQUB &F0, &05, &A9, &00, &8D, &8B, &08, &AD
  EQUB &4A, &08, &2D, &D2, &08, &F0, &08, &AD
  EQUB &8D, &08, &D0, &03, &4C, &F0, &25, &AD
  EQUB &4F, &08, &F0, &03, &20, &14, &55, &AD
  EQUB &4E, &08, &2D, &CC, &08, &F0, &0A, &A5
  EQUB &2F, &D0, &06, &CE, &8C, &08, &20, &70
  EQUB &45, &AD, &50, &08, &2D, &D0, &08, &F0
  EQUB &03, &8D, &8B, &08, &A9, &00, &85, &43
  EQUB &85, &7D, &A5, &7C, &4A, &66, &7D, &4A
  EQUB &66, &7D, &85, &7E, &AD, &92, &08, &D0
  EQUB &2E, &AD, &48, &08, &F0, &29, &AD, &93
  EQUB &08, &C9, &F2, &B0, &22, &AE, &91, &08
  EQUB &BD, &B4, &08, &F0, &1A, &48, &29, &7F
  EQUB &85, &43, &8D, &8F, &08, &A9, &00, &20
  EQUB &C3, &55, &20, &CF, &31, &68, &10, &02
  EQUB &A9, &00, &29, &FA, &8D, &92, &08, &A2
  EQUB &00, &86, &83, &BD, &52, &08, &D0, &03
  EQUB &4C, &96, &14, &85, &8B, &20, &6C, &44
  EQUB &A0, &24, &B1, &1F, &99, &45, &00, &88
  EQUB &10, &F8, &A5, &8B, &30, &27, &0A, &A8
  EQUB &B9, &FE, &CF, &85, &1D, &B9, &FF, &CF
  EQUB &85, &1E, &AD, &CE, &08, &10, &16, &C0
  EQUB &04, &F0, &12, &C0, &3E, &B0, &0E, &A5
  EQUB &64, &29, &20, &D0, &08, &06, &64, &38

 ELIF _EXECUTIVE

  EQUB &08, &2D, &D7, &08, &F0, &0F, &A0, &0C   \ These bytes appear to be
  EQUB &20, &87, &45, &A9, &28, &20, &F8, &55   \ unused and just contain random
  EQUB &A9, &00, &8D, &90, &08, &A5, &44, &10   \ workspace noise left over from
  EQUB &12, &AD, &4B, &08, &F0, &0D, &AE, &D7   \ the BBC Micro assembly process
  EQUB &08, &F0, &08, &8D, &90, &08, &A0, &0F
  EQUB &20, &B6, &45, &AD, &4D, &08, &F0, &07
  EQUB &A5, &44, &30, &3F, &20, &FD, &2B, &AD
  EQUB &49, &08, &F0, &03, &0E, &CE, &08, &AD
  EQUB &51, &08, &F0, &05, &A9, &00, &8D, &8B
  EQUB &08, &AD, &4A, &08, &2D, &D2, &08, &F0
  EQUB &08, &AD, &8D, &08, &D0, &03, &4C, &0C
  EQUB &26, &AD, &4F, &08, &F0, &03, &20, &44
  EQUB &55, &AD, &4E, &08, &2D, &CC, &08, &F0
  EQUB &0A, &A5, &2F, &D0, &06, &CE, &8C, &08
  EQUB &20, &95, &45, &AD, &50, &08, &2D, &D0
  EQUB &08, &F0, &03, &8D, &8B, &08, &A9, &00
  EQUB &85, &43, &85, &7D, &A5, &7C, &4A, &66
  EQUB &7D, &4A, &66, &7D, &85, &7E, &AD, &92
  EQUB &08, &D0, &2E, &AD, &48, &08, &F0, &29
  EQUB &AD, &93, &08, &C9, &F2, &B0, &22, &AE
  EQUB &91, &08, &BD, &B4, &08, &F0, &1A, &48
  EQUB &29, &7F, &85, &43, &8D, &8F, &08, &A9
  EQUB &00, &20, &F8, &55, &20, &EB, &31, &68
  EQUB &10, &02, &A9, &00, &29, &FA, &8D, &92
  EQUB &08, &A2, &00, &86, &83, &BD, &52, &08
  EQUB &D0, &03, &4C, &98, &14, &85, &8B, &20
  EQUB &91, &44, &A0, &24, &B1, &1F, &99, &45
  EQUB &00, &88, &10, &F8, &A5, &8B, &30, &27
  EQUB &0A, &A8, &B9, &FE, &CF, &85, &1D, &B9
  EQUB &FF, &CF, &85, &1E, &AD, &CE, &08, &10
  EQUB &16, &C0, &04, &F0, &12, &C0, &3E, &B0
  EQUB &0E, &A5, &64, &29, &20, &D0, &08, &06

 ELIF _SOURCE_DISC

  EQUB &D7, &08, &F0, &0F, &A0, &0C, &20, &5C   \ These bytes appear to be
  EQUB &45, &A9, &28, &20, &BA, &55, &A9, &00   \ unused and just contain random
  EQUB &8D, &90, &08, &A5, &44, &10, &12, &AD   \ workspace noise left over from
  EQUB &4B, &08, &F0, &0D, &AE, &D7, &08, &F0   \ the BBC Micro assembly process
  EQUB &08, &8D, &90, &08, &A0, &0F, &20, &8B
  EQUB &45, &AD, &4D, &08, &F0, &07, &A5, &44
  EQUB &30, &3F, &20, &E1, &2B, &AD, &49, &08
  EQUB &F0, &03, &0E, &CE, &08, &AD, &51, &08
  EQUB &F0, &05, &A9, &00, &8D, &8B, &08, &AD
  EQUB &4A, &08, &2D, &D2, &08, &F0, &08, &AD
  EQUB &8D, &08, &D0, &03, &4C, &F0, &25, &AD
  EQUB &4F, &08, &F0, &03, &20, &0B, &55, &AD
  EQUB &4E, &08, &2D, &CC, &08, &F0, &0A, &A5
  EQUB &2F, &D0, &06, &CE, &8C, &08, &20, &6A
  EQUB &45, &AD, &50, &08, &2D, &D0, &08, &F0
  EQUB &03, &8D, &8B, &08, &A9, &00, &85, &43
  EQUB &85, &7D, &A5, &7C, &4A, &66, &7D, &4A
  EQUB &66, &7D, &85, &7E, &AD, &92, &08, &D0
  EQUB &2E, &AD, &48, &08, &F0, &29, &AD, &93
  EQUB &08, &C9, &F2, &B0, &22, &AE, &91, &08
  EQUB &BD, &B4, &08, &F0, &1A, &48, &29, &7F
  EQUB &85, &43, &8D, &8F, &08, &A9, &00, &20
  EQUB &BA, &55, &20, &CF, &31, &68, &10, &02
  EQUB &A9, &00, &29, &FA, &8D, &92, &08, &A2
  EQUB &00, &86, &83, &BD, &52, &08, &D0, &03
  EQUB &4C, &96, &14, &85, &8B, &20, &66, &44
  EQUB &A0, &24, &B1, &1F, &99, &45, &00, &88
  EQUB &10, &F8, &A5, &8B, &30, &27, &0A, &A8
  EQUB &B9, &FE, &CF, &85, &1D, &B9, &FF, &CF
  EQUB &85, &1E, &AD, &CE, &08, &10, &16, &C0
  EQUB &04, &F0, &12, &C0, &3E, &B0, &0E, &A5
  EQUB &64, &29, &20, &D0, &08, &06, &64, &38

 ENDIF

ELSE

 SKIP 256               \ The horizontal line buffer to send with this command

ENDIF

