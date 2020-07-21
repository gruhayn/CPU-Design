`include "addressPrefixs.h"
`include "commands_list.h"
`include "ramVariables.h"
`include "operation_codes_list.h"
`include "registerFileParameters.h"
`include "instruction_types.h"

module cpu
	#(
		parameter dataLength=`dataLength,
		parameter addressLegth=`addressLegth
	)
		(
	input clk,
	output [addressLegth-1:0] SRAM_ADDR_fromCPU_out ,
	inout  [dataLength-1:0] SRAM_DQ_fromCPU,
	output SRAM_WE_N_fromCPU,
	output SRAM_OE_N_fromCPU,
	output SRAM_UB_N_fromCPU,
	output SRAM_LB_N_fromCPU,
	output SRAM_CE_N_fromCPU
		);

parameter instructionLength=`instructionLength;	
parameter operation_code_length=`operation_code_length;
parameter registerLength = `registerLength;
parameter registerAddressLength = `registerAddressLength;
parameter registerFileDepth = `registerFileDepth;
parameter totalAddressLength = `totalAddressLength;
parameter instructionTypeLength=`instructionTypeLength;

/////////////////////////////////GLOBAL REGS
reg [dataLength-1:0] r_PC=0;
reg [operation_code_length-1:0] r_operation_count=0;
reg [dataLength-1:0] r_SRAM_data_out ;
reg r_halted=0;
reg r_clock_new=0;
reg r_clock_old=0;
//////////////////////////////////////////////GLOBAL PINS
wire 	[instructionLength-1:0] IR;
//reg 	[instructionLength-1:0] r_IR;
//assign IR = r_IR;

///////////////////////////////////////Memory address creator pins///////////////
//Memory address creator input pins
wire 	[addressLegth-3:0] memory_address_creator_in_ADDR;
wire 	memory_address_creator_select_code_segment;
//Memory address creator output pins
wire 	[addressLegth-1:0] memory_address_creator_out_ADDR;

//Memory address creator regs
reg 	[addressLegth-3:0] r_memory_address_creator_in_ADDR;
reg 	r_memory_address_creator_select_code_segment;


assign memory_address_creator_in_ADDR = r_memory_address_creator_in_ADDR;
assign memory_address_creator_select_code_segment = r_memory_address_creator_select_code_segment;

/////////////////////////////////SRAM pins/////////////
///////////SRAM logical input pins
//GLOBAL IR pin
wire [dataLength-1:0] SRAM_data_in ;
wire SRAM_wr_n ;
wire SRAM_cs_n ;
wire SRAM_oe_n ;
wire [addressLegth-1:0] SRAM_ADD_in ;
///////////SRAM logical output pins
wire [dataLength-1:0] SRAM_data_out ;


//SRAM regs
reg [dataLength-1:0] r_SRAM_data_in ;

assign SRAM_data_in = r_SRAM_data_in;

//////////SRAM pins for SRAM hardware
//TODO: cpuya bagla bunlari
wire SRAM_WE_N;
wire SRAM_OE_N;
wire SRAM_UB_N;
wire SRAM_LB_N;
wire SRAM_CE_N;

///////////////////////////////////////Contol Signals Generator
///////////Contol Signals Generator input pins
wire [operation_code_length-1:0] operation;
///////////Contol Signals Generator output pins
wire w_CSG_RegFile_en_reg_file;
wire w_CSG_RegFile_rst;
wire w_CSG_RegFile_inc;
wire w_CSG_RegFile_dec;
wire w_CSG_RegFile_en_write;
wire w_CSG_ALU_enable_alu;
wire w_CSG_SRAM_wr_n;
wire w_CSG_SRAM_cs_n;
wire w_CSG_SRAM_oe_n;

//Contol Signals Generator regs
reg [operation_code_length-1:0] r_operation=`OPER_RESET;

assign operation = r_operation;
///////////////////////////Operation Code Creator pins
/////////////Operation Code Creator input pins
//GLOBAL IR pin
/////////////Operation Code Creator output pins
wire [operation_code_length-1:0] OPER_CODE_1;
wire [operation_code_length-1:0] OPER_CODE_2;
wire [operation_code_length-1:0] OPER_CODE_3;
wire [operation_code_length-1:0] OPER_CODE_4;

////////////////////////////////// ALU pins
/////////ALU input pins
wire enable_alu;
wire [dataLength -1 :0] ALU_in1;
wire [dataLength -1 :0] ALU_in2;
//GLOBAL IR pin
/////////ALU output pins
wire  C;
wire  Z;
wire  S; 
wire  V;
wire  P;
wire  [dataLength -1 :0] ALU_out;
wire  ALU_output_ready;

