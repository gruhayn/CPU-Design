#!/usr/bin/python
import sys
ASSIGNING_COMMAND = "ASSIGN"
DEASSIGNING_COMMAND = "DEASSIGN"
DEFINING_VAR_COMMAND = "DFN"
HALT_FUNC = "HALT"

commands = {
	"ADD"		:"000000",
	"ADC"		:"000001",
	"SUB"		:"000010",
	"AND"		:"000011",
	"OR"		:"000100",
	"XOR"		:"000101",
	"INC"		:"000110",
	"DEC"		:"000111",
	"NEG"		:"001000",
	"NOT"		:"001001",
	"SHRA"		:"001010",
	"SHRS"		:"001011",
	"SHLA"		:"001100",
	"SHLS"		:"001101",
	"ROR"		:"001110",
	"ROL"		:"001111",
	"RCR"		:"010000",
	"RCL"		:"010001",
	"TEST"		:"010010",
	"JA"		:"010011",
	"JNBE"		:"010011",
	"JB"		:"010100",
	"JNAE"		:"010100",
	"JC"		:"010100",
	"JNB"		:"010101",
	"JAE"		:"010101",
	"JNC"		:"010101",
	"JBE"		:"010110",
	"JNA"		:"010110",
	"JL"		:"010111",
	"JNGE"		:"010111",
	"JNL"		:"011000",
	"JGE"		:"011000",
	"JLE"		:"011001",
	"JNG"		:"011001",
	"JNLE"		:"011010",
	"JG"		:"011010",
	"JE"		:"011011",
	"JZ"		:"011011",
	"JNE"		:"011100",
	"JNZ"		:"011100",
	"JO"		:"011101",
	"JNO"		:"011110",
	"JS"		:"011111",
	"JNS"		:"100000",
	"JP"		:"100001",
	"JPE"		:"100001",
	"JNP"		:"100010",
	"JPO"		:"100010",
	"JMP"		:"100011",
	"CMP"		:"100100",
	"SETC"		:"100101",
	"CLC"		:"100110",
	"LDIL"		:"100111",
	"LDIH"		:"101000",
	"SETADDL"	:"101001",
	"SETADDH"	:"101010",
	"GETDATA"	:"101011",
	"SETDATA"	:"101110",
	"MOV"		:"101111",
	"PUSH"		:"110010",
	"POP"		:"110011",
	"HALT"		:"110111"
}
registers = {
"AX1"	:		"00000",
"BX1"	:		"00001",
"CX1"	:		"00010",
"DX1"	:		"00011",
"AX2"	:		"00100",
"BX2"	:		"00101",
"CX2"	:		"00110",
"DX2"	:		"00111",
"R1"	: 		"01000",
"R2"	: 		"01001",
"R3"	: 		"01010",
"R4"	: 		"01011",
"RLI"	:		"01100",
"SP"	: 		"01101",
"BP"	: 		"01110",
"RADR"	: 		"01111",
"AL1"	:		"10000",
"BL1"	:		"10001",
"CL1"	:		"10010",
"DL1"	:		"10011",
"AL2"	:		"10100",
"BL2"	:		"10101",
"CL2"	:		"10110",
"DL2"	:		"10111",
"AH1"	:		"11000",
"BH1"	:		"11001",
"CH1"	:		"11010",
"DH1"	:		"11011",
"AH2"	:		"11100",
"BH2"	:		"11101",
"CH2"	:		"11110",
"DH2"	:		"11111"
}

