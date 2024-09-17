module Memory (clk, rst, MEMread, MEMwrite, address, data, MEM_result);
input clk;
input rst;
input MEMread;
input MEMwrite;
input [31:0] address;
input signed [31:0] data;
output signed [31:0] MEM_result;

	reg signed [31:0] memory [0:65535]; //256 KB memory

	assign MEM_result = MEMread? memory[(address - 1024)>>2] : 32'bz;

	always @(posedge clk) begin
		if (MEMwrite) begin
			memory[(address - 1024)>>2] <= data;
			$display("Memory write => Stored data %d in address %d ", data, address);
		end
	end

endmodule 