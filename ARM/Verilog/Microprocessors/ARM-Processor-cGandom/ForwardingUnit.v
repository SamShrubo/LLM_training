module ForwardingUnit (src1, src2, MEM_Dest, MEM_WB_EN, WB_Dest, WB_WB_EN, Sel_src1, Sel_src2);
input [3:0] src1;
input [3:0] src2;
input [3:0] MEM_Dest;
input MEM_WB_EN;
input [3:0] WB_Dest;
input WB_WB_EN;
output [1:0] Sel_src1;
output [1:0] Sel_src2;

	assign Sel_src1 = ((MEM_WB_EN == 1'b1) && (src1 == MEM_Dest))? 2'b01:
			  ((WB_WB_EN == 1'b1) && (src1 == WB_Dest))? 2'b10:
			   2'b00;

	assign Sel_src2 = ((MEM_WB_EN == 1'b1) && (src2 == MEM_Dest))? 2'b01:
			  ((WB_WB_EN == 1'b1) && (src2 == WB_Dest))? 2'b10:
			   2'b00;

endmodule 