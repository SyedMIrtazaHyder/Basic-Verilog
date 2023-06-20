module RegFile(readA, readB,
              addrA, addrB, addrWrite, writeData, clk, rst, RegWrite);
  input clk, rst, RegWrite;
  input [4:0] addrA, addrB, addrWrite;
  input [31:0] writeData; 
  
  output reg [31:0] readA, readB;
  
  reg [31:0] register_file [31:0];//having 32 registers
  always @ (posedge clk or negedge rst)
  begin
    if (!rst)//flushing data
      begin
        register_file[0] <= 'd 15;
        register_file[1] <= 'd 20;
        register_file[2] <= 'd 4;
        register_file[3] <= 'd 3;
        register_file[4] <= 'd 45;  
        register_file[10] <= 'd 69;        
      end
      
    else begin
    if (RegWrite)
        register_file[addrWrite] <= writeData;
    else
        register_file[addrWrite] <= register_file[addrWrite];
    end
  end
  
  always @ (*)
  begin
    readA = register_file[addrA];
    readB = register_file[addrB];
  end
      
endmodule
