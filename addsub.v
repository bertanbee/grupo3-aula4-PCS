module addsub
(
	input [15:0] data1,
	input [15:0] data2,
	input add_sub,	  // se for 1, adiciona, caso contrario, subtrai
	input clk,
	output reg [15:0] resultado
);

	always @ (posedge clk)
	begin
		if (add_sub)
			resultado <= data1 + data2;
		else
			resultado <= data1 - data2;
	end

endmodule