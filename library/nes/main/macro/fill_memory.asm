\ ******************************************************************************
\
\       Name: FILL_MEMORY
\       Type: Macro
\   Category: Drawing tiles
\    Summary: Fill memory with the specified number of bytes
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to fill a block of memory with the same value:
\
\   FILL_MEMORY byte_count
\
\ It writes the value A into byte_count bytes, starting at the Y-th byte of the
\ memory block at addresss addr6(1 0). It also updates the index in Y to point
\ to the byte after the block that is filled.
\
\ Arguments:
\
\   byte_count          The number of bytes to fill
\
\   addr6(1 0)          The base address of the block of memory to fill
\
\   Y                   The index into addr6(1 0) from which to fill
\
\   A                   The value to fill
\
\ Returns:
\
\   Y                   The index in Y is updated to point to the byte after the
\                       filled block
\
\ ******************************************************************************

MACRO FILL_MEMORY byte_count

 FOR I%, 1, byte_count

  STA (addr6),Y         \ Write A to the Y-th byte of addr6(1 0)

  INY                   \ Increment the index in Y

 NEXT

ENDMACRO

