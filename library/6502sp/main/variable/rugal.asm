\ ******************************************************************************
\
\       Name: RUGAL
\       Type: Variable
\   Category: Text
\    Summary: The criteria for systems with special extended descriptions
\
\ ------------------------------------------------------------------------------
\
\ This table contains the criteria for printing a special extended description
\ for a system. The galaxy number is in bits 0-6, while bit 7 determines whether
\ to show this token during mission 1 only (bit 7 is clear, i.e. a value of &0x
\ in the table below), or all of the time (bit 7 is set, i.e. a value of &8x in
\ the table below).
\
\ In other words, Teorge, Dimabion, Edatreed and Lave have special extended
\ descriptions that are always shown, while the rest only appear when mission 1
\ is in progress.
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

 EQUB &80                \ Token  1, system 211, galaxy 0                 Teorge
 EQUB &00                \ Token  2, system 150, galaxy 0, mission 1        Xeer
 EQUB &00                \ Token  3, system 36 , galaxy 0, mission 1    Reesdice
 EQUB &00                \ Token  4, system 28 , galaxy 0, mission 1       Arexe
 EQUB &01                \ Token  5, system 253, galaxy 1, mission 1      Orleso
 EQUB &01                \ Token  6, system 79 , galaxy 1, mission 1      Raaran
 EQUB &01                \ Token  7, system 53 , galaxy 1, mission 1      Soisqu
 EQUB &01                \ Token  8, system 118, galaxy 1, mission 1     Arustea
 EQUB &82                \ Token  9, system 100, galaxy 2               Dimabion
 EQUB &01                \ Token 10, system 32 , galaxy 1, mission 1    Dieranor
 EQUB &01                \ Token 11, system 68 , galaxy 1, mission 1       Aanra
 EQUB &01                \ Token 12, system 164, galaxy 1, mission 1      Diquus
 EQUB &01                \ Token 13, system 220, galaxy 1, mission 1        Esdi
 EQUB &01                \ Token 14, system 106, galaxy 1, mission 1      Tetete
 EQUB &01                \ Token 15, system 16 , galaxy 1, mission 1    Teescear
 EQUB &01                \ Token 16, system 162, galaxy 1, mission 1    Ususoner
 EQUB &01                \ Token 17, system 3  , galaxy 1, mission 1    Leatanre
 EQUB &01                \ Token 18, system 107, galaxy 1, mission 1    Diriledi
 EQUB &01                \ Token 19, system 26 , galaxy 1, mission 1    Titiridi
 EQUB &01                \ Token 20, system 192, galaxy 1, mission 1       Biabi
 EQUB &01                \ Token 21, system 184, galaxy 1, mission 1     Maarabi
 EQUB &01                \ Token 22, system 5  , galaxy 1, mission 1      Revequ
 EQUB &02                \ Token 23, system 101, galaxy 2, mission 1    Attisoer
 EQUB &01                \ Token 24, system 193, galaxy 1, mission 1      Atbele
 EQUB &82                \ Token 25, system 41 , galaxy 2               Edatreed
 EQUB &80                \ Token 26, system 7  , galaxy 0                   Lave