//ALU regs
reg [dataLength -1 :0] r_ALU_in1;
reg [dataLength -1 :0] r_ALU_in2;

assign ALU_in1 = r_ALU_in1;
assign ALU_in2 = r_ALU_in2;

////////////////////////////////////// Register file pins
/////Register file input pins
wire [registerAddressLength-1:0] 	regfile_address_rd1;
wire [registerAddressLength-1:0] 	regfile_address_rd2;
wire [registerAddressLength-1:0] 	regfile_address_wr;

wire [registerLength-1:0] 	regfile_wr_data;

wire regfile_lb_rd1;
wire regfile_hb_rd1;
wire regfile_lb_rd2;
wire regfile_hb_rd2;
wire regfile_lb_wr;
wire regfile_hb_wr;

wire regfile_inc;
wire regfile_dec;
wire regfile_en_write;
wire regfile_rst;
wire regfile_en_reg_file;
/////Register file output pins
wire [registerLength-1:0] 	regfile_rd_data1;
wire [registerLength-1:0] 	regfile_rd_data2;
wire regfile_out_data_enable;

///Regfile regs

reg [registerLength-1:0] 	r_regfile_wr_data;
assign regfile_wr_data = r_regfile_wr_data;

////////////////////////////////////Regfile Address Creator pins
/////Regfile Address Creator rd1 input pins
//GLOBAL IR pin
wire [totalAddressLength-1:0] regfileAddressCreator_rd1_add;
/////Regfile Address Creator rd1 output pins
wire regfileAddressCreator_rd1_lb;
wire regfileAddressCreator_rd1_hb;
wire [registerAddressLength-1:0] regfileAddressCreator_rd1_add_to_regfile;

/////Regfile Address Creator rd2 input pins
//GLOBAL IR pin
wire [totalAddressLength-1:0] regfileAddressCreator_rd2_add;
/////Regfile Address Creator rd2 output pins
wire regfileAddressCreator_rd2_lb;
wire regfileAddressCreator_rd2_hb;
wire [registerAddressLength-1:0] regfileAddressCreator_rd2_add_to_regfile;

/////Regfile Address Creator wr input pins
//GLOBAL IR pin
wire [totalAddressLength-1:0] regfileAddressCreator_wr_add;
/////Regfile Address Creator wr output pins
wire regfileAddressCreator_wr_lb;
wire regfileAddressCreator_wr_hb;
wire [registerAddressLength-1:0] regfileAddressCreator_wr_add_to_regfile;

//////Regfile Address Creators regs
reg [totalAddressLength-1:0] r_regfileAddressCreator_rd1_add;
reg [totalAddressLength-1:0] r_regfileAddressCreator_rd2_add;
reg [totalAddressLength-1:0] r_regfileAddressCreator_wr_add;

assign regfileAddressCreator_rd1_add = r_regfileAddressCreator_rd1_add;
assign regfileAddressCreator_rd2_add = r_regfileAddressCreator_rd2_add;
assign regfileAddressCreator_wr_add = r_regfileAddressCreator_wr_add;

//////////////////////////////////////////Regfile address from IR pins
///////Regfile address from IR input pins
//GLOBAL IR pin
///////Regfile address from IR output pins
wire reg_address_from_IR_setRegAddress;
wire [totalAddressLength-1:0] reg_address_from_IR_regAddress;

////////////////////////////////////Memory Decoder pins
//////////////Memory Decoder input pins
wire [dataLength-1:0] memoryDecoder_dataIn;
//////////////Memory Decoder output pins
//GLOBAL IR pin
wire [instructionTypeLength-1:0] memoryDecoder_inst_type;
wire [totalAddressLength-1:0] memoryDecoder_reg1_add;
wire [totalAddressLength-1:0] memoryDecoder_reg2_add;
wire [registerLength-1:0]	 memoryDecoder_dataOut;

///Memory Decoder regs
reg [dataLength-1:0] r_memoryDecoder_dataIn;
assign memoryDecoder_dataIn = r_memoryDecoder_dataIn;


///////////////////////////////CONNECTION BETWEEN MODULES/////////

//Connection between ram and control signal generator modules
assign SRAM_wr_n = w_CSG_SRAM_wr_n;
assign SRAM_cs_n = w_CSG_SRAM_cs_n;
assign SRAM_oe_n = w_CSG_SRAM_oe_n;

