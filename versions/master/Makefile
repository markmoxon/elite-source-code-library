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
#                         sng47 (default)
#                         compact
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
#   make variant=compact commander=max encrypt=no match=no verify=no
#
# will build an unencrypted Master Compact variant with a maxed-out commander,
# no workspace noise and no crc32 verification

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

ifeq ($(variant-master), compact)
  variant-number_master=2
  folder_master=/compact
  suffix_master=-compact
  boot_master=-opt 2
else
  variant-number_master=1
  folder_master=/sng47
  suffix_master=-sng47
  boot_master=-boot M128Elt
endif

.PHONY:master
master:
	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_master) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v > versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py $(unencrypt) -rel$(variant-number_master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot_master) -do versions/master/5-compiled-game-discs/elite-master$(suffix_master).ssd -title "E L I T E"
ifneq ($(verify), no)
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries$(folder_master) versions/master/3-assembled-output
endif

.PHONY:b2-master
b2-master:
	curl -G "http://localhost:48075/reset/b2"
	curl -H "Content-Type:application/binary" --upload-file "versions/master/5-compiled-game-discs/elite-master$(suffix_master).ssd" "http://localhost:48075/run/b2?name=elite-master$(suffix_master).ssd"
