BEEBASM?=beebasm
PYTHON?=python
C1541?=c1541

# A make command with no arguments will build the GMA85 variant with
# encrypted binaries, checksums enabled, the standard commander and
# crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         gma85-ntsc (default)
#                         gma86-pal
#                         source-disk-build (the binaries we get from running a build)
#                         source-disk-files (the binaries already on the source disk)
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
#   make variant=gma86-pal commander=max encrypt=no match=no verify=no
#
# will build an unencrypted GMA85 PAL variant with a maxed-out commander,
# no workspace noise and no crc32 verification
#
# The following variables are written into elite-build-options.asm depending on
# the above arguments, so they can be passed to BeebAsm:
#
# _VERSION
#   8 = Commodore 64
#
# _VARIANT
#   1 = GMA85 NTSC (default)
#   2 = GMA85 PAL
#   3 = source disk build (the binaries from running a build of the source disk)
#   4 = source disk files (the binaries already on the source disk)
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

ifeq ($(variant-c64), source-disk-build)
  variant-number_c64=3
  folder_c64=source-disk-build
  suffix_c64=-source-disk-build
else ifeq ($(variant-c64), source-disk-files)
  variant-number_c64=4
  folder_c64=source-disk-files
  suffix_c64=-source-disk-files
else ifeq ($(variant-c64), gma86-pal)
  variant-number_c64=2
  folder_c64=gma86-pal
  suffix_c64=-gma86-pal
else
  variant-number_c64=1
  folder_c64=gma85-ntsc
  suffix_c64=-gma85-ntsc
endif

.PHONY:c64
c64: c64-build c64-disk

c64-build:
	echo _VERSION=8 > versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_c64) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/c64/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-data.asm -v > versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-sprites.asm -v >> versions/c64/3-assembled-output/compile.txt
ifeq ($(variant-number_c64), 1)
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-firebird.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-gma1.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-gma2.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-gma3.asm -v >> versions/c64/3-assembled-output/compile.txt
else ifeq ($(variant-number_c64), 2)
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-firebird.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-gma1.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-gma2.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-gma3.asm -v >> versions/c64/3-assembled-output/compile.txt
endif
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-source.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-loader.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-send.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/c64/1-source-files/main-sources/elite-readme.asm -v >> versions/c64/3-assembled-output/compile.txt
	$(PYTHON) versions/c64/2-build-files/elite-checksum.py $(unencrypt) -rel$(variant-number_c64)
ifneq ($(verify), no)
	@$(PYTHON) versions/c64/2-build-files/crc32.py versions/c64/4-reference-binaries/$(folder_c64) versions/c64/3-assembled-output
endif

c64-disk:
ifeq ($(variant-number_c64), 1)
	@$(C1541) \
    -format "elite,1" \
            d64 \
            versions/c64/5-compiled-game-disks/elite-commodore-64$(suffix_c64).d64 \
    -attach versions/c64/5-compiled-game-disks/elite-commodore-64$(suffix_c64).d64 \
    -write versions/c64/3-assembled-output/firebird.bin firebird \
    -write versions/c64/3-assembled-output/gma1.unprot.bin gma1 \
    -write versions/c64/3-assembled-output/gma3.bin gma3 \
    -write versions/c64/3-assembled-output/gma4.bin gma4 \
    -write versions/c64/3-assembled-output/gma5.bin gma5 \
    -write versions/c64/3-assembled-output/gma6.bin gma6 \
    -write versions/c64/3-assembled-output/readme.txt "readme,s"
else ifeq ($(variant-number_c64), 2)
	@$(C1541) \
    -format "elite,1" \
            d64 \
            versions/c64/5-compiled-game-disks/elite-commodore-64$(suffix_c64).d64 \
    -attach versions/c64/5-compiled-game-disks/elite-commodore-64$(suffix_c64).d64 \
    -write versions/c64/3-assembled-output/firebird.bin firebird \
    -write versions/c64/3-assembled-output/byebyejulie.bin byebyejulie \
    -write versions/c64/3-assembled-output/gma1.unprot.bin gma1 \
    -write versions/c64/3-assembled-output/gma3.bin gma3 \
    -write versions/c64/3-assembled-output/gma4.bin gma4 \
    -write versions/c64/3-assembled-output/gma5.bin gma5 \
    -write versions/c64/3-assembled-output/gma6.bin gma6 \
    -write versions/c64/3-assembled-output/readme.txt "readme,s"
endif