`include "registerList.h"
`include "commands_list.h"
`include "ramVariables.h"

module testCpu;

parameter dataLength=`dataLength;
parameter addressLegth=`addressLegth;

wire [addressLegth-1:0] SRAM_ADDR_fromCPU_out;
wire [dataLength-1:0] SRAM_DQ_fromCPU;
wire SRAM_WE_N_fromCPU;
wire SRAM_OE_N_fromCPU;
wire SRAM_UB_N_fromCPU;
wire SRAM_LB_N_fromCPU;
wire SRAM_CE_N_fromCPU;

reg [dataLength-1:0] r_SRAM_DQ_fromCPU;
assign SRAM_DQ_fromCPU = r_SRAM_DQ_fromCPU;

reg clk;

cpu
	cpu1
	(
		.clk(clk),
		.SRAM_ADDR_fromCPU_out(SRAM_ADDR_fromCPU_out) ,
		.SRAM_DQ_fromCPU(SRAM_DQ_fromCPU),
		.SRAM_WE_N_fromCPU(SRAM_WE_N_fromCPU),
		.SRAM_OE_N_fromCPU(SRAM_OE_N_fromCPU),
		.SRAM_UB_N_fromCPU(SRAM_UB_N_fromCPU),
		.SRAM_LB_N_fromCPU(SRAM_LB_N_fromCPU),
		.SRAM_CE_N_fromCPU(SRAM_CE_N_fromCPU)
	);

initial begin
	clk=0;
	r_SRAM_DQ_fromCPU = 16'h0000;
	#100000
	r_SRAM_DQ_fromCPU = {`JNC,`AL1,5'b00000};



	#100
	$stop();

end

always begin
	#50
	clk = ~clk;
end

endmodule