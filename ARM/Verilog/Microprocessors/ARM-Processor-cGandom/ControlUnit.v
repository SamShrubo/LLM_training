module ControlUnit (mode, opcode, S, WB_EN, MEM_R_EN, MEM_W_EN, B, S_out, EXE_CMD);
input [1:0] mode;
input [3:0] opcode;
input S;
output reg WB_EN;
output reg MEM_R_EN;
output reg MEM_W_EN;
output B;
output S_out;
output reg [3:0] EXE_CMD;

	reg MOV, MVN, ADD, ADC, SUB, SBC, AND, ORR, EOR, CMP, TST, LDR, STR, BRANCH;

	//Decode opcode - combinational
	always @(mode or opcode or S) begin
		{MOV, MVN, ADD, ADC, SUB, SBC,
			 AND, ORR, EOR, CMP, TST, LDR, STR, BRANCH} = 14'b0;

		if (mode == 2'b00) begin
			case(opcode)
				4'b1101: MOV = 1'b1;
				4'b1111: MVN = 1'b1;
				4'b0100: ADD = 1'b1;
				4'b0101: ADC = 1'b1;
				4'b0010: SUB = 1'b1;
				4'b0110: SBC = 1'b1;
				4'b0000: AND = 1'b1;
				4'b1100: ORR = 1'b1;
				4'b0001: EOR = 1'b1;
				4'b1010: CMP = 1'b1;
				4'b1000: TST = 1'b1;
			endcase
		end
		else if (mode == 2'b01) begin
			if (S)
				LDR = 1'b1;
			else
				STR = 1'b1;
		end
		else if (mode == 2'b10) begin
			BRANCH = 1'b1;	
		end
	end

	//Generate control signals - combinational
	always @(MOV or MVN or ADD or ADC or SUB or SBC or AND or ORR or EOR or CMP or TST or LDR or STR or BRANCH) begin
		{WB_EN, MEM_R_EN, MEM_W_EN} = 3'b0; 
		EXE_CMD = 4'b0;

		if (MOV) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b0001;
		end
		else if (MVN) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b1001;
		end
		else if (ADD) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b0010;
		end
		else if (ADC) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b0011;
		end
		else if (SUB) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b0100;
		end
		else if (SBC) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b0101;
		end
		else if (AND) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b0110;
		end
		else if (ORR) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b0111;
		end
		else if (EOR) begin
			WB_EN = 1'b1;
			EXE_CMD = 4'b1000;
		end
		else if (CMP) begin
			//WB_EN = 1'b1;
			EXE_CMD = 4'b0100;
		end
		else if (TST) begin
			//WB_EN = 1'b1;
			EXE_CMD = 4'b0110;
		end
		else if (LDR) begin
			WB_EN = 1'b1;
			MEM_R_EN = 1'b1;
			EXE_CMD = 4'b0010;
		end
		else if (STR) begin
			MEM_W_EN = 1'b1;
			EXE_CMD = 4'b0010;
		end
	end

	assign B = BRANCH;
	assign S_out = ~B? S : 1'b0;

endmodule 
