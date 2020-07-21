`include "operation_codes_list.h"

module contolSignalsGenerator
			#(
				parameter operation_code_length=`operation_code_length
			)
				(
					input [operation_code_length-1:0] operation,
					output w_RegFile_en_reg_file,
					output w_RegFile_rst,
					output w_RegFile_inc,
					output w_RegFile_dec,
					output w_RegFile_en_write,
					output w_ALU_enable_alu,
					output w_SRAM_wr_n,
					output w_SRAM_cs_n,
					output w_SRAM_oe_n
				);

//register file control signals
//RegFile

reg r_RegFile_en_reg_file; 	
reg r_RegFile_rst;			
reg r_RegFile_en_write;		
reg r_RegFile_inc;
reg r_RegFile_dec;

//ALU
reg r_ALU_enable_alu;

//SRAM
reg r_SRAM_wr_n;
reg r_SRAM_cs_n;
reg r_SRAM_oe_n;

assign w_RegFile_en_reg_file = r_RegFile_en_reg_file;
assign w_RegFile_rst = r_RegFile_rst;
assign w_RegFile_en_write = r_RegFile_en_write;
assign w_RegFile_inc = r_RegFile_inc;
assign w_RegFile_dec = r_RegFile_dec;
assign w_ALU_enable_alu = r_ALU_enable_alu;
assign w_SRAM_wr_n = r_SRAM_wr_n;
assign w_SRAM_cs_n = r_SRAM_cs_n;
assign w_SRAM_oe_n = r_SRAM_oe_n;


always @(*) begin
	case(operation)
		`OPER_READ_REGS : begin
			r_RegFile_en_reg_file	= 1'b1;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b0;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b0;
			r_SRAM_cs_n				= 1'b1;
			r_SRAM_oe_n				= 1'b0;

		end
		`OPER_ENABLE_ALU_AND_RUN : begin
			r_RegFile_en_reg_file	= 1'b0;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b0;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b1;
			r_SRAM_wr_n				= 1'b0;
			r_SRAM_cs_n				= 1'b1;
			r_SRAM_oe_n				= 1'b0;
		end
		`OPER_WRITE_REG : begin
			r_RegFile_en_reg_file	= 1'b1;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b1;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b0;
			r_SRAM_cs_n				= 1'b1;
			r_SRAM_oe_n				= 1'b0;
		end
		`OPER_READ_MEM, `OPER_READ_INST : begin
			r_RegFile_en_reg_file	= 1'b0;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b0;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b1;
			r_SRAM_cs_n				= 1'b0;
			r_SRAM_oe_n				= 1'b0;
		end
		`OPER_WRITE_MEM : begin
			r_RegFile_en_reg_file	= 1'b0;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b0;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b0;
			r_SRAM_cs_n				= 1'b0;
			r_SRAM_oe_n				= 1'b0;
		end
		`OPER_PUSH_TO_STACK : begin
			r_RegFile_en_reg_file	= 1'b1;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b1;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b1;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b0;
			r_SRAM_cs_n				= 1'b0;
			r_SRAM_oe_n				= 1'b0;
		end
		`OPER_POP_FROM_STACK : begin
			r_RegFile_en_reg_file	= 1'b1;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b1;
			r_RegFile_dec			= 1'b1;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b1;
			r_SRAM_cs_n				= 1'b0;
			r_SRAM_oe_n				= 1'b0;
		end
		`OPER_SET_PC, `OPER_HALT : begin 
			r_RegFile_en_reg_file	= 1'b0;
			r_RegFile_rst			= 1'b0;
			r_RegFile_en_write		= 1'b0;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b0;
			r_SRAM_cs_n				= 1'b1;
			r_SRAM_oe_n				= 1'b0;
		end
		`OPER_RESET : begin
			r_RegFile_en_reg_file	= 1'b1;
			r_RegFile_rst			= 1'b1;
			r_RegFile_en_write		= 1'b0;
			r_RegFile_dec			= 1'b0;
			r_RegFile_inc			= 1'b0;
			r_ALU_enable_alu		= 1'b0;
			r_SRAM_wr_n				= 1'b0;
			r_SRAM_cs_n				= 1'b1;
			r_SRAM_oe_n				= 1'b0;
		end
	endcase
end

endmodule