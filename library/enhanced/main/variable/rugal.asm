\ ******************************************************************************
\
\       Name: RUGAL
\       Type: Variable
\   Category: Text
\    Summary: The criteria for systems with extended decription overrides
\  Deep dive: Extended system descriptions
\             Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This table contains the criteria for printing an extended decription override
\ for a system. The galaxy number is in bits 0-6, while bit 7 determines whether
\ to show this token during mission 1 only (bit 7 is clear, i.e. a value of &0x
\ in the table below), or all of the time (bit 7 is set, i.e. a value of &8x in
\ the table below).
\
\ In other words, Teorge, Arredi, Anreer and Lave have extended decription
\ overrides descriptions that are always shown, while the rest only appear when
\ mission 1 is in progress.
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

.RUGAL

 EQUB &80                \ System 211, Galaxy 0                Teorge = Token  1
 EQUB &00                \ System 150, Galaxy 0, Mission 1       Xeer = Token  2
 EQUB &00                \ System  36, Galaxy 0, Mission 1   Reesdice = Token  3
 EQUB &00                \ System  28, Galaxy 0, Mission 1      Arexe = Token  4
 EQUB &01                \ System 253, Galaxy 1, Mission 1     Errius = Token  5
 EQUB &01                \ System  79, Galaxy 1, Mission 1     Inbibe = Token  6
 EQUB &01                \ System  53, Galaxy 1, Mission 1      Ausar = Token  7
 EQUB &01                \ System 118, Galaxy 1, Mission 1     Usleri = Token  8
 EQUB &82                \ System 100, Galaxy 2                Arredi = Token  9
 EQUB &01                \ System  32, Galaxy 1, Mission 1     Bebege = Token 10
 EQUB &01                \ System  68, Galaxy 1, Mission 1     Cearso = Token 11
 EQUB &01                \ System 164, Galaxy 1, Mission 1     Dicela = Token 12
 EQUB &01                \ System 220, Galaxy 1, Mission 1     Eringe = Token 13
 EQUB &01                \ System 106, Galaxy 1, Mission 1     Gexein = Token 14
 EQUB &01                \ System  16, Galaxy 1, Mission 1     Isarin = Token 15
 EQUB &01                \ System 162, Galaxy 1, Mission 1   Letibema = Token 16
 EQUB &01                \ System   3, Galaxy 1, Mission 1     Maisso = Token 17
 EQUB &01                \ System 107, Galaxy 1, Mission 1       Onen = Token 18
 EQUB &01                \ System  26, Galaxy 1, Mission 1     Ramaza = Token 19
 EQUB &01                \ System 192, Galaxy 1, Mission 1     Sosole = Token 20
 EQUB &01                \ System 184, Galaxy 1, Mission 1     Tivere = Token 21
 EQUB &01                \ System   5, Galaxy 1, Mission 1     Veriar = Token 22
 EQUB &02                \ System 101, Galaxy 2, Mission 1     Xeveon = Token 23
 EQUB &01                \ System 193, Galaxy 1, Mission 1     Orarra = Token 24
 EQUB &82                \ System  41, Galaxy 2                Anreer = Token 25
IF _6502SP_VERSION \ Advanced: The source disc release of the 6502SP version overrides the extended system description for Lave. The Master version also has an override for Lave, but this time it's only for Lave in galaxy 16 (i.e. the 17th galaxy)

IF _SOURCE_DISC

 EQUB &80                \ System   7, Galaxy 0                  Lave = Token 26

ENDIF

ELIF _MASTER_VERSION
 EQUB &90                \ System   7, Galaxy 16                 Lave = Token 26

ENDIF

