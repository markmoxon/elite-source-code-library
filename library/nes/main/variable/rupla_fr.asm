\ ******************************************************************************
\
\       Name: RUPLA_FR
\       Type: Variable
\   Category: Text
\    Summary: System numbers that have extended description overrides (French)
\  Deep dive: Extended system descriptions
\             Extended text tokens
\             Multi-language support in NES Elite
\             The Constrictor mission
\
\ ------------------------------------------------------------------------------
\
\ This table contains the extended token numbers to show as the specified
\ system's extended description, if the criteria in the RUGAL_FR table are met.
\
\ The three variables work as follows:
\
\   * The RUPLA_FR table contains the system numbers
\
\   * The RUGAL_FR table contains the galaxy numbers and mission criteria
\
\   * The RUTOK_FR table contains the extended token to display instead of the
\     normal extended description if the criteria in RUPLA_FR and RUGAL_FR are
\     met
\
\ See the PDESC routine for details of how extended system descriptions work.
\
\ ******************************************************************************

.RUPLA_FR

 EQUB 211               \ System 211, Galaxy 0                 Teorge = Token  1
 EQUB 150               \ System 150, Galaxy 0, Mission 1        Xeer = Token  2
 EQUB 36                \ System  36, Galaxy 0, Mission 1    Reesdice = Token  3
 EQUB 28                \ System  28, Galaxy 0, Mission 1       Arexe = Token  4
 EQUB 253               \ System 253, Galaxy 1, Mission 1      Errius = Token  5
 EQUB 79                \ System  79, Galaxy 1, Mission 1      Inbibe = Token  6
 EQUB 53                \ System  53, Galaxy 1, Mission 1       Ausar = Token  7
 EQUB 118               \ System 118, Galaxy 1, Mission 1      Usleri = Token  8
 EQUB 32                \ System  32, Galaxy 1, Mission 1      Bebege = Token  9
 EQUB 68                \ System  68, Galaxy 1, Mission 1      Cearso = Token 10
 EQUB 164               \ System 164, Galaxy 1, Mission 1      Dicela = Token 11
 EQUB 220               \ System 220, Galaxy 1, Mission 1      Eringe = Token 12
 EQUB 106               \ System 106, Galaxy 1, Mission 1      Gexein = Token 13
 EQUB 16                \ System  16, Galaxy 1, Mission 1      Isarin = Token 14
 EQUB 162               \ System 162, Galaxy 1, Mission 1    Letibema = Token 15
 EQUB 3                 \ System   3, Galaxy 1, Mission 1      Maisso = Token 16
 EQUB 107               \ System 107, Galaxy 1, Mission 1        Onen = Token 17
 EQUB 26                \ System  26, Galaxy 1, Mission 1      Ramaza = Token 18
 EQUB 192               \ System 192, Galaxy 1, Mission 1      Sosole = Token 19
 EQUB 184               \ System 184, Galaxy 1, Mission 1      Tivere = Token 20
 EQUB 5                 \ System   5, Galaxy 1, Mission 1      Veriar = Token 21
 EQUB 101               \ System 101, Galaxy 2, Mission 1      Xeveon = Token 22
 EQUB 193               \ System 193, Galaxy 1, Mission 1      Orarra = Token 23

