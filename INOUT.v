module INOUT(
	inout			[7:0]	F_IO_A,
    inout			[7:0]	F_IO_B,//inout 8
    input					En_A,//in 1
    input					En_B,//in 1
    output	wire	[7:0]	F_IO_A_IN,//out 8
    input			[7:0]	F_IO_A_OUT,//in 8
    input			[7:0]	F_IO_B_OUT//in 8
    );
	assign F_IO_A_IN=(En_A)?8'bz:F_IO_A;//T FRAME
	assign F_IO_A=(En_A)?F_IO_A_OUT:8'bz;//R FRAME
	assign F_IO_B=(En_B)?F_IO_B_OUT:8'bz;//R FRAME
endmodule