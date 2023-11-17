`timescale 1ns/10ps
`define rm(x) `"/home/morris/272/uvm/baby/``x`"




`include "pio.sv"
`include `rm(piowrap.sv)


package uvmcode;
import uvm_pkg::*;
`include `rm(regs.svp)
`include `rm(sq1.svhp)
`include `rm(msgs.svh)
`include `rm(seqr1.svh)
`include `rm(drv1.svh)
`include `rm(moni.svh)
`include `rm(mon_setpins.svh)
`include `rm(chk_setpins.svh)
`include `rm(chk_setdir.svh)
`include `rm(sv_chkread.svh)
`include `rm(t1.svh)


endpackage : uvmcode;

import uvm_pkg::*;

module top();
reg clk;
piointf mp(clk);
initial begin
    clk=0;
    #5;
    repeat(30000) begin
        #5 clk=1;
        #5 clk=0;
    end
    $display("Ran out of clocks");
    $finish;
end
initial begin
//    $display("I'm alive");
    $dumpfile("rdump.vcd");
    $dumpvars(9,top);
end
initial begin : bob
    uvm_config_db #(virtual piointf)::set(null, "pio0", "intf" , mp);
    run_test("t1");
end : bob

piowrap p0(mp.piomod);

endmodule : top
//
