module Mux2to1_32 (inp0, inp1, sel, out);
input [31:0] inp0;
input [31:0] inp1;
input sel;
output [31:0] out;

	assign out = sel? inp1: inp0;

endmodule 