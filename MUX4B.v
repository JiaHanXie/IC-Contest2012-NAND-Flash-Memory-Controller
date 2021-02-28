module MUX4B(
    input		[7:0]	Data,//in 8
    input		[7:0]	CMD,//in 8
    input		[7:0]	ADDR,//in 8
    input		[1:0]	Sel4Out,//in 2
    output	reg	[7:0]	Data_out//out 8
    );
	always@(*)begin
		case(Sel4Out)
			2'd0:begin
				Data_out=Data;
			end
			2'd1:begin
				Data_out=CMD;
			end
			2'd2:begin
				Data_out=ADDR;
			end
			default:begin
				Data_out=8'dx;
			end  
		endcase
	end
endmodule
