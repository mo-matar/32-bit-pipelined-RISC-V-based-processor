module mux3 (input [31:0] i0, i1, i2, input [1:0] select, output [31:0] y);
	assign y = 	select[1] ? i2 : (select[0] ? i1 : i0); 
endmodule			
