\ ******************************************************************************
\
\       Name: BLOCK
\       Type: Variable
\   Category: Copy protection
\    Summary: Addresses for the obfuscated jumps that use RTS not JMP
\
\ ------------------------------------------------------------------------------
\
\ These two addresses get pushed onto the stack in part 4. The first EQUW is the
\ address of ENTRY2, while the second is the address of the first instruction in
\ part 6, after it is pushed onto the stack.
\
\ This entire section from BLOCK to ENDBLOCK gets copied into the stack at
\ location &015E by part 4, so by the time we call the routine at the second
\ EQUW address at the start, the entry point is on the stack at &0163.
\
\ This means that the RTS instructions at the end of parts 4 and 5 jump to
\ ENTRY2 and the start of part 6 respectively. See part 4 for details.
\
\ ******************************************************************************

.BLOCK

 EQUW ENTRY2-1

 EQUW 512-LEN+BLOCK-ENDBLOCK+3

