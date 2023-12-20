\ ******************************************************************************
\
\       Name: FillMemory
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Fill a block of memory with a specified value
\
\ ------------------------------------------------------------------------------
\
\ When called directly, this routine fills a whole page of memory (256 bytes)
\ with the value in A.
\
\ It can also be called at an arbitrary entry point to fill a specified number
\ of locations, anywhere from 0 to 255 bytes. The entry point is calculated as
\ as an offset backwards from the end of the FillMemory32Bytes routine (which
\ ends at ClearMemory), such that jumping to this entry point will fill the
\ required number of bytes. Each FILL_MEMORY macro call takes up three bytes
\ (two bytes for the STA (clearAddress),Y and one for the INY), so the
\ calculation is essentially:
\
\   ClearMemory - 1 - (3 * clearBlockSize)
\
\ where clearBlockSize is the size of the block to clear, in bytes. See the
\ ClearMemory routine for an example of this calculation in action.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   clearAddress(1 0)   The base address of the block of memory to fill
\
\   Y                   The index into clearAddress(1 0) from which to fill
\
\   A                   The value to fill
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   The index in Y is updated to point to the byte after the
\                       filled block
\
\ ******************************************************************************

.FillMemory

 FILL_MEMORY 224        \ Fill 224 bytes at clearAddress(1 0) + Y with A

                        \ Falling through into FillMemory32Bytes to fill another
                        \ 32 bytes, bringing the total to 256

