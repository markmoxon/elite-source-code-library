BEEBASM?=beebasm
PYTHON?=python

# A make command with no arguments will build the SNG45 variant with
# encrypted binaries, checksums enabled, the standard commander and
# crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         sng45 (default)
#                         executive
#                         source-disc-build
#                         source-disc-files
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
#   3 = BBC Micro with 6502 Second Processor
#
# _VARIANT
#   1 = SNG45 (default)
#   2 = Executive version
#   3 = Source disc build (the binaries from running a build of the source disc)
#   4 = Source disc files (the binaries already on the source disc)
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

ifeq ($(variant-6502sp), executive)
  variant-number_6502sp=2
  folder_6502sp=executive
  suffix_6502sp=-executive
  boot_6502sp=-boot ELITE
else ifeq ($(variant-6502sp), source-disc-build)
  variant-number_6502sp=3
  folder_6502sp=source-disc-build
  suffix_6502sp=-from-source-disc-build
  boot_6502sp=-boot ELITE
else ifeq ($(variant-6502sp), source-disc-files)
  variant-number_6502sp=4
  folder_6502sp=source-disc-files
  suffix_6502sp=-from-source-disc-files
  boot_6502sp=-boot ELITE
else
  variant-number_6502sp=1
  folder_6502sp=sng45
  suffix_6502sp=-sng45
  boot_6502sp=-opt 2
endif

.PHONY:6502sp
6502sp:
	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_6502sp) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-boot.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py $(unencrypt) -rel$(variant-number_6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix_6502sp).ssd $(boot_6502sp) -title "E L I T E"
ifneq ($(verify), no)
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries/$(folder_6502sp) versions/6502sp/3-assembled-output
endif

.PHONY:b2-6502sp
b2-6502sp:
	curl -G "http://localhost:48075/reset/b2"
	curl -H "Content-Type:application/binary" --upload-file "versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix_6502sp).ssd" "http://localhost:48075/run/b2?name=elite-6502sp$(suffix_6502sp).ssd"
