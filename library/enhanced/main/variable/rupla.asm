\ ******************************************************************************
\
\       Name: RUPLA
\       Type: Variable
\   Category: Text
\    Summary: System numbers that have extended description overrides
\  Deep dive: Extended system descriptions
\             Extended text tokens
\             The Constrictor mission
\
\ ------------------------------------------------------------------------------
\
\ This table contains the extended token numbers to show as the specified
\ system's extended description, if the criteria in the RUGAL table are met.
\
\ The three variables work as follows:
\
\   * The RUPLA table contains the system numbers
\
\   * The RUGAL table contains the galaxy numbers and mission criteria
\
\   * The RUTOK table contains the extended token to display instead of the
\     normal extended description if the criteria in RUPLA and RUGAL are met
\
\ See the PDESC routine for details of how extended system descriptions work.
\
\ ******************************************************************************

.RUPLA

 EQUB 211               \ System 211, Galaxy 0                 Teorge = Token  1
 EQUB 150               \ System 150, Galaxy 0, Mission 1        Xeer = Token  2
 EQUB 36                \ System  36, Galaxy 0, Mission 1    Reesdice = Token  3
 EQUB 28                \ System  28, Galaxy 0, Mission 1       Arexe = Token  4
 EQUB 253               \ System 253, Galaxy 1, Mission 1      Errius = Token  5
 EQUB 79                \ System  79, Galaxy 1, Mission 1      Inbibe = Token  6
 EQUB 53                \ System  53, Galaxy 1, Mission 1       Ausar = Token  7
 EQUB 118               \ System 118, Galaxy 1, Mission 1      Usleri = Token  8
IF NOT(_NES_VERSION)
 EQUB 100               \ System 100, Galaxy 2                 Arredi = Token  9
ENDIF
 EQUB 32                \ System  32, Galaxy 1, Mission 1      Bebege = Token 10
 EQUB 68                \ System  68, Galaxy 1, Mission 1      Cearso = Token 11
 EQUB 164               \ System 164, Galaxy 1, Mission 1      Dicela = Token 12
 EQUB 220               \ System 220, Galaxy 1, Mission 1      Eringe = Token 13
 EQUB 106               \ System 106, Galaxy 1, Mission 1      Gexein = Token 14
 EQUB 16                \ System  16, Galaxy 1, Mission 1      Isarin = Token 15
 EQUB 162               \ System 162, Galaxy 1, Mission 1    Letibema = Token 16
 EQUB 3                 \ System   3, Galaxy 1, Mission 1      Maisso = Token 17
 EQUB 107               \ System 107, Galaxy 1, Mission 1        Onen = Token 18
 EQUB 26                \ System  26, Galaxy 1, Mission 1      Ramaza = Token 19
 EQUB 192               \ System 192, Galaxy 1, Mission 1      Sosole = Token 20
 EQUB 184               \ System 184, Galaxy 1, Mission 1      Tivere = Token 21
 EQUB 5                 \ System   5, Galaxy 1, Mission 1      Veriar = Token 22
 EQUB 101               \ System 101, Galaxy 2, Mission 1      Xeveon = Token 23
 EQUB 193               \ System 193, Galaxy 1, Mission 1      Orarra = Token 24
IF NOT(_NES_VERSION)
 EQUB 41                \ System  41, Galaxy 2                 Anreer = Token 25
ENDIF
IF _6502SP_VERSION  \ Advanced: The Executive version, the source disc variant of the 6502SP version, and the Master version all use token 26 to override the extended system description for Lave. The Executive version also uses token 27 to override the extended system description for Riedquat

IF _SOURCE_DISC

 EQUB 7                 \ System   7, Galaxy 0                   Lave = Token 26

ELIF _EXECUTIVE

 EQUB 7                 \ System   7, Galaxy 0                   Lave = Token 26
 EQUB 46                \ System  46, Galaxy 0               Riedquat = Token 27

ENDIF

ELIF _MASTER_VERSION
 EQUB 1                 \ System   7, Galaxy 16                  Lave = Token 26

ENDIF

