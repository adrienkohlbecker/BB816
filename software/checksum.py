import struct

path = "software/main.bin"
addr = 0x7fde

def checksum(file):
  cksum = 0
  while num := file.read(2):
    cksum = (cksum + int.from_bytes(num, byteorder='little')) % 65536
  return cksum

with open(path, mode='r+b') as file:
  cksum = checksum(file)
  if cksum == 0:
    print("checksum OK")
    exit(0)

  sumbyte = 65536 - cksum

  print("checksum is 0x{0:0>4x}, setting sum byte to 0x{1:0>4x} at 0x{2:0>4x} in {3}".format(cksum, sumbyte, addr, path))

  file.seek(addr, 0)
  file.write(struct.pack('<H', sumbyte))
  file.close()
