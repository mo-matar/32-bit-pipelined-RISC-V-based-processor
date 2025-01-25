module mux2 (input [31:0] i0, i1, input select, output [31:0] y);
	assign	  y = select ? i1 : i0;
endmodule								 