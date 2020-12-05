\ ******************************************************************************
\
\       Name: KTRAN
\       Type: Variable
\   Category: Keyboard
\    Summary: The key logger buffer that is populated by the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   buf                 The two OSWORD size configuration bytes for transmitting
\                       the key logger from the I/O processor to the parasite
\                       
\ ******************************************************************************

.buf

 EQUB 2                 \ Transmit 2 bytes as part of this command

 EQUB 15                \ Receive 15 bytes as part of this command

.KTRAN

 EQUS "1234567890"      \ A 17-byte buffer to hold the key logger data from the
 EQUS "1234567"         \ KEYBOARD routine in the I/O processor (note that only
                        \ 12 of these bytes are written to by the KEYBOARD
                        \ routine)