//Connection between ram and cpu modules
assign SRAM_WE_N_fromCPU = SRAM_WE_N;
assign SRAM_OE_N_fromCPU = SRAM_OE_N;
assign SRAM_UB_N_fromCPU = SRAM_UB_N;
assign SRAM_LB_N_fromCPU = SRAM_LB_N;
assign SRAM_CE_N_fromCPU = SRAM_CE_N;

//Connection between memory address creator and ram
assign SRAM_ADD_in = memory_address_creator_out_ADDR;

//Connection between alu and control signal generator modules
assign enable_alu = w_CSG_ALU_enable_alu;

//Connection between regfile and control signal generator modules
assign regfile_inc = w_CSG_RegFile_inc;
assign regfile_dec = w_CSG_RegFile_dec;
assign regfile_en_write = w_CSG_RegFile_en_write;
assign regfile_rst = w_CSG_RegFile_rst;
assign regfile_en_reg_file = w_CSG_RegFile_en_reg_file;

//Connection between Regfile Address Creator and Register File
assign regfile_address_rd1 = regfileAddressCreator_rd1_add_to_regfile;
assign regfile_address_rd2 = regfileAddressCreator_rd2_add_to_regfile;
assign regfile_address_wr = regfileAddressCreator_wr_add_to_regfile;

//Connection between regfile and regfile address creator
assign regfile_lb_rd1 = regfileAddressCreator_rd1_lb;
assign regfile_hb_rd1 = regfileAddressCreator_rd1_hb;
assign regfile_lb_rd2 = regfileAddressCreator_rd2_lb;
assign regfile_hb_rd2 = regfileAddressCreator_rd2_hb;
assign regfile_lb_wr = regfileAddressCreator_wr_lb;
assign regfile_hb_wr = regfileAddressCreator_wr_hb;

////////////////////////////////////////////// Initialization of Registers 


//////////////////////////////////////////////////////////////////////////////
memoryAddressCreator
	memoryAddressCreator1		
				(
					.IR(IR),
					.in_ADDR(r_memory_address_creator_in_ADDR),
					.select_code_segment(r_memory_address_creator_select_code_segment),
					.out_ADDR(memory_address_creator_out_ADDR)
				);


ram
	ram1
		(
			.SRAM_data_in(SRAM_data_in) ,
			.SRAM_data_out(SRAM_data_out) ,
			.SRAM_wr_n(SRAM_wr_n),
			.SRAM_cs_n(SRAM_cs_n) ,
			.SRAM_oe_n(SRAM_oe_n) ,
			.SRAM_ADD_in(SRAM_ADD_in) ,
			
			.SRAM_ADDR_out(SRAM_ADDR_fromCPU_out) ,
			.SRAM_DQ(SRAM_DQ_fromCPU),
			.SRAM_WE_N(SRAM_WE_N),
			.SRAM_OE_N(SRAM_OE_N),
			.SRAM_UB_N(SRAM_UB_N),
			.SRAM_LB_N(SRAM_LB_N),
			.SRAM_CE_N(SRAM_CE_N)
		);

contolSignalsGenerator
			contolSignalsGenerator1
				(
					.operation(operation),
					.w_RegFile_en_reg_file(w_CSG_RegFile_en_reg_file),
					.w_RegFile_rst(w_CSG_RegFile_rst),
					.w_RegFile_inc(w_CSG_RegFile_inc),
					.w_RegFile_dec(w_CSG_RegFile_dec),
					.w_RegFile_en_write(w_CSG_RegFile_en_write),
					.w_ALU_enable_alu(w_CSG_ALU_enable_alu),
					.w_SRAM_wr_n(w_CSG_SRAM_wr_n),
					.w_SRAM_cs_n(w_CSG_SRAM_cs_n),
					.w_SRAM_oe_n(w_CSG_SRAM_oe_n)
				);
	
operationCodeCreator
		operationCodeCreator1	
				(
					.IR(IR),
					.OPER_CODE_1(OPER_CODE_1),
					.OPER_CODE_2(OPER_CODE_2),
					.OPER_CODE_3(OPER_CODE_3),
					.OPER_CODE_4(OPER_CODE_4)
				);

alu
	alu1
	
		(
      	.enable_alu(enable_alu),
		.in1(ALU_in1),
		.in2(ALU_in2),
		.IR(IR),
		.C(C),
		.Z(Z),
		.S(S), 
		.V(V),
		.P(P),
		.out(ALU_out),
		.output_ready(ALU_output_ready)
	);

