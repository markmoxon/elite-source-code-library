#!/usr/bin/env python
#
# ******************************************************************************
#
# COMMODORE 64 ELITE CHECKSUM SCRIPT
#
# Written by Mark Moxon, and inspired by Kieran Connell's version for the
# cassette version of Elite
#
# This script applies encryption and checksums to the compiled binaries for the
# Commodore 64 version of Elite
#
# ******************************************************************************

from __future__ import print_function
import sys

argv = sys.argv
Encrypt = True
release = 1

for arg in argv[1:]:
    if arg == "-u":
        Encrypt = False
    if arg == "-rel1":
        release = 1
    if arg == "-rel2":
        release = 2
    if arg == "-rel3":
        release = 3

print("Commodure 64 Elite Checksum")
print("Encryption = ", Encrypt)

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

if release == 2 or release == 3:

    # Source disc
    b = 0x1D00                  # B%
    g = 0x1D7E                  # G%
    na2_per_cent = 0x2616       # NA2%
    u = 0x7655                  # U%
    v = 0x86cc                  # V%
    w = 0x4000                  # W%
    x = 0x7601                  # X%

# Load assembled code files that make up LOCODE file

data_block = bytearray()
eliteb_offset = 0
elited_offset = 0

# Append all assembled code files

elite_names = ("ELTA", "ELTB", "ELTC", "ELTD", "ELTE", "ELTF", "ELTG", "ELTH", "ELTI", "ELTJ", "ELTK")

for file_name in elite_names:
    print(str(len(data_block)), file_name)
    if file_name == "ELTB":
        eliteb_offset = len(data_block)
    if file_name == "ELTD":
        elited_offset = len(data_block)
    elite_file = open("versions/c64/3-assembled-output/" + file_name + ".bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()

# Write output file for LOCODE.unprot.bin

output_file = open("versions/c64/3-assembled-output/LOCODE.unprot.bin", "wb")
output_file.write(data_block[:elited_offset])
output_file.close()

print("versions/c64/3-assembled-output/LOCODE.unprot.bin file saved")

# Write output file for HICODE.unprot.bin

output_file = open("versions/c64/3-assembled-output/HICODE.unprot.bin", "wb")
output_file.write(data_block[elited_offset:])
output_file.close()

print("versions/c64/3-assembled-output/HICODE.unprot.bin file saved")

# Encrypt the LOCODE file

scramble_from = g - b
scramble_to = elited_offset - 1
seed = 0x36

if Encrypt:
    for n in range(scramble_from, scramble_to):
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Write output file for LOCODE

output_file = open("versions/c64/3-assembled-output/LOCODE.bin", "wb")
output_file.write(data_block[:elited_offset])
output_file.close()

print("versions/c64/3-assembled-output/LOCODE.bin file saved")

# Encrypt the HICODE file

scramble_from = elited_offset
scramble_to = len(data_block) - 1
seed = 0x49

if Encrypt:
    for n in range(scramble_from, scramble_to):
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Write output file for HICODE

output_file = open("versions/c64/3-assembled-output/HICODE.bin", "wb")
output_file.write(data_block[elited_offset:])
output_file.close()

print("versions/c64/3-assembled-output/HICODE.bin file saved")

# Load assembled code file for COMLOD

data_block = bytearray()

elite_file = open("versions/c64/3-assembled-output/COMLOD.unprot.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

# Encrypt the second half of the COMLOD file

scramble_from = u - w
scramble_to = len(data_block) - 1
seed = 0x8E

if Encrypt:
    for n in range(scramble_from, scramble_to):
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Encrypt the first half of the COMLOD file

scramble_from = 0
scramble_to = x - w - 1
seed = 0x6C

if Encrypt:
    for n in range(scramble_from, scramble_to):
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Write output file for COMLOD

output_file = open("versions/c64/3-assembled-output/COMLOD.bin", "wb")
output_file.write(data_block)
output_file.close()

print("versions/c64/3-assembled-output/COMLOD.bin file saved")
