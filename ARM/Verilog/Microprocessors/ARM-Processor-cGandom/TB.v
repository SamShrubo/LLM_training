`timescale 1ns/1ns

module TB();

	reg clk = 1, rst = 0;
	reg Forward_EN = 1;

	ARM arm (
		.clk(clk),
		.rst(rst),
		.Forward_EN(Forward_EN)
		);

	
	integer cyclenum = 0;
	always #150 clk = ~clk;
	always #300 cyclenum = cyclenum + 1;

	initial begin
		#100
		rst = 1;
		#300
		rst = 0;

		#1000000
		$stop;
	end

endmodule 