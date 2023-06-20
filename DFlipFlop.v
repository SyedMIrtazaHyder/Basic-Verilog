module DFlipFlop(D, clk, Q);
  input D, clk; //setting the data pin and clock as input
  wire S, R; //Set and Reset declared as wires as they are part of combinational design
  reg _Q;
  output reg Q; //taking Q and _Q as output
  
  //setting the Set and reset pins
  assign S = D&clk; //set pin
  assign R = (~D)&clk; //reset pin
  
  initial //setting initial values required for Q and _Q to function
  begin
    Q = 0;
    _Q = ~Q;
  end
  
  always @ (posedge clk)
  begin
    //using the (SR)' nand gate configuration
    //Q <= ~(~S&_Q); //setting q and needs previous value of the _q
    _Q = ~(~R&Q); //setting _q
    Q = ~(~S&_Q); //to prevent propagation delay, after _q is updated we try to update q again
    //otherwise it will update in the next clock cycle
  end
endmodule