types_of_instructions = {
						
"ADD"		:		"00",
"ADC"		:		"00",
"SUB"		:		"00",
"AND"		:		"00",
"OR"		:		"00",
"XOR"		:		"00",
"INC"		:		"01",
"DEC"		:		"01",
"NEG"		:		"01",
"NOT"		:		"01",
"SHRA"		:		"01",
"SHRS"		:		"01",
"SHLA"		:		"01",
"SHLS"		:		"01",
"ROR"		:		"01",
"ROL"		:		"01",
"RCR"		:		"01",
"RCL"		:		"01",
"TEST"		:		"00",
"JA"		:		"01",
"JNBE"		:		"01",
"JB"		:		"01",
"JNAE"		:		"01",
"JC"		:		"01",
"JNB"		:		"01",
"JAE"		:		"01",
"JNC"		:		"01",
"JBE"		:		"01",
"JNA"		:		"01",
"JL"		:		"01",
"JNGE"		:		"01",
"JNL"		:		"01",
"JGE"		:		"01",
"JLE"		:		"01",
"JNG"		:		"01",
"JNLE"		:		"01",
"JG"		:		"01",
"JE"		:		"01",
"JZ"		:		"01",
"JNE"		:		"01",
"JNZ"		:		"01",
"JO"		:		"01",
"JNO"		:		"01",
"JS"		:		"01",
"JNS"		:		"01",
"JP"		:		"01",
"JPE"		:		"01",
"JNP"		:		"01",
"JPO"		:		"01",
"JMP"		:		"01",
"CMP"		:		"00",
"SETC"		:		"11",
"CLC"		:		"11",
"LDIL"		:		"10",
"LDIH"		:		"10",
"SETADDL"	:		"10",
"SETADDH"	:		"10",
"GETDATA"	:		"00",
"GETDATAL"	:		"00",
"GETDATAH"	:		"00",
"SETDATA"	:		"00",
"MOV"		:		"00",
"PUSH"		:		"01",
"POP"		:		"01",
"GETSDATA"	:		"00",
"HALT"		:		"11"			

}

list_of_instruction_types = {
	"00" :	"OPR1R2",
	"01" :	"OPR1",
	"10" :	"OPD8",
	"11" :	"OP"
}

filling_zeros_of_instruction = {
	"OPR1R2"	:	"",
	"OPR1"		:	"00000",
	"OPD8"		:	"00",
	"OP"		:	"0000000000"
}



DS_LENGTH = 65536;
CS_LENGTH = 65536;

PC = 0; # Program Counter
DataSegmentCounter = 0;

labels={}
shadow_names={}
variables={}

CS_binaryCodes = [0]*CS_LENGTH;
DS_binaryCodes = [0]*DS_LENGTH;

binaryCode=""
error=0

lines = []

def readLines(dosyaIsmi):
	global lines
	with open(dosyaIsmi,"r") as fileKod:
		lines=fileKod.read().split("\n")

def clearLines():
	global lines
	#remove comments 
	for index in range(len(lines)):
		lines[index] = lines[index].split("//",1)[0]
	#remove lines which contains whitespaces
	lines = [line for line in lines if line.strip() != '']

def isValidCommand(command):
	global commands
	global ASSIGNING_COMMAND
	global DEASSIGNING_COMMAND
	global DEFINING_VAR_COMMAND

	if (command in commands.keys())	 	or \
		command==ASSIGNING_COMMAND 		or \
		command==DEASSIGNING_COMMAND 	or \
		command==DEFINING_VAR_COMMAND	:
		return True
	return False

def getOperationTypes(command):
	global types_of_instructions
	global list_of_instruction_types
	return list_of_instruction_types[ types_of_instructions[command] ]

def isUsedShadowName(shadowName):
	global shadow_names
	if shadowName in shadow_names.keys():
		return True
	return False

def isValidName(shadowName):
	if shadowName.isalnum() and shadowName[0].isalpha():
		return True
	return False

def isRegName(name):
	global registers
	if name in registers.keys():
		return True
	return False

def isUsedLabelName(name):
	global labels
	if name in labels.keys():
		return True
	return False

def isUsedVarName(name):
	global variables
	if name in variables.keys():
		return True
	return False

def addShadowName(shadowName,regName):
	global shadow_names
	shadow_names[shadowName]=regName

def removeShadowName(shadowName):
	global shadow_names
	del shadow_names[shadowName]

def addVarName(varName):
	global variables
	variables[varName]=DataSegmentCounter

def setVarNameValues(varName,var_values):
	global variables
	global DataSegmentCounter
	address = variables[varName]
	for value in var_values:
		DS_binaryCodes[address] = value
		address = address + 1
	
	DataSegmentCounter = DataSegmentCounter + len(var_values)			


def addLabel(labelName):
	global labels
	labels[labelName] = PC

def getCommandBinaryCode(command) :
	global commands
	return commands[command]

