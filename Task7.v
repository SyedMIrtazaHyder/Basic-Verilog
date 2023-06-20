module JKFlipFlop(J,K,clk,Q,_Q);
  input J,K,clk;
  output Q, _Q;
  reg Q, _Q; //as acting as storage elements
  reg _J, _K;
  
  initial//to give some input readings for setting _J and _K
  begin
    Q = 1;
    _Q = 0;
  end 
    
  always @ (posedge clk) // as flip flop only triggers at positive edge of clk
   begin 
    _J = ~(J&clk&_Q);
    _K = ~(K&clk&Q);
    if (Q == 0) //as we need to toggle input 0 to 1 so we can toggle other from 1 to 0
    //(as we need to give input 1 and 1 to toggle to 0)
    begin
      Q = ~(_J&_Q);
      _Q = ~(_K&Q);
    end
    
    else
    begin
      _Q = ~(_K&Q);
      Q = ~(_J&_Q);
    end
  end
endmodule

/*module reg_combo_example( a, b, y);
input a, b;
output y;
reg   y;
wire a, b;

always @ ( a or b)
begin	
 y = a & b;
end

endmodule*/