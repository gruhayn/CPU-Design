`ifndef __operation_codes_list_h__
`define __operation_codes_list_h__

`define operation_code_length 4

`define OPER_READ_REGS 				4'b0000
`define OPER_ENABLE_ALU_AND_RUN 	4'b0001
`define OPER_WRITE_REG				4'b0010
`define OPER_READ_MEM				4'b0011
`define OPER_WRITE_MEM				4'b0100
`define OPER_PUSH_TO_STACK			4'b0101
`define OPER_POP_FROM_STACK			4'b0110
`define OPER_SET_PC					4'b1000
`define OPER_HALT					4'b1001
`define OPER_READ_INST				4'b1010
`define OPER_RESET					4'b1011

`endif