module StatusRegister (clk, rst, d, en, q);
input clk;
input rst;
input [3:0] d;
input en;
output reg [3:0] q;

	always @(negedge clk or posedge rst) begin
		if (rst)
			q <= {3{1'b0}};
		else if(en)
			q <= d;
	end

endmodule 