\ ******************************************************************************
\
\       Name: CHK
\       Type: Variable
\   Category: Save and load
\    Summary: First checksum byte for the saved commander data file
\
\ ------------------------------------------------------------------------------
\
\ Commander checksum byte, see elite-checksum.py for more details.
\
\ ******************************************************************************

.CHK

 EQUB CH%

PRINT "CH% = ", ~CH%

