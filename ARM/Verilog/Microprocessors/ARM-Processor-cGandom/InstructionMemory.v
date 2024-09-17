module InstructionMemory (addr, inst);
input [31:0] addr;
output [31:0] inst;

	reg [31:0] InstMem [0:255]; //1 KB instruction memory

	assign inst = InstMem[addr[31:2]];

	initial begin 
		$readmemb("Mem.inst", InstMem); //Upload instructions from file "Mem.inst"
	end	


endmodule 