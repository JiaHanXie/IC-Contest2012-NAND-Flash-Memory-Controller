module FSM(
		input					rst,//in 1
		input					clk,//in 1
		output	wire			done,//out 1
		output	wire			F_WEN_B,//out 1
		output	wire			F_REN_B,//out 1
		output	wire			F_ALE_B,//out 1
		output	wire			F_CLE_B,//out 1
		input					F_RB_B,//in 1
		output	reg				F_WEN_A,//out 1
		output	wire			F_REN_A,//out 1
		output	wire			F_ALE_A,//out 1
		output	wire			F_CLE_A,//out 1
		input					F_RB_A,//in 1
		output	wire			En_B,//out 1
		output	wire			En_A,//out 1
		output	reg		[511:0]	En4Mem,//out 512
		output	reg		[8:0]	Sel4Mem,//out 9
		output	reg		[1:0]	Sel4Out_B,//out 2
		output	reg				Sel4Out_A,//out 1
		output	reg		[7:0]	ADDR,//out 8
		output	reg		[7:0]	CMD,//out 8
		output	wire			L_run,//out 1
		input			[8:0]	L_count,//in 9
		input					L_flag,//in 1
		output	wire			S_run,//out 1
		input			[8:0]	S_count,//in 9
		input					S_flag,//in 1
		output	wire 			O_run,//out 1
		input					O_flag,//in 1
		output	wire			L_setZ,//out1
		output	wire			S_setZ
		);
//////////////// define ///////////////////////
	`define	RST_STATE				5'd0
	`define	CMD_READ_STATE			5'd1
	`define	ADDR_READ_1_STATE		5'd2
	`define ADDR_READ_2_STATE		5'd3
	`define	ADDR_READ_3_STATE		5'd4
	`define	WAIT4A_Response			5'd15
	`define READ_1_STATE			5'd5
	`define CMD_WRITE_1_STATE		5'd6
	`define ADDR_WRITE_1_STATE		5'd8
	`define	ADDR_WRITE_2_STATE		5'd9
	`define ADDR_WRITE_3_STATE		5'd10
	`define WRITE_1_STATE 			5'd11
	`define	CMD_WRITE_FINISH_STATE	5'd12
	`define	WAIT4B_Response			5'd16
	`define	READY_SATTE				5'd13
	`define	FINISH_STATE 			5'd14
	`define	Lcountplus1				5'd17
//////////////// var //////////////////////////
	reg	[4:0]	next_state;
	reg	[4:0]	state;
//////////////// state ////////////////////////
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			state<=5'd0;
		end else begin
			state<=next_state;
		end
	end

	always@(*)begin
		case(state)
			`RST_STATE:				next_state=`CMD_READ_STATE;
			`CMD_READ_STATE:		next_state=(O_flag)?`ADDR_READ_1_STATE:state;
			`ADDR_READ_1_STATE:		next_state=(O_flag)?`ADDR_READ_2_STATE:state;
			`ADDR_READ_2_STATE:		next_state=(O_flag)?`ADDR_READ_3_STATE:state;
			`ADDR_READ_3_STATE:		next_state=(O_flag)?`WAIT4A_Response:state;
			`WAIT4A_Response:		next_state=(F_RB_A)?`READ_1_STATE:state;
			`READ_1_STATE:			next_state=(S_flag && O_flag)?`CMD_WRITE_1_STATE:state;
			`CMD_WRITE_1_STATE:		next_state=(O_flag)?`ADDR_WRITE_1_STATE:state;
			`ADDR_WRITE_1_STATE:	next_state=(O_flag)?`ADDR_WRITE_2_STATE:state;
			`ADDR_WRITE_2_STATE:	next_state=(O_flag)?`ADDR_WRITE_3_STATE:state;
			`ADDR_WRITE_3_STATE:	next_state=(O_flag)?`WRITE_1_STATE:state;
			`WRITE_1_STATE:			next_state=(S_flag && O_flag)?`CMD_WRITE_FINISH_STATE:state;
			`CMD_WRITE_FINISH_STATE:next_state=(O_flag)?`WAIT4B_Response:state;
			`WAIT4B_Response:		next_state=(F_RB_B)?`READY_SATTE:state;
			`READY_SATTE:			next_state=(L_flag)?`FINISH_STATE:`Lcountplus1;
			`FINISH_STATE:			next_state=state;
			`Lcountplus1:			next_state=`RST_STATE;
			default:next_state=state;
		endcase
	end
//done,//out 1
	assign	done=(state==`FINISH_STATE);
