module stuff(q, clk, rst, d);
  input clk, rst,d ;
  output reg q;
  //asynchoronous reset but if only posedge clk only then called synchronous 
  always @ (posedge clk or rst)
  begin
    if (rst)
      q <= 0;
    else
      q<=d;
  end
endmodule

module Register(data_out, clk, data);
  input clk;
  input [31:0] data;
  output reg [31:0] data_out;
  
  always @ (posedge clk)
  data_out <= data;
  
endmodule

module testbench;
  reg clk, rst, d;
  wire q;
  stuff s1(.q(q), .clk(clk), .rst(rst), .d(d));
  initial
  begin
    rst = 0;
    d = 0;
    clk = 1;//0 for posedge and 1 for negedge
    #100 
    d = 1;
    #100  //at increment from the last time stamp
    rst = 1;
    #100
    rst = 0;
  end
  
  always #50 clk = ~clk;

endmodule