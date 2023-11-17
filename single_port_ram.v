module single_port_ram(input clk,input reset,input [4:0] waddr, input [4:0] raddr, input [15:0] wdata, output  [15:0] rdata, input wr, input rd);

bit [15:0] mem [0:31];

integer i;

/*always @(posedge clk or negedge reset)begin
    if(reset) begin
        for (i=0; i<32;i++) begin
            mem[i] <= 'h0;
        end
    end
    else begin
        if (wr) begin
            mem [waddr] <= wdata;
            $display("%0t: MEM_WR addr=%h wdata=%h",$time,waddr,wdata);
        end
    end
end
*/
assign rdata = (rd & !reset)? mem[raddr] : 'h0;

always_comb begin
    if(wr)
     mem[waddr] = wdata;
end

endmodule