regfile32x32
			regfile
			(
		
				.address_rd1(regfile_address_rd1),
				.address_rd2(regfile_address_rd2),
				.address_wr(regfile_address_wr),

				.rd_data1(regfile_rd_data1),
				.rd_data2(regfile_rd_data2),
				.wr_data(r_regfile_wr_data),

				.lb_rd1(regfile_lb_rd1),
				.hb_rd1(regfile_hb_rd1),
				.lb_rd2(regfile_lb_rd2),
				.hb_rd2(regfile_hb_rd2),
				.lb_wr(regfile_lb_wr),
				.hb_wr(regfile_hb_wr),

				.out_data_enable(regfile_out_data_enable),
				.inc(regfile_inc),
				.dec(regfile_dec),
				.en_write(regfile_en_write),
				.rst(regfile_rst),
				.en_reg_file(regfile_en_reg_file)
			);

regfileAddressCreator
	regfileAddressCreator_rd1
	(
			.IR(IR),
			.w_add(regfileAddressCreator_rd1_add),
			.w_lb(regfileAddressCreator_rd1_lb),
			.w_hb(regfileAddressCreator_rd1_hb),
			.w_regfile_add(regfileAddressCreator_rd1_add_to_regfile)
	);

regfileAddressCreator
	regfileAddressCreator_rd2
		(
			.IR(IR),
			.w_add(regfileAddressCreator_rd2_add),
			.w_lb(regfileAddressCreator_rd2_lb),
			.w_hb(regfileAddressCreator_rd2_hb),
			.w_regfile_add(regfileAddressCreator_rd2_add_to_regfile)
	);

regfileAddressCreator
	regfileAddressCreator_wr
		(
			.IR(IR),
			.w_add(regfileAddressCreator_wr_add),
			.w_lb(regfileAddressCreator_wr_lb),
			.w_hb(regfileAddressCreator_wr_hb),
			.w_regfile_add(regfileAddressCreator_wr_add_to_regfile)
	);

regfileAddressFromIR 
		regfileAddressFromIR1	
				(
					.IR(IR),
					.setRegAddress(reg_address_from_IR_setRegAddress),
					.regAddress(reg_address_from_IR_regAddress)
				);

memoryDecoder
		memoryDecoder1
				(
					.dataIn(memoryDecoder_dataIn),
					.IR(IR),
					.inst_type(memoryDecoder_inst_type),
					.reg1_add(memoryDecoder_reg1_add),
					.reg2_add(memoryDecoder_reg2_add),
					.dataOut(memoryDecoder_dataOut)
				);

