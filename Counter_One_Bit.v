module Counter_One_Bit(
		input				rst,
		input				clk,
		input				run,
		output	reg			count,
		output	wire		flag
		);
//////////////// var /////////////
	parameter	count_max=1'd1;
	reg			next_count;
	assign flag=(count==count_max);

	always@(posedge clk or posedge rst) begin
		if (rst) begin
			count<=1'd0;			
		end else if(run)begin
			count<=next_count;
		end
	end

	always@(*)begin
		if(count==count_max)begin
			next_count=1'd0;
		end else begin
			next_count=count+1'd1;
		end
	end
endmodule