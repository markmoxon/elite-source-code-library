BEEBASM?=beebasm
PYTHON?=python

# A make command with no arguments will build the PAL variant with
# the standard commander and crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         pal (default)
#                         ntsc
#
#   commander=max       Start with a maxed-out commander
#
#   match=no            Do not attempt to match the original game binaries
#                       (i.e. omit workspace noise)
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=ntsc commander=max match=no verify=no
#
# will build an NTSC variant with a maxed-out commander, no workspace noise
# and no crc32 verification
#
# The following variables are written into elite-build-options.asm depending on
# the above arguments, so they can be passed to BeebAsm:
#
# _VERSION
#   7 = NES
#
# _VARIANT
#   1 = NTSC (default)
#   2 = PAL
#
# _MAX_COMMANDER
#   TRUE  = Maxed-out commander
#   FALSE = Standard commander
#
# _MATCH_ORIGINAL_BINARIES
#   TRUE  = Match binaries to released version (i.e. fill workspaces with noise)
#   FALSE = Zero-fill workspaces
#
# The verify argument is passed to the crc32.py script, rather than BeebAsm

ifeq ($(commander), max)
  max-commander=TRUE
else
  max-commander=FALSE
endif

ifeq ($(match), no)
  match-original-binaries=FALSE
else
  match-original-binaries=TRUE
endif

ifeq ($(variant-nes), ntsc)
  variant-number_nes=1
  folder_nes=ntsc
  suffix_nes=-ntsc
else
  variant-number_nes=2
  folder_nes=pal
  suffix_nes=-pal
endif

.PHONY:nes
nes:
	echo _VERSION=7 > versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_nes) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/nes/1-source-files/main-sources/elite-source-header.asm -v > versions/nes/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/nes/1-source-files/main-sources/elite-source-common.asm -v >> versions/nes/3-assembled-output/compile.txt
	cat versions/nes/3-assembled-output/header.bin versions/nes/3-assembled-output/bank0.bin versions/nes/3-assembled-output/bank1.bin versions/nes/3-assembled-output/bank2.bin versions/nes/3-assembled-output/bank3.bin versions/nes/3-assembled-output/bank4.bin versions/nes/3-assembled-output/bank5.bin versions/nes/3-assembled-output/bank6.bin versions/nes/3-assembled-output/bank7.bin > versions/nes/3-assembled-output/elite.bin
	cp versions/nes/3-assembled-output/elite.bin versions/nes/5-compiled-rom-images/ELITE$(suffix_nes).NES
ifneq ($(verify), no)
	@$(PYTHON) versions/nes/2-build-files/crc32.py versions/nes/4-reference-binaries/$(folder_nes) versions/nes/3-assembled-output
endif
