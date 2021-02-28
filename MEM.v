module MEM(
    input						rst,//in 1
    input						clk,//in 1
    input			[7:0]		Data_in,//in 8
    input			[511:0]		En4Mem,//in 512
    input			[8:0]		Sel,//in 9
    output	wire	[7:0]		Data_out//out 8
    );
//////////////// var ///////////////////////
	reg	[7:0]	mem      [0:511];
	reg [9:0]	i;
	reg [7:0]	next_mem [0:511];
//////////////// mem ///////////////////////
	always@(posedge clk or posedge rst)begin
		if(rst) 
			for(i=0;i<=10'd511;i=i+1)begin
				mem[i]<=8'd0;
			end		
		else 
			for(i=0;i<=10'd511;i=i+1)begin
				if(En4Mem[i])begin
					mem[i]<=next_mem[i];
				end
			end		
	end

	always@(*)begin
		for(i=0;i<=10'd511;i=i+1)begin
			next_mem[i]=Data_in;
		end			
	end
//////////////// sel ///////////////////////
	assign Data_out=mem[Sel];

endmodule