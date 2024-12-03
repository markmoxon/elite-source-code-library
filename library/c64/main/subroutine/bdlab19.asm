\ ******************************************************************************
\
\       Name: BDlab19
\       Type: Subroutine
\   Category: Sound
\    Summary: Increment the music data pointer in BDdataptr1(1 0) and fetch the
\             next data byte into A
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   Y is always 0
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   BDdataptr1(1 0)     Incremented to point to the next music data byte
\
\   A                   The next music data byte
\
\ ******************************************************************************

.BDlab19

 INC BDdataptr1         \ Increment the data pointer in BDdataptr1(1 0)
 BNE BDskipme1
 INC BDdataptr1+1

.BDskipme1

 LDA (BDdataptr1),Y     \ Y is zero, so this sets A to the next byte of music
                        \ data from BDdataptr1(1 0)
                        \
                        \ We have to include an index of Y as the 6502 doesn't
                        \ have an instruction of the form LDA (BDdataptr1)

 RTS                    \ Return from the subroutine

