import serial
import time
ser = serial.Serial('/dev/ttyUSB1')#,baudrate = 9600)

print ser.name

a = 0b00000001    
sent = ser.write(chr(a))

acc_h =ser.read()      
acc_l = ser.read()
ser.close()
print "AAC_L= ", ord(acc_l)
print "AAC_H= ", ord(acc_h)