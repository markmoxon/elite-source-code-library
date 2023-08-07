\ ******************************************************************************
\
\       Name: SEND_DATA_TO_PPU
\       Type: Macro
\   Category: Drawing the screen
\    Summary: Send a specified block of memory to the PPU
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to send bytes to the PPU:
\
\   SEND_DATA_TO_PPU byte_count
\
\ It sends a block of byte_count bytes from memory to the PPU, starting with the
\ Y-th byte of the data block at address dataForPPU(1 0). It also updates the
\ index in Y to point to the byte after the block that is sent.
\
\ Arguments:
\
\   byte_count          The number of bytes to send to the PPU
\
\   Y                   The index into dataForPPU(1 0) from which to start
\                       sending data
\
\ Returns:
\
\   Y                   The index in Y is updated to point to the byte after the
\                       block that is sent
\
\ ******************************************************************************

MACRO SEND_DATA_TO_PPU byte_count

                        \ We do the following code byte_count times, so we send
                        \ a total of byte_count bytes from memory to the PPU

 FOR I%, 1, byte_count

  LDA (dataForPPU),Y    \ Send the Y-th byte of dataForPPU(1 0) to the PPU
  STA PPU_DATA

  INY                   \ Increment the index in Y

 NEXT

ENDMACRO