def getRegisterBinaryCode(regName):
	global registers
	if regName not in registers:
		regName = shadow_names[regName]
	return registers[regName]


def addBinaryCodeToCS(binaryCode):
	global PC
	global CS_binaryCodes
	CS_binaryCodes[PC] = binaryCode
	PC = PC + 1

def getCommandFillingZeros(command):
	global types_of_instructions
	global list_of_instruction_types
	global filling_zeros_of_instruction

	return filling_zeros_of_instruction[list_of_instruction_types[types_of_instructions[command]]]


def getVarAddress(varName):
	return variables[varName]

def getLabelAddress(labelName):
	return labels[labelName]


def updateBinaryCodeinCS(index,binaryCode):
	global CS_binaryCodes
	CS_binaryCodes[index] = binaryCode



try:
	dosyaIsmi=str(sys.argv[1])
	print(dosyaIsmi)
	readLines(dosyaIsmi)
	clearLines()
except IndexError:
	print("compiler.py <dosya ismi> olarak giriniz.")
	error==1
	sys.exit()

for line in lines:
	command=line.strip().split(' ',1)[0].upper()
	if isValidCommand(command):
		if command == ASSIGNING_COMMAND:
			try:
				shadowName=line.strip().split(' ',1)[1].strip().split(",",1)[0].strip().upper()
				regName=line.strip().split(' ',1)[1].strip().split(",",1)[1].strip().upper()
				if isUsedShadowName(shadowName):
					error=1
					print("Kullanılmış shadow name. Yeniden kullanmak için DEASSIGN yapınız.  line-->",line)
					break
				if not isValidName(shadowName):
					error=1
					print("Shadow Name içinde özel karakterler barındıramaz ve rakamla başlayamaz.  line-->",line)
					break
		
				if isRegName(shadowName) or isUsedLabelName(shadowName) or isUsedVarName(shadowName) \
									or isValidCommand(shadowName):
					error=1
					print("Shadow Name kullanılmış register, label, variable ismi olamaz.  line-->",line)
					break
				if not isRegName(regName):
					error=1
					print("ASSIGN 'shadowName', <reg>. line->",line)
					break
				addShadowName(shadowName,regName)

			except IndexError:
				print("ASSIGN 'shadowName', <reg>. line->",line)

		elif command == DEASSIGNING_COMMAND:
			shadowName=line.strip().split()[1].strip().upper()
			if not isUsedShadowName(shadowName):
				error=1
				print("ASSIGN shadow name için DEASSIGN kullanılamaz.  line-->",line)
				break

			removeShadowName(shadowName)

		elif command == DEFINING_VAR_COMMAND:
			try:
				varName = line.strip().split()[1].upper()

				if isRegName(varName) or isUsedLabelName(varName) or isUsedVarName(varName)\
									or isValidCommand(varName):
					error=1
					print("Var-name kullanılmış register, label, variable ismi olamaz.  line-->",line)
					break

				var_values =  line.strip().split()[2:]
				for i in range(len(var_values)):
					var_values[i] = int(var_values[i])

				if len(var_values)==0:
					error=1
					print("Variable tanımlandığında sayılar eklenmelidir.  line-->",line)
					break

				addVarName(varName)
				setVarNameValues(varName,var_values)

			except ValueError:
				error=1
				print("Sayılar integer olmalıdır.  line-->",line)
				break

			except (TypeError, IndexError) as e:
				error=1
				print("DFN <VAR_COUNT> <>.  line-->",line)
				break
			
		else:
			operation_type = getOperationTypes(command)
			if operation_type=="OPR1R2":
				try:	
					operands = line.strip().split(' ',1)[1].strip().upper()
					reg1Name,reg2Name = operands.split(',',1)
					reg1Name = reg1Name.strip()
					reg2Name = reg2Name.strip()
					if (not isRegName(reg1Name)) and (not isUsedShadowName(reg1Name)) : 
						error=1
						print(reg1Name,"register ve ya shadow ismi değildir.  line-->",line)
						break
					if (not isRegName(reg2Name)) and (not isUsedShadowName(reg2Name)) : 
						error=1
						print(reg2Name,"register ve ya shadow ismi değildir.  line-->",line)
						break

					binaryCode = getCommandBinaryCode(command) + getRegisterBinaryCode(reg1Name) + getRegisterBinaryCode(reg2Name) 
					addBinaryCodeToCS(binaryCode)
				except ValueError:
					error=1
					print(command,"operand1,operand2.  line-->",line)
					break

			elif operation_type=="OPR1":
				reg1Name = line.strip().split()[1].strip().upper()
				if (not isRegName(reg1Name)) and (not isUsedShadowName(reg1Name)) : 
					error=1
					print(reg1Name,"register ve ya shadow ismi değildir.  line-->",line)
					break
				pass

				binaryCode = getCommandBinaryCode(command) + getRegisterBinaryCode(reg1Name) + getCommandFillingZeros(command) 
				addBinaryCodeToCS(binaryCode)

			elif operation_type=="OPD8":
				if (command=="LDIL" or command=="LDIH") :  #constant value low 8 bit
					try:
						constant = int( line.strip().split()[1].strip().upper() )
						if command=="LDIL":
							low8bit = (16*"0"+bin(constant if constant>0 else constant+(1<<16)).replace("0b",""))[-16:]
							low8bit = low8bit[-8:]
						else:
							low8bit = (16*"0"+bin(constant if constant>0 else constant+(1<<16)).replace("0b",""))[-16:]
							low8bit = low8bit[:8] 
						binaryCode = getCommandBinaryCode(command) + low8bit[-8:] + getCommandFillingZeros(command) 
						addBinaryCodeToCS(binaryCode)

					except ValueError:
						error=1
						print("LDIL/LDIH <constant>.  line-->",line)
						break
				else:
					try:
						varLabel = line.strip().split()[1].strip().upper()
						addBinaryCodeToCS([command,varLabel])		
					except IndexError:
							error=1
							print("SETADDL/SETADDH <variable/label>.  line-->",line)
							break

			elif operation_type=="OP":				
				operands = line.strip().split()
				if len(operands)>1:
					error=1
					print(command," operandsız komutdur.  line-->",line)
					break
				
				binaryCode = getCommandBinaryCode(command) + getCommandFillingZeros(command) 
				addBinaryCodeToCS(binaryCode)	
	else:	
		labelName=command
		if labelName[-1]==":" :
			labelName=labelName[:-1]
			if isRegName(labelName) or isUsedLabelName(labelName) or isUsedVarName(labelName)\
									or isValidCommand(labelName):
				error=1
				print("Label-name kullanılmış register, label, variable ismi olamaz.  line-->",line)
				break
			if not isValidName(labelName) :
				error=1
				print("Label Name içinde özel karakterler barındıramaz ve rakamla başlayamaz.  line-->",line)
				break
			try:
				if line.strip().split()[1].upper() : 
					error=1
					print("Tek satırda sadece label ismi yazılabilir.  line-->",line)
					break
			except:
				pass
			addLabel(labelName)

		else: 
			print(line,'Command is not valid command')
			error=1
			break
