`include "Counter.v"
`include "FSM.v"
`include "Counter_One_Bit.v"
module CTL(
    input					rst,//in 1
    input					clk,//in 1
    output	wire			done,//out 1
    output	wire			F_CLE_A,//out 1
    output	wire			F_ALE_A,//out 1
    output	wire			F_REN_A,//out 1
    output	wire			F_WEN_A,//out 1
    input					F_RB_A,//in 1
    output	wire			F_CLE_B,//out 1
    output	wire			F_ALE_B,//out 1
    output	wire			F_REN_B,//out 1
    output	wire			F_WEN_B,//out 1
    input					F_RB_B,//in 1
    output	wire			En_A,//out 1
    output	wire			En_B,//out 1
    output	wire	[511:0]	En4Mem,//out 512
    output	wire	[8:0]	Sel4Mem,//out 9
    output	wire			Sel4Out_A,//out 1
    output	wire	[1:0]	Sel4Out_B,//out 2
    output	wire	[7:0]	CMD,//out 8
    output	wire	[7:0]	ADDR//out 8
    );
//////////////// var ///////////////////////
	wire			L_setZ;
	wire			L_run;
	wire	[8:0]	L_count;
	wire			L_flag;
	wire			S_setZ;
	wire			S_run;
	wire	[8:0]	S_count;
	wire			S_flag;
//////////////// large counter /////////////
	Counter lcounter(
		.rst(rst),
		.clk(clk),
		.setZ(L_setZ),
		.run(L_run),
		.count(L_count),
		.flag(L_flag)
		);
//////////////// small counter /////////////
	Counter scounter(
		.rst(rst),
		.clk(clk),
		.setZ(S_setZ),
		.run(S_run),
		.count(S_count),
		.flag(S_flag)
		);
//////////////// one bit counter /////////////
	Counter_One_Bit ocounter(
		.rst(rst),
		.clk(clk),
		.run(O_run),
		.count(O_count),
		.flag(O_flag)
		);
//////////////// FSM ///////////////////////
	FSM fsm(
		.rst(rst),//in 1
		.clk(clk),//in 1
		.done(done),//out 1
		.F_WEN_B(F_WEN_B),//out 1
		.F_REN_B(F_REN_B),//out 1
		.F_ALE_B(F_ALE_B),//out 1
		.F_CLE_B(F_CLE_B),//out 1
		.F_RB_B(F_RB_B),//in 1
		.F_WEN_A(F_WEN_A),//out 1
		.F_REN_A(F_REN_A),//out 1
		.F_ALE_A(F_ALE_A),//out 1
		.F_CLE_A(F_CLE_A),//out 1
		.F_RB_A(F_RB_A),//in 1
		.En_B(En_B),//out 1
		.En_A(En_A),//out 1
		.En4Mem(En4Mem),//out 512
		.Sel4Mem(Sel4Mem),//out 9
		.Sel4Out_B(Sel4Out_B),//out 2
		.Sel4Out_A(Sel4Out_A),//out 1
		.ADDR(ADDR),//out 8
		.CMD(CMD),//out 8
		.L_run(L_run),//out 1
		.L_count(L_count),//in 9
		.L_flag(L_flag),//in 1
		.S_run(S_run),//out 1
		.S_count(S_count),//in 9
		.S_flag(S_flag),//in 1
		.O_run(O_run),//out 1
		.O_flag(O_flag),//in 1	
		.L_setZ(L_setZ),
		.S_setZ(S_setZ)	
		);
endmodule