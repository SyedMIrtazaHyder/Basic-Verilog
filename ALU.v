module ALU(ALUOut, zeroFlag, ALUOp, func, in1, in2);
  output reg zeroFlag;
  output reg [31:0] ALUOut;
  input [1:0] ALUOp;
  input [5:0] func;
  input [31:0] in1, in2;//in2 is also acts like shamt

  always @ (*)
    begin
      case (ALUOp)
        2'b 00: ALUOut = in1 + in2;
        2'b 01: ALUOut = in1 - in2;
        2'b 10: begin
          case (func)
            'd 0: ALUOut = in1 + in2;
            'd 1: ALUOut = in1 - in2;
            'd 2: ALUOut = in1 * in2;
            'd 3: ALUOut = in1 << in2;//shift left logical
            'd 4: ALUOut = in1 >> in2;
            default: ALUOut = 0;
          endcase
        end
      endcase
      
      if (ALUOut == 'd 0)
        zeroFlag = 1;
      else
        zeroFlag = 0;
    end
    
endmodule

module ALUtest;
  reg  [31:0] in1, in2;
  reg [1:0] ALUOp;
  reg [5:0] func;
  wire [31:0] ALUOut;
  wire zeroFlag;
  ALU alu(ALUOut, zeroFlag, ALUOp, func, in1, in2);
  initial
  begin
    ALUOp = 'd 0;//addition
    func = 'd 0;
    in1 = 'd 15;
    //in2 = 'd 24;
    
    #50
    in2 = 'd 24;
    ALUOp = 'd 1;//subtraction
    
    #50
    in2 = 'd 15;//zeroFlag Check
    
    #50
    ALUOp = 2'b 10;//R type addition
    
    #50;
    in2 = 'd 3;
    func = 'd 1;
    
    #50
    func = 'd 2;
    
    #50
    func = 'd 3;
    
    #50
    func = 'd 4;
  end
  
endmodule