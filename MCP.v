module MCP(input clk, rst);
  reg [31: 0] PC, MemoryDataReg, ALUOutReg, A, B;
  
  wire IRWrite;
  wire [31:0] data;
  //reg [31:0] data;
  //NULL signals giving problem for newer signals to be synthesised
  wire [4:0] regAaddr, regBaddr, writeRegAddr;
  wire [25:0] jumpAddr;
  wire [5:0] func, opcode;
  wire [15:0] wordAddr;
  Decode d(opcode, regAaddr, regBaddr, jumpAddr, writeRegAddr, func, wordAddr,
              data, clk, rst, IRWrite);


  wire PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, ALUSrcA, RegWrite, RegDst;
  wire [1:0] ALUSrcB, ALUOp, PCSource;
  CU c(PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
  clk, rst, opcode);

  reg [31:0] addr;
  //wire [31:0] WriteData;
  reg [31:0] WD;//write data
  MEM m( data, addr, clk, rst, WD, MemRead, MemWrite);
  
  wire zeroFlag;
  wire [31:0] ALUOut;
  ALU a(ALUOut, zeroFlag, ALUOp, func, A, B);

  reg [4:0] writeAddr;
  wire [31:0] readA, readB;
  RegFile r(readA, readB, regAaddr, regBaddr, writeAddr, WD, clk, rst, RegWrite);
  
  always @ (posedge clk or negedge rst)
  begin            
    case (ALUSrcA)
      1: A <= readA;
      0: A <= PC;
    endcase
  
    case (ALUSrcB)
      2'b 00: B <= readB;
      2'b 01: B <= 'd 4;
      2'b 10: B <= wordAddr;
      2'b 11: B <= wordAddr << 2;
    endcase
 
    ALUOutReg <= ALUOut;
    MemoryDataReg <= data;      
  end
  
  always @ (*) begin
    if (IorD)
      addr = ALUOut;
    else
      addr = PC;
    end
  
  always @ (*) begin
    if (PCWrite) begin
      case (PCSource)
        2'b 00: PC = ALUOut; //PC + 4
        2'b 01:
          if (PCWrite & PCWriteCond)
            PC = ALUOutReg;
        2'b 10: PC[27:0] = jumpAddr << 2;
      endcase
    end
    
    else if (!rst)
        PC = 0;
    
    else
        PC = PC;
  end
   
  always @ (*) begin
    if (RegWrite) begin
    if (RegDst)
      writeAddr = writeRegAddr;
    else
      writeAddr = regBaddr;
        
    if (MemtoReg)
      WD = data;
    else
      WD = ALUOut;
    end
  end
endmodule

module TestMCP;
  reg clk, rst;
  MCP processor(clk, rst);
  integer i;
  initial begin
    rst = 0;
    clk = 1;
    
    #50 clk = ~clk;
    #50 clk = ~clk;
    #50 clk = ~clk;
    #50 rst = 1; clk = ~clk;   
    
    for (i = 0; i < 100; i = i+1) #50 clk = ~clk; 
  end
endmodule