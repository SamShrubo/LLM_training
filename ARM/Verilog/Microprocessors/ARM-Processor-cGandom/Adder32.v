module Adder32 (inp0, inp1, out);
input [31:0] inp0;
input [31:0] inp1;
output [31:0] out;

	assign out = inp0 + inp1;

endmodule
