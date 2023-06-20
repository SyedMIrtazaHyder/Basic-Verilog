module Decode(opcode, regAaddr, regBaddr, jumpAddr, writeRegAddr, func, wordAddr,
              data, clk, rst, IRWrite);
  input IRWrite, rst, clk;
  input [31:0] data;
  
  output reg [4:0] regAaddr, regBaddr, writeRegAddr;
  output reg [25:0] jumpAddr;
  output reg [5:0] func, opcode;
  output reg [15:0] wordAddr;  
  
  always @ (posedge clk, negedge rst) begin
    if (!rst) begin//flushing decode reg
      opcode = 'd 0;
      regAaddr = 'd 0;
      regBaddr = 'd 0;
      writeRegAddr = 'd 0;
      jumpAddr = 'd 0;
      func = 'd 0;
      wordAddr = 'd 0;
    end
    
    else
     if(IRWrite) begin
      opcode = data[31:26];
      regAaddr = data[25:21];
      regBaddr = data[20:16];
      writeRegAddr = data[15:11];
      jumpAddr = data[25:0];
      func = data[5:0];
      wordAddr = data[15:0];
    end
      
  end
endmodule

module DTB;
  reg IRWrite, rst, clk;
  reg [31:0] data;
  
  wire [4:0] regAaddr, regBaddr, writeRegAddr;
  wire [25:0] jumpAddr;
  wire [5:0] func, opcode;
  wire [15:0] wordAddr;  
  
  Decode dm(opcode, regAaddr, regBaddr, jumpAddr, writeRegAddr, func, wordAddr,
              data, clk, rst, IRWrite);
              
  initial
  begin
    IRWrite = 1;
    rst = 0;
    data = 'd 325;
    rst = 1;
    clk = 1;
    
    #50 clk = ~clk;
    
    #50
    data = 'd 512323;
    clk = ~clk;
  end
endmodule
