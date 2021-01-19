\ ******************************************************************************
\
\       Name: LL9 (Part 8 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the screen coordinates of visible vertices
\
\ ------------------------------------------------------------------------------
\
\ This section projects the coordinate of the vertex into screen coordinates and
\ stores them on the XX3 heap. By the end of this part, the XX3 heap contains
\ four bytes containing the 16-bit screen coordinates of the current vertex, in
\ the order: x_lo, x_hi, y_lo, y_hi.
\
\ When we reach here, we are looping through the vertices, and we've just worked
\ out the coordinates of the vertex in our normal coordinate system, as follows
\
\   XX15(2 0)           (x_sign x_lo) = x-coordinate of the current vertex
\
\   XX15(5 3)           (y_sign y_lo) = y-coordinate of the current vertex
\
\   (U T)               (z_sign z_lo) = z-coordinate of the current vertex
\
\ Note that U is always zero when we get to this point, as the vertex is always
\ in front of us (so it has a positive z-coordinate, into the screen).
\
\ Other entry points:
\
\   LL70+1              Contains an RTS (as the first byte of an LDA
\                       instruction)
\
\ ******************************************************************************

.LL60

 LDA T                  \ Set Q = z_lo
 STA Q

 LDA XX15               \ Set A = x_lo

 CMP Q                  \ If x_lo < z_lo jump to LL69
 BCC LL69

 JSR LL61               \ Call LL61 to calculate:
                        \
                        \   (U R) = 256 * A / Q
                        \         = 256 * x / z
                        \
                        \ which we can do as x >= z

 JMP LL65               \ Jump to LL65 to skip the division for x_lo < z_lo

.LL69

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * x / z
                        \
                        \ Because x < z, the result fits into one byte, and we
                        \ also know that U = 0, so (U R) also contains the
                        \ result

.LL65

                        \ At this point we have:
                        \
                        \   (U R) = x / z
                        \
                        \ so (U R) contains the vertex's x-coordinate projected
                        \ on screen
                        \
                        \ The next task is to convert (U R) to a pixel screen
                        \ coordinate and stick it on the XX3 heap.
                        \
                        \ We start with the x-coordinate. To convert the
                        \ x-coordinate to a screen pixel we add 128, the
                        \ x-coordinate of the centre of the screen, because the
                        \ projected value is relative to an origin at the centre
                        \ of the screen, but the origin of the screen pixels is
                        \ at the top-left of the screen

 LDX CNT                \ Fetch the pointer to the end of the XX3 heap from CNT
                        \ into X

 LDA XX15+2             \ If x_sign is negative, jump up to LL62, which will
 BMI LL62               \ store 128 - (U R) on the XX3 heap and return by
                        \ jumping down to LL66 below

 LDA R                  \ Calculate 128 + (U R), starting with the low bytes
 CLC
 ADC #128

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 INX                    \ Increment the heap pointer in X to point to the next
                        \ byte

 LDA U                  \ And then add the high bytes
 ADC #0

 STA XX3,X              \ Store the high byte of the result in the X-th byte of
                        \ the heap at XX3

.LL66

                        \ We've just stored the screen x-coordinate of the
                        \ vertex on the XX3 heap, so now for the y-coordinate

 TXA                    \ Store the heap pointer in X on the stack (at this
 PHA                    \ it points to the last entry on the heap, not the first
                        \ free byte)

 LDA #0                 \ Set U = 0
 STA U

 LDA T                  \ Set Q = z_lo
 STA Q

 LDA XX15+3             \ Set A = y_lo

 CMP Q                  \ If y_lo < z_lo jump to LL67
 BCC LL67

 JSR LL61               \ Call LL61 to calculate:
                        \
                        \   (U R) = 256 * A / Q
                        \         = 256 * y / z
                        \
                        \ which we can do as y >= z

 JMP LL68               \ Jump to LL68 to skip the division for y_lo < z_lo

.LL70

                        \ This gets called from below when y_sign is negative

 LDA #Y                 \ Calculate #Y + (U R), starting with the low bytes
 CLC
 ADC R

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 INX                    \ Increment the heap pointer in X to point to the next
                        \ byte

 LDA #0                 \ And then add the high bytes
 ADC U

 STA XX3,X              \ Store the high byte of the result in the X-th byte of
                        \ the heap at XX3

 JMP LL50               \ Jump to LL68 to skip the division for y_lo < z_lo

.LL67

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * y / z
                        \
                        \ Because y < z, the result fits into one byte, and we
                        \ also know that U = 0, so (U R) also contains the
                        \ result

.LL68

                        \ At this point we have:
                        \
                        \   (U R) = y / z
                        \
                        \ so (U R) contains the vertex's y-coordinate projected
                        \ on screen
                        \
                        \ We now want to convert this to a screen y-coordinate
                        \ and stick it on the XX3 heap, much like we did with
                        \ the x-coordinate above. Again, we convert the
                        \ coordinate by adding or subtracting the y-coordinate
                        \ of the centre of the screen, which is in the constant
                        \ #Y, but this time we do the opposite, as a positive
                        \ projected y-coordinate, i.e. up the space y-axis and
                        \ up the screen, converts to a low y-coordinate, which
                        \ is the opposite way round to the x-coordinates

 PLA                    \ Restore the heap pointer from the stack into X
 TAX

 INX                    \ When we stored the heap pointer, it pointed to the
                        \ last entry on the heap, not the first free byte, so we
                        \ increment it so it does point to the next free byte

 LDA XX15+5             \ If y_sign is negative, jump up to LL70, which will
 BMI LL70               \ store #Y + (U R) on the XX3 heap and return by jumping
                        \ down to LL50 below

 LDA #Y                 \ Calculate #Y - (U R), starting with the low bytes
 SEC
 SBC R

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 INX                    \ Increment the heap pointer in X to point to the next
                        \ byte

 LDA #0                 \ And then subtract the high bytes
 SBC U

 STA XX3,X              \ Store the high byte of the result in the X-th byte of
                        \ the heap at XX3

.LL50

                        \ By the time we get here, the XX3 heap contains four
                        \ bytes containing the screen coordinates of the current
                        \ vertex, in the order: x_lo, x_hi, y_lo, y_hi

 CLC                    \ Set CNT = CNT + 4, so the heap pointer points to the
 LDA CNT                \ next free byte on the heap
 ADC #4
 STA CNT

 LDA XX17               \ Set A to the offset of the current vertex's data,
                        \ which we set in part 6

 ADC #6                 \ Set Y = A + 6, so Y now points to the data for the
 TAY                    \ next vertex

 BCS LL72               \ If the addition just overflowed, meaning we just tried
                        \ to access vertex #43, jump to LL72, as the maximum
                        \ number of vertices allowed is 42

 CMP XX20               \ If Y >= number of vertices * 6 (which we stored in
 BCS LL72               \ XX20 in part 6), jump to LL72, as we have processed
                        \ all the vertices for this ship

 JMP LL48               \ Loop back to LL48 in part 6 to calculate visibility
                        \ and screen coordinates for the next vertex

