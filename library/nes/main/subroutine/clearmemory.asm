\ ******************************************************************************
\
\       Name: ClearMemory
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Clear a block of memory, split across multiple calls if required
\
\ ------------------------------------------------------------------------------
\
\ This routine clears a block of memory, but only if there are enough cycles in
\ the cycle count. If it runs out of cycles, it will pick up where it left off
\ when called again.
\
\ Arguments:
\
\   clearAddress        The address of the block to clear
\
\   clearBlockSize      The size of the block to clear as a 16-bit number, must
\                       be a multiple of 8 bytes
\
\ Returns:
\
\   clearAddress        The address of the next byte to clear in the block,
\                       ready for the next call (if the whole block was not
\                       cleared)
\
\   clearBlockSize      The size of the block, reduced by the number of bytes
\                       cleared in the current call, so it's ready for the next
\                       call (this will be 0 if this call cleared the whole
\                       block)
\
\ ******************************************************************************

.ClearMemory

 LDA clearBlockSize+1   \ If the high byte of the block size is zero, then jump
 BEQ cmem8              \ to cmem8 to clear a block of fewer than 256 bytes

                        \ If we get here then the high byte of the block size is
                        \ non-zero, so the block we need to clear consists of
                        \ one or more page-sized blocks (i.e. 256-byte blocks),
                        \ as well as one block with fewer than 256 bytes
                        \
                        \ We now concentrate on clearing the page-sized blocks,
                        \ leaving the block with fewer than 256 bytes for the
                        \ next VBlank

                        \ First we consider whether we can clear a block of 256
                        \ bytes

 SUBTRACT_CYCLES 2105   \ Subtract 2105 from the cycle count

 BMI cmem1              \ If the result is negative, jump to cmem1 to consider
                        \ clearing a 32-byte block in this VBlank, as we don't
                        \ have enough cycles for a 256-byte block

 JMP cmem2              \ The result is positive, so we have enough cycles to
                        \ clear a 256-byte block in this VBlank, so jump to
                        \ cmem2 to do just that

.cmem1

 ADD_CYCLES 2059        \ Add 2059 to the cycle count

 JMP cmem3              \ Jump to cmem3 to consider clearing the block with
                        \ fewer than 256 bytes

.cmem2

 LDA #0                 \ Set A = 0 so the call to FillMemory zeroes the memory
                        \ block

 LDY #0                 \ Set an index in Y to pass to FillMemory, so we start
                        \ clearing memory from clearAddress(1 0) onwards

 JSR FillMemory         \ Call FillMemory to clear a whole 256-byte block of
                        \ memory at clearAddress(1 0)

 DEC clearBlockSize+1   \ Decrement the high byte of clearBlockSize(1 0), which
                        \ is the same as subtracting 256, as we just cleared 256
                        \ bytes of memory

 INC clearAddress+1     \ Increment the high byte of clearAddress(1 0) to point
                        \ at the next 256-byte block of memory after the block
                        \ we just cleared, so we clear that next

 JMP ClearMemory        \ Jump back to ClearMemory to consider clearing the next
                        \ 256 bytes of memory

.cmem3

                        \ If we get here then we did not have enough cycles to
                        \ send a 256-byte block

                        \ Now we consider whether we can clear a block of 32
                        \ bytes

 SUBTRACT_CYCLES 318    \ Subtract 318 from the cycle count

 BMI cmem4              \ If the result is negative, jump to cmem4 to skip
                        \ clearing the next 32-byte block in this VBlank, as we
                        \ have run out of cycles (we will pick up where we left
                        \ off in the next VBlank)

 JMP cmem5              \ The result is positive, so we have enough cycles to
                        \ clear the next 32-byte block in this VBlank, so jump
                        \ to cmem5 to do just that

.cmem4

 ADD_CYCLES 277         \ Add 277 to the cycle count

 JMP cmem7              \ Jump to cmem7 to return from the subroutine

