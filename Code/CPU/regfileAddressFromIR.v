`include "commands_list.h"
`include "registerFileParameters.h"
`include "registerList.h"

module regfileAddressFromIR 
			#(
				parameter instructionLength=`instructionLength,
				parameter totalAddressLength=`totalAddressLength
			)
				(
					input 	[instructionLength-1:0] IR,
					output  setRegAddress,
					output	[totalAddressLength-1:0] regAddress
				);

reg [totalAddressLength-1:0] r_regAddress;
assign regAddress = r_regAddress ;

reg r_setRegAddress;
assign setRegAddress = r_setRegAddress;

always @(*) begin	
	if (IR==`SETADDL || IR==`SETADDH) begin
		r_setRegAddress = 1;
		r_regAddress  = `RADR;
	end
	else if (IR==`LDIL || IR==`LDIH) begin
		r_setRegAddress = 1;
		r_regAddress  = `RLI;
	end 
	else if (IR==`PUSH || IR==`POP) begin
		r_setRegAddress = 1;
		r_regAddress  = `SP;
	end
	else begin
		r_setRegAddress = 0;
	end
end

endmodule