if error!=1:
	for i in range(CS_LENGTH):
		if isinstance(CS_binaryCodes[i], list):
			varLabel = CS_binaryCodes[i][1]
			command = CS_binaryCodes[i][0]
			if isUsedVarName(varLabel):
				address = getVarAddress(varLabel)
			elif isUsedLabelName(varLabel):
				address = getLabelAddress(varLabel)
			else :
				error=1
				print(varLabel,"used but not initialized.  line-->",line)
				break

			if command=="SETADDL" :
				low8bit = format(address,"08b")
			else:
				low8bit = format(address>>8,"08b")

			binaryCode = getCommandBinaryCode(command) + low8bit[-8:] + getCommandFillingZeros(command) 
			updateBinaryCodeinCS(i,binaryCode)		

"""
labels={}
shadow_names={}
variables={}

CS_binaryCodes = [0]*CS_LENGTH;
DS_binaryCodes = [0]*DS_LENGTH;

if error!=1:
	print("VARS")
	print(variables)

	print("LABEL")
	print(labels)


	print("SHADOW NAMES")
	print(shadow_names)

	print("Code segment")
	for i in range(CS_LENGTH):
		if CS_binaryCodes[i]==0:
			break
		print(CS_binaryCodes[i])

	print("Data segment")
	for i in range(DS_LENGTH):
		if DS_binaryCodes[i]==0:
			break
		print(DS_binaryCodes[i])

####################################
###########Write DS to file#########
def writeFile(binaryfileW,out_hex):
	for hex_str in out_hex:
		hex_int = int(hex_str, 16)
		binaryfileW.write(binascii.unhexlify(hex_str))


import binascii
binaryfileW = open("sramWrite.txt", "wb")
print(type(CS_binaryCodes[0]))

for i in CS_binaryCodes:
	if isinstance(i, str):
		low=i[-8:]
		high=i[:8]
		padding=2
		value=int(low,2)
		low=('0x%0*X' % (padding,value))[2:]
		value=int(high,2)
		high=('0x%0*X' % (padding,value))[2:]

		out_hex=[low,high]
		writeFile(binaryfileW,out_hex)
	else:
		low=0
		high=0
		low=('0x%0*X' % (padding,low))[2:]
		high=('0x%0*X' % (padding,high))[2:]
		out_hex=[low,high]
		writeFile(binaryfileW,out_hex)

for i in DS_binaryCodes:
	value=i
	padding=4
	hex_num=('0x%0*X' % (padding,value))[2:]
	high,low=hex_num[:2],hex_num[2:]
	out_hex=[low,high]
	writeFile(binaryfileW,out_hex)

"""