.cmem5

 LDA #0                 \ Set A = 0 so the call to FillMemory zeroes the memory
                        \ block

 LDY #0                 \ Set an index in Y to pass to FillMemory, so we start
                        \ clearing memory from clearAddress(1 0) onwards

 JSR FillMemory32Bytes  \ Call FillMemory to clear 32 bytes of memory from
                        \ clearAddress(1 0) to clearAddress(1 0) + 31

 LDA clearAddress       \ Set clearAddress(1 0) = clearAddress(1 0) + 32
 CLC                    \
 ADC #32                \ So it points at the next memory location to clear
 STA clearAddress       \ after the block we just cleared
 LDA clearAddress+1
 ADC #0
 STA clearAddress+1

 JMP cmem3              \ Jump back to cmem3 to consider clearing the next 32
                        \ bytes of memory, which we can keep doing until we run
                        \ out of cycles because we only get here if we don't
                        \ have enough cycles for a 256-byte block, so the cycles
                        \ will run out before we manage to clear eight blocks of
                        \ 32 bytes

.cmem6

 ADD_CYCLES_CLC 132     \ Add 132 to the cycle count

.cmem7

 RTS                    \ Return from the subroutine

.cmem8

                        \ If we get here then we need to clear a block of fewer
                        \ than 256 bytes

 SUBTRACT_CYCLES 186    \ Subtract 186 from the cycle count

 BMI cmem9              \ If the result is negative, jump to cmem9 to skip
                        \ clearing the block in this VBlank, as we have run out
                        \ of cycles (we will pick up where we left off in the
                        \ next VBlank)

 JMP cmem10             \ The result is positive, so we have enough cycles to
                        \ clear the block in this VBlank, so jump to cmem10
                        \ to do just that

.cmem9

 ADD_CYCLES 138         \ Add 138 to the cycle count

 JMP cmem7              \ Jump to cmem7 to return from the subroutine

