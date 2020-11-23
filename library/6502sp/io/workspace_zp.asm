\ ******************************************************************************
\       Name: ZP
\ ******************************************************************************

ORG &0080

.ZP

 SKIP 0                 \ The start of the zero page workspace

INCLUDE "library/6502sp/io/variable_p.asm"
INCLUDE "library/common/main/variable_q.asm"
INCLUDE "library/common/main/variable_r.asm"
INCLUDE "library/common/main/variable_s.asm"
INCLUDE "library/common/main/variable_t.asm"
INCLUDE "library/common/main/variable_swap.asm"
INCLUDE "library/common/main/variable_t1.asm"
INCLUDE "library/common/main/variable_col.asm"
INCLUDE "library/6502sp/io/variable_ossc.asm"
