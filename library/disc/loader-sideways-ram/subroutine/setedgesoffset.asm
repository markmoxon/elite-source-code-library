\ ******************************************************************************
\
\       Name: SetEdgesOffset
\       Type: Subroutine
\   Category: Loader
\    Summary: Calculate the edges offset within sideways RAM for the blueprint
\             we are processing and set it in bytes #3 and #16 of the blueprint
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The blueprint number to process (0 to 30)
\
\   Y                   The offset within the XX21 table for blueprint X
\
\   P(1 0)              The address of the ship blueprint in the loaded ship
\                       blueprint file
\
\   ZP(1 0)             The address in sideways RAM where we are storing the
\                       ship blueprint that we are processing
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.SetEdgesOffset

 TYA                    \ Store X and Y on the stack so we can preserve them
 PHA                    \ through the subroutine
 TXA
 PHA

                        \ We start by calculating the following:
                        \
                        \   (U T) = P(1 0) + offset to the edges data
                        \
                        \ where the offset to the edges data is stored in bytes
                        \ #3 and #16 of the blueprint at P(1 0)
                        \
                        \ So (U T) will be the address of the edges data for
                        \ blueprint X within the loaded blueprints file

 CLC                    \ Clear the C flag for the following addition

 LDY #3                 \ Set A to byte #3 of the ship blueprint, which contains
 LDA (P),Y              \ the low byte of the offset to the edges data

 ADC P                  \ Set T = A + P
 STA T                  \
                        \ so this adds the low bytes of the calculation

 LDY #16                \ Set A to byte #16 of the ship blueprint, which
 LDA (P),Y              \ contains the high byte of the offset to the edges data

 ADC P+1                \ Set U = A + P+1
 STA U                  \
                        \ so this adds the high bytes of the calculation

 LDY #0                 \ We now step through the addresses in the XX21 table,
                        \ so set an address counter in Y, which we will
                        \ increment by 2 for each iteration (I will refer to
                        \ the address at index Y as the Y-th address, to keep
                        \ things simple)

 LDX #0                 \ We will store the blueprint number that contains the
                        \ edges data in X, so initialise it to zero

 LDA #LO(XX21)          \ Set V(1 0) to the address of the XX21 table in the
 STA V                  \ loaded blueprints file, which is the address of the
 LDA #HI(XX21)          \ start of the blueprints file (as XX21 is the first
 STA V+1                \ bit of data in the file)

.edge1

 LDA XX21,Y             \ If the Y-th address in XX21 >= (U T), jump to edge3 to
 CMP T                  \ move on to the next address in XX21
 LDA XX21+1,Y
 SBC U
 BCS edge3

.edge2

 LDA XX21,Y             \ If the Y-th address in XX21 < V(1 0), jump to edge3 to
 CMP V                  \ move on to the next address in XX21
 LDA XX21+1,Y
 SBC V+1
 BCC edge3

                        \ If we get here then the address in the Y-th entry in
                        \ XX21 is between V(1 0) and (U T), so it's between the
                        \ start of the loaded file and the edges data
                        \
                        \ We now store the entry number (in Y) in X, and update
                        \ V(1 0) so it contains the Y-th entry in XX21, as this
                        \ entry in the blueprints file contains the edges data

 LDA XX21,Y             \ Set V(1 0) to the Y-th address in XX21
 STA V
 LDA XX21+1,Y
 STA V+1

 TYA                    \ Set X = Y
 TAX

.edge3

 INY                    \ Increment the address counter in Y to point to the
 INY                    \ next address in XX21

 CPY #31 * 2            \ Loop back until we have worked our way through the
 BNE edge1              \ whole table

                        \ At this point, X is the number of the blueprint within
                        \ the loaded blueprint file that contains the edges data
                        \ for the blueprint we are processing, and (U T)
                        \ contains the address of the edges data for the
                        \ blueprint we are processing
                        \
                        \ We now use these values to calculate the offset for
                        \ the edges data within sideways RAM
                        \
                        \ First, we take the address in (U T), which is an
                        \ address within the X-th blueprint in the loaded ship
                        \ blueprint file, and convert it to the equivalent
                        \ address within the sideways RAM blueprints
                        \
                        \ We can do this by subtracting the address of the X-th
                        \ blueprint in the loaded ship file, and adding the
                        \ address of the X-th blueprint in sideways RAM

 SEC                    \ Set (U T) = (U T) - the X-th address in XX21
 LDA T
 SBC XX21,X
 STA T
 LDA U
 SBC XX21+1,X
 STA U

 CLC                    \ Set (U T) = (U T) + the X-th address in ROM_XX21
 LDA ROM_XX21,X
 ADC T
 STA T
 LDA ROM_XX21+1,X
 ADC U
 STA U

                        \ We now have the address of the edges data in sideways
                        \ RAM in (U T), so we can convert this to an offset by
                        \ subtracting the address of the start of the blueprint
                        \ we are storing, which is in ZP(1 0)

 SEC                    \ Set the edges data offset in bytes #3 and #16 in the
 LDA T                  \ blueprint in sideways RAM to the following:
 SBC ZP                 \
 LDY #3                 \   (U T) - ZP(1 0)
 STA (P),Y
 LDA U
 SBC ZP+1
 LDY #16
 STA (P),Y

 PLA                    \ Restore X and Y from the stack so they are preserved
 TAX                    \ through the subroutine
 PLA
 TAY

 RTS                    \ Return from the subroutine

