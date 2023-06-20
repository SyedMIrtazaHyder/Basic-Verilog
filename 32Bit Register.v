module MU(data_out, addr, data_in, rst, clk, memRead, memWrite);
  input rst, clk, memWrite, memRead;//read signal redundant
  input [31:0] addr;
  input [31: 0] data_in;
  output reg [31:0] data_out; 
  integer i;
  
  reg[31:0] mem[127:0];
  initial
  begin//setting test data in the registers for test bench
    mem[0] = 32'b 00000000001000100001000000000000;
    //000000_00001_00010_00010_00000_00000
    //R type, rs = 1 reg, rt = 2d reg, rd = 2nd reg, shamt = func = 0
    mem[4] = 32'b 00000000001000100010000000000010;
    //000000_00001_00010_00100_00000_000010
    //R type, rs = 1 reg, rt = 2d reg, rd = 4th reg, shamt = 0, func = 2
    mem[8] = 32'b 00100000000001000000000000001101;
    //001000_00000_00100_0000000000001101
    //SW, rs = 0 reg, rt = 4th reg, addr = 13
    mem[12] = 32'b 00010000000001110000000000001101;
    //000100_00000_00111_0000000000001101
    //LW, rs = 0 reg, rt = 7th reg, addr = 13
    
    mem[16] = 32'b 01000000011001000000000001010000;
    //010000_00011_00100_0000000001010000
    //Branch FAil, rs = 3rd reg, rt = 4th reg, addr = 100-16-4 = 80
    
    mem[20] = 32'b 01000000011001110000000001001100;
    //010000_00011_00111_0000000001001100
    //Branch Yes, rs = 3rd reg, rt = 7th reg, addr = 100-20-4 = 76
    
    mem[100] = 32'b 10000000000000000000000000000001;
    //100000_00000000000000000000000001
    //Jump, jump to mem address 1*4 = 4 to read from



  end
  
  always @ (posedge clk)  //synchoronous so only depends on clock
  begin
    if (rst)
      for(i = 0; i < 128; i = i + 1)
        mem[i] = 'd 0;
    if (memRead)
      data_out <= mem[addr];
    else if (memWrite)
      mem[addr] <= data_in;  
    else
      data_out <= addr;//as otherwise we want to output the ALUOut as R-type instrc     
  end
    
endmodule

module TB;
  reg clk, rst, memRead, memWrite;
  reg [31:0] addr, data_in;
  wire [31:0] data_out;
  MU DataMem(.data_out(data_out), .addr(addr), .data_in(data_in), .rst(rst), .clk(clk), .memRead(memRead), .memWrite(memRead));
  initial
  begin
    clk = 1;
    rst = 0;
    memRead = 0;
    memWrite = 0;
    addr = 'd 0;
    data_in = 'd 15;
    #100
    memRead = 1;
    #100
    memRead = 0;
    memWrite = 1;
    #100
    memRead = 1;
  end
  
  always #50 clk = ~clk;
endmodule
