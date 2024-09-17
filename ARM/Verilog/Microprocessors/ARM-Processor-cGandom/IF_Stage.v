module IF_Stage (clk, rst, freeze, branchTaken, branchAddress, PC, Instruction);
input clk;
input rst;
input freeze;
input branchTaken;
input [31:0] branchAddress;
output [31:0] PC; 
output [31:0] Instruction;
	
	wire [31:0] PCin, PCout;

	Mux2to1_32 PCinMux(
			.inp0(PC),
			.inp1(branchAddress),
			.sel(branchTaken),
			.out(PCin)
			);
	
	Reg #(.WIDTH(32)) PC_reg (
			.clk(clk),
			.rst(rst),
			.d(PCin),
			.en(~freeze | branchTaken),
			.q(PCout)
			);

	InstructionMemory InstMem(
			.addr(PCout),
			.inst(Instruction)
			);

	Adder32 AdderPCplus4(
			.inp0(PCout),
			.inp1(4),
			.out(PC)
			);

endmodule 