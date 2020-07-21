/*

REGISTERS	Binary equivalent
AX1	00000
BX1	00001
CX1	00010
DX1	00011
AX2	00100
BX2	00101
CX2	00110
DX2	00111
R1	01000
R2	01001
R3	01010
R4	01011
RLI	01100
SP	01101
BP	01110
RADR	01111
AL1	10000
BL1	10001
CL1	10010
DL1	10011
AL2	10100
BL2	10101
CL2	10110
DL2	10111
AH1	11000
BH1	11001
CH1	11010
DH1	11011
AH2	11100
BH2	11101
CH2	11110
DH2	11111

*/

/*
	This register file designed as  16x16.
	(16 register, 16 bit wide // and 8 register can be divided and accessed to low and high).
	Either writing or reading can be done in one access to register file.
*/

`include "registerFileParameters.h"

module regfile32x32
			#(
				parameter registerLength = `registerLength,
				parameter registerAddressLength = `registerAddressLength,
				parameter registerFileDepth = `registerFileDepth
			)
			(
				input 	[registerAddressLength-1:0] 	address_rd1,
				input 	[registerAddressLength-1:0] 	address_rd2,
				input 	[registerAddressLength-1:0] 	address_wr,

				output 	[registerLength-1:0] 	rd_data1,
				output 	[registerLength-1:0] 	rd_data2,
				input 	[registerLength-1:0] 	wr_data,

				input	lb_rd1,
				input	hb_rd1,
				input	lb_rd2,
				input	hb_rd2,
				input	lb_wr,
				input	hb_wr,

				output 	out_data_enable,
				input  	inc,
				input  	dec,
				input 	en_write,
				input 	rst,
				input   en_reg_file
			);

	//REGISTER FILE
	reg [registerLength-1:0] registers [registerFileDepth-1:0];
	
	//counter for resetting register file
	integer i;

	//for reading from read address1
	reg [registerLength-1:0]r_rd_data1;

	//for reading from read address1
	reg [registerLength-1:0]r_rd_data2;

	//for outputting values which have been read from register file 
	assign rd_data1 = r_rd_data1;
	assign rd_data2 = r_rd_data2;
	
	// if read data is ready , r_out_data_enable will be enabled(will equal 1).
	// when writing value to register file, r_out_data_enable will be disabled(will be 0).
	reg r_out_data_enable;
	//data output is ready or not.
	assign out_data_enable=r_out_data_enable;
	


always @(*) begin
	if (en_reg_file) begin // is register file enabled?
		if(rst) begin  	// is reset enabled?
			for (i=0; i<registerFileDepth; i=i+1) 
			begin
				registers[i] <= 0;
				r_out_data_enable <= 0; 
			end
		end
		else if (en_write) begin // write to register file
			if (lb_wr==1'b1 & hb_wr==1'b0) begin // low byte of register
				if (inc==1'b1 && dec==1'b0) begin
					registers[address_wr][registerLength/2-1:0] = registers[address_wr][registerLength/2-1:0] + 1'b1;
					r_out_data_enable = 0;
				end
				else if (inc==1'b0 && dec==1'b1) begin
					registers[address_wr][registerLength/2-1:0] = registers[address_wr][registerLength/2-1:0] - 1'b1;
					r_out_data_enable = 0;
				end
				else begin
					registers[address_wr][registerLength/2-1:0] <= wr_data[registerLength/2-1:0];
					r_out_data_enable <= 0;	
				end
			end
			else if (hb_wr==1'b1 & lb_wr==1'b0) begin // high byte of register
				if (inc==1'b1 && dec==1'b0) begin
					registers[address_wr][registerLength-1:registerLength/2] = registers[address_wr][registerLength-1:registerLength/2] + 1'b1;
					r_out_data_enable = 0;
				end
				else if (inc==1'b0 && dec==1'b1) begin
					registers[address_wr][registerLength-1:registerLength/2] = registers[address_wr][registerLength-1:registerLength/2] - 1'b1;
					r_out_data_enable = 0;
				end
				else begin
					registers[address_wr][registerLength-1:registerLength/2] <= wr_data[registerLength/2-1:0]; 	
					r_out_data_enable <= 0;
				end
			end
			else if (hb_wr==1'b1 & lb_wr==1'b1) begin // low and high byte of register
				if (inc==1'b1 && dec==1'b0) begin
					registers[address_wr] = registers[address_wr] + 1'b1;
					r_out_data_enable = 0;
				end
				else if (inc==1'b0 && dec==1'b1) begin
					registers[address_wr] = registers[address_wr] - 1'b1;
					r_out_data_enable = 0;
				end
				else begin
					registers[address_wr] <= wr_data;
					r_out_data_enable <= 0;
				end
			end
		end
		else begin 	// read from register file
			if (lb_rd1==1'b1 & hb_rd1==1'b0) begin // low byte of register
				r_rd_data1 <= {8'b00000000,registers[address_rd1][registerLength/2-1:0]};
				r_out_data_enable <= 1;
			end
			if (hb_rd1==1'b1 & lb_rd1==1'b0) begin // high byte of register
				r_rd_data1 <= {8'b00000000,registers[address_rd1][registerLength-1:registerLength/2]};
				r_out_data_enable <= 1;
			end
			if (hb_rd1==1'b1 & lb_rd1==1'b1) begin // low and high byte of register
				r_rd_data1 <= registers[address_rd1];
				r_out_data_enable <= 1;
			end

			if (lb_rd2==1'b1 & hb_rd2==1'b0) begin // low byte of register
				r_rd_data2 <= {8'b00000000,registers[address_rd2][registerLength/2-1:0]};
				r_out_data_enable <= 1;
			end
			if (hb_rd2==1'b1 & lb_rd2==1'b0) begin // high byte of register
				r_rd_data2 <= {8'b00000000,registers[address_rd2][registerLength-1:registerLength/2]};
				r_out_data_enable <= 1;
			end
			if (hb_rd2==1'b1 & lb_rd2==1'b1) begin // low and high byte of register
				r_rd_data2 <= registers[address_rd2];
				r_out_data_enable <= 1;
			end
		end
	end
end



endmodule