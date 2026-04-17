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
#   disc=no             Build a version to load from demo rather than disc
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
#
# The following variables are written into elite-build-options.asm depending on
# the above arguments, so they can be passed to BeebAsm:
#
# _VERSION
#   1 = BBC Micro demo
#
# _VARIANT
#   1 = Source disc
#   2 = Text sources
#   3 = Stairway to Hell (default)
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
# _DISC
#   TRUE  = Build for loading from disc
#   FALSE = Build for loading from demo
#
# _PROT
#   TRUE  = Apply block-level tape protection
#   FALSE = Do not apply block-level tape protection
#
# The encrypt and verify arguments are passed to the elite-checksum.py and
# crc32.py scripts, rather than BeebAsm

max-commander=FALSE

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

protect-tape=-p
prot=TRUE
tape-or-disc=
build-for-disc=TRUE
protect-tape=
prot=FALSE

variant-number_demo=1
suffix_demo=
folder_demo=demo

.PHONY:demo
demo:
	echo _VERSION=1 > versions/demo/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_demo) >> versions/demo/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/demo/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/demo/1-source-files/main-sources/elite-build-options.asm
	echo _DISC=$(build-for-disc) >> versions/demo/1-source-files/main-sources/elite-build-options.asm
	echo _PROT=$(prot) >> versions/demo/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/demo/1-source-files/main-sources/elite-source.asm -v > versions/demo/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/demo/1-source-files/main-sources/elite-bcfs.asm -v >> versions/demo/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/demo/1-source-files/main-sources/elite-loader.asm -v >> versions/demo/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/demo/1-source-files/main-sources/elite-readme.asm -v >> versions/demo/3-assembled-output/compile.txt
	$(PYTHON) versions/demo/2-build-files/elite-checksum.py $(unencrypt) $(tape-or-disc) $(protect-tape)
	$(BEEBASM) -i versions/demo/1-source-files/main-sources/elite-disc.asm -do versions/demo/5-compiled-game-discs/elite-demo$(suffix_demo).ssd -opt 3 -title "E L I T E"
ifneq ($(verify), no)
	@$(PYTHON) versions/demo/2-build-files/crc32.py versions/demo/4-reference-binaries/$(folder_demo) versions/demo/3-assembled-output
endif

.PHONY:b2-demo
b2-demo:
	curl -G "http://localhost:48075/reset/b2"
	curl -H "Content-Type:application/binary" --upload-file "versions/demo/5-compiled-game-discs/elite-demo$(suffix_demo).ssd" "http://localhost:48075/run/b2?name=elite-demo$(suffix_demo).ssd"
