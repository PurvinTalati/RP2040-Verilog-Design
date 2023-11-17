typedef struct packed {
    bit [31:12] reserved;
    bit [11:8]  clkdiv_restart;
    bit [7:4]   sm_restart;
    bit [3:0]   sm_enable;
} ctrl_st;

typedef struct packed {
    bit [31:28] reserved_fstat_1;
    bit [27:24] txempty;
    bit [23:20] reserved_fstat_2;
    bit [19:16] txfull;
    bit [15:12] reserved_fstat_3;
    bit [11:8]  rxempty;
    bit [7:4]   reserved_fstat_4;
    bit [3:0]   rxfull;
} fstat_st;


typedef struct packed {
    bit [31:28] reserved_fdebug_1;
    bit [27:24] txstall;
    bit [23:20] reserved_fdebug_2;
    bit [19:16] txover;
    bit [15:12] reserved_fdebug_3;
    bit [11:8]  rxunder;
    bit [7:4]   reserved_fdebug_4;
    bit [3:0]   rxstall;
} fdebug_st; 

typedef struct packed {
    bit [31:28] rx3;
    bit [27:24] tx3;
    bit [23:20] rx2;
    bit [19:16] tx2;
    bit [15:12] rx1;
    bit [11:8]  tx1;
    bit [7:4]   rx0;
    bit [3:0]   tx0;
} flevel_st;

typedef struct packed {
    bit [31:0] fifo_wr;
} tx_fifo_st;


typedef struct packed {
    bit [31:0] fifo_rd;
} rx_fifo_st;

typedef struct packed {
    bit [31:22] reserved_dbg_cfg_1;
    bit [21:16] imem_size;
    bit [15:12] reserved_dbg_cfg_2;
    bit [11:8]  sm_cnt;
    bit [7:6]   reserved_dbg_cfg_3;
    bit [5:0]   fifo_dept;
} dbg_cfginfo_st;

typedef struct packed {
    bit [31:16] Int;
    bit [15:8]  frac;
    bit [7:0]   reserved_sm;
} sm_clkdiv_st;

typedef struct packed {
    bit exec_stalled;
    bit side_en;
    bit side_pindir;
    bit [28:24] jmp_pin;
    bit [23:19] out_en_sel;
    bit inline_out_en;
    bit out_sticky;
    bit [16:12] wrap_top;
    bit [11:7] wrap_bottom;
    bit [6:5] reserved_exec;
    bit status_sel;
    bit [3:0] status_n;
} execctrl_st;

typedef struct packed {
    bit  fjoin_rx;
    bit  fjoin_tx;
    bit [29:25] pull_thresh;
    bit [24:20] push_thresh;
    bit out_shtdir;
    bit  in_shtdir;
    bit   autopull;
    bit autopush;
    bit [15:0] reserved_shtctrl;
} shtctrl_st;

typedef struct packed {
    bit [31:5] reserved_sm_addr;
    bit [4:0] curr_inst_addr;

} sm_addr_st;

typedef struct packed {
    bit [31:16] reserved_sm_inst;
    bit [15:0]  inst;
} sm_inst_st;

typedef struct packed {
    bit [31:29] sideset_cnt;
    bit [28:26] set_cnt;
    bit [25:20] out_cnt;
    bit [19:15] in_base;
    bit [14:10] sideset_base;
    bit [9:5] set_base;
    bit [4:0] out_base;
} sm_pinctrl_st;

typedef struct packed {
    bit [31:12] reserved_intr;
    bit  sm3;
    bit sm2;
    bit sm1;
    bit sm0;
    bit sm3_txnfull;
    bit sm2_txnfull;
    bit sm1_txnfull;
    bit sm0_txnfull;
    bit sm3_rxempty;
    bit sm2_rxempty;
    bit sm1_rxempty;
    bit sm0_rxempty;
} intr_st;

typedef struct packed {
    bit [31:0] ff_2_bit_sync;
} input_sync_bypass_st;

typedef struct packed {
    bit [31:0] general_reg;
} general_32_reg_st;

typedef struct packed {
    bit [31:8] reserved__irq_f;
    bit [7:0]  irq_force;
} irq_force_st;

typedef struct packed {
    bit [31:8] general_reserved;
    bit [7:0]  general_8_bit;
} general_8_bit_reg;

