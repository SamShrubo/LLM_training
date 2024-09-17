module EXE_reg (clk, rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in, ALU_result_in, ST_val_in, Dest_in,
		WB_en, MEM_R_EN, MEM_W_EN, ALU_result, ST_val, Dest);
input clk;
input rst;
input WB_en_in;
input MEM_R_EN_in;
input MEM_W_EN_in;
input [31:0] ALU_result_in;
input [31:0] ST_val_in;
input [3:0] Dest_in; 
output WB_en;
output MEM_R_EN;
output MEM_W_EN;
output [31:0] ALU_result;
output [31:0] ST_val;
output [3:0] Dest;

	Reg #(.WIDTH(1)) WB_en_reg (
		.clk(clk),
		.rst(rst),
		.d(WB_en_in),
		.en(1'b1),
		.q(WB_en)
		);

	Reg #(.WIDTH(1)) MEM_R_EN_reg (
		.clk(clk),
		.rst(rst),
		.d(MEM_R_EN_in),
		.en(1'b1),
		.q(MEM_R_EN)
		);

	Reg #(.WIDTH(1)) MEM_W_EN_reg (
		.clk(clk),
		.rst(rst),
		.d(MEM_W_EN_in),
		.en(1'b1),
		.q(MEM_W_EN)
		);

	Reg #(.WIDTH(32)) ALU_result_reg (
		.clk(clk),
		.rst(rst),
		.d(ALU_result_in),
		.en(1'b1),
		.q(ALU_result)
		);

	Reg #(.WIDTH(32)) ST_val_reg (
		.clk(clk),
		.rst(rst),
		.d(ST_val_in),
		.en(1'b1),
		.q(ST_val)
		);
	
	Reg #(.WIDTH(4)) Dest_reg (
		.clk(clk),
		.rst(rst),
		.d(Dest_in),
		.en(1'b1),
		.q(Dest)
		);

endmodule 