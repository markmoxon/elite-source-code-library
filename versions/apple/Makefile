BEEBASM?=beebasm
PYTHON?=python
DISKM8?=diskm8

# A make command with no arguments will build the source disk variant with
# encrypted binaries, checksums enabled, the standard commander and crc32
# verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         ib-disk (default)
#                         source-disk-build (the binaries we get from running a build)
#                         source-disk-code-files (the CODE* binaries already on the source disk)
#                         source-disk-elt-files (the ELT* binaries already on the source disk)
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
#   make variant=source-disk-build commander=max encrypt=no match=no verify=no
#
# will build an unencrypted source disk variant with a maxed-out commander,
# no workspace noise and no crc32 verification
#
# The following variables are written into elite-build-options.asm depending on
# the above arguments, so they can be passed to BeebAsm:
#
# _VERSION
#   9 = Apple II
#
# _VARIANT
#   1 = Ian Bell's game disk (default)
#   2 = source disk build (the binaries from running a build of the source disk)
#   3 = source disk CODE files (the CODE* binaries already on the source disk)
#   4 = source disk ELT files (the ELT* binaries already on the source disk)
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

ifeq ($(variant-apple), source-disk-build)
  variant-number_apple=2
  folder_apple=source-disk-build
  suffix_apple=-source-disk-build
else ifeq ($(variant-apple), source-disk-code-files)
  variant-number_apple=3
  folder_apple=source-disk-code-files
  suffix_apple=-source-disk-code-files
else ifeq ($(variant-apple), source-disk-elt-files)
  variant-number_apple=4
  folder_apple=source-disk-elt-files
  suffix_apple=-source-disk-elt-files
else
  variant-number_apple=1
  folder_apple=ib-disk
  suffix_apple=-ib-disk
endif

.PHONY:apple
apple: apple-build apple-disk

apple-build:
	echo _VERSION=9 > versions/apple/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_apple) >> versions/apple/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/apple/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/apple/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/apple/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/apple/1-source-files/main-sources/elite-data.asm -v > versions/apple/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/apple/1-source-files/main-sources/elite-source.asm -v >> versions/apple/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/apple/1-source-files/main-sources/elite-bcfs.asm -v >> versions/apple/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/apple/1-source-files/main-sources/elite-mover.asm -v >> versions/apple/3-assembled-output/compile.txt
	$(PYTHON) versions/apple/2-build-files/elite-checksum.py $(unencrypt) -rel$(variant-number_apple)
	$(BEEBASM) -i versions/apple/1-source-files/main-sources/elite-transfer.asm -v >> versions/apple/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/apple/1-source-files/main-sources/elite-readme.asm -v >> versions/apple/3-assembled-output/compile.txt
ifneq ($(verify), no)
	@$(PYTHON) versions/apple/2-build-files/crc32.py versions/apple/4-reference-binaries/$(folder_apple) versions/apple/3-assembled-output
endif

apple-disk:
ifeq ($(variant-number_apple), 1)
  ifeq ($(OS), Windows_NT)
	del /Q /F versions\apple\5-compiled-game-disks\*.bin
	copy versions\apple\1-source-files\other-files\/$(folder_apple)\blank.dsk versions\apple\5-compiled-game-disks\elite-apple$(suffix_apple).dsk
	copy versions\apple\1-source-files\images\/$(folder_apple)\A.SCREEN.bin versions\apple\5-compiled-game-disks\elitepic#0x2000.bin
	copy versions\apple\3-assembled-output\DATA.bin versions\apple\5-compiled-game-disks\bee#0x3b00.bin
	copy versions\apple\3-assembled-output\CODE1.bin versions\apple\5-compiled-game-disks\four#0x4000.bin
	copy versions\apple\3-assembled-output\CODE2.bin versions\apple\5-compiled-game-disks\nine#0x5000.bin
	copy versions\apple\3-assembled-output\MOVER.bin versions\apple\5-compiled-game-disks\mover#0x0300.bin
  else
	rm -fr versions/apple/5-compiled-game-disks/*.bin
	cp versions/apple/1-source-files/other-files/$(folder_apple)/blank.dsk versions/apple/5-compiled-game-disks/elite-apple$(suffix_apple).dsk
	cp versions/apple/1-source-files/images/$(folder_apple)/A.SCREEN.bin versions/apple/5-compiled-game-disks/elitepic#0x2000.bin
	cp versions/apple/3-assembled-output/DATA.bin versions/apple/5-compiled-game-disks/bee#0x3b00.bin
	cp versions/apple/3-assembled-output/CODE1.bin versions/apple/5-compiled-game-disks/four#0x4000.bin
	cp versions/apple/3-assembled-output/CODE2.bin versions/apple/5-compiled-game-disks/nine#0x5000.bin
	cp versions/apple/3-assembled-output/MOVER.bin versions/apple/5-compiled-game-disks/mover#0x0300.bin
  endif
	$(DISKM8) -with-disk versions/apple/5-compiled-game-disks/elite-apple$(suffix_apple).dsk -file-put versions/apple/5-compiled-game-disks/elitepic#0x2000.bin
	$(DISKM8) -with-disk versions/apple/5-compiled-game-disks/elite-apple$(suffix_apple).dsk -file-put versions/apple/5-compiled-game-disks/nine#0x5000.bin
	$(DISKM8) -with-disk versions/apple/5-compiled-game-disks/elite-apple$(suffix_apple).dsk -file-put versions/apple/5-compiled-game-disks/bee#0x3b00.bin
	$(DISKM8) -with-disk versions/apple/5-compiled-game-disks/elite-apple$(suffix_apple).dsk -file-put versions/apple/5-compiled-game-disks/four#0x4000.bin
	$(DISKM8) -with-disk versions/apple/5-compiled-game-disks/elite-apple$(suffix_apple).dsk -file-put versions/apple/5-compiled-game-disks/mover#0x0300.bin
	$(DISKM8) -with-disk versions/apple/5-compiled-game-disks/elite-apple$(suffix_apple).dsk -file-put versions/apple/3-assembled-output/readme.txt
  ifeq ($(OS), Windows_NT)
	del /Q /F versions\apple\5-compiled-game-disks\*.bin
  else
	rm -fr versions/apple/5-compiled-game-disks/*.bin
  endif
endif
