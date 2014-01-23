import serial
import sys
import time

arduino = serial.Serial('/dev/ttyACM0', 9600)
time.sleep(2)
while True:
#comando = raw_input('intoduce:')
#comando = sys.argv[1]
#print"la cadena es: ",sys.argv[1]
arduino.write("00")
time.sleep(3)
arduino.close()   
