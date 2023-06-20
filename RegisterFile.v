module RegFile(read1, read2,
              addr1, addr2, writeData, addr3, RegWrite, clk);
  input [4:0] addr1, addr2, addr3;
  input [31:0] writeData;
  input RegWrite, clk;
  output reg [31:0] read1, read2;
  
  reg [31:0] regFile [31:0];//32- bit register file containing 32 registers
  
  integer index;
  initial
  begin
    for (index = 0; index < 32; index = index + 1)
      regFile[index] = 0;
  end
  
  initial
  begin
    regFile[1] = 'd 15;
    regFile[2] = 'd 32;
  end
  
  /*always @ (addr1)
  begin
    read1 = regFile[addr1];
  end
  
  always @ (addr2)
  begin
    read2 = regFile[addr2];
  end*/
  
  always @ (posedge clk)
  begin
    read1 <= regFile[addr1];
    read2 <= regFile[addr2];
  end
        
  always @ (writeData)
    if (RegWrite == 1)
      regFile[addr3] = writeData;
    
endmodule