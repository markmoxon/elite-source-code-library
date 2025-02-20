\ ******************************************************************************
\
\       Name: armtb2
\       Type: Variable
\   Category: Save and load
\    Summary: Phase-off time table in 100-usec intervals
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ This table is identical to the OFFTABLE table in Apple DOS 3.3.
\
\ The original DOS 3.3 source code for this table in is shown in the comments.
\
\ Elite uses different label names to the original DOS 3.3 source, but the code
\ is the same.
\
\ This code forms part of the RWTS ("read/write track-sector") layer from Apple
\ DOS, which was written by Randy Wigginton and Steve Wozniak. It implements the
\ low-level functions to read and write Apple disks, and is included in Elite so
\ the game can use the memory that's normally allocated to DOS for its own use.
\
\ ******************************************************************************

.armtb2

 EQUB &70               \ OFFTABLE DFB $70,$2C,$26
 EQUB &2C               \          DFB $22,$1F,$1E
 EQUB &26               \          DFB $1D,$1C,$1C
 EQUB &22               \          DFB $1C,$1C,$1C
 EQUB &1F
 EQUB &1E
 EQUB &1D
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C

