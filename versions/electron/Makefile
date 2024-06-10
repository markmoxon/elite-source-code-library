BEEBASM?=beebasm
PYTHON?=python

# A make command with no arguments will build the Ian Bell Superior Software
# variant with the standard commander and crc32 verification of the game
# binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         ib-superior (default)
#                         ib-acornsoft
#
#   commander=max       Start with a maxed-out commander
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=ib-acornsoft commander=max verify=no
#
# will build the Ian Bell Acornsoft variant with a maxed-out commander and
# no crc32 verification
#
# The following variables are written into elite-build-options.asm depending on
# the above arguments, so they can be passed to BeebAsm:
#
# _VERSION
#   5 = Acorn Electron
#
# _VARIANT
#   1 = Ian Bell's Superior Software UEF (default)
#   2 = Ian Bell's Acornsoft UEF
#
# _MAX_COMMANDER
#   TRUE  = Maxed-out commander
#   FALSE = Standard commander
#
# The verify argument is passed to the crc32.py script, rather than BeebAsm

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

ifeq ($(variant-electron), ib-acornsoft)
  variant-number_electron=2
  folder_electron=/ib-acornsoft
  suffix_electron=-ib-acornsoft
else
  variant-number_electron=1
  folder_electron=/ib-superior
  suffix_electron=-ib-superior
endif

.PHONY:electron
electron:
	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_electron) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py $(unencrypt) -rel$(variant-number_electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix_electron).ssd -opt 3 -title "E L I T E"
ifneq ($(verify), no)
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries$(folder_electron) versions/electron/3-assembled-output
endif
