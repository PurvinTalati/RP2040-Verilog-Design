`default_nettype none

module divider (
  input         clk,
  input         reset,
  input [15:0]  INT,
  input [7:0]   FRAC,
  input         use_divider,
  output        pulse_en
);

  reg [15:0] div_cntr, divisor_int; 
  reg [7:0] iteration, ratio, div_iteration_max;
  wire pulse;
  wire enable = use_divider && (INT >= 2);
  wire iterateUp = div_cntr == (divisor_int - 1);

  assign pulse_en = use_divider? pulse : 1;
  assign pulse = iterateUp? 1 : 0;

  //running cntr
  always@(posedge clk) begin
    if(reset) 
      div_cntr <= 16'b0;
    else if(enable) begin
      if(use_divider) begin
        if(div_cntr == divisor_int - 1)
          div_cntr <= 16'b0;
        else div_cntr <= div_cntr + 1;
      end
    end
  end

  //ratio cntr for averaging
  always@(posedge clk) begin
    if(reset) begin
      iteration  <= 8'b0;
    end else begin
      if(use_divider && iterateUp) begin
        if(iteration < div_iteration_max - 1) begin
          iteration <= iteration + 1;
        end else begin 
          iteration <= 8'b0;
        end
      end
    end
  end

  /*
  //pulse 
  always@(*) begin
    pulse = (div_cntr == divisor_int);
  end 
  */

  //div_iteration_max, divisor_int, ratio
  always@(*) divisor_int = (iteration < ratio)? INT + 1: INT;

  always@(*) begin
    case(FRAC) 
      8'bxxxxxxx1: begin 
        div_iteration_max = 255;
        ratio             = FRAC;
      end
      8'bxxxxxx10: begin 
        div_iteration_max = 127;
        ratio             = {1'b0, FRAC[7:1]};
      end
      8'bxxxxx100: begin 
        div_iteration_max = 63;
        ratio             = {2'b0, FRAC[7:2]};
      end
      8'bxxxx1000: begin 
        div_iteration_max = 31;
        ratio             = {3'b0, FRAC[7:3]};
      end
      8'bxxx10000: begin 
        div_iteration_max = 15;
        ratio             = {4'b0, FRAC[7:4]};
      end
      8'bxx100000: begin 
        div_iteration_max = 7;
        ratio             = {5'b0, FRAC[7:5]};
      end
      8'bx1000000: begin 
        div_iteration_max = 3;
        ratio             = {6'b0, FRAC[7:6]};
      end
      8'b10000000: begin 
        div_iteration_max = 1;
        ratio             = {7'b0, FRAC[7]};
      end
      default: begin 
        div_iteration_max = 0;
        ratio             = 0;
      end
    endcase
  end


endmodule
