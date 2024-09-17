module IF_Stage_Reg (clk, rst, freeze, flush, PC_in, Instruction_in, PC, Instruction);
input clk;
input rst;
input freeze;
input flush;
input [31:0] PC_in;
input [31:0] Instruction_in;
output [31:0] PC;
output [31:0] Instruction;

	/*IMPORTANT: we prioritzed flush over freeze*/

	// if freeze = 1, nothing new is stored after posedge clk
	// if flush = 1, 0 is stored in register after clk posedge, else data is stored

	Reg #(.WIDTH(32)) pcReg (
		.clk(clk),
		.rst(rst),
		.en(~freeze | flush), 
		.d(PC_in & {32{~flush}}), 
		.q(PC)
		);

	Reg #(.WIDTH(32)) instReg (
		.clk(clk),
		.rst(rst),
		.en(~freeze | flush),
		.d(Instruction_in & {32{~flush}}),
		.q(Instruction)
		);
endmodule 