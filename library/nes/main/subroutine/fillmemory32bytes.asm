\ ******************************************************************************
\
\       Name: FillMemory32Bytes
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Fill a 32-byte block of memory with a specified value
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
\ Returns:
\
\   Y                   The index in Y is updated to point to the byte after the
\                       filled block
\
\ ******************************************************************************

.FillMemory32Bytes

 FILL_MEMORY 32         \ Fill 32 bytes at clearAddress(1 0) + Y with A

 RTS                    \ Return from the subroutine

