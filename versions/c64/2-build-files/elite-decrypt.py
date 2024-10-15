#!/usr/bin/env python
#
# ******************************************************************************
#
# COMMODORE 64 ELITE DECRYPTION SCRIPT
#
# Written by Mark Moxon
#
# This script removes encryption and checksums from the compiled binaries for
# the Commodore 64 version of Elite
#
# Files are saved using the decrypt.bin suffix so they don't overwrite any
# existing unprot.bin files, so they can be compared if required
#
# Run this script by changing directory to the repository's root folder and
# running the script with "python 2-build-files/elite-decrypt.py"
#
# You can decrypt specific releases by adding the following arguments, as in
# "python 2-build-files/elite-decrypt.py -rel2" for example:
#
#   -rel1   Decrypt the GMA85 NTSC release
#   -rel2   Decrypt the GMA86 PAL release
#   -rel3   Decrypt the version built by the source disk
#   -rel4   Decrypt the binaries already on the source disk
#
# If unspecified, the default is rel1
#
# ******************************************************************************

from __future__ import print_function
import sys

print()
print("Commodore 64 Elite decryption")

argv = sys.argv
release = 1
folder = "gma85-ntsc"

for arg in argv[1:]:
    if arg == "-rel1":
        release = 1
        folder = "gma85-ntsc"
    if arg == "-rel2":
        release = 2
        folder = "gma86-pal"
    if arg == "-rel3":
        release = 3
        folder = "source-disk-build"
    if arg == "-rel4":
        release = 4
        folder = "source-disk-files"

# Configuration variables for scrambling code and calculating checksums
#
# Values must match those in 3-assembled-output/compile.txt
#
# If you alter the source code, then you should extract the correct values for
# the following variables and plug them into the following, otherwise the game
# will fail the checksum process and will hang on loading
#
# You can find the correct values for these variables by building your updated
# source, and then searching compile.txt for "elite-checksum.py", where the new
# values will be listed

if release == 1 or release == 2:

    # GMA85/GMA86
    b = 0x1D00                  # B%
    g = 0x1D81                  # G%
    w = 0x4000                  # W%
    x = 0x7590                  # X%
    u = 0x75E4                  # U%

    prg = True                  # Convert gma4, gma5, gma6

    padding_comlod = 5          # Unencrypted bytes at the end of each file
    padding_locode = 3
    padding_hicode = 9

elif release == 3 or release == 4:

    # Source disk
    b = 0x1D00                  # B%
    g = 0x1D7E                  # G%
    w = 0x4000                  # W%
    x = 0x7601                  # X%
    u = 0x7655                  # U%

    prg = False                 # Convert COMLOD, LOCODE, HICODE

    padding_comlod = 0          # Unencrypted bytes at the end of each file
    padding_locode = 0
    padding_hicode = 0

# Load assembled HICODE/gma6 file

data_block = bytearray()

if prg:
    elite_file = open("4-reference-binaries/" + folder + "/gma6.bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()
    data_block = data_block[2:]
else:
    elite_file = open("4-reference-binaries/" + folder + "/HICODE.bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/HICODE.bin")

# Do decryption

seed = 0x49
unscramble_from = len(data_block) - 1 - padding_hicode
unscramble_to = 0 - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/HICODE.bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/HICODE.decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/HICODE.decrypted.bin")

# Load assembled LOCODE/gma5 file

data_block = bytearray()

if prg:
    elite_file = open("4-reference-binaries/" + folder + "/gma5.bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()
    data_block = data_block[2:]
else:
    elite_file = open("4-reference-binaries/" + folder + "/LOCODE.bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/LOCODE.bin")

# Do decryption

seed = 0x36
unscramble_from = len(data_block) - 1 - padding_locode
unscramble_to = g - b - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/LOCODE.bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/LOCODE.decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/LOCODE.decrypted.bin")

# Load assembled COMLOD/gma4 file

data_block = bytearray()

if prg:
    elite_file = open("4-reference-binaries/" + folder + "/gma4.bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()
    data_block = data_block[2:]
else:
    elite_file = open("4-reference-binaries/" + folder + "/COMLOD.bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/COMLOD.bin")

# Do decryption

seed = 0x8E
unscramble_from = len(data_block) - 1 - padding_comlod
unscramble_to = u - w - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

seed = 0x6C
unscramble_from = x - w - 1
unscramble_to = 0 - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/COMLOD.bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/COMLOD.decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/COMLOD.decrypted.bin")
print()
