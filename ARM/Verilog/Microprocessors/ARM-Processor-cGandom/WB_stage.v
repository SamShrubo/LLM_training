module WB_stage (clk, rst, ALU_result, MEM_result, MEM_R_en, out);
input clk; //not needed
input rst; //not needed
input [31:0] ALU_result;
input [31:0] MEM_result;
input MEM_R_en;
output [31:0] out;

	assign out = MEM_R_en ? MEM_result: ALU_result;

endmodule 
