module Val2Generator (Val_Rm, imm, is_ldr_or_str, Shift_operand, Val2out);
input [31:0] Val_Rm;
input imm;
input is_ldr_or_str;
input [11:0] Shift_operand;
output [31:0] Val2out;

	//naming 32-bit immediate nets
	wire [7:0] immed_8;
	wire [3:0] rotate_imm;
	wire [4:0] rotate_imm_value;
	wire [31:0] extended_immed_8;

	assign immed_8 = Shift_operand[7:0];
	assign rotate_imm = Shift_operand[11:8];
	assign extended_immed_8 = {{24{1'b0}}, immed_8};
	assign rotate_imm_value = rotate_imm << 1;

	//naming Immediate shifts with 4 possible modes nets
	wire [1:0] shift_mode;
	wire [4:0] shift_imm;
	assign shift_mode = Shift_operand[6:5];
	assign shift_imm = Shift_operand[11:7];
	

	//Generating Val2
	assign Val2out = is_ldr_or_str? {{20{Shift_operand[11]}}, Shift_operand} : //is ldr-str?
			imm? {extended_immed_8, extended_immed_8} >> (rotate_imm_value) : //is 32-bit immediate?
			//if non of above, then it is either Immediate shifts with 4 possible modes or Register shifts 
			~Shift_operand[4]? //Checking if it is Immediate shifts
				(shift_mode == 2'b00)? Val_Rm << shift_imm : //LSL
				(shift_mode == 2'b01)? Val_Rm >> shift_imm : //LSR
				(shift_mode == 2'b10)? Val_Rm >>> shift_imm : //ASR
				(shift_mode == 2'b11)? {Val_Rm, Val_Rm} >> shift_imm //ROR
				: 32'bz //something went wrong
			: 32'bz; //It is Register shifts, which we don't implement in this project


endmodule 