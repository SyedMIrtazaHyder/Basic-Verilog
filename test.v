module test;
  reg [31:0] A;
  initial
  begin
  A = 'd 1;
  #100
  A = A << 16;
  end
  
  always @ (A)
    A = A << 16;
endmodule
