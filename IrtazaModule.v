module Q1(Select, CP, clr, SI, PI, Out);
  input Select, CP, clr, SI;
  input [3:0] PI;
  output reg [3:0] Out;
  
  initial
  begin
    Out[0] = 0;
    Out[1] = 0;
    Out[3] = 0;
    Out[2] = 0;
  end 
  
  always @ (negedge CP)
  begin
    Out[3] = (~clr)&((Select&PI[3])|(~Select&Out[2]));
    Out[2] = (~clr)&((Select&PI[2])|(~Select&Out[1]));
    Out[1] = (~clr)&((Select&PI[1])|(~Select&Out[0]));
    Out[0] = (~clr)&((Select&PI[0])|(~Select&SI));
  end  
endmodule

module testbench;
  reg Sel, clk, clr, si;
  reg [3:0] pi;
  wire [3:0] Out;
  
  Q1 run(.Select(Sel), .CP(clk), .clr(clr), .SI(si), .PI(pi), .Out(Out));
  initial
  begin
    Sel = 0;
    clk = 1;
    clr = 0;
    si = 1;
    pi = 4'b1111;
    
    #500
    Sel = 1;
    
  end
  
  always #50 clk = ~clk;
  
  always #100
  begin
    si = ~si;
  end
   
endmodule



