\ ******************************************************************************
\
\       Name: mvsm
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy 280 bytes in memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (A ZP2)             The source address
\
\   ZP(1 0)             The destination address
\
\ ******************************************************************************

.mvsm

 LDX #1                 \ Set X = 1 to pass to mvblock so it copies one page of
                        \ data

 JSR mvblock            \ Call mvblock to copy 1 page of data (256 bytes) from
                        \ (A ZP2) to ZP(1 0)

 LDY #23                \ We now want to copy the next 24 bytes to give a total
                        \ of 280 bytes (as 256 + 24 = 280), so set abyte counter
                        \ in Y

 LDX #1                 \ Set X = 1 (though this has no effect, so this is
                        \ presumably left over from development)

.LOOP5new

 LDA (ZP2),Y            \ Copy the Y-th byte of ZP2(1 0) to the Y-th byte of
 STA (ZP),Y             \ ZP(1 0)

 DEY                    \ Decrement the byte counter to point to the next byte

 BPL LOOP5new           \ Loop back to LOOP5new until we have copied all
                        \ 24 bytes

 LDX #0                 \ Set X = 0

 RTS                    \ Return from the subroutine

