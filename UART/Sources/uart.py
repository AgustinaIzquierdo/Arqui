import serial
import time
ser = serial.Serial('/dev/ttyUSB1')

print ser.name

# def getOperando():
#     x = int(raw_input("Ingrese el operando: "))
#     return x

def getOperador():

    codigos = {
        '+' : 0b100000,
        '-' : 0b100010,
        '&' : 0b100100,
        '|' : 0b100101,
        '^' : 0b100110,
        '}' : 0b000011,
        ']' : 0b000010,
        '~' : 0b100111
    }

    while True:
        print(" ADD : + \n "
              " SUB : - \n "
              " AND : & \n "
              " OR  : | \n "
              " XOR : ^ \n "
              " SRA : } \n "
              " SRL : ] \n "
              " NOR : ~")
               
        a = raw_input("Ingrese el operador: ")


        if(a in codigos):
            # print(bin(codigos[a]))
            return codigos[a]
        else:
            print("Operando incorrecto, los valores posibles son:")
            print(" ADD : + \n "
                  " SUB : - \n "
                  " AND : & \n "
                  " OR  : | \n "
                  " XOR : ^ \n "
                  " SRA : } \n "
                  " SRL : ] \n "
                  " NOR : ~"
            )

a = 0b00000111    
sent = ser.write(chr(a))

b = 0b00000101  
sent = ser.write(chr(b))

print "a =", bin(a)
print "b =", bin(b)

op = getOperador()
sent = ser.write(chr(op))

x = ser.read()         

print "op =", bin(op)
print "result =", bin(ord(x))

#ser.close()