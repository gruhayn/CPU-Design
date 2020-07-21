`include "registerFileParameters.h"
`include "commands_list.h"

module regfileAddressCreator
	#(
		parameter registerAddressLength = `registerAddressLength,
		parameter totalAddressLength = `totalAddressLength,
		parameter instructionLength = `instructionLength
				
	)
	(
			input [instructionLength-1:0] IR,
			input [totalAddressLength-1:0] w_add,
			output w_lb,
			output w_hb,
			output [registerAddressLength-1:0]w_regfile_add
	);


// converting register address to register file address
assign w_regfile_add = (w_add>=5'b10000)? {1'b0,w_add[totalAddressLength-3:0]} : w_add[totalAddressLength-2:0] ;
// is low byte selected?(lb)
assign w_lb = (w_add>=5'b10000)? (w_add[totalAddressLength-1] & (~w_add[totalAddressLength-2])) : 
										(( IR==`SETADDH || IR==`LDIH) ? 0 : 1);
//is high byte selected?(hb)
assign w_hb = (w_add>=5'b10000)? (w_add[totalAddressLength-1] & (w_add[totalAddressLength-2])) : 
										(( IR==`SETADDL || IR==`LDIL) ? 0 : 1);



endmodule