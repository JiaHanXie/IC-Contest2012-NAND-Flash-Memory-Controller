module Counter(
		input				rst,
		input				clk,
		input				setZ,
		input				run,
		output	reg	[8:0]	count,
		output	wire		flag
		);
//////////////// var /////////////
	parameter	count_max=9'd511;
	reg	[8:0]	next_count;
	
	assign flag=(count==count_max);

	always@(posedge clk or posedge rst)begin
		if(rst)begin
			count<=9'd0;
		end else if(setZ)begin
			count<=9'd0;
		end	else if(run)begin
			count<=next_count;
		end
	end

	always@(*)begin
		if(count==count_max)begin
			next_count=count;
		end else begin
			next_count=count+9'd1;
		end
	end
endmodule