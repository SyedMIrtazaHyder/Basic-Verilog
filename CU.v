module CU(RegDst, Branch, Jump, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite,
          Opcode);
  input [5:0] Opcode;
  output reg RegDst, Branch, Jump, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
  output reg [1:0] ALUOp;
  
  always @ (Opcode)
  begin
    case (Opcode)
      'd 0: //R Type
      begin
        RegDst = 1;
        ALUSrc = 0;
        MemToReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        Jump = 0;
        ALUOp = 2'b 10;
      end
      
      'd 2: //I type Instructions
      //constant 5 bits as we are no longer using RegB.
      begin
        RegDst = 1;
        ALUSrc = 1;
        MemToReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        Jump = 0;
        ALUOp = 2'b 10;
        
      end
      
      'd 4: //Load Word
      begin
        RegDst = 0;
        ALUSrc = 1;
        MemToReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        Branch = 0;
        Jump = 0;
        ALUOp = 2'b 00;
      end
      
      'd 8: //Save Word
      begin
        ALUSrc = 1;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 1;
        Branch = 0;
        Jump = 0;
        ALUOp = 2'b 00;
      end
      
      'd 16: //Branch if equal to
      begin
        ALUSrc = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 1;
        Jump = 0;
        ALUOp = 2'b 01;
      end
      
      //maybe also add branch if less than and branch if smaller than
      //need to add for I type instructions as well
      
      'd 32://Jump
      begin
        Jump = 1;
        Branch = 0;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
      end
      
      default://instruction that does nothing when OpCode is wrong
      begin
        Jump = 0;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        Branch = 0;
      end
    endcase
  end
          
endmodule

module CUTB;
  wire RegDst, Branch, Jump, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
  wire [1:0] ALUOp;
  reg [5:0] Opcode;
  CU cu(RegDst, Branch, Jump, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite,
          Opcode);
          
  initial
  begin
    Opcode = 0;//R type
    
    #50
    Opcode = 2;//I type

    #50
    Opcode = 'd 4;//Lw

    #50
    Opcode = 'd 8;//SW
    
    #50
    Opcode = 'd 16;//Branch
    
    #50
    Opcode = 'd 32;//Jump
    
    #50
    Opcode = 'd 3;//Invalid Instrc
  end
endmodule