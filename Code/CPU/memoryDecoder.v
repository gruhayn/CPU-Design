`include "registerFileParameters.h"
`include "ramVariables.h"
`include "instruction_types.h"
`include "commands_list.h"

module memoryDecoder
		#(
			parameter dataLength=`dataLength,
			parameter instructionLength=`instructionLength,
			parameter instructionTypeLength=`instructionTypeLength,
			parameter totalAddressLength=`totalAddressLength,
			parameter registerLength=`registerLength
		)
				(
					input  [dataLength-1:0] dataIn,
					output [instructionLength-1:0] IR,
					output [instructionTypeLength-1:0] inst_type,
					output [totalAddressLength-1:0] reg1_add,
					output [totalAddressLength-1:0] reg2_add,
					output [registerLength-1:0]	 dataOut
				);

reg [instructionLength-1:0] r_IR;
reg [instructionTypeLength-1:0] r_inst_type;
reg [totalAddressLength-1:0] r_reg1_add;
reg [totalAddressLength-1:0] r_reg2_add;
reg [registerLength-1:0]	 r_dataOut;


assign IR 			= r_IR;
assign inst_type 	= r_inst_type;
assign reg1_add 	= r_reg1_add;
assign reg2_add 	= r_reg2_add;
assign dataOut 		= r_dataOut;


always @(*) begin
	r_IR=dataIn[dataLength-1:dataLength-instructionLength];

	case(r_IR)
		`ADD, `ADC, `SUB, `AND, `OR, `XOR,
		`TEST, `CMP, `GETDATA, `SETDATA, `MOV : begin
			r_inst_type = `OPR1R2;
			r_reg1_add 	= dataIn[dataLength-instructionLength-1:dataLength-instructionLength-totalAddressLength]; 
			r_reg2_add 	= dataIn[dataLength-instructionLength-totalAddressLength-1:dataLength-instructionLength-2*totalAddressLength];
		end
		`INC, `DEC, `NEG, `NOT, `SHRA, `SHRS,
		`SHLA, `SHLS, `ROR, `ROL, `RCR, `RCL,
		`JA, `JNBE, `JB, `JNAE, `JC, `JNB, 
		`JAE, `JNC, `JBE, `JNA, `JL, `JNGE,
		`JNL, `JGE, `JLE, `JNG, `JNLE, `JG,
		`JE, `JZ, `JNE, `JNZ, `JO, `JNO, `JS,
		`JNS, `JP, `JPE, `JNP, `JPO, `JMP, 
		`PUSH, `POP : begin
			r_inst_type = `OPR1;
			r_reg1_add 	= dataIn[dataLength-instructionLength-1:dataLength-instructionLength-totalAddressLength];
		end
		`LDIL, `LDIH, `SETADDL, `SETADDH : begin
			r_inst_type = `OPD8;
			r_dataOut	= {8'b00000000,dataIn[dataLength-instructionLength-1:dataLength-instructionLength-registerLength/2]};
		end
		`SETC, `CLC, `HALT : begin
			r_inst_type = `OP;
		end

	endcase
end

endmodule