module pio_regs(input clk, input reset, input sel, input RW, input [11:0] addr, input [31:0] wdata, output  [31:0] rdata, input  busy, output reg [4:0] waddr_instr, output reg [15:0] wdata_instr, output reg we);

  ctrl_st ctrl;
  fstat_st fstat;
  fdebug_st fdebug;
  flevel_st flevel;
  tx_fifo_st txf0, txf1, txf2, txf3; 
  dbg_cfginfo_st dbg_cfginfo;
  sm_clkdiv_st sm0_clkdiv, sm1_clkdiv , sm2_clkdiv , sm3_clkdiv;
  execctrl_st  sm0_execctrl, sm1_execctrl, sm2_execctrl, sm3_execctrl;
  shtctrl_st  sm0_shtctrl, sm1_shtctrl, sm2_shtctrl, sm3_shtctrl;
  sm_addr_st sm0_addr, sm1_addr, sm2_addr ,sm3_addr;
  sm_inst_st sm0_inst, sm1_inst , sm2_inst ,sm3_inst;
  sm_pinctrl_st sm0_pinctrl, sm1_pinctrl, sm2_pinctrl, sm3_pinctrl;
  intr_st intr,irq0_inte,irq1_inte,irq0_intf,irq1_intf,irq0_ints,irq1_ints;
  rx_fifo_st rxf0, rxf1, rxf2, rxf3;
  input_sync_bypass_st input_sync_bypass;
  general_32_reg_st dbg_padoe,dbg_padout;
  irq_force_st irq_force;
  general_8_bit_reg irq_reg;

  assign CTRL_SEL = sel & (addr == 12'h000);
  assign FSTAT_SEL = sel & (addr == 12'h004);
  assign FDEBUG_SEL = sel & (addr == 12'h008);
  assign FLEVEL_SEL = sel & (addr == 12'h00c);
  assign TXF0_SEL = sel & (addr == 12'h010);
  assign TXF1_SEL = sel & (addr == 12'h014);
  assign TXF2_SEL = sel & (addr == 12'h018);
  assign TXF3_SEL = sel & (addr == 12'h01c);
  assign RXF0_SEL = sel & (addr == 12'h020);
  assign RXF1_SEL = sel & (addr == 12'h024);
  assign RXF2_SEL = sel & (addr == 12'h028);
  assign RXF3_SEL = sel & (addr == 12'h02c);
  assign IRQ_SEL = sel & (addr == 12'h030);
  assign IRQ_FORCE_SEL = sel & (addr == 12'h034);
  assign INPUT_SYNC_BYPASS_SEL = sel & (addr == 12'h038);
  assign DBG_PADOUT_SEL = sel & (addr == 12'h03C);
  assign DBG_PADOE_SEL = sel & (addr == 12'h040);
  assign DBG_CFGINFO_SEL = sel & (addr == 12'h044);
  assign SM0_CLKDIV_SEL = sel & (addr == 12'h0C8);
  assign SM1_CLKDIV_SEL = sel & (addr == 12'h0E0);
  assign SM2_CLKDIV_SEL = sel & (addr == 12'h0F8);
  assign SM3_CLKDIV_SEL = sel & (addr == 12'h110);
  assign SM0_EXECCTRL_SEL = sel & (addr == 12'h0CC);
  assign SM1_EXECCTRL_SEL = sel & (addr == 12'h0E4);
  assign SM2_EXECCTRL_SEL = sel & (addr == 12'h0FC);
  assign SM3_EXECCTRL_SEL = sel & (addr == 12'h114);
  assign SM0_SHIFTCTRL_SEL = sel & (addr == 12'h0D0);
  assign SM1_SHIFTCTRL_SEL = sel & (addr == 12'h0E8);
  assign SM2_SHIFTCTRL_SEL = sel & (addr == 12'h100);
  assign SM3_SHIFTCTRL_SEL = sel & (addr == 12'h118);
  assign SM0_ADDR_SEL = sel & (addr == 12'h0D4);
  assign SM1_ADDR_SEL = sel & (addr == 12'h0EC);
  assign SM2_ADDR_SEL = sel & (addr == 12'h104);
  assign SM3_ADDR_SEL = sel & (addr == 12'h11C);
  assign SM0_INSTR_SEL = sel & (addr == 12'h0D8);
  assign SM1_INSTR_SEL = sel & (addr == 12'h0F0);
  assign SM2_INSTR_SEL = sel & (addr == 12'h108);
  assign SM3_INSTR_SEL = sel & (addr == 12'h120);
  assign INTR_SEL = sel & (addr == 12'h128);
  assign IRQ0_INTE_SEL = sel & (addr == 12'h12C);
  assign IRQ0_INTF_SEL = sel & (addr == 12'h130);
  assign IRQ0_INTS_SEL = sel & (addr == 12'h134);
  assign IRQ1_INTE_SEL = sel & (addr == 12'h138);
  assign IRQ1_INTF_SEL = sel & (addr == 12'h13C);
  assign IRQ1_INTS_SEL = sel & (addr == 12'h140);
  assign SM0_PINCTRL_SEL = sel & (addr == 12'h0DC);
  assign SM1_PINCTRL_SEL = sel & (addr == 12'h0F4);
  assign SM2_PINCTRL_SEL = sel & (addr == 12'h10C);
  assign SM3_PINCTRL_SEL = sel & (addr == 12'h124);
  
  assign rdata = (({32{CTRL_SEL}} &  ctrl)|
({32{FSTAT_SEL}} &  fstat)|
({32{FDEBUG_SEL}} &  fdebug)|
({32{FLEVEL_SEL}} &  flevel)|
({32{TXF0_SEL}} &  txf0)|
({32{TXF1_SEL}} &  txf1)|
({32{TXF2_SEL}} &  txf2)|
({32{TXF3_SEL}} &  txf3)|
({32{RXF0_SEL}} &  rxf0)|
({32{RXF1_SEL}} &  rxf1)|
({32{RXF2_SEL}} &  rxf2)|
({32{RXF3_SEL}} &  rxf3)|
({32{IRQ_SEL}} &  irq_reg)|
({32{IRQ_FORCE_SEL}} &  irq_force)|
({32{INPUT_SYNC_BYPASS_SEL}} &  input_sync_bypass)|
({32{DBG_PADOUT_SEL}} &  dbg_padout)|
({32{DBG_PADOE_SEL}} &  dbg_padoe)|
({32{DBG_CFGINFO_SEL}} &  dbg_cfginfo)|
({32{SM0_CLKDIV_SEL}} &  sm0_clkdiv)|
({32{SM1_CLKDIV_SEL}} &  sm1_clkdiv)|
({32{SM2_CLKDIV_SEL}} &  sm2_clkdiv)|
({32{SM3_CLKDIV_SEL}} &  sm3_clkdiv)|
({32{SM0_EXECCTRL_SEL}} &  sm0_execctrl)|
({32{SM1_EXECCTRL_SEL}} &  sm1_execctrl)|
({32{SM2_EXECCTRL_SEL}} &  sm2_execctrl)|
({32{SM3_EXECCTRL_SEL}} &  sm3_execctrl)|
({32{SM0_SHIFTCTRL_SEL}} &  sm0_shtctrl)|
({32{SM1_SHIFTCTRL_SEL}} &  sm1_shtctrl)|
({32{SM2_SHIFTCTRL_SEL}} &  sm2_shtctrl)|
({32{SM3_SHIFTCTRL_SEL}} &  sm3_shtctrl)|
({32{SM0_ADDR_SEL}} &  sm0_addr)|
({32{SM1_ADDR_SEL}} &  sm1_addr)|
({32{SM2_ADDR_SEL}} &  sm2_addr)|
({32{SM3_ADDR_SEL}} &  sm3_addr)|
({32{SM0_INSTR_SEL}} &  sm0_inst)|
({32{SM1_INSTR_SEL}} &  sm1_inst)|
({32{SM2_INSTR_SEL}} &  sm2_inst)|
({32{SM3_INSTR_SEL}} &  sm3_inst)|
({32{SM0_PINCTRL_SEL}} &  sm0_pinctrl)|
({32{SM1_PINCTRL_SEL}} &  sm1_pinctrl)|
({32{SM2_PINCTRL_SEL}} &  sm2_pinctrl)|
({32{SM3_PINCTRL_SEL}} &  sm3_pinctrl)|
({32{INTR_SEL}} &  intr)|
({32{IRQ0_INTE_SEL}} &  irq0_inte)|
({32{IRQ0_INTF_SEL}} &  irq0_intf)|
({32{IRQ0_INTS_SEL}} &  irq0_ints)|
({32{IRQ1_INTE_SEL}} &  irq1_inte)|
({32{IRQ1_INTF_SEL}} &  irq1_intf)|
({32{IRQ1_INTS_SEL}} &  irq1_ints));
  always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
      ctrl   <= 32'h0000_0000;
      fstat  <= 32'h0f00_0f00;
      flevel <= 32'h0000_0000; 
      fdebug <= 32'h0000_0000;
      txf0   <= 32'h0000_0000;
      txf1   <= 32'h0000_0000;
      txf2   <= 32'h0000_0000;
      txf3   <= 32'h0000_0000;
      input_sync_bypass <=  32'h0000_0000;
      dbg_cfginfo <= 32'h0020_4010;
      sm0_clkdiv <= 32'h0001_0000;
      sm1_clkdiv <= 32'h0001_0000;
      sm2_clkdiv <= 32'h0001_0000;
      sm3_clkdiv <= 32'h0001_0000;
      sm0_execctrl <= 32'h0001_f000;
      sm1_execctrl <= 32'h0001_f000;
      sm2_execctrl <= 32'h0001_f000;
      sm3_execctrl <= 32'h0001_f000;
      sm0_shtctrl  <= 32'h000c_0000;
      sm1_shtctrl  <= 32'h000c_0000;
      sm2_shtctrl  <= 32'h000c_0000;
      sm3_shtctrl  <= 32'h000c_0000;
      sm0_inst <= 32'h0000_0000;
      sm1_addr <= 32'h0000_0000;
      sm1_inst <= 32'h0000_0000;
      sm2_inst <= 32'h0000_0000;
      sm3_inst <= 32'h0000_0000;
      sm2_addr <= 32'h0000_0000;
      sm3_addr <= 32'h0000_0000;
      sm0_pinctrl <= 32'h1400_0000;
      sm1_pinctrl <= 32'h1400_0000;
      sm2_pinctrl <= 32'h1400_0000;
      sm3_pinctrl <= 32'h1400_0000;
      intr <= 32'h0000_0000;
      irq0_inte <= 32'h0000_0000;
      irq1_inte <= 32'h0000_0000;
      irq0_intf <= 32'h0000_0000;
      irq1_intf <= 32'h0000_0000;
      irq0_ints <= 32'h0000_0000;
      irq1_ints <= 32'h0000_0000;
      dbg_padoe <= 32'h0000_0000;
      dbg_padout <= 32'h0000_0000;
      irq_force <= 32'h0000_0000;
      irq_reg <= 32'h0000_0000;
      waddr_instr <= 'h0;
      wdata_instr <= 'h0;
      we <= 'h0;
      end
      else begin
          we <= 'h0;
          if(sel) begin
      case(addr)
          12'h000: begin
                    if(RW)
                      ctrl <= (wdata & 'h0000_000f);
                    ////else
                      //rdata <= ctrl; 
                   end
           
          12'h004: begin
                    if(RW)
                      fstat  <= wdata;
                    //else
                     // rdata <= fstat; 
                   end

          12'h008: begin
                    if(RW)
                      fdebug  <= wdata;
                    //else
                    //  rdata <= fdebug; 
                   end

          12'h00c: begin
                    if(RW)
                      flevel  <= wdata;
                    //else
                     // rdata <= flevel; 
                   end

          12'h010: begin
                    if(RW)
                      txf0  <= wdata;
                    //else
                     // rdata <= txf0; 
                   end

          12'h014: begin
                    if(RW)
                      txf1  <= wdata;
                    //else
                     // rdata <= txf1; 
                   end

          12'h018: begin
                    if(RW)
                      txf2  <= wdata;
                    //else
                      //rdata <= txf2; 
                   end

          12'h01c: begin
                    if(RW)
                      txf3  <= wdata;
                    //else
                      //rdata <= txf3; 
                   end

          12'h044: begin
                    if(RW)
                      dbg_cfginfo  <= wdata;
                    //else
                      //rdata <= dbg_cfginfo; 
                   end

          12'h0c8: begin
                    if(RW)
                        sm0_clkdiv<= (wdata & 'hffff_ff00);
                    //else
                      //rdata <= sm0_clkdiv; 
                   end

          12'h0e0: begin
                    if(RW)
                      sm1_clkdiv <= (wdata& 'hffff_ff00) ;
                    //else
                      //rdata <= sm1_clkdiv; 
                   end

          12'h0f8: begin
                    if(RW)
                     sm2_clkdiv <= (wdata & 'hffff_ff00);
                    //else
                      //rdata <= sm2_clkdiv; 
                   end

          12'h110: begin
                    if(RW)
                      sm3_clkdiv <= (wdata & 'hffff_ff00);
                    //else
                      //rdata <= sm3_clkdiv; 
                   end

          12'h0cc: begin
                    if(RW) begin
                      sm0_execctrl[31] <=0;
                      sm0_execctrl[30:7] <= wdata[30:7];
                      sm0_execctrl [6:5] <= 0;
                      sm0_execctrl[4:0] <= wdata[4:0];
                    end
                    //else
                      //rdata <= sm0_execctrl; 
                   end

          12'h0e4: begin
              if(RW) begin
                      sm1_execctrl[31] <=0;
                      sm1_execctrl[30:7] <= wdata[30:7];
                      sm1_execctrl [6:5] <= 0;
                      sm1_execctrl[4:0] <= wdata[4:0];
                  end
                    //else
                      //rdata <= sm1_execctrl; 
                   end

          12'h0fc: begin
              if(RW) begin
                      sm2_execctrl[31] <=0;
                      sm2_execctrl[30:7] <= wdata[30:7];
                      sm2_execctrl [6:5] <= 0;
                      sm2_execctrl[4:0] <= wdata[4:0];
                  end
                    //else
                      //rdata <= sm2_execctrl; 
                   end

          12'h114: begin
              if(RW) begin
                      sm3_execctrl[31] <=0;
                      sm3_execctrl[30:7] <= wdata[30:7];
                      sm3_execctrl[6:5] <= 0;
                      sm3_execctrl[4:0] <= wdata[4:0];
                  end
                    //else
                      //rdata <= sm3_execctrl; 
                   end

          12'h0d0: begin
                    if(RW)
                        sm0_shtctrl <= (wdata& 'hffff_0000);
                    //else
                      //rdata <= sm0_shtctrl; 
                   end

          12'h0e8: begin
                    if(RW)
                    sm1_shtctrl <= (wdata& 'hffff_0000);
                    //else
                      //rdata <= sm1_shtctrl; 
                   end

          12'h100: begin
                    if(RW)
                    sm2_shtctrl <= (wdata& 'hffff_0000);
                    //else
                      //rdata <= sm2_shtctrl; 
                   end

          12'h118: begin
                    if(RW)
                    sm3_shtctrl <= (wdata& 'hffff_0000);
                    //else
                      //rdata <= sm3_shtctrl; 
                   end

          12'h0d8: begin
                    if(RW)
                        sm0_inst <= (wdata& 'h0000_ffff);
                    //else
                      //rdata <= sm0_inst; 
                   end

          12'h0f0: begin
                    if(RW)
                      sm1_inst <=(wdata& 'h0000_ffff) ;
                    //else
                      //rdata <= sm1_inst; 
                   end

          12'h108: begin
                    if(RW)
                      sm2_inst <= (wdata& 'h0000_ffff);
                    //else
                      //rdata <= sm2_inst; 
                   end

          12'h120: begin
                    if(RW)
                      sm3_inst <=(wdata& 'h0000_ffff) ;
                    //else
                      //rdata <= sm3_inst; 
                   end

          12'h0ec: begin
                    if(RW)
                      sm1_addr <= wdata;
                    //else
                      //rdata <= sm1_addr; 
                   end

          12'h104: begin
                    if(RW)
                      sm2_addr <= wdata;
                    //else
                      //rdata <= sm2_addr; 
                   end

          12'h11c: begin
                    if(RW)
                      sm3_addr <= wdata;
                    //else
                      //rdata <= sm3_addr; 
                   end

          12'h0dc: begin
                    if(RW)
                      sm0_pinctrl <= wdata;
                    //else
                      //rdata <= sm0_pinctrl; 
                   end

          12'h0f4: begin
                    if(RW)
                      sm1_pinctrl <= wdata;
                    //else
                      //rdata <= sm1_pinctrl; 
                   end

          12'h10c: begin
                    if(RW)
                      sm2_pinctrl <= wdata;
                    //else
                      //rdata <= sm2_pinctrl; 
                   end

          12'h124: begin
                    if(RW)
                      sm3_pinctrl <= wdata;
                    //else
                      //rdata <= sm3_pinctrl; 
                   end

          12'h128: begin
                    if(RW)
                      intr <= wdata;
                    //else
                      //rdata <= intr; 
                   end

          12'h12c: begin
                    if(RW)
                        irq0_inte <= (wdata& 'h00000fff);
                    //else
                      //rdata <= irq0_inte; 
                   end

          12'h138: begin
                    if(RW)
                    irq1_inte <= (wdata& 'h00000fff);
                    //else
                      //rdata <= irq1_inte; 
                   end
          
          12'h130: begin
                    if(RW)
                    irq0_intf <= (wdata& 'h00000fff);
                    //else
                      //rdata <= irq0_intf; 
                   end
          
          12'h13c: begin
                    if(RW)
                    irq1_intf <= (wdata& 'h00000fff);
                    //else
                      //rdata <= irq1_intf; 
                   end

          12'h134: begin
                    if(RW)
                      irq0_ints <= wdata;
                    //else
                      //rdata <= irq0_ints; 
                   end

          12'h040: begin
                    if(RW)
                      dbg_padoe <= wdata;
                    //else
                      //rdata <= dbg_padoe; 
                   end

          12'h03c: begin
                    if(RW)
                      dbg_padout <= wdata;
                    //else
                      //rdata <= dbg_padout; 
                   end
   
          12'h038: begin
                    if(RW)
                      input_sync_bypass <= wdata;
                    //else
                      //rdata <= input_sync_bypass; 
                   end

          12'h034: begin
                    if(RW)
                      irq_force <= wdata;
                    //else
                      //rdata <= irq_force; 
                   end

          12'h030: begin
                    if(RW)
                      irq_reg <= wdata;
                    //else
                      //rdata <= irq_reg; 
                   end
          
          12'h140: begin
                    if(RW)
                      irq1_ints <= wdata;
                    //else
                      //rdata <= irq1_ints; 
                   end
 
          //Instruction Mem registors
          12'h048: begin
                    if(RW) begin
                       waddr_instr <= 0;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h04c: begin
                    if(RW) begin
                       waddr_instr <= 1;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h050: begin
                    if(RW) begin
                       waddr_instr <= 2;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h054: begin
                    if(RW) begin
                       waddr_instr <= 3;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h058: begin
                    if(RW) begin
                       waddr_instr <= 4;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h05c: begin
                    if(RW) begin
                       waddr_instr <= 5;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h060: begin
                    if(RW) begin
                       waddr_instr <= 6;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h064: begin
                    if(RW) begin
                       waddr_instr <= 7;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h068: begin
                    if(RW) begin
                       waddr_instr <= 8;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h06c: begin
                    if(RW) begin
                       waddr_instr <= 9;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h070: begin
                    if(RW) begin
                       waddr_instr <= 10;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h074: begin
                    if(RW) begin
                       waddr_instr <= 11;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h078: begin
                    if(RW) begin
                       waddr_instr <= 12;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h07c: begin
                    if(RW) begin
                       waddr_instr <= 13;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h080: begin
                    if(RW) begin
                       waddr_instr <= 14;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h084: begin
                    if(RW) begin
                       waddr_instr <= 15;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h088: begin
                    if(RW) begin
                       waddr_instr <= 16;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h08c: begin
                    if(RW) begin
                       waddr_instr <= 17;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h090: begin
                    if(RW) begin
                       waddr_instr <= 18;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h094: begin
                    if(RW) begin
                       waddr_instr <= 19;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h098: begin
                    if(RW) begin
                       waddr_instr <= 20;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h09c: begin
                    if(RW) begin
                       waddr_instr <= 21;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0a0: begin
                    if(RW) begin
                       waddr_instr <= 22;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0a4: begin
                    if(RW) begin
                       waddr_instr <= 23;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0a8: begin
                    if(RW) begin
                       waddr_instr <= 24;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0ac: begin
                    if(RW) begin
                       waddr_instr <= 25;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0b0: begin
                    if(RW) begin
                       waddr_instr <= 26;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end     
          12'h0b4: begin
                    if(RW) begin
                       waddr_instr <= 27;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0b8: begin
                    if(RW) begin
                       waddr_instr <= 28;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0bc: begin
                    if(RW) begin
                       waddr_instr <= 29;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0c0: begin
                    if(RW) begin
                       waddr_instr <= 30;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
          12'h0c4: begin
                    if(RW) begin
                       waddr_instr <= 31;
                       wdata_instr <= wdata;
                       we <= 1;
                    end
                   end
 
      endcase
  end
  end
  end
endmodule
