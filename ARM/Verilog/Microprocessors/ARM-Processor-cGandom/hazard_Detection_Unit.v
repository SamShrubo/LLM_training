module hazard_Detection_Unit (src1, src2, is_src1_valid, Two_src, Exe_Dest, Exe_WB_EN, EXE_MEM_R_EN,
				Mem_Dest, Mem_WB_EN, Forward_EN, hazard_Detected);
input [3:0] src1;
input [3:0] src2;
input is_src1_valid;
input Two_src;
input [3:0] Exe_Dest;
input Exe_WB_EN;
input EXE_MEM_R_EN;
input [3:0] Mem_Dest;
input Mem_WB_EN; 
input Forward_EN;
output hazard_Detected;

	assign hazard_Detected = ~Forward_EN?
				//Mode 1: Forwarding is disabled
				((Exe_WB_EN && ((is_src1_valid && Exe_Dest == src1) | (Two_src == 1'b1 && Exe_Dest == src2)))? 1'b1
				:(Mem_WB_EN && ((is_src1_valid && Mem_Dest == src1) | (Two_src == 1'b1 && Mem_Dest == src2)))? 1'b1
				: 1'b0) : 
				//Mode 2: Forwarding is enabled
				((EXE_MEM_R_EN && ((is_src1_valid && Exe_Dest == src1) | (Two_src == 1'b1 && Exe_Dest == src2)))? 1'b1
				: 1'b0);


endmodule 