# TP 4. MIPS.
# Script que muestra los resultados obtenidos de la simulacion.
# Arquitectura de Computadoras. FCEFyN. UNC.
# Anio 2019-2020.
# Autores: Izquierdo Agustina, Salvatierra Andres

#CONSTANTES
ex_mem = "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/ex_mem.txt"
mem_wb = "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/mem_wb.txt"
if_id = "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/if_id.txt"
id_ex = "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/id_ex.txt"
cant_clock = "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/cant_clock.txt"

#Latch IF_ID
len_if_id= 65
cont_programa = 0 #32 bit
instr = 32
flag_halt = 64 #1 bit

#Latch ID_EX
len_id_ex=204
ctrl_wb_id_ex = 0 #2 bit 
ctrl_mem_id_ex = 2 #9 bit
ctrl_ex_id_ex = 11 #11 bit
shamt = 22 #5 bit
rs = 27 #5 bit
rt = 32 #5 bit
rd = 37 #5 bit
out_adder_id_ex = 42 #32 bit
dir_jump = 74 #32 bit
sign_extend = 106 #32 bit
dato1 = 138 #32 bit
dato2_if_ex = 170 #32 bit
flag_stall = 202 #1 bit
flag_jump = 203 #1 bit

#LATCH EX_MEM
len_ex_mem=112
ctrl_wb_ex_mem = 0 #2 bit
ctrl_mem_ex_mem = 2 # 9 bit
write_reg_ex_mem = 11 #5 bit
branch_dir = 16 #32 bit
result_alu_ex_mem = 48 #32 bit
dato2_ex_mem = 80 #32 bit

#LATCH MEM_WB
len_mem_wb=72
PCSrc = 0 #1 bit
ctrl_wb_mem_wb = 1 #2 bit
write_reg_mem_wb = 3 #5 bit
result_alu_mem_wb = 8 #32 bit
read_data_memory = 40 #32 bit


# Funcion que efectua la lectura de un archivo y devuelve su contenido.
def fileReader (file_name):
    arreglo=[]
    try:
        f1 = open(file_name, 'r')
        for line in f1:
            arreglo.append(line)
        f1.close()
        return arreglo
    except:
        print("No esta el archivo")
        exit(1)

arreglo_if_id=[]
arreglo_id_ex=[]
arreglo_ex_mem=[]
arreglo_mem_wb=[]
arreglo_cant_clock=[]

arreglo_if_id=fileReader(if_id)
arreglo_id_ex=fileReader(id_ex)
arreglo_ex_mem=fileReader(ex_mem)
arreglo_mem_wb=fileReader(mem_wb)
arreglo_cant_clock=fileReader(cant_clock)

def print_if_id(linea):
    print('\x1b[1;32;40m' + "//////////////////LATCH_IF_ID//////////////////" + '\x1b[0m')
    print("Cont_programa: ",linea[cont_programa:instr])
    ins=linea[instr:flag_halt]
    print("Instruccion: ",hex(int(ins,2)))
    print("Flag_halt: ", linea[flag_halt])

def print_id_ex(linea):
    print('\x1b[1;35;40m' + "//////////////////LATCH_ID_EX//////////////////" + '\x1b[0m')
    print("Ctrl_wb: ",linea[ctrl_wb_id_ex:ctrl_mem_id_ex])
    print("Ctrl_mem: ",linea[ctrl_mem_id_ex:ctrl_ex_id_ex])
    print("Ctrl_ex: ",linea[ctrl_ex_id_ex:shamt])
    print("Shamt: ",linea[shamt:rs])
    print("Rs: ",int(linea[rs:rt],2))
    print("Rt: ",int(linea[rt:rd],2))
    print("Rd: ",int(linea[rd:out_adder_id_ex],2))
    print("out_adder: ",linea[out_adder_id_ex:dir_jump])
    print("dir_jump: ",linea[dir_jump:sign_extend])
    print("sign_extend: ",linea[sign_extend:dato1])
    print("dato1: ",int(linea[dato1:dato2_if_ex],2))
    print("dato2: ",int(linea[dato2_if_ex:flag_stall],2))
    print("flag_stall: ",linea[flag_stall:flag_jump])
    print("flag_jump: ",linea[flag_jump])

def print_ex_mem(linea):
    print('\x1b[1;36;40m' + "//////////////////LATCH_EX_MEM//////////////////" + '\x1b[0m')
    print("Ctrl_wb: ",linea[ctrl_wb_ex_mem:ctrl_mem_ex_mem])
    print("Ctrl_mem: ",linea[ctrl_mem_ex_mem:write_reg_ex_mem])
    print("Write_reg: ",int(linea[write_reg_ex_mem:branch_dir],2))
    print("Branch_dir:",linea[branch_dir:result_alu_ex_mem])
    print("Result_alu:",int(linea[result_alu_ex_mem:dato2_ex_mem],2))
    print("Dato2:",int(linea[dato2_ex_mem:len_id_ex-1],2))

def print_mem_wb(linea):
    print('\x1b[1;31;40m' + "//////////////////LATCH_MEM_WB//////////////////" + '\x1b[0m')
    print("PCSrc: ",linea[PCSrc:ctrl_wb_mem_wb])
    print("Ctrl_wb: ",linea[ctrl_wb_mem_wb:write_reg_mem_wb])
    print("Write_reg: ",int(linea[write_reg_mem_wb:result_alu_mem_wb],2))
    print("Result_alu:",int(linea[result_alu_mem_wb:read_data_memory],2))
    print("Read_data:",int(linea[read_data_memory:len_mem_wb-1],2))


for i in range(1,len(arreglo_ex_mem)):
    
    print_if_id(arreglo_if_id[i])
    print_id_ex(arreglo_id_ex[i])
    print_ex_mem(arreglo_ex_mem[i])
    print_mem_wb(arreglo_mem_wb[i])
    arreglo_ex_mem[i]
    input('\x1b[6;30;42m' + '"Enter para siguiente iteracion"' + '\x1b[0m')
    print("\n")

print("Cantidad de ciclos empleados",int(arreglo_cant_clock[len(arreglo_cant_clock)-1],2))