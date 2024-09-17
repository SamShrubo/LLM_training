module ID_Stage (clk, rst, Instruction, Result_WB, writeBackEn, Dest_wb, hazard, SR,
			WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, 
			Val_Rn, Val_Rm, 
			imm, Shift_operand, Signed_imm_24, Dest,
			src1, src2, Two_src, is_Rn_valid);
input clk;
input rst;
//from IF Reg
input [31:0] Instruction;
//from WB stage
input [31:0] Result_WB;
input writeBackEn;
input [3:0] Dest_wb;
//from hazard detect module
input hazard;
//from Status register
input [3:0] SR;
//to next stage
output WB_EN;
output MEM_R_EN;
output MEM_W_EN;
output B;
output S;
output [3:0] EXE_CMD;
output [31:0] Val_Rn;
output [31:0] Val_Rm;
output imm;
output [11:0] Shift_operand;
output [23:0] Signed_imm_24;
output [3:0] Dest;
//to hazard detect module and forwarding unit
output [3:0] src1;
output [3:0] src2;
output Two_src;
output is_Rn_valid;

	wire [3:0] Rn, Rd, Rm;
	assign Rn = Instruction[19:16];
	assign Rd = Instruction[15:12];
	assign Rm = Instruction[3:0];


	assign imm = Instruction[25];
	assign Signed_imm_24 = Instruction[23:0];
	assign Shift_operand = Instruction[11:0];
	assign Dest = Rd;

	wire [1:0] mode;
	wire [3:0] opcode, cond;
	wire S_in;
	assign cond = Instruction[31:28];
	assign mode = Instruction[27:26];
	assign opcode = Instruction[24:21];
	assign S_in = Instruction[20];

	//to hazard detect module
	assign Two_src = ~imm | MEM_W_EN;
	assign src1 = Rn;
	assign src2 = MEM_W_EN? Rd: Rm;
	assign is_Rn_valid = ((opcode == 4'b1101) //MOV
				| (opcode == 4'b1111) //MVN
				| (Instruction == 32'b11100000000000000000000000000000)) //NOP
				? 1'b0: 1'b1; //This is used in hazard detection unit

	//register file module 
	RegisterFile registerfile (
			.clk(clk), 
			.rst(rst), 
			.src1(src1), 
			.src2(src2), 
			.Dest_wb(Dest_wb), 
			.Result_WB(Result_WB), 
			.writeBackEn(writeBackEn), 
			.reg1(Val_Rn), 
			.reg2(Val_Rm)
			);

	//condition check
	wire MetCondition;

	ConditionCheck conditioncheck(
			.Cond(cond), 
			.SR(SR), 
			.MetCondition(MetCondition)
			);

	//control unit and control signals
	wire CU_WB_EN, CU_MEM_R_EN, CU_MEM_W_EN, CU_B, CU_S;
	wire [3:0] CU_EXE_CMD;

	ControlUnit controlunit (
			.mode(mode), 
			.opcode(opcode), 
			.S(S_in), 
			.WB_EN(CU_WB_EN), 
			.MEM_R_EN(CU_MEM_R_EN), 
			.MEM_W_EN(CU_MEM_W_EN), 
			.B(CU_B), 
			.S_out(CU_S), 
			.EXE_CMD(CU_EXE_CMD)
			);

	//control signals multiplexer
	wire control_signals_sel;
	assign control_signals_sel = ~MetCondition | hazard;
	
	assign {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD}
		= ~control_signals_sel? {CU_WB_EN, CU_MEM_R_EN, CU_MEM_W_EN, CU_B, CU_S, CU_EXE_CMD} : 9'b0;

	

endmodule
