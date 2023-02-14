from multiprocessing import Process
import subprocess
import sys
import serial
import sys

status, result = subprocess.getstatusoutput("set -euo pipefail; ioreg -r -c IOUSBHostDevice -l -n 'USB Serial' | grep -w 'IOCalloutDevice' | awk -F'=' '{print $2}' | sed -E -e 's/[ \"]//g' | head -1")
if status != 0:
  print("Unable to get IO device: {}".format(result))
  sys.exit(1)
port = serial.Serial(result.strip(), 115200, timeout=10, write_timeout=10)

def program_eeprom():
  fin = sys.argv[1]
  with open(fin, 'br') as f:
    while True:
      b = f.read1(140) # read at most the size of a single hex packet
      if len(b) == 0: # we have reached EOF
        break
      port.write(b)

def read_status():
  while True:
    line = port.readline().decode('ascii').strip()
    if line != "":
      print(line)

    if line == "Done!":
      sys.exit(0)
    elif line == "Errors during programming!":
      sys.exit(1)

if __name__ == '__main__':
  # p1 = Process(target=program_eeprom, args=())
  # p2 = Process(target=read_status, args=())
  # p1.start()
  # p2.start()
  # p1.join(timeout=10)
  # p2.join(timeout=1)
  # if p1.exitcode == None:
  #   p1.terminate()
  # if p2.exitcode == None:
  #   p2.terminate()

  # if p1.exitcode != 0 or p2.exitcode != 0:
  #   sys.exit(1)
  program_eeprom()
