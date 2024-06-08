BEEBASM?=beebasm
PYTHON?=python

# A make command with no arguments will build the source disc variant with
# encrypted binaries, checksums enabled, the standard commander and crc32
# verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         source-disc (default)
#                         text-sources
#                         sth
#
#   disc=no             Build a version to load from cassette rather than disc
#
#   protect=no          Disable block-level tape protection code (disc=no only)
#
#   commander=max       Start with a maxed-out commander
#
#   encrypt=no          Disable encryption and checksum routines
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=text-sources commander=max encrypt=no verify=no
#
# will build an unencrypted text sources variant with a maxed-out commander
# and no crc32 verification

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

ifeq ($(protect), no)
  protect-tape=
  prot=FALSE
else
  protect-tape=-p
  prot=TRUE
endif

ifeq ($(disc), no)
  tape-or-disc=-t
  build-for-disc=FALSE
else
  tape-or-disc=
  build-for-disc=TRUE
  protect-tape=
  prot=FALSE
endif

ifeq ($(variant-cassette), text-sources)
  variant-number_cassette=2
  folder_cassette=/text-sources
  suffix_cassette=-from-text-sources
else ifeq ($(variant-cassette), source-disc)
  variant-number_cassette=1
  folder_cassette=/source-disc
  suffix_cassette=-from-source-disc
else
  variant-number_cassette=3
  suffix_cassette=-sth
  ifeq ($(disc), no)
    folder_cassette=/sth-for-tape
  else
    folder_cassette=/sth
  endif
endif

.PHONY:cassette
cassette:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_cassette) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _DISC=$(build-for-disc) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _PROT=$(prot) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py $(unencrypt) $(tape-or-disc) $(protect-tape) -rel$(variant-number_cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix_cassette).ssd -opt 3 -title "E L I T E"
ifneq ($(verify), no)
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries$(folder_cassette) versions/cassette/3-assembled-output
endif

.PHONY:b2-cassette
b2-cassette:
	curl -G "http://localhost:48075/reset/b2"
	curl -H "Content-Type:application/binary" --upload-file "versions/cassette/5-compiled-game-discs/elite-cassette$(suffix_cassette).ssd" "http://localhost:48075/run/b2?name=elite-cassette$(suffix_cassette).ssd"