always @(posedge clk) begin
	if (r_halted==1'b0) begin
		r_operation_count=0;
		r_PC = r_PC + 1'b1;
	end
end 



always @(*) begin
	if (r_operation_count==0) begin
		r_memoryDecoder_dataIn = SRAM_data_out ;
		r_memory_address_creator_select_code_segment=1;
		r_memory_address_creator_in_ADDR=r_PC-1;	
		r_operation = `OPER_READ_INST;
		r_operation_count <= 1 ;
	end
	else if(r_operation_count==1) begin
		//r_operation = `OPER_HALT; // disable all devices
		r_operation = OPER_CODE_1;
		if (OPER_CODE_1==`OPER_READ_REGS) begin
			r_regfileAddressCreator_rd1_add = memoryDecoder_reg1_add;
			if (OPER_CODE_2==`OPER_PUSH_TO_STACK )begin
				if (reg_address_from_IR_setRegAddress==1) begin
					r_regfileAddressCreator_rd2_add = reg_address_from_IR_regAddress;
					r_regfileAddressCreator_wr_add = reg_address_from_IR_regAddress;
				end
			end
			else if( OPER_CODE_2==`OPER_POP_FROM_STACK) begin
				r_regfileAddressCreator_rd2_add = reg_address_from_IR_regAddress;
				r_regfileAddressCreator_wr_add = reg_address_from_IR_regAddress;
			end
			else begin
				r_regfileAddressCreator_rd2_add = memoryDecoder_reg2_add;
			end
		end 
		else if(OPER_CODE_1==`OPER_WRITE_REG) begin
			if (reg_address_from_IR_setRegAddress==1) begin
				r_regfileAddressCreator_wr_add = reg_address_from_IR_regAddress;
				r_regfile_wr_data = memoryDecoder_dataOut;
			end
		end
		
		

		case(r_operation) 
			`OPER_READ_REGS : begin
				r_operation_count<=2;
			end
			`OPER_ENABLE_ALU_AND_RUN : begin
				r_operation_count<=2;
			end
			`OPER_WRITE_REG : begin
				r_operation_count<=2;
			end
			`OPER_HALT : begin
				r_operation_count<=1;
				r_halted<=1;
			end
		endcase
	end
	else if(r_operation_count==2) begin
		//r_operation = `OPER_HALT; // disable all devices
		r_operation=OPER_CODE_2;
		if (OPER_CODE_2==`OPER_ENABLE_ALU_AND_RUN) begin
			r_ALU_in1 = regfile_rd_data1;
			r_ALU_in2 = regfile_rd_data2;
		end 
		else if (OPER_CODE_2==`OPER_WRITE_REG) begin
			r_regfileAddressCreator_wr_add = memoryDecoder_reg2_add;
			r_regfile_wr_data = regfile_rd_data1;
		end
		else if (OPER_CODE_2==`OPER_READ_MEM) begin
			r_memory_address_creator_in_ADDR = regfile_rd_data1;
			r_memory_address_creator_select_code_segment=0;
		end
		else if (OPER_CODE_2==`OPER_WRITE_MEM) begin
			r_memory_address_creator_in_ADDR = regfile_rd_data2;
			r_memory_address_creator_select_code_segment=0;
			r_SRAM_data_in = regfile_rd_data1;
		end
		else if (OPER_CODE_2==`OPER_PUSH_TO_STACK) begin
			r_memory_address_creator_in_ADDR = regfile_rd_data2+1;
			r_memory_address_creator_select_code_segment=0;
			r_SRAM_data_in = regfile_rd_data1;
		end
		else if (OPER_CODE_2==`OPER_POP_FROM_STACK) begin
			r_memory_address_creator_in_ADDR = regfile_rd_data2;
			r_regfileAddressCreator_wr_add = reg_address_from_IR_regAddress;
			r_memory_address_creator_select_code_segment=0;
			r_SRAM_data_out = SRAM_data_out;
		end

		case(r_operation) 
			`OPER_ENABLE_ALU_AND_RUN : begin
				r_operation_count<=3;
			end
			`OPER_WRITE_REG : begin
				r_operation_count<=3;
			end
			`OPER_READ_MEM : begin
				r_operation_count<=3;
			end
			`OPER_WRITE_MEM : begin
				r_operation_count<=3;
			end
			`OPER_PUSH_TO_STACK : begin
				r_operation_count<=3;
			end
			`OPER_POP_FROM_STACK : begin
				r_operation_count<=3;
			end
			`OPER_READ_INST : begin
				r_operation_count<=2;
			end
		endcase
	end
	else if(r_operation_count==3) begin
		//r_operation = `OPER_HALT; // disable all devices
		
		if (OPER_CODE_3==`OPER_WRITE_REG) begin
			if (OPER_CODE_2==`OPER_POP_FROM_STACK) begin
				r_operation=OPER_CODE_3;
				r_regfileAddressCreator_wr_add = memoryDecoder_reg1_add;
				r_regfile_wr_data = r_SRAM_data_out;
			end
			else if (OPER_CODE_2==`OPER_READ_MEM) begin
				r_operation=OPER_CODE_3;
				r_regfile_wr_data = SRAM_data_out;
				r_regfileAddressCreator_wr_add = memoryDecoder_reg2_add;
			end
			else begin
				r_operation=OPER_CODE_3;
				r_regfile_wr_data = ALU_out;
				if (memoryDecoder_inst_type==`OPR1R2) begin
					r_regfileAddressCreator_wr_add = memoryDecoder_reg2_add;
				end
				else if (memoryDecoder_inst_type==`OPR1) begin
					r_regfileAddressCreator_wr_add = memoryDecoder_reg1_add;
				end
				
			end
		end 
		else if (OPER_CODE_3==`OPER_SET_PC) begin
			r_operation=OPER_CODE_3;
			if (OPER_CODE_2==`OPER_ENABLE_ALU_AND_RUN) begin
				if (ALU_out==16'hffff) begin
					r_PC <= regfile_rd_data1;
				end
			end
		end
		
		case(r_operation) 
			`OPER_WRITE_REG : begin
				r_operation_count=4;
			end
			`OPER_SET_PC : begin
				r_operation_count=4;
			end
			`OPER_READ_INST : begin
				r_operation_count=3;
			end
		endcase
	end
	else if(r_operation_count==4) begin
		r_operation<=OPER_CODE_4;
		r_operation_count<=4;
	end

end


endmodule

