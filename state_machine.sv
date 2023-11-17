module state_machine(input clk,input reset,input sm_enable,input sm_restart,output reg [4:0] pc,input [15:0] instr_data,output reg valid,output reg rd,input flag_abnormal,input [15:0] jmp_data, input penable);

typedef enum {IDLE,DECODE,WAIT} sm;

sm current_state,next_state;
bit [4:0] delay;

reg [15:0] decode_instr_data;
reg [4:0] jmp_addr;
reg [4:0] scratchX, scratchX_update;
reg [4:0] scratchY, scratchY_update;

//decoding
reg jump_valid;
reg [2:0] condition;
assign condition = decode_instr_data[7:5];

always @(posedge clk, posedge reset) begin
  if(reset==1) begin
    current_state <= IDLE; 
    scratchX      <= 32'b0;
    scratchY      <= 32'b0;
  end else begin
    current_state <= next_state; 
    if(condition == 3'b010)
      scratchX      <= scratchX - 5'b1;
    if(condition == 3'b100)
      scratchY      <= scratchY - 5'b1;
  end 
end

always @(posedge clk)
begin
  if(penable || flag_abnormal) begin
    //scratchX_update   = scratchX;
    if(flag_abnormal & sm_enable) begin
      current_state     = DECODE;
      decode_instr_data = jmp_data;
    end
    //if(sm_restart) begin
    //end
    case(current_state) 
        IDLE:begin
            pc = 0;
            decode_instr_data =0;
            valid = 0;
            rd=0;
            if(sm_enable)
              next_state = DECODE;
        end
        
        DECODE:begin
            jump_valid = 0;
            scratchX_update = scratchX;
            scratchY_update = scratchY;
            if(!flag_abnormal)
              decode_instr_data= instr_data;
            else
              decode_instr_data = jmp_data;
           
            jmp_addr = decode_instr_data[4:0];
            
            if(sm_enable==0)
                next_state = IDLE;
            else begin
               next_state = DECODE;
                case(decode_instr_data[15:13])
                3'b000: begin                      //JMP
                    //Note write for condition
                   if(condition == 3'd0) begin                //always
                     jump_valid = 1;
                   end
                   else if(condition == 3'b001) begin    //!X    (jmp_test4, 5)
                     if(scratchX == 0) begin
                       jump_valid = 1;
                       $display("JMP condition !X: %h \t pc:%h \t scratchX: %h", decode_instr_data, pc, scratchX);
                     end
                   end 
                   else if(condition == 3'b010) begin    //X--    (jmp_test5)
                     if(scratchX != 5'b0) 
                       jump_valid      = 1;
                     else 
                       jump_valid = 0;
                     //decrement X
                     scratchX = scratchX_update - 5'b1;
                     $display("JMP condition X--: %h \t pc:%h \t scratchX: %h", decode_instr_data, pc, scratchX);
                   end
                   else if(condition == 3'b011) begin    //!Y    (jmp_test6?)
                     if(scratchY == 0) begin
                       jump_valid = 1;
                       $display("JMP condition !Y: %h \t pc:%h \t scratchY: %h", decode_instr_data, pc, scratchY);
                     end
                   end 
                   else if(condition == 3'b100) begin    //Y--     (jmp_test7)
                      if(scratchY != 5'b0) 
                       jump_valid      = 1;
                     else 
                       jump_valid = 0;
                     //decrement Y
                     scratchY = scratchY_update - 5'b1;
                     $display("JMP condition Y--: %h \t pc:%h \t scratchY: %h", decode_instr_data, pc, scratchY_update);  
                   end    
                   else if (condition == 3'b101) begin
                     if(scratchX != scratchY)
                       jump_valid = 1;
                   end      
                   else if(condition == 3'b110) begin
                     if(top.p0.p0.gpio_pins[top.p0.p0.r1.sm0_execctrl[28:24]] == 1'b1) 
                       jump_valid = 1;
                     else jump_valid = 0;
                     $display("JMP condition (pin): %h \t pc:%h \t jmp_pin: #%h, %h", decode_instr_data, pc, top.p0.p0.r1.sm0_execctrl[28:24], top.p0.p0.gpio_pins[top.p0.p0.r1.sm0_execctrl[28:24]]);  
                   end 
                   else jump_valid = 0;                //other conditions to be coded
                    
                    if(jump_valid) begin
                     pc = jmp_addr;
                     valid = 1;
                     delay = decode_instr_data [12:8];
                    end else begin
                     pc = pc + 'h1;
                    end
                    rd = 1;
                    if(delay!=0) begin
                      next_state = WAIT;
                      delay = delay - 1;
                    end
                    $display("inside JMP %h %h",decode_instr_data,pc);
                end
               // 3'b110: next_state = IRQ;
               // 3'b111: next_state = SET;
               endcase
            end
        end
        
        WAIT:begin
            if(sm_enable==0)
                next_state = IDLE;
            else begin
                if(delay==0)
                   next_state = DECODE;
                else
                   delay = delay - 1;
            end
        end
    endcase
  end
end
endmodule
