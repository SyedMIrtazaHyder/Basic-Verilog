module RightShfitRegister4bit(D, clk, Do);
  input [3:0] D;
  input clk; 
  reg [3:0] currentData;
  output reg Do;
  
  //loading data in the form of parallel in
  DFlipFlop LSB       (D[3], clk, currentData[3]);
  DFlipFlop SecondBit (D[2], clk, currentData[2]);
  DFlipFlop ThirdBit  (D[1], clk, currentData[1]);
  DFlipFlop MSB       (D[0], clk, currentData[0]);
  
  //deloading data in the form of series out
  always @ (posedge clk)
  begin
    Do <= currentData[0];
    currentData[0] <= currentData[1];
    currentData[1] <= currentData[2];
    currentData[2] <= currentData[3];
    currentData[3] <= 0;
  end
endmodule