//Write posedge Read negedge
//F_WEN_B,//out 1
	assign	F_WEN_B=((state==`CMD_WRITE_1_STATE)||(state==`ADDR_WRITE_1_STATE)||
	(state==`ADDR_WRITE_2_STATE)||(state==`ADDR_WRITE_3_STATE)||(state==`WRITE_1_STATE)||
	(state==`CMD_WRITE_FINISH_STATE))&&(O_flag);
//F_REN_B,//out 1
	assign F_REN_B=1'b1;
//F_ALE_B,//out 1
	assign	F_ALE_B=((state==`ADDR_WRITE_1_STATE)||
	(state==`ADDR_WRITE_2_STATE)||(state==`ADDR_WRITE_3_STATE));
//F_CLE_B,//out 1
	assign	F_CLE_B=((state==`CMD_WRITE_1_STATE)||
	(state==`CMD_WRITE_FINISH_STATE));
//F_WEN_A,//out 1
	always@(*)begin
		if((state==`CMD_READ_STATE)||
	(state==`ADDR_READ_1_STATE)||(state==`ADDR_READ_2_STATE)||
	(state==`ADDR_READ_3_STATE))begin
		if(O_flag)begin
			F_WEN_A=1'b1;
		end else begin
			F_WEN_A=1'b0;
		end
	end else begin
		F_WEN_A=1'b1;
	end
	end
//F_REN_A,//out 1
	assign	F_REN_A=~((state==`READ_1_STATE)&&(O_flag));
//F_ALE_A,//out 1
	assign	F_ALE_A=((state==`ADDR_READ_1_STATE)||(state==`ADDR_READ_2_STATE)||
	(state==`ADDR_READ_3_STATE));
//F_CLE_A,//out 1
	assign	F_CLE_A=(state==`CMD_READ_STATE);
//En_B,//out 1  1:out 0:in
	assign	En_B=1'b1;
//En_A,//out 1
	assign	En_A=~(state==`READ_1_STATE);
//En4Mem,//out 512
	always@(*)begin
		if(state==`READ_1_STATE)begin
			En4Mem=512'd0;
			En4Mem[S_count]=1'd1;
		end else begin
			En4Mem=512'd0;
		end
	end
//Sel4Mem,//out 9
	always@(*)begin
		if(state==`WRITE_1_STATE)begin
			Sel4Mem=S_count;
		end else begin
			Sel4Mem=9'dx;
		end
	end	
//Sel4Out_B,//out 2 0:data; 1:cmd; 2:addr;
	always@(*) begin
		case(state)
			`CMD_WRITE_1_STATE,`CMD_WRITE_FINISH_STATE:begin
				Sel4Out_B=2'd1;
			end
			`ADDR_WRITE_1_STATE,`ADDR_WRITE_2_STATE,`ADDR_WRITE_3_STATE:begin
				Sel4Out_B=2'd2;
			end
			`WRITE_1_STATE:begin
				Sel4Out_B=2'd0;
			end
			default:Sel4Out_B=2'dx;
		endcase	
	end		
//Sel4Out_A,//out 1 0:cmd; 1:addr;
	always@(*)begin
		case(state)
			`CMD_READ_STATE:begin
				Sel4Out_A=1'd0;
			end
			`ADDR_READ_1_STATE,`ADDR_READ_2_STATE,`ADDR_READ_3_STATE:begin
				Sel4Out_A=1'd1;
			end
			default:Sel4Out_A=1'dx;
		endcase
	end
//ADDR,//out 8
	always@(*)begin
		case(state)
			`ADDR_READ_1_STATE,`ADDR_WRITE_1_STATE:begin
				ADDR=8'd0;
			end
			`ADDR_READ_2_STATE,`ADDR_WRITE_2_STATE:begin
				ADDR=L_count[7:0];
			end
			`ADDR_READ_3_STATE,`ADDR_WRITE_3_STATE:begin
				ADDR={7'd0,L_count[8]};
			end
			default:begin
				ADDR=8'dx;
			end
		endcase
	end
//CMD,//out 8
	always@(*)begin
		case(state)
			`CMD_READ_STATE:begin
				CMD=8'h00;
			end
			`CMD_WRITE_1_STATE:begin
				CMD=8'h80;
			end
			`CMD_WRITE_FINISH_STATE:begin
				CMD=8'h10;
			end
			default:begin
				CMD=8'hx;
			end
		endcase
	end
//L_run,//out 1
	assign L_run=(state==`Lcountplus1);
//S_run,//out 1
	assign S_run=(((state==`READ_1_STATE)||(state==`WRITE_1_STATE))&&(O_flag));
//O_run
	assign O_run=~((state==`RST_STATE)||(state==`READY_SATTE)||(state==`FINISH_STATE));
//L_setZ
	assign L_setZ=1'b0;
//S_setZ
	assign S_setZ=~((state==`READ_1_STATE)||(state==`WRITE_1_STATE));
endmodule