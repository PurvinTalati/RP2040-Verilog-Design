module shift_register(
    input clk,
    input reset,
    input shift_dir,
    //input config,   //0 for ISR, 1 for OSR
    input shift,     //
    input shift_amnt,//how many bits to shift? used with IN/OUT
    input load,      //can be used for PULL/PUSH
    output reg [7:0] data,          //usually 0? unless shift takes place
    output reg [7:0] data_valid
);

always @ (clk) begin
    if(reset)
        data <= 8'b0;
    else if(shift) begin
        if(shift_dir)
            data <= {1'b0, data[7:1]};      //new value can be brought from eslewhere 
        else data <= {data[6:0], 1'b0};     //instead of hardcoding to 0.
    end
end

endmodule