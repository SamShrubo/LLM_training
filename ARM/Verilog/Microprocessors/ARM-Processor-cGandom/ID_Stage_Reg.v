module ID_Stage_Reg (clk, rst, flush, WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,B_IN, S_IN, 
			EXE_CMD_IN, PC_IN, Val_Rn_IN, Val_Rm_IN,
			imm_IN, Shift_operand_IN, Signed_imm_24_IN, Dest_IN, src1_IN, src2_IN,
			WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, PC, Val_Rn, Val_Rm,
			imm, Shift_operand, Signed_imm_24, Dest, src1, src2);
input clk;
input rst;
input flush;
input WB_EN_IN;
input MEM_R_EN_IN;
input MEM_W_EN_IN;
input B_IN; 
input S_IN; 
input [3:0] EXE_CMD_IN;
input [31:0] PC_IN;
input [31:0] Val_Rn_IN;
input [31:0] Val_Rm_IN;
input imm_IN;
input [11:0] Shift_operand_IN;
input [23:0] Signed_imm_24_IN;
input [3:0] Dest_IN;
input [3:0] src1_IN;
input [3:0] src2_IN;
output WB_EN;
output MEM_R_EN;
output MEM_W_EN;
output B;
output S;
output [3:0] EXE_CMD;
output [31:0] PC;
output [31:0] Val_Rn;
output [31:0] Val_Rm;
output imm;
output [11:0] Shift_operand;
output [23:0] Signed_imm_24;
output [3:0] Dest;
output [3:0] src1;
output [3:0] src2;

	Reg #(.WIDTH(1)) WB_EN_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(WB_EN_IN & {1{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(WB_EN)
		);

	Reg #(.WIDTH(1)) MEM_R_EN_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(MEM_R_EN_IN & {1{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(MEM_R_EN)
		);

	Reg #(.WIDTH(1)) MEM_W_EN_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(MEM_W_EN_IN & {1{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(MEM_W_EN)
		);

	Reg #(.WIDTH(1)) B_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(B_IN & {1{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(B)
		);

	Reg #(.WIDTH(1)) S_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(S_IN & {1{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(S)
		);

	Reg #(.WIDTH(4)) EXEC_CMD_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(EXE_CMD_IN & {4{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(EXE_CMD)
		);

	Reg #(.WIDTH(32)) PC_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(PC_IN & {32{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(PC)
		);

	Reg #(.WIDTH(32)) Val_Rn_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(Val_Rn_IN & {32{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(Val_Rn)
		);

	Reg #(.WIDTH(32)) Val_Rm_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(Val_Rm_IN & {32{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(Val_Rm)
		);

	Reg #(.WIDTH(1)) imm_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(imm_IN & {1{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(imm)
		);

	Reg #(.WIDTH(12)) Shift_operand_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(Shift_operand_IN & {12{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(Shift_operand)
		);

	Reg #(.WIDTH(24)) Signed_imm_24_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(Signed_imm_24_IN & {24{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(Signed_imm_24)
		);

	Reg #(.WIDTH(4)) Dest_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(Dest_IN & {4{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(Dest)
		);

	Reg #(.WIDTH(4)) src1_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(src1_IN & {4{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(src1)
		);

	Reg #(.WIDTH(4)) src2_reg (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.d(src2_IN & {4{~flush}}), // if flush = 1, 0 is stored in register after clk posedge, else data is stored
		.q(src2)
		);

endmodule 
