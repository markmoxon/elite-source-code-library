 \ a.icode - ELITE III encyclopedia

INCLUDE "converted_source_files/a.global.asm"

CODE% = &11E3
ORG CODE%
LOAD% = &11E3
EXEC% = &11E3


.dcode_in

 JMP dcode_2

.boot_in

 JMP dcode_2

.wrch_in

 JMP wrchdst
 EQUW &114B

.brk_in

 JMP brk_go

INCLUDE "converted_source_files/a.icode_1.asm"

INCLUDE "converted_source_files/a.icode_2.asm"

INCLUDE "converted_source_files/a.icode_3.asm"

SAVE "output/1.E", CODE%, P%, LOAD%