.cmem10

 LDA clearBlockSize     \ Set A to the size of the block we need to clear, which
                        \ is in the low byte of clearBlockSize(1 0) (as we only
                        \ get here when the high byte of clearBlockSize(1 0) is
                        \ zero)

 BEQ cmem6              \ If the block size is zero, then there are no bytes to
                        \ clear, so jump to cmem6 to return from the subroutine

 LSR A                  \ Set A = clearBlockSize / 16
 LSR A
 LSR A
 LSR A

 CMP cycleCount+1       \ If A >= high byte of cycleCount(1 0), then:
 BCS cmem12             \
                        \   clearBlockSize / 16 >= cycleCount(1 0) / 256
                        \
                        \ so:
                        \
                        \   clearBlockSize >= cycleCount(1 0) / 16
                        \
                        \ If clearing each byte takes up to 16 cycles, then this
                        \ means we can't clear the whole block in this VBlank,
                        \ as we don't have enough cycles, so jump to cmem12 to
                        \ consider clearing it in blocks of 32 bytes rather than
                        \ all at once
                        \
                        \ (I don't know why this calculation counts 16 cycles
                        \ per byte, as it only takes 8 cycles for FILL_MEMORY
                        \ to clear a byte; perhaps it's an overestimation to be
                        \ safe and cater for all this extra logic code?)

                        \ If we get here then we can clear the block of memory
                        \ in one go

                        \ First we subtract the number of cycles that we need to
                        \ clear the memory block from the cycle count
                        \
                        \ Each call to the FILL_MEMORY macro takes 8 cycles (6
                        \ for the STA (clearAddress),Y instruction and 2 for the
                        \ INY instruction), so the total number of cycles we
                        \ will take will be clearBlockSize(1 0) * 8, so that's
                        \ what we subtract from the cycle count

 LDA #0                 \ Set the high byte of clearBlockSize(1 0) = 0 (though
 STA clearBlockSize+1   \ this should already be the case)

 LDA clearBlockSize     \ Set (A clearBlockSize+1) = clearBlockSize(1 0)

 ASL A                  \ Set (A clearBlockSize+1) = (A clearBlockSize+1) * 8
 ROL clearBlockSize+1   \                          = clearBlockSize(1 0) * 8
 ASL A
 ROL clearBlockSize+1
 ASL A
 ROL clearBlockSize+1

 EOR #&FF               \ Set cycleCount(1 0) = cycleCount(1 0)
 SEC                    \                        + ~(A clearBlockSize+1) + 1
 ADC cycleCount         \
 STA cycleCount         \   = cycleCount(1 0) - (A clearBlockSize+1)
 LDA clearBlockSize+1   \   = cycleCount(1 0) - clearBlockSize(1 0) * 8
 EOR #&FF
 ADC cycleCount+1
 STA cycleCount+1

                        \ Next we calculate the entry point into the FillMemory
                        \ routine that will fill clearBlockSize(1 0) bytes of
                        \ memory
                        \
                        \ FillMemory consists of 256 sequential FILL_MEMORY
                        \ macros, each of which fills one byte, as follows:
                        \
                        \   STA (clearAddress),Y
                        \   INY
                        \
                        \ The first instruction takes up two bytes while the INY
                        \ takes up one, so each byte that FillMemory fills takes
                        \ up three bytes of instruction memory
                        \
                        \ The FillMemory routine ends with an RTS, and is
                        \ followed by the ClearMemory routine, so we can work
                        \ out the entry point for filling clearBlockSize bytes
                        \ as follows:
                        \
                        \   ClearMemory - 1 - (3 * clearBlockSize)
                        \
                        \ The 1 is for the RTS, and each of the byte fills has
                        \ three instructions
                        \
                        \ So this is what we calculate next

 LDY #0                 \ Set an index in Y to pass to FillMemory (which we call
                        \ via the JMP (clearBlockSize) instruction below, so we
                        \ start clearing memory from clearAddress(1 0) onwards

 STY clearBlockSize+1   \ Set the high byte of clearBlockSize(1 0) = 0

 LDA clearBlockSize     \ Store the size of the memory block that we want to
 PHA                    \ clear on the stack, so we can retrieve it below

 ASL A                  \ Set clearBlockSize(1 0)
 ROL clearBlockSize+1   \        = clearBlockSize(1 0) * 2 + clearBlockSize(1 0)
 ADC clearBlockSize     \        = clearBlockSize(1 0) * 3
 STA clearBlockSize     \
 LDA clearBlockSize+1   \ So clearBlockSize(1 0) contains the block size * 3
 ADC #0
 STA clearBlockSize+1

                        \ At this point the C flag is clear, as the high byte
                        \ addition will never overflow, so this means the SBC
                        \ in the following will subtract an extra 1

 LDA #LO(ClearMemory)   \ Set clearBlockSize(1 0)
 SBC clearBlockSize     \        = ClearMemory - clearBlockSize(1 0) - 1
 STA clearBlockSize     \        = ClearMemory - (block size * 3) - 1
 LDA #HI(ClearMemory)   \
 SBC clearBlockSize+1   \ So clearBlockSize(1 0) is the address of the entry
 STA clearBlockSize+1   \ point in FillMemory that fills clearBlockSize(1 0)
                        \ bytes with zero, and we can now call it with this
                        \ instruction:
                        \
                        \   JMP (clearBlockSize)
                        \
                        \ So calling cmem11 below will fill memory with the
                        \ value of A, for clearBlockSize(1 0) bytes from
                        \ clearAddress(1 0) + Y onwards
                        \
                        \ We already set Y to 0 above, so it will start filling
                        \ from clearAddress(1 0) onwards

 LDA #0                 \ Set A = 0 so the call to FillMemory via the
                        \ JMP (clearBlockSize) instruction zeroes the memory
                        \ block

 JSR cmem11             \ Jump to cmem11 to call the correct entry point in
                        \ FillMemory to clear the memory block, returning here
                        \ when it's done

 PLA                    \ Set A to the size of the memory block that we want to
                        \ clear, which we stored on the stack above

 CLC                    \ Set clearAddress(1 0) = clearAddress(1 0) + A
 ADC clearAddress       \
 STA clearAddress       \ So it points at the next memory location to clear
 LDA clearAddress+1     \ after the block we just cleared
 ADC #0
 STA clearAddress+1

 RTS                    \ Return from the subroutine

.cmem11

 JMP (clearBlockSize)   \ We set up clearBlockSize(1 0) to point to the entry
                        \ point in FillMemory that will fill the correct number
                        \ of bytes with zero, so this clears our memory block
                        \ and returns to the PLA above using a tail call

.cmem12

                        \ If we get here then we need to consider clearing the
                        \ memory in blocks of 32 bytes rather than all at once

 ADD_CYCLES_CLC 118     \ Add 118 to the cycle count

