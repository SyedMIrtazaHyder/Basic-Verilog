module Counter(clk, S);
  input clk;
  output reg [3:0] S;
  wire high, tempS0, tempS1, tempS2, tempS3;
  assign high = 1;
  
  initial
  begin
    S[0] = 0;
    S[1] = 0;
    S[2] = 0;
    S[3] = 0;
  end
  
  TFlipFlop Q0(.T(high), .clk(clk), .Q(tempS0));
  TFlipFlop Q1(.T(tempS0), .clk(clk), .Q(tempS1));
  TFlipFlop Q2(.T(tempS1&tempS0), .clk(clk), .Q(tempS2));
  TFlipFlop Q3(.T(tempS2&tempS1&tempS0), .clk(clk), .Q(tempS3));
      
  always @ (posedge clk)
  begin
    S[0] = tempS0;
    S[1] = tempS1;
    S[2] = tempS2;
    S[3] = tempS3;
  end
endmodule
