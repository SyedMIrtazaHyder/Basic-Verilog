module SCP(clk);
  input clk;
  
  reg test1, test2, test3, test4, test5;
  wire [31:0] instrc;
  reg [31:0] PC;
  MU IntrcMem(instrc, PC, 0, rst, clk, 'b 1, 'b 0);// as we only  read from instrc mem and never write
  
  wire RegDst, Branch, Jump, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
  wire [1:0] ALUOp;
  reg [5:0] Opcode;
  CU Control(RegDst, Branch, Jump, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite, Opcode);
  
  wire [31:0] regA, regB;
  reg [4:0] regAaddr, regBaddr, writeRegAddr;
  reg RegWriteIn;//repetead
  reg [31:0] ALUOutIn; 
  RegFile RF(regA, regB, regAaddr, regBaddr, ALUOutIn, writeRegAddr, RegWriteIn, test1);
  
  wire [31:0] data_out;
  reg [31:0] addr, data_in;
  reg dataRst, waitClk, MemReadIn, MemWriteIn;//MemRead and MemWrite are now regs
  MU DataMem(data_out, addr, data_in, dataRst, waitClk, MemReadIn, MemWriteIn);//need to wait its turn
  
  wire [31:0] ALUOut;
  wire zeroFlag;
  reg [1:0] ALUOpIn;//converted to reg
  reg [5:0] func;
  reg [31: 0] regAIn, regBIn;//converted from wire to reg
  ALU alu(ALUOut, zeroFlag, ALUOpIn, func, regAIn, regBIn);
  
  initial
  begin
    PC = 0;
  end
  
  always @ (posedge clk)
  begin
    waitClk <= 0;
    PC <= PC + 4;
    test1 <= 0;
    test2 <= 0;
    test3 <= 0;
    test4 <= 0;
    test5 <= 0;
  end
  
  always @(*)
  begin
    //decoding and running CU
    regAaddr = instrc[25:21];
    regBaddr = instrc[20:16];
    writeRegAddr = instrc[15:11];
    addr = instrc[15:0];//automatically extends sign
    func = instrc[5:0];
    test1 = 1;
    Opcode = instrc[31:26];
  end
 
  always @ (*)
  begin
    test2 = 1;
    //RegFile
    if (!RegDst)//Rg/Rs MUX
      writeRegAddr = regBaddr;
  end 
  
  always @ (*)
  begin
    test3 = 1;
    //ALU
    regAIn = regA;
    ALUOpIn = ALUOp;
    if (ALUSrc)//ALUSrc MUX
      regBIn = addr;
    else
      regBIn = regB;
    MemReadIn = MemRead;
    MemWriteIn = MemWrite;
  end
  
  always @ (*)
  begin
    test4 = 1;
    //DataMem
    if (MemWrite)
      data_in = regB;
    waitClk = 1;
  end
  
  always @ (*)
  begin
    test5 = 1;
    //BacktoRegFile  
    RegWriteIn = RegWrite;
    if (MemToReg)
      ALUOutIn = data_out;
    else
      ALUOutIn = ALUOut;
  end
    
  always @ (*)
  begin
    if (Branch && zeroFlag)//why not give race condition?
        PC = PC + addr;
  end

  always @ (negedge clk)
  begin
    if (Jump)
      PC[27:0] <= instrc[25:0] << 2;
  end

endmodule