.cmem13

 SUBTRACT_CYCLES 321    \ Subtract 321 from the cycle count

 BMI cmem14             \ If the result is negative, jump to cmem14 to skip
                        \ clearing the block in this VBlank, as we have run out
                        \ of cycles (we will pick up where we left off in the
                        \ next VBlank)

 JMP cmem15             \ The result is positive, so we have enough cycles to
                        \ clear the block in this VBlank, so jump to cmem15
                        \ to do just that

.cmem14

 ADD_CYCLES 280         \ Add 280 to the cycle count

 JMP cmem16             \ Jump to cmem16 to return from the subroutine

.cmem15

 LDA clearBlockSize     \ Set A = clearBlockSize - 32
 SEC
 SBC #32

 BCC cmem17             \ If the subtraction underflowed, then we need to clear
                        \ fewer than 32 bytes (as clearBlockSize < 32), so jump
                        \ to cmem17 to do just that

 STA clearBlockSize     \ Set clearBlockSize - 32 = A
                        \                         = clearBlockSize - 32
                        \
                        \ So clearBlockSize(1 0) is updated with the new block
                        \ size, as we are about to clear 32 bytes

 LDA #0                 \ Set A = 0 so the call to FillMemory32Bytes zeroes the
                        \ memory block

 LDY #0                 \ Set an index in Y to pass to FillMemory32Bytes, so we
                        \ start clearing memory from clearAddress(1 0) onwards

 JSR FillMemory32Bytes  \ Call FillMemory32Bytes to clear a 32-byte block of
                        \ memory at clearAddress(1 0)

 LDA clearAddress       \ Set clearAddress(1 0) = clearAddress(1 0) + 32
 CLC                    \
 ADC #32                \ So it points at the next memory location to clear
 STA clearAddress       \ after the block we just cleared
 BCC cmem13
 INC clearAddress+1

 JMP cmem13             \ Jump back to cmem13 to consider clearing the next 32
                        \ bytes of memory

.cmem16

 RTS                    \ Return from the subroutine

.cmem17

                        \ If we get here then we need to clear fewer than 32
                        \ bytes of memory

 ADD_CYCLES_CLC 269     \ Add 269 to the cycle count

.cmem18

 SUBTRACT_CYCLES 119    \ Subtract 119 from the cycle count

 BMI cmem19             \ If the result is negative, jump to cmem19 to skip
                        \ clearing the block in this VBlank, as we have run out
                        \ of cycles (we will pick up where we left off in the
                        \ next VBlank)

 JMP cmem20             \ The result is positive, so we have enough cycles to
                        \ clear the block in this VBlank, so jump to cmem20
                        \ to do just that

.cmem19

 ADD_CYCLES 78          \ Add 78 to the cycle count

 JMP cmem16             \ Jump to cmem16 to return from the subroutine

.cmem20

 LDA clearBlockSize     \ Set A = clearBlockSize - 8
 SEC
 SBC #8

 BCC cmem22             \ If the subtraction underflowed, then we need to clear
                        \ fewer than 8 bytes (as clearBlockSize < 8), so jump
                        \ to cmem22 to return from the subroutine, as this means
                        \ we have filled the whole block (as we only clear
                        \ memory blocks in multiples of 8 bytes)

 STA clearBlockSize     \ Set clearBlockSize - 8 = A
                        \                         = clearBlockSize - 8
                        \
                        \ So clearBlockSize(1 0) is updated with the new block
                        \ size, as we are about to clear 8 bytes

 LDA #0                 \ Set A = 0 so the FILL_MEMORY macro zeroes the memory
                        \ block

 LDY #0                 \ Set an index in Y to pass to the FILL_MEMORY macro, so
                        \ we start clearing memory from clearAddress(1 0)
                        \ onwards

 FILL_MEMORY 8          \ Fill eight bytes at clearAddress(1 0) + Y with A, so
                        \ this zeroes eight bytes at clearAddress(1 0) and
                        \ increments the index counter in Y

 LDA clearAddress       \ Set clearAddress(1 0) = clearAddress(1 0) + 8
 CLC                    \
 ADC #8                 \ So it points at the next memory location to clear
 STA clearAddress       \ after the block we just cleared
 BCC cmem21
 INC clearAddress+1

.cmem21

 JMP cmem18             \ Jump back to cmem18 to consider clearing the next 8
                        \ bytes of memory

.cmem22

 ADD_CYCLES_CLC 66      \ Add 66 to the cycle count

 RTS                    \ Return from the subroutine

