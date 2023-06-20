module MEM( data,//Data can be  Instrc or Data
            addr, clk, rst, WriteData, MemRead, MemWrite);
  input clk, rst, MemRead, MemWrite;
  input [31:0] addr, WriteData;
  output reg [31:0] data;
  
  reg [31:0] memory [100:0];
  always @ (posedge clk or negedge rst)begin
    if (!rst) begin//initializing memory values
    // R type add $r1 and $r0 and store in $r3: 000100_00000_00001_00011_00000_000000
      memory[0] <= 32'b 00010000000000010001100000000000;//working OMFG
      // LW $r5, 5($r3) => saving 35+5 = 40 memory location data in $r5
      // 010000_00011_00101_0000000000000101
      memory[4] <= 32'b 01000000011001010000000000000101;
      // SW $r5, 9($r3) => saving 35+9 = 44 memory location data in $r5
      // 001000_00011_00101_0000000000001001
      memory[8] <= 32'b 00100000011001010000000000001001;
      //Branch true $r5, $r10, 5, 000010_00101_01010_0000000000000101
      memory[12] <= 32'b 00001000101010100000000000000101;
      //Jump to address 4 000001_0000000000000000000000001;
      memory[32] <= 32'b 00000100000000000000000000000001;
      memory[40] <= 'd 69;//Test data to load
      
      /*memory[4] <= 'd 2;
      memory[8] <= 'd 4;*/
    end
    
    else begin
      if (MemWrite)//writing into memory first then reading
        memory[addr] <= WriteData;
    end
  end
  
  always @ (*)//should give problem on reading same address but lez see
    if (MemRead)
      data = memory[addr];
endmodule

module MMTB;
  reg clk, rst, MemRead, MemWrite;
  reg [31:0] addr, WriteData;
  wire [31:0] data;
  
  MEM m( data, addr, clk, rst, WriteData, MemRead, MemWrite);
  
  initial
  begin
    MemRead = 0;
    MemWrite = 0;
    clk = 1;
    rst = 0;
    
    #50 clk = ~clk;
    
    //#50 clk = ~clk;
    
    #50
    rst = 1;
    MemWrite = 1;
    addr = 'd 5;
    WriteData = 'd 10;
    clk = ~clk;   
    
    #50
    clk = ~clk;
    
    #50
    addr = 1;
    MemRead = 1;
    
  end
endmodule