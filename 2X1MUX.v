module MUX(SI, PI, C, Out);
  input SI, PI, C;
  output Out;
  
  assign Out = (SI&(~C))|(PI&C);
endmodule
