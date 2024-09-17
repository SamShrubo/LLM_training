module RegisterFile (clk, rst, src1, src2, Dest_wb, Result_WB, writeBackEn, reg1, reg2);
input clk;
input rst;
input [3:0] src1;
input [3:0] src2;
input [3:0] Dest_wb;
input [31:0] Result_WB;
input writeBackEn;
output [31:0] reg1;
output [31:0] reg2;

	reg [31:0] registers [0:13]; // 14 32-bit register
	
	assign reg1 = registers[src1];
	assign reg2 = registers[src2];

	integer i;
	always @(negedge clk or posedge rst) begin
		if (rst) begin
			for (i = 0; i < 14; i=i+1)
				registers[i] <= 32'b0;
		end
		else if (writeBackEn) begin
			registers[Dest_wb] <= Result_WB;
		end
	end

endmodule 