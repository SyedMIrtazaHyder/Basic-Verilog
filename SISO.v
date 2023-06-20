module SISOIrtaza(D, clk, O);
  input clk, D;
  output reg O;
  reg Q1,Q2,Q3,Q4;
  
  initial
  begin
    Q1 = 0;
    Q2 = 0;
    Q3 = 0;
    Q4 = 0;
  end
  
  always @ (posedge clk)
  begin
    Q1 <= D;
    Q2 <= Q1;
    Q3 <= Q2;
    Q4 <= Q3; 
    O <= Q4;   
  end
endmodule
