`ifndef __registerFileParameters_h__
`define __registerFileParameters_h__
`define registerLength 16 		// WIDE OF REGISTER (16 BIT)
`define registerAddressLength 4 // LOWEST BIT NUMBER FOR ACCESSING TO REGISTER FILE(only 16 bit registers)
`define registerFileDepth  16	// registerLength = 2^registerAddressLength (NUMBER OF REGISTERS)
 /*		
 		totalAddressLength 
 LOWEST BIT NUMBER FOR ACCESSING TO REGISTER FILE
(16 bit registers(16 reg) + 8 bit registers(16))(total 32 reg)
32=2^5
*/
`define totalAddressLength   5
`endif