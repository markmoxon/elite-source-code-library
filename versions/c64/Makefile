BEEBASM?=beebasm
PYTHON?=python

# A make command with no arguments will build the SNG47 variant with
# encrypted binaries, checksums enabled, the standard commander and
# crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         source-disc (default)
#
#   commander=max       Start with a maxed-out commander
#
#   encrypt=no          Disable encryption and checksum routines
#
#   match=no            Do not attempt to match the original game binaries
#                       (i.e. omit workspace noise)
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=source-disc commander=max encrypt=no match=no verify=no
#
# will build an unencrypted source disc variant with a maxed-out commander,
# no workspace noise and no crc32 verification
#
# The following variables are written into elite-build-options.asm depending on
# the above arguments, so they can be passed to BeebAsm:
#
# _VERSION
#   8 = Commodore 64
#
# _VARIANT
#   1 = source disc (default)
#
# _MAX_COMMANDER
#   TRUE  = Maxed-out commander
#   FALSE = Standard commander
#
# _REMOVE_CHECKSUMS
#   TRUE  = Disable checksum routines
#   FALSE = Enable checksum routines
#
# _MATCH_ORIGINAL_BINARIES
#   TRUE  = Match binaries to released version (i.e. fill workspaces with noise)
#   FALSE = Zero-fill workspaces
#
# The encrypt and verify arguments are passed to the elite-checksum.py and
# crc32.py scripts, rather than BeebAsm

ifeq ($(commander), max)
  max-commander=TRUE
else
  max-commander=FALSE
endif

ifeq ($(encrypt), no)
  unencrypt=-u
  remove-checksums=TRUE
else
  unencrypt=
  remove-checksums=FALSE
endif

ifeq ($(match), no)
  match-original-binaries=FALSE
else
  match-original-binaries=TRUE
endif

 variant-number_c64=1
 folder_c64=/source-disc
 suffix_c64=-source-disc

.PHONY:c64
c64:
	echo _VERSION=8 > versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_c64) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-source.asm -v > versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-readme.asm -v >> versions/c64/3-assembled-output/compile.txt
	#$(PYTHON) versions/c64/2-build-files/elite-checksum.py $(unencrypt) -rel$(variant-number_c64)
	#$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-disc.asm -do versions/c64/5-compiled-game-discs/elite-c64$(suffix_c64).ssd -title "E L I T E"
ifneq ($(verify), no)
	@$(PYTHON) versions/c64/2-build-files/crc32.py versions/c64/4-reference-binaries$(folder_c64) versions/c64/3-assembled-output
endif
