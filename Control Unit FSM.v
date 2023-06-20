//work.MulticycleProcessor
module CU(PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
          clk, rst, opcode);
 //reg [5:0] current_state;
 //input clk, rst;
 input clk, rst;
 input [5:0] opcode;
 output reg PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst;
 output reg [1:0] ALUSrcB, ALUOp, PCSource;
 reg [4:0] next_state, current_state;
 
 localparam FETCH   = 5'b 00001,
            DECODE  = 5'b 00010,
            EXEC    = 5'b 00100,
            READ    = 5'b 01000,
            WRITE   = 5'b 10000;
 
 //state register, good practice to have rst = 0 for rst, preferably 3 lines always
  always @ (posedge clk or negedge rst)
    if (!rst) current_state <= FETCH;
    else current_state <= next_state;
      
  //2nd always block holds all combinational logic
  always @ (current_state) begin
    case (current_state)
      FETCH:
      begin
        PCWrite = 0;
        RegWrite = 0;
        MemRead = 1;
        MemWrite = 0;
        ALUSrcA = 0;
        IorD = 0;
        IRWrite = 1;
        ALUSrcB = 2'b 01;
        ALUOp = 2'b 00;
        PCSource = 2'b 00;
        next_state = DECODE;
      end
      
      DECODE:
      begin
        MemRead = 0;
        PCWrite = 1;
        IRWrite = 0;
        ALUSrcA = 0;
        ALUSrcB = 2'b 11;
        ALUOp = 2'b 00;
        next_state = EXEC;
      end
      
      EXEC:
      begin
        PCWrite = 0;
        case (opcode)
          6'b 000001: //Jump
          begin
            PCWrite = 1;
            PCSource = 2'b 10;
            next_state = FETCH;
          end
          
          6'b 000010: //Branch
          begin
            ALUSrcA = 1;
            ALUSrcB = 2'b 00;
            ALUOp = 2'b 01;
            PCWriteCond = 1;
            PCSource = 2'b 01;
            next_state = FETCH;
          end
          
          6'b 000100: //R type
          begin
            ALUSrcA = 1;
            ALUSrcB = 2'b 00; 
            ALUOp = 2'b 10;
            next_state = WRITE;
          end
          
          default://LW && SW
          begin
            ALUSrcA = 1;
            ALUSrcB = 10;
            ALUOp = 00;
            next_state = READ;
          end
        endcase
      end
      
      READ:
      begin
        if (opcode == 6'b 001000)//SW
          begin
            IorD = 1;
            MemWrite = 1;
            next_state = FETCH;
          end
        
        else//LW
          begin
            MemRead = 1;
            IorD = 1;
            next_state = WRITE;
          end
      end
      
      WRITE:
      begin
        if (opcode == 6'b 010000)
          begin
            RegDst = 0;
            MemtoReg = 1;
          end
        else
          begin
            RegDst = 1;
            MemtoReg = 0;
          end
        RegWrite = 1;
        next_state = FETCH;
      end
      default: next_state = FETCH;
    endcase
  end
  
endmodule  
