
`include "commands_list.h"
`include "alu_parameters.h"

//TODO : overflow flag'e bax islemir
module alu
	#(
	parameter dataLength = `dataLength,
	parameter instructionLength = `instructionLength
	)
		(
      	input enable_alu,
		input[dataLength -1 :0] in1,
		input[dataLength -1 :0] in2,
		input[instructionLength -1 :0] IR,
		output  C,
		output  Z,
		output  S, 
		output  V,
		output  P,
		output  [dataLength -1 :0] out,
		output 	output_ready
	);

reg [dataLength -1 :0] r_out;
reg r_output_ready;

reg [dataLength -1:0] r_neg_in2=0; // used for finding overflow flag
reg [dataLength -1:0] r_in1;  // used for finding overflow flag
assign output_ready = r_output_ready;
assign out = r_out;

//FLAGs
reg r_C=0;
reg r_Z=0;
reg r_S=0;
reg r_V=0;
reg r_P=0;
reg r_setFlags=0;
assign Z = r_Z;
assign C = r_C;
assign S = r_S;
assign V = r_V;
assign P = r_P;		

//calculate flags
always @(*) begin
	if (r_setFlags==1'b1) begin
		if (IR==`ADD  ||
			IR==`ADC  ||
			IR==`SUB  ||
			IR==`AND  ||
			IR==`OR   ||
			IR==`XOR  ||
			IR==`INC  ||
			IR==`DEC  ||
			IR==`NEG  ||
			IR==`TEST ||
			IR==`CMP    ) begin

			r_Z = ~(|r_out);
			r_S = r_out[dataLength -1] == 1;
			r_P = ~^r_out ; 
		
		end
/*
		if(IR==`ADC && r_output_ready==1) begin
			r_C=r_C;
		end
*/
		if (IR==`ADD  ||
			IR==`ADC  ||
			IR==`SUB  ||
			IR==`INC  ||
			IR==`DEC  ||
			IR==`CMP  ) begin

			r_V= ( 
			( r_in1[dataLength -1]==0 && 
			r_neg_in2[dataLength -1]==0 && 
			r_out[dataLength -1]==1 )
				||
			( r_in1[dataLength -1]==1 && 
			r_neg_in2[dataLength -1]==1 && 
			r_out[dataLength -1]== 0 ) 
				);
			
		end

		if (IR==`SHRS  ||
			IR==`SHLS  ||
			IR==`AND   ||
			IR==`OR    ||
			IR==`XOR   ||
			IR==`TEST    ) begin

			r_V=0;

		end

		if (IR==`AND   ||
			IR==`OR    ||
			IR==`XOR   ||
			IR==`TEST    ) begin

			r_C=0;

		end

		if (IR==`NEG) begin
			r_C = |in1;
			r_V = ( 
					( r_in1[dataLength -1]==0 && 
					r_out[dataLength -1]==1 )
						||
					( r_in1[dataLength -1]==1 &&  
					r_out[dataLength -1]== 0 ) 
				   );
		end
		
		if (IR==`SHRA) begin
			r_V = 1'b0 ^ in1[dataLength-1];
		end
		
		if (IR==`SHLA) begin
			r_V = in1[dataLength-1] ^ in1[dataLength-2];
		end
		
		if (IR==`ROL) begin
			r_C = in1[dataLength-1];
			r_V = in1[dataLength-1] ^ in1[dataLength-2];
		end

		if (IR==`ROR) begin
			r_C = in1[0];
			r_V = in1[dataLength-1] ^ in1[0]; 
		end

		if (IR==`RCL) begin
			r_C = in1[dataLength-1];
			r_V = in1[dataLength-1] ^ in1[dataLength-2]; 
		end

		if (IR==`RCR) begin
			r_V = in1[dataLength-1] ^ r_C; 
			r_C = in1[0];
		end


		r_setFlags=0;
	end
	r_in1=in1;
	r_output_ready=0;
//	r_C=r_C;
	if (enable_alu==1'b1) begin
		r_setFlags=1;
		case(IR)
			//add
			`ADD: begin
		        {r_C,r_out} = in1 + in2;
		        r_neg_in2 = in2;
		        r_output_ready = 1;
			end
			//adc add with carry
			//TODO:ADC test ele
			`ADC: begin
		        r_neg_in2 = in2 + r_C;
				{r_C,r_out} = in1 + in2 + r_C;
		        r_output_ready = 1;
			end
			//sub
			`SUB: begin
		        r_neg_in2 = (~in2) + 1;
		        {r_C,r_out} = in1 + r_neg_in2;
		        r_output_ready = 1 ;
			end
			//inc 
			`INC: begin
				r_out = in1 + 1;
				r_output_ready = 1;
			end
			//dec 
			`DEC: begin
				r_out = in1 - 1;
				r_output_ready = 1;
			end
			//and 
			`AND: begin
				r_out = in1 & in2;
				r_output_ready = 1;
			end
			//or  
			`OR: begin
				r_out = in1 | in2;
				r_output_ready = 1;
			end
			//xor  
			`XOR: begin
				r_out = in1 ^ in2;
				r_output_ready = 1;
			end
			//not  
			`NOT: begin
				r_out = ~in1;
				r_output_ready = 1;
			end
			//not
			//TODO:NEG'in testini ele 
			`NEG: begin
				r_out = ~in1 + 1;
				r_output_ready = 1;
			end
			//shr signed 
			`SHRS: begin
				{r_out,r_C} = {in1[dataLength -1],in1[dataLength-1:0]};
				r_output_ready = 1;
			end
			//shr unsigned
			`SHRA: begin
				{r_out,r_C} = {1'b0,in1[dataLength-1:0]};
				r_output_ready = 1;
			end
			//shl  signed
			`SHLS: begin
				{r_C,r_out} = {in1[dataLength -1],
					in1[dataLength -1],	in1[dataLength-3:0],1'b0};
				r_output_ready = 1;
			end
			//shl  unsigned
			`SHLA: begin
				{r_C,r_out} = {in1[dataLength-1:0],1'b0};
				r_output_ready = 1;
			end

			//rol rotate left
			`ROL: begin
				r_out = {in1[dataLength-2:0],in1[dataLength-1]}; 
				r_output_ready = 1;
			end
			//ror rotate right
			`ROR: begin
				r_out = {in1[0],in1[dataLength-1:1]};
				r_output_ready = 1;
			end
			//rcl rotate left with carry
			`RCL: begin
				r_out = {in1[dataLength-2:0],r_C};
				r_output_ready = 1;
			end
			//rcr rotate right with carry
			`RCR: begin
				r_out = {r_C,in1[dataLength-1:1]};
				r_output_ready = 1;
			end
			//and 
			`TEST: begin
				r_out = in1 & in2;
				r_output_ready = 0;
			end
			//setc set carry flag
			`SETC: begin
				r_C = 1'b1;
				r_output_ready = 0;
			end

			//clc clear carry flag
			`CLC: begin
				r_C = 1'b0;
				r_output_ready = 0;
			end		

			//cmp instruction
			`CMP: begin
				r_neg_in2 = ~in2 + 1;
				{r_C,r_out} = in1 + ~in2 + 1;
				r_output_ready = 0;
			end	
			//TODO: asagidakilarin hamisina bax,testlerini ele
			//baxanda r_out deyerine bax
			/* ja/jnbe instructions 
			Jump if above/Jump if not below or equal	
			unsigned numbers
			*/
			`JA , `JNBE: 
			begin	
				if ( r_C==1'b0 && r_Z==1'b0 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end

			end	

			/* JB/JNAE/JC 
			jump if below/Jump if not above or equal/Jump if carry	
			unsigned
			*/
			`JB , `JNAE , `JC: 
			begin
				if ( r_C == 1'b1 ) begin
					r_out =  {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			/* JNB/JAE/JNC
			Jump if not below/Jump if above or equal/Jump if not carry
			unsigned
			*/
			`JNB , `JAE , `JNC: 
			begin
				if ( r_C == 1'b0 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end

			/* JBE/JNA 
			Jump if below or equal/Jump if not above	
			unsigned
			*/
			`JBE , `JNA : 
			begin
				if ( r_C == 1'b1 || r_Z==1'b1 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			/* JL/JNGE
				Jump if less/Jump if not greater or equal	
				signed
			*/
			`JL , `JNGE : 
			begin
				if ( r_S != r_V ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			/* JGE/JNL
				Jump if greater or equal/Jump if not less	
				signed
			*/
			`JNL , `JGE : 
			begin
				if ( r_S == r_V ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			/* JLE/JNG
				Jump if less or equal/Jump if not greater	
				signed
			*/
			`JLE , `JNG : 
			begin
				if ( r_Z==1'b1 || r_S != r_V ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	


			/* JG/JNLE
				Jump if greater/Jump if not less or equal	
				signed
			*/
			`JG , `JNLE : 
			begin
				if ( r_Z==1'b0 && r_S == r_V ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			// JE/JZ jump if equal/jump if zero
			`JE , `JZ : 
			begin
				if ( r_Z==1'b1 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			// JNE/JNZ jump if not equal/jump if not zero
			`JNE , `JNZ : 
			begin
				if ( r_Z==1'b0 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			// JO jump if overflow
			`JO : 
			begin
				if ( r_V==1'b1 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			// JNO jump if not overflow
			`JNO : 
			begin
				if ( r_V==1'b0 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	
			// JS jump if sign flag
			`JS : 
			begin
				if ( r_S==1'b1 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			// JNS jump if not sign
			`JNS : 
			begin
				if ( r_S==1'b0 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	

			// JP/JPE jump if parity/Jump if parity even	
			`JP, `JPE : 
			begin
				if ( r_P==1'b1 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	
			
			// JNP/JPO Jump if not parity/Jump if parity odd	
			`JNP, `JPO : 
			begin
				if ( r_P==1'b0 ) begin
					r_out = {dataLength{1'b1}};
					r_output_ready = 1;
				end
				else begin
					r_out = {dataLength{1'b0}};
					r_output_ready = 1;
				end
			end	
			`JMP : 
			begin
				r_out = {dataLength{1'b1}};
				r_output_ready = 1;
			end		

		endcase
	end
	else begin
		r_output_ready = 0;
	end
end



endmodule