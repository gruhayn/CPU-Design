`ifndef __commands_list_h__
`define __commands_list_h__

`define instructionLength 	6

`define	ADD			6'b000000
`define	ADC			6'b000001
`define	SUB			6'b000010
`define	AND			6'b000011
`define	OR			6'b000100
`define	XOR			6'b000101
`define	INC			6'b000110
`define	DEC			6'b000111
`define	NEG			6'b001000
`define	NOT			6'b001001
`define	SHRA		6'b001010
`define	SHRS		6'b001011
`define	SHLA		6'b001100
`define	SHLS		6'b001101
`define	ROR			6'b001110
`define	ROL			6'b001111
`define	RCR			6'b010000
`define	RCL			6'b010001
`define	TEST		6'b010010
`define	JA			6'b010011
`define	JNBE		6'b010011
`define	JB			6'b010100
`define	JNAE		6'b010100
`define	JC			6'b010100
`define	JNB			6'b010101
`define	JAE			6'b010101
`define	JNC			6'b010101
`define	JBE			6'b010110
`define	JNA			6'b010110
`define	JL			6'b010111
`define	JNGE		6'b010111
`define	JNL			6'b011000
`define	JGE			6'b011000
`define	JLE			6'b011001
`define	JNG			6'b011001
`define	JNLE		6'b011010
`define	JG			6'b011010
`define	JE			6'b011011
`define	JZ			6'b011011
`define	JNE			6'b011100
`define	JNZ			6'b011100
`define	JO			6'b011101
`define	JNO			6'b011110
`define	JS			6'b011111
`define	JNS			6'b100000
`define	JP			6'b100001
`define	JPE			6'b100001
`define	JNP			6'b100010
`define	JPO			6'b100010
`define	JMP			6'b100011
`define	CMP			6'b100100
`define	SETC		6'b100101
`define	CLC			6'b100110
`define	LDIL		6'b100111
`define	LDIH		6'b101000
`define	SETADDL		6'b101001
`define	SETADDH		6'b101010
`define	GETDATA		6'b101011

`define	SETDATA		6'b101110
`define	MOV			6'b101111

`define	PUSH		6'b110010
`define	POP			6'b110011
`define	HALT		6'b110111

`endif 
