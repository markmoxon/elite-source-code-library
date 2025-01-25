\ ******************************************************************************
\
\       Name: wsect
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write a specific sector from the buffer to disk
\
\ ------------------------------------------------------------------------------
\
\ For a detailed look at how DOS works, see the book "Beneath Apple DOS" by Don
\ Worth and Pieter Lechner. In particular, see chapter 4 for the layout of the
\ VTOC, catalog sector, file entry and file/track list.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   track               The track number
\
\   sector              The sector number
\
\   buffer              Contains the data to write
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   wsect2              Read or write a sector, depending on the value of the
\                       C flag (clear = read, set = write)
\
\ ******************************************************************************

.wsect

 SEC                    \ Set the C flag to denote that this is a write
                        \ operation (this value will be read throughout the
                        \ RWTS code that follows)

.wsect2

 PHP                    \ Store the read/write status on the stack (specifically
                        \ the C flag)

 LDA #&60               \ Set the slot number containing the disk controller
 STA slot16             \ to 6 (storing it as the number multiplied by 16 so we
                        \ can use this as an offset to add to the soft switch
                        \ addresses for the disk controller, to ensure we access
                        \ the addresses for slot 6)

 LDA #2                 \ Set the maximum number of arm recalibrations to 2
 STA recals

 LDA #4                 \ Set the maximum number of seeks to 4
 STA seeks

 LDA #&D8               \ Set the high byte of the motor on time to &D8
 STA mtimeh

 LDX slot16             \ Set X to the disk controller card slot number * 16

                        \ Fall through into rwts to read or write the specified
                        \ sector

