/*
description: the intermediate registers/latches for holding pipelined data.
1. flopr (flip flop with reset):                     used for the control_reg_M, control_reg_W, reg_M, reg_W
2. floprc (flip flop with reset and clear):          used for control_reg_E, reg_E
3. flopenr (flip flop with enable and reset):        used for pcreg
4. flopenrc (flip flop with enable reset and clear): used for regD


*/
module flopr #(parameter WIDTH = 8) 
              (input  logic clk, reset, 
               input  logic [WIDTH-1:0] d,  
               output logic [WIDTH-1:0] q); 
 
  always_ff @(posedge clk, posedge reset) 
    if (reset) q <= 0; 
    else       q <= d; 
endmodule 
 
module flopenr #(parameter WIDTH = 8) 
                (input  logic clk, reset, en, 
                 input  logic [WIDTH-1:0] d,  
                 output logic [WIDTH-1:0] q); 
 
  always_ff @(posedge clk, posedge reset) 
    if (reset)   q <= 0; 
    else if (en) q <= d; 
endmodule 
 
module flopenrc #(parameter WIDTH = 8) 
                (input  logic clk, reset, clear, en, 
                 input  logic [WIDTH-1:0] d,  
                 output logic [WIDTH-1:0] q); 
 
  always_ff @(posedge clk, posedge reset) 
    if (reset)   q <= 0; 
    else if (en)  
      if (clear) q <= 0; 
      else       q <= d; 
 endmodule 

module floprc #(parameter WIDTH = 8) 
                (input  logic clk, 
                input  logic reset, 
                input  logic clear, 
                input  logic [WIDTH-1:0] d,  
                output logic [WIDTH-1:0] q); 
always_ff @(posedge clk, posedge reset) 
if (reset) q <= 0; 
else        
if (clear) q <= 0; 
else       q <= d; 
endmodule      