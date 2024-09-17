module ALU (Val1, Val2, carry_in, EXE_CMD, result, status);
input signed [31:0] Val1;
input signed [31:0] Val2;
input carry_in;
input [3:0] EXE_CMD;
output signed [31:0] result;
output [3:0] status;

	wire N, Z, C, V;
	assign status = {N, Z, C, V};

	assign {C, result} = (EXE_CMD == 4'b0001)? Val2: 			//MOV
				(EXE_CMD == 4'b1001)? ~Val2: 			//MVN
				(EXE_CMD == 4'b0010)? Val1 + Val2: 		//ADD
				(EXE_CMD == 4'b0011)? Val1 + Val2 + carry_in: 	//ADC
				(EXE_CMD == 4'b0100)? Val1 - Val2: 		//SUB
				(EXE_CMD == 4'b0101)? Val1 - Val2 - 1: 		//SBC
				(EXE_CMD == 4'b0110)? Val1 & Val2: 		//AND
				(EXE_CMD == 4'b0111)? Val1 | Val2: 		//ORR
				(EXE_CMD == 4'b1000)? Val1 ^ Val2: 		//EOR
				32'bz;

	assign N = result[31];
	assign Z = ~(|result);

	assign V = ((EXE_CMD == 4'b0010) | (EXE_CMD == 4'b0011))? //is command Add?
			(result[31] & ~Val1[31] & ~Val2[31]) | (~result[31] & Val1[31] & Val2[31])
		  :((EXE_CMD == 4'b0100) | (EXE_CMD == 4'b0101))? //is command Sub?
			(result[31] & ~Val1[31] & Val2[31]) | (~result[31] & Val1[31] & ~Val2[31])
		  : 1'b0;


endmodule
