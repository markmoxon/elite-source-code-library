\ ******************************************************************************
\
\       Name: RUPLA
\       Type: Variable
\   Category: Text
\    Summary: System numbers that have special extended decriptions
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

 EQUB 211                \ Token  1, system 211, galaxy 0                 Teorge
 EQUB 150                \ Token  2, system 150, galaxy 0, mission 1        Xeer
 EQUB 36                 \ Token  3, system 36 , galaxy 0, mission 1    Reesdice
 EQUB 28                 \ Token  4, system 28 , galaxy 0, mission 1       Arexe
 EQUB 253                \ Token  5, system 253, galaxy 1, mission 1    Riattein
 EQUB 79                 \ Token  6, system 79 , galaxy 1, mission 1      Raaran
 EQUB 53                 \ Token  7, system 53 , galaxy 1, mission 1      Soisqu
 EQUB 118                \ Token  8, system 118, galaxy 1, mission 1     Arustea
 EQUB 100                \ Token  9, system 100, galaxy 2               Dimabion
 EQUB 32                 \ Token 10, system 32 , galaxy 1, mission 1    Dieranor
 EQUB 68                 \ Token 11, system 68 , galaxy 1, mission 1       Aanra
 EQUB 164                \ Token 12, system 164, galaxy 1, mission 1      Diquus
 EQUB 220                \ Token 13, system 220, galaxy 1, mission 1        Esdi
 EQUB 106                \ Token 14, system 106, galaxy 1, mission 1      Tetete
 EQUB 16                 \ Token 15, system 16 , galaxy 1, mission 1    Teescear
 EQUB 162                \ Token 16, system 162, galaxy 1, mission 1    Ususoner
 EQUB 3                  \ Token 17, system 3  , galaxy 1, mission 1    Leatanre
 EQUB 107                \ Token 18, system 107, galaxy 1, mission 1    Diriledi
 EQUB 26                 \ Token 19, system 26 , galaxy 1, mission 1    Titiridi
 EQUB 192                \ Token 20, system 192, galaxy 1, mission 1       Biabi
 EQUB 184                \ Token 21, system 184, galaxy 1, mission 1     Maarabi
 EQUB 5                  \ Token 22, system 5  , galaxy 1, mission 1      Revequ
 EQUB 101                \ Token 23, system 101, galaxy 2, mission 1    Attisoer
 EQUB 193                \ Token 24, system 193, galaxy 1, mission 1      Atbele
 EQUB 41                 \ Token 25, system 41 , galaxy 2               Edatreed
 EQUB 7                  \ Token 26, system 7  , galaxy 0                   Lave
                         