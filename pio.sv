
`include "pio_regs.sv"
`include "single_port_ram.v"
`include "state_machine.sv"
`include "divider_ked.sv"
`include "shift_register.sv"
module pio(input clk, input reset, input sel, input RW,
                   input  [11:0] addr,
                   input  [31:0] wdata, output [31:0] rdata, output busy,
                   input  [31:0] gpio_pins,
                   output gpio_set_dir,
                   output [31:0] gpio_dir,
                   output gpio_set_value,
                   output [31:0] gpio_value,
                   output irq0,
                   output irq1);

wire [4:0] memory_waddr,pc;
wire wr,rd;
wire [15:0] memory_wdata,memory_rdata;
wire [15:0] instr_data;
wire valid;
wire flag_ab;
wire [23:0] div;
wire use_divider;
wire penable;
wire pclk;
wire [16:12] wrap_top;
wire [16:12] wrap_bottom;
//OSR
wire sm_shiftctrl = r1.sm0_shtctrl.out_shtdir;
wire [7:0] OSR_value, OSR_valid;

assign sm_enable  = r1.ctrl[0];
assign sm_restart = r1.ctrl[4];
assign r1.sm0_addr.curr_inst_addr = pc;
assign flag_ab = (r1.SM0_INSTR_SEL & RW) ? 1'b1 : 1'b0;
assign use_divider = (r1.sm0_clkdiv[31:16] <= 2) ? 1'b0 : 1'b1;
assign INT = r1.sm0_clkdiv.Int;
assign FRAC = r1.sm0_clkdiv.frac;
assign div = r1.sm0_clkdiv[31:8];
assign div = r1.sm0_clkdiv[31:8];
assign wrap_top = r1.sm0_execctrl.wrap_top
assign wrap_bottom = r1.sm0_execctrl.wrap_bottom;

shift_register OSR(.clk(clk), .reset(reset), 
                   .shift_dir(sm_shiftctrl),
                   .shift(1'b0), .shift_amnt(1'b1),
                   .data(OSR_value), .data_valid(OSR_valid));

pio_regs r1(clk,reset,sel,RW,addr,wdata,rdata,busy, memory_waddr, memory_wdata, wr);

single_port_ram s1(clk,reset,memory_waddr, pc, memory_wdata, memory_rdata,wr,rd);

state_machine sm(clk,reset,sm_enable,sm_restart,pc,memory_rdata,valid,rd,flag_ab,wdata[15:0],penable, 
                wrap_bottom, wrap_top,
                //OSR
                OSR_value, OSR_valid
                );
divider(.clk(clk), .reset(reset), .INT(INT), .FRAC(FRAC), .use_divider(use_divider), .pulse_en(penable));

always @(posedge clk)
begin
    if(RW)
        $display("%0t, addr=%h wdata=%h",$time,addr,wdata);
    else
        $display("%0t, addr=%h rdata=%h",$time,addr,rdata);
end
endmodule

