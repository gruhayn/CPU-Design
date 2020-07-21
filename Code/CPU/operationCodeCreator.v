`include "operation_codes_list.h"
`include "commands_list.h"

module operationCodeCreator
			#(
				parameter instructionLength = `instructionLength,
				parameter operation_code_length =`operation_code_length
			)
				(
					input[instructionLength -1 :0] IR,
					output[operation_code_length-1:0] OPER_CODE_1,
					output[operation_code_length-1:0] OPER_CODE_2,
					output[operation_code_length-1:0] OPER_CODE_3,
					output[operation_code_length-1:0] OPER_CODE_4
				);

reg [operation_code_length-1:0] r_OPER_CODE_1;
reg [operation_code_length-1:0] r_OPER_CODE_2;
reg [operation_code_length-1:0] r_OPER_CODE_3;
reg [operation_code_length-1:0] r_OPER_CODE_4;


assign OPER_CODE_1=r_OPER_CODE_1;
assign OPER_CODE_2=r_OPER_CODE_2;
assign OPER_CODE_3=r_OPER_CODE_3;
assign OPER_CODE_4=r_OPER_CODE_4;

always @(*) begin
	case(IR) 
		`ADD, `ADC, `SUB, `AND, `OR, `XOR,
		`INC, `DEC, `NEG, `NOT, `SHRA, `SHRS,
		`SHLA, `SHLS, `ROR, `ROL, `RCR, `RCL: 
		begin
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_ENABLE_ALU_AND_RUN;
			r_OPER_CODE_3 <= `OPER_WRITE_REG;
			r_OPER_CODE_4 <= `OPER_READ_INST;
		end

		`JA, `JNBE, `JB, `JNAE, `JC, `JNB, `JAE,
		`JNC, `JBE, `JNA, `JL, `JNGE, `JNL, `JGE,
		`JLE, `JNG, `JNLE, `JG, `JE, `JZ, `JNE,
		`JNZ, `JO, `JNO, `JS, `JNS, `JP, `JPE, 
		`JNP, `JPO, `JMP :
		begin
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_ENABLE_ALU_AND_RUN;
			r_OPER_CODE_3 <= `OPER_SET_PC;
			r_OPER_CODE_4 <= `OPER_READ_INST;
		end
		`CMP : begin
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_ENABLE_ALU_AND_RUN;
			r_OPER_CODE_3 <= `OPER_READ_INST;
		end
		`TEST  : 
		begin
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_ENABLE_ALU_AND_RUN;
			r_OPER_CODE_3 <= `OPER_READ_INST;
		end

		`SETC, `CLC : 
		begin
			r_OPER_CODE_1 <= `OPER_ENABLE_ALU_AND_RUN;
			r_OPER_CODE_2 <= `OPER_READ_INST;
		end

		`LDIL, `LDIH, `SETADDL, `SETADDH : 
		begin
			r_OPER_CODE_1 <= `OPER_WRITE_REG;
			r_OPER_CODE_2 <= `OPER_READ_INST;
		end 

		`GETDATA : 
		begin
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_READ_MEM;
			r_OPER_CODE_3 <= `OPER_WRITE_REG;
			r_OPER_CODE_4 <= `OPER_READ_INST;
		end

		`SETDATA : 
		begin 
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_WRITE_MEM;
			r_OPER_CODE_3 <= `OPER_READ_INST;
		end

		`MOV : 
		begin 
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_WRITE_REG;
			r_OPER_CODE_3 <= `OPER_READ_INST;
		end

		`POP : 
		begin
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_POP_FROM_STACK;
			r_OPER_CODE_3 <= `OPER_WRITE_REG;
			r_OPER_CODE_4 <= `OPER_READ_INST;
		end

		`PUSH : 
		begin
			r_OPER_CODE_1 <= `OPER_READ_REGS;
			r_OPER_CODE_2 <= `OPER_PUSH_TO_STACK;
			r_OPER_CODE_3 <= `OPER_READ_INST;
		end


		`HALT : 
		begin
			r_OPER_CODE_1 <= `OPER_HALT;
		end

	endcase
end


endmodule