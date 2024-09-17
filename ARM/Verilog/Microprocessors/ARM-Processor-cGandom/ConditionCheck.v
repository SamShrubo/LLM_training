module ConditionCheck (Cond, SR, MetCondition);
input [3:0] Cond;
input [3:0] SR;
output reg MetCondition;

	wire N, Z, C, V;
	assign {N, Z, C, V} = SR;

	always @(Cond or N or Z or C or V) begin
		MetCondition = 1'b0;
		case (Cond)
			4'b0000: MetCondition = Z;	//EQ
			4'b0001: MetCondition = ~Z;	//NE
			4'b0010: MetCondition = C;	//CS/HS
			4'b0011: MetCondition = ~C;	//CC/Lo
			4'b0100: MetCondition = N;	//MI
			4'b0101: MetCondition = ~N;	//PL
			4'b0110: MetCondition = V;	//VS
			4'b0111: MetCondition = ~V;	//VC
			4'b1000: MetCondition = C & ~Z;	//HI
			4'b1001: MetCondition = ~C | Z;	//LS
			4'b1010: MetCondition = (N&V) | (~N&~V);	//GE
			4'b1011: MetCondition = (N&~V) | (~N&V);	//LT
			4'b1100: MetCondition = ~Z & ((N&V)|(~N&~V));	//GT
			4'b1101: MetCondition = Z | (N&~V) | (~N&V);	//LE
			4'b1110: MetCondition = 1'b1; 	//AL
			default: MetCondition = 1'b0;
		endcase
	end


endmodule 
