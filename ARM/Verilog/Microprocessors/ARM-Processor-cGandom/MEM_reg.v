module MEM_reg (clk, rst, WB_en_in, MEM_R_en_in, ALU_result_in, Mem_read_value_in, Dest_in,
		WB_en, MEM_R_en, ALU_result, Mem_read_value, Dest);
input clk;
input rst;
input WB_en_in;
input MEM_R_en_in;
input [31:0] ALU_result_in;
input [31:0] Mem_read_value_in;
input [3:0] Dest_in;
output WB_en;
output MEM_R_en;
output [31:0] ALU_result;
output [31:0] Mem_read_value;
output [3:0] Dest;

	Reg #(.WIDTH(1)) WB_en_reg (
		.clk(clk),
		.rst(rst),
		.d(WB_en_in),
		.en(1'b1),
		.q(WB_en)
		);

	Reg #(.WIDTH(1)) MEM_R_en_reg (
		.clk(clk),
		.rst(rst),
		.d(MEM_R_en_in),
		.en(1'b1),
		.q(MEM_R_en)
		);

	Reg #(.WIDTH(32)) ALU_result_reg (
		.clk(clk),
		.rst(rst),
		.d(ALU_result_in),
		.en(1'b1),
		.q(ALU_result)
		);

	Reg #(.WIDTH(32)) Mem_read_value_reg (
		.clk(clk),
		.rst(rst),
		.d(Mem_read_value_in),
		.en(1'b1),
		.q(Mem_read_value)
		);

	Reg #(.WIDTH(4)) Dest_reg (
		.clk(clk),
		.rst(rst),
		.d(Dest_in),
		.en(1'b1),
		.q(Dest)
		);

endmodule 