print("Binary Codes Created.")
print("Code Segment values are ready.")
print("Data Segment values are ready.")
print("Writing ram values to ram.v.")
ramFile = open("ram.v", "w")
start= """
`include "ramVariables.h"

module ram
	#(
		parameter dataLength=`dataLength,
		parameter addressLegth=`addressLegth
	)
		(
			input [dataLength-1:0] SRAM_data_in ,
			output [dataLength-1:0] SRAM_data_out ,
			input SRAM_wr_n,
			input SRAM_cs_n ,
			input SRAM_oe_n ,
			input [addressLegth-1:0] SRAM_ADD_in ,
			
			output [addressLegth-1:0] SRAM_ADDR_out ,
			inout [dataLength-1:0] SRAM_DQ,
			output SRAM_WE_N,
			output SRAM_OE_N,
			output SRAM_UB_N,
			output SRAM_LB_N,
			output SRAM_CE_N
		);

reg [dataLength-1:0] sram_mem [2**addressLegth-1:0];

assign SRAM_LB_N=0;
assign SRAM_UB_N=0;
assign SRAM_CE_N = SRAM_cs_n;
assign SRAM_WE_N = SRAM_wr_n;
assign SRAM_OE_N = SRAM_oe_n;
assign SRAM_ADDR_out = SRAM_ADD_in;
//assign SRAM_data_out = ( (!SRAM_cs_n & !SRAM_oe_n & SRAM_wr_n) ) ? sram_mem[SRAM_ADD_in] : {16{1'bz}};
assign SRAM_data_out = sram_mem[SRAM_ADD_in];

always @(*) begin
	if (SRAM_cs_n==0 && SRAM_wr_n==0) begin
		sram_mem[SRAM_ADD_in] = SRAM_data_in ;
	end
end

initial begin

"""

end="end\nendmodule"


if error==0:
	ramFile.write(start)
	#print("initial begin")
	for i in range(CS_LENGTH):
		ramFile.write("\tsram_mem["+str(i)+"] = 16'b"+str(CS_binaryCodes[i])+";\n");
		#print("\tsram_mem["+str(i)+"] = 16'b"+str(CS_binaryCodes[i])+";")
		if str(CS_binaryCodes[i])[:6]==commands[HALT_FUNC]:
			break
	for i in range(DS_LENGTH):
		number=DS_binaryCodes[i]
		number=(16*"0"+bin(number if number>0 else number+(1<<16)).replace("0b",""))[-16:]
		ramFile.write("\tsram_mem["+str(i+2**16)+"] = 16'b"+str(number)+";\n");
		#print("\tsram_mem[",i+2**16,"] = 16'b"+str(number),";")

	ramFile.write(end)
	print("Ready.")

else:
	print("Error occured!!!")