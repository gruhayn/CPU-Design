`include "addressPrefixs.h"
`include "commands_list.h"
`include "ramVariables.h"

module memoryAddressCreator
			#(
				parameter addressLegth=`addressLegth,
				parameter instructionLength=`instructionLength
			)
				(
					input 	[instructionLength-1:0] IR,
					input 	[addressLegth-3:0] in_ADDR,
					input 	select_code_segment,
					output 	[addressLegth-1:0] out_ADDR
				);

reg [addressLegth-1:0] r_out_ADDR;
assign out_ADDR = r_out_ADDR; 

always @(*) begin
	if (select_code_segment==1'b1) begin
		r_out_ADDR = {`CS,in_ADDR};
	end
	else begin	
		case(IR)
			`GETDATA, `SETDATA : begin
				r_out_ADDR = {`DS,in_ADDR};		
			end
			`PUSH, `POP : begin
				r_out_ADDR = {`SS,in_ADDR};
			end
		endcase
	end
end


endmodule