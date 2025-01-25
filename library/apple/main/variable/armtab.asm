\ ******************************************************************************
\
\       Name: armtab
\       Type: Variable
\   Category: Save and load
\    Summary: Phase-on time table in 100-usec intervals
\
\ ------------------------------------------------------------------------------
\
\ This table is identical to the ONTABLE table in Apple DOS 3.3.
\
\ The original DOS 3.3 source code for this table in is shown in the comments.
\
\ Elite uses different label names to the original DOS 3.3 source, but the code
\ is the same.
\
\ This code forms part of the RWTS ("read/write track sector") layer from Apple
\ DOS, which was written by Randy Wigginton and Steve Wozniak. It implements the
\ low-level functions to read and write Apple disks, and is included in Elite so
\ the game can use the memory that's normally allocated to DOS for its own use.
\
\ ******************************************************************************

.armtab

 EQUB 1                 \ ONTABLE  DFB 1,$30,$28
 EQUB &30               \          DFB $24,$20,$1E
 EQUB &28               \          DFB $1D,$1C,$1C
 EQUB &24               \          DFB $1C,$1C,$1C
 EQUB &20
 EQUB &1E
 EQUB &1D
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C

