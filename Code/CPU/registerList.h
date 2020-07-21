`ifndef __registerList_h__
`define __registerList_h__
// Binary representation of each register(8 bit and 16 bit)

//(ONLY A,B,C,D group registers can be divided to 8 bit registers.(to high and low byte))
//// reg(X)<num(1,2)>=reg(H)<num(1,2)>,reg(L)<num(1,2)>

//16 bit registers
`define AX1	5'b00000
`define BX1	5'b00001
`define CX1	5'b00010
`define DX1	5'b00011
`define AX2	5'b00100
`define BX2	5'b00101
`define CX2	5'b00110
`define DX2	5'b00111
`define R1 5'b01000
`define R2 5'b01001
`define R3 5'b01010
`define R4 5'b01011
`define RLI	5'b01100
`define SP 5'b01101
`define BP 5'b01110
`define RADR 5'b01111
//8 bit registers
`define AL1	5'b10000
`define BL1	5'b10001
`define CL1	5'b10010
`define DL1	5'b10011
`define AL2	5'b10100
`define BL2	5'b10101
`define CL2	5'b10110
`define DL2	5'b10111
`define AH1	5'b11000
`define BH1	5'b11001
`define CH1	5'b11010
`define DH1	5'b11011
`define AH2	5'b11100
`define BH2	5'b11101
`define CH2	5'b11110
`define DH2	5'b11111
`endif