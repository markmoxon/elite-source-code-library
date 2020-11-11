\ ******************************************************************************
\
\       Name: David7
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Part of the multi-jump obfuscation code in PROT1
\
\ ------------------------------------------------------------------------------
\
\ This instruction is part of the multi-jump obfuscation in PROT1 (see part 2 of
\ the loader), which does the following jumps:
\
\   David8 -> FRED1 -> David7 -> Ian1 -> David3
\
\ ******************************************************************************

.David7

 BCC Ian1               \ This instruction is part of the multi-jump obfuscation
                        \ in PROT1

