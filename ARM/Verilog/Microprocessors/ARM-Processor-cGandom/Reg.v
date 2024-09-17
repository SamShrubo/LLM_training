module Reg #(parameter WIDTH = 32) (clk, rst, d, en, q);
input clk;
input rst;
input [WIDTH-1:0] d;
input en;
output reg [WIDTH-1:0] q;

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= {WIDTH{1'b0}};
		else if(en)
			q <= d;
	end

endmodule
