module EXE_Stage (clk, rst, EXE_CMD, MEM_R_EN, MEM_W_EN, PC, Val_Rn, Val_Rm, 
			imm, Shift_operand, signed_imm_24, SR, Sel_src1, Sel_src2, 
			MEM_ALU_result, WB_Value, ALU_result, Br_addr, status);
input clk; //not needed
input rst; //not needed 
input [3:0] EXE_CMD;
input MEM_R_EN;
input MEM_W_EN;
input [31:0] PC;
input [31:0] Val_Rn;
input [31:0] Val_Rm;
input imm; 
input [11:0] Shift_operand;
input [23:0] signed_imm_24;
input [3:0] SR;
input [1:0] Sel_src1;
input [1:0] Sel_src2;
input [31:0] MEM_ALU_result;
input [31:0] WB_Value;
output [31:0] ALU_result;
output [31:0] Br_addr;
output [3:0] status;

	//Branch Address Calculator
	wire [31:0] signed_EX_imm24;
	assign signed_EX_imm24 = {{8{signed_imm_24[23]}},signed_imm_24} << 2;

	Adder32 br_addr_adder(
			.inp0(PC), 
			.inp1(signed_EX_imm24), 
			.out(Br_addr)
			);
	
	//Val2 Generator
	wire is_ldr_or_str;
	assign is_ldr_or_str = MEM_R_EN | MEM_W_EN;

	wire [31:0] Val2Gen_Rm_Input;
	assign Val2Gen_Rm_Input = (Sel_src2 == 2'b00)? Val_Rm:
			     	  (Sel_src2 == 2'b01)? MEM_ALU_result: 
			          (Sel_src2 == 2'b10)? WB_Value:
			      	  Val_Rm;

	wire [31:0] Val2;
	Val2Generator val2generator(
			.Val_Rm(Val2Gen_Rm_Input),
			.imm(imm),
			.is_ldr_or_str(is_ldr_or_str),
			.Shift_operand(Shift_operand),
			.Val2out(Val2)
			);

	//Muliplexers for ALU input 1
	wire [31:0] ALU_Input_1;
	
	assign ALU_Input_1 = (Sel_src1 == 2'b00)? Val_Rn:
			     (Sel_src1 == 2'b01)? MEM_ALU_result: 
			     (Sel_src1 == 2'b10)? WB_Value:
			      Val_Rn;


	//ALU
	wire carry_in;
	assign carry_in = SR[1];

	ALU alu(
		.Val1(ALU_Input_1),
		.Val2(Val2),
		.carry_in(carry_in),
		.EXE_CMD(EXE_CMD),
		.result(ALU_result),
		.status(status)
		);
		

endmodule 