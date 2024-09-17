module ARM (clk, rst, Forward_EN);
input clk;
input rst;
input Forward_EN;


	/*=====Wires=====*/

	//Stage IF//
	wire [31:0] IF_PC, IF_Inst;
	
	//Stage IF_ID Registers//
	wire [31:0] IF_ID_PC, IF_ID_Inst;

	//Stage ID//
	wire ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S;
	wire [3:0] ID_EXE_CMD; 
	wire [31:0] ID_Val_Rn, ID_Val_Rm; 
	wire ID_imm; 
	wire [11:0] ID_Shift_operand;
	wire [23:0] ID_Signed_imm_24;
	wire [3:0] ID_Dest, ID_src1, ID_src2;
	wire ID_Two_src, ID_is_Rn_valid;

	//Stage ID_EX Registers//
	wire ID_EX_WB_EN, ID_EX_MEM_R_EN, ID_EX_MEM_W_EN, ID_EX_B, ID_EX_S;
	wire [3:0] ID_EX_EXE_CMD;
	wire [31:0] ID_EX_PC, ID_EX_Val_Rn, ID_EX_Val_Rm;
	wire ID_EX_imm; 
	wire [11:0] ID_EX_Shift_operand;
	wire [23:0] ID_EX_Signed_imm_24;
	wire [3:0] ID_EX_Dest, ID_EX_src1, ID_EX_src2;

	//Stage EX//
	wire flush, branchTaken;
	wire [31:0] EX_ALU_result, EX_Br_addr; 
	wire [3:0] EX_status_bits;

	assign branchTaken = ID_EX_B;
	assign flush = ID_EX_B;

	//Status Register
	wire [3:0] SR;
	
	//Stage EX_MEM Registers//
	wire EX_MEM_WB_en, EX_MEM_MEM_R_EN, EX_MEM_MEM_W_EN; 
	wire [31:0] EX_MEM_ALU_result, EX_MEM_ST_val; 
	wire [3:0] EX_MEM_Dest;

	//Stage MEM//
	wire [31:0] MEM_mem_result;

	//Stage MEM_WB Registers//
	wire MEM_WB_WB_EN, MEM_WB_MEM_R_en;
	wire [31:0] MEM_WB_ALU_result, MEM_WB_Mem_read_value; 
	wire [3:0] MEM_WB_Dest;
	
	//Stage WB//
	wire WB_WriteBack_En;
	wire [3:0] WB_Dest;
	wire [31:0] WB_Value;

	assign WB_WriteBack_En = MEM_WB_WB_EN;
	assign WB_Dest = MEM_WB_Dest;

	//Hazard Detection Unit//
	wire freeze, hazard;
	assign freeze = hazard;

	//Forwarding Unit//
	wire [1:0] FU_Sel_src1, FU_Sel_src2;

	/*=====Modules=====*/

	//Stage IF//
	IF_Stage if_stage(
		.clk(clk),
		.rst(rst),
		.freeze(freeze), 
		.branchTaken(branchTaken), 
		.branchAddress(EX_Br_addr), 
		.PC(IF_PC), 
		.Instruction(IF_Inst)
		);
	
	//Stage IF_ID Registers//
	IF_Stage_Reg if_stage_reg(
		.clk(clk), 
		.rst(rst), 
		.freeze(freeze), 
		.flush(flush), 
		.PC_in(IF_PC), 
		.Instruction_in(IF_Inst), 
		.PC(IF_ID_PC), 
		.Instruction(IF_ID_Inst)
		);

	//Stage ID//
	ID_Stage id_stage(
		.clk(clk), 
		.rst(rst), 
		.Instruction(IF_ID_Inst), 
		.Result_WB(WB_Value), 
		.writeBackEn(WB_WriteBack_En), 
		.Dest_wb(WB_Dest), 
		.hazard(hazard), 
		.SR(SR),
		.WB_EN(ID_WB_EN), 
		.MEM_R_EN(ID_MEM_R_EN), 
		.MEM_W_EN(ID_MEM_W_EN), 
		.B(ID_B), 
		.S(ID_S), 
		.EXE_CMD(ID_EXE_CMD), 
		.Val_Rn(ID_Val_Rn), 
		.Val_Rm(ID_Val_Rm), 
		.imm(ID_imm), 
		.Shift_operand(ID_Shift_operand), 
		.Signed_imm_24(ID_Signed_imm_24), 
		.Dest(ID_Dest),
		.src1(ID_src1), 
		.src2(ID_src2), 
		.Two_src(ID_Two_src),
		.is_Rn_valid(ID_is_Rn_valid)
		);

	//Stage ID_EX Registers//
	ID_Stage_Reg id_stage_reg(
		.clk(clk), 
		.rst(rst), 
		.flush(flush), 
		.WB_EN_IN(ID_WB_EN), 
		.MEM_R_EN_IN(ID_MEM_R_EN), 
		.MEM_W_EN_IN(ID_MEM_W_EN),
		.B_IN(ID_B), 
		.S_IN(ID_S), 
		.EXE_CMD_IN(ID_EXE_CMD), 
		.PC_IN(IF_ID_PC), 
		.Val_Rn_IN(ID_Val_Rn), 
		.Val_Rm_IN(ID_Val_Rm),
		.imm_IN(ID_imm), 
		.Shift_operand_IN(ID_Shift_operand), 
		.Signed_imm_24_IN(ID_Signed_imm_24), 
		.Dest_IN(ID_Dest),
		.src1_IN(ID_src1),
		.src2_IN(ID_src2),
		.WB_EN(ID_EX_WB_EN), 
		.MEM_R_EN(ID_EX_MEM_R_EN), 
		.MEM_W_EN(ID_EX_MEM_W_EN), 
		.B(ID_EX_B), 
		.S(ID_EX_S), 
		.EXE_CMD(ID_EX_EXE_CMD), 
		.PC(ID_EX_PC), 
		.Val_Rn(ID_EX_Val_Rn), 
		.Val_Rm(ID_EX_Val_Rm),
		.imm(ID_EX_imm), 
		.Shift_operand(ID_EX_Shift_operand), 
		.Signed_imm_24(ID_EX_Signed_imm_24), 
		.Dest(ID_EX_Dest),
		.src1(ID_EX_src1),
		.src2(ID_EX_src2)
		);

	//Stage EX//
	EXE_Stage exe_stage(
		.clk(clk), 
		.rst(rst), 
		.EXE_CMD(ID_EX_EXE_CMD), 
		.MEM_R_EN(ID_EX_MEM_R_EN), 
		.MEM_W_EN(ID_EX_MEM_W_EN), 
		.PC(ID_EX_PC), 
		.Val_Rn(ID_EX_Val_Rn), 
		.Val_Rm(ID_EX_Val_Rm), 
		.imm(ID_EX_imm), 
		.Shift_operand(ID_EX_Shift_operand), 
		.signed_imm_24(ID_EX_Signed_imm_24), 
		.SR(SR), 
		.Sel_src1(FU_Sel_src1), 
		.Sel_src2(FU_Sel_src2), 
		.MEM_ALU_result(EX_MEM_ALU_result), 
		.WB_Value(WB_Value),
		.ALU_result(EX_ALU_result), 
		.Br_addr(EX_Br_addr), 
		.status(EX_status_bits)
		);

	//Status Register
	StatusRegister status_register(
		.clk(clk),
		.rst(rst),
		.d(EX_status_bits),
		.en(ID_EX_S),
		.q(SR)
		);

	//Stage EX_MEM Registers//
	EXE_reg exe_reg(
		.clk(clk), 
		.rst(rst), 
		.WB_en_in(ID_EX_WB_EN), 
		.MEM_R_EN_in(ID_EX_MEM_R_EN), 
		.MEM_W_EN_in(ID_EX_MEM_W_EN), 
		.ALU_result_in(EX_ALU_result), 
		.ST_val_in(ID_EX_Val_Rm), 
		.Dest_in(ID_EX_Dest),
		.WB_en(EX_MEM_WB_en), 
		.MEM_R_EN(EX_MEM_MEM_R_EN), 
		.MEM_W_EN(EX_MEM_MEM_W_EN), 
		.ALU_result(EX_MEM_ALU_result), 
		.ST_val(EX_MEM_ST_val), 
		.Dest(EX_MEM_Dest)
		);

	//Stage MEM//
	Memory memory(
		.clk(clk), 
		.rst(rst), 
		.MEMread(EX_MEM_MEM_R_EN), 
		.MEMwrite(EX_MEM_MEM_W_EN), 
		.address(EX_MEM_ALU_result), 
		.data(EX_MEM_ST_val), 
		.MEM_result(MEM_mem_result)
		);

	//Stage MEM_WB Registers//
	MEM_reg mem_reg(
		.clk(clk), 
		.rst(rst), 
		.WB_en_in(EX_MEM_WB_en), 
		.MEM_R_en_in(EX_MEM_MEM_R_EN), 
		.ALU_result_in(EX_MEM_ALU_result), 
		.Mem_read_value_in(MEM_mem_result), 
		.Dest_in(EX_MEM_Dest),
		.WB_en(MEM_WB_WB_EN), 
		.MEM_R_en(MEM_WB_MEM_R_en), 
		.ALU_result(MEM_WB_ALU_result), 
		.Mem_read_value(MEM_WB_Mem_read_value), 
		.Dest(MEM_WB_Dest)
		);
	
	//Stage WB//
	WB_stage wb_stage(
		.clk(clk), 
		.rst(rst), 
		.ALU_result(MEM_WB_ALU_result), 
		.MEM_result(MEM_WB_Mem_read_value), 
		.MEM_R_en(MEM_WB_MEM_R_en),
		.out(WB_Value)
		);

	//Hazard Detection Unit//
	hazard_Detection_Unit hazard_detection_unit(
		.src1(ID_src1), 
		.src2(ID_src2),
		.is_src1_valid(ID_is_Rn_valid),
		.Two_src(ID_Two_src), 
		.Exe_Dest(ID_EX_Dest), 
		.Exe_WB_EN(ID_EX_WB_EN),
		.EXE_MEM_R_EN(ID_EX_MEM_R_EN),
		.Mem_Dest(EX_MEM_Dest), 
		.Mem_WB_EN(EX_MEM_WB_en),
		.Forward_EN(Forward_EN),
		.hazard_Detected(hazard)
		);

	//Forwarding Unit//
	ForwardingUnit forwarding_unit(
		.src1(ID_EX_src1), 
		.src2(ID_EX_src2), 
		.MEM_Dest(EX_MEM_Dest), 
		.MEM_WB_EN(EX_MEM_WB_en), 
		.WB_Dest(MEM_WB_Dest), 
		.WB_WB_EN(MEM_WB_WB_EN), 
		.Sel_src1(FU_Sel_src1), 
		.Sel_src2(FU_Sel_src2)
		);


endmodule 