`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 11:12:38 PM
// Design Name: 
// Module Name: accel_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
import type_pkg::*;
import cfg_param::*;

module accel_wrapper#(
    parameter           IPDATA_BNNENC = 0,
    parameter           IPWGHT_BNNENC = 0,
    parameter           OP_ACTV_LAYER = 0,
    parameter           IP_DATA_WIDTH = 8,
    parameter           IP_WGHT_WIDTH = 8,
    parameter           IP_BIAS_WIDTH = 32,
    parameter           IP_NEUR_WIDTH = 8,
    parameter           OP_NEUR_WIDTH = 8,
    parameter           IP_NEUR_HIGHT = 8,
    parameter           IP_DECBIAS_EN = 1,
    parameter           OP_DATA_WIDTH = ( ((OP_ACTV_LAYER == 1) || OP_ACTV_LAYER == 2)   ? 1: 
                                        ( ((IPDATA_BNNENC == 0) && (IPWGHT_BNNENC == 0))            ? ($clog2(IP_NEUR_WIDTH)+(IP_DATA_WIDTH+IP_WGHT_WIDTH)) : ($clog2(IP_NEUR_WIDTH)+IP_DATA_WIDTH+1))  )
    
    )(
    input   clk_i, rst_n_i,
    input   data_ready_i, write_done_i, read_done_i,
    
    input   rw_en                   en_A_i          ,
            ram_addr_port           addr_A_i        ,
    input   [(IP_DATA_WIDTH-1):0]   wd_A_i          ,
    
    
    input   rw_en                   en_BK_i         ,
    input                           BK_sel_i [2]    ,
            ram_addr_port           addr_BK_i       ,
    input   [(MAX_BSWT_WIDTH-1):0]  wd_BK_i         ,
    
    output  rw_en                   en_C_o          ,
            ram_addr_port           addr_C_fsm_o    ,
    output  [OP_DATA_WIDTH-1:0]     wd_C_o          ,
    
    
    output  [1:0]   state_o,
    output                          accel_done_o, accel_ready_o
    );
    
    localparam IP_NEUR_HIGHT_CLOG = (IP_NEUR_HIGHT == 1) ? 2 : IP_NEUR_HIGHT;
    
    logic accel_rst_fsm [2];
    rw_en en_A, en_A_fsm , en_B, en_K ;
    
    ram_addr_port #(.RAM_WIDTH (IP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_A_fsm();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_WIDTH)) addr_B_fsm();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_K_fsm();
    
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_WIDTH)) addr_B_mod();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_K_mod();
    
    
    always_comb begin
        addr_B_mod.x = addr_BK_i.x[$clog2(OP_NEUR_WIDTH)-1:0];
        addr_K_mod.x = addr_BK_i.x[$clog2(OP_NEUR_WIDTH)-1:0];
        addr_B_mod.y = addr_BK_i.y[$clog2(IP_NEUR_WIDTH)-1:0];
        addr_K_mod.y = addr_BK_i.y[$clog2(IP_NEUR_HIGHT_CLOG)-1:0];
    end
    
    
    
    
    
    typedef struct {
    logic [(IP_DATA_WIDTH-1):0]  data   ;
    logic                        valid     ;
    } valid_data;
    
    logic wd_C_accel;
    valid_data rd_A ;
    valid_data wd_A ;
    
    logic [IP_BIAS_WIDTH-1:0] rd_K ;
    logic [IP_WGHT_WIDTH-1:0] rd_B ;
    
    assign wd_A.data = wd_A_i ;
  
  
    data_matrix_mem #(
        .DATA_WIDTH     ( IP_DATA_WIDTH ),
        .MATRIX_WIDTH   ( IP_NEUR_WIDTH ),
        .MATRIX_HIGHT   ( IP_NEUR_HIGHT )
        ) data (
        .clk_i          ( clk_i         ), 
        .rst_n_i        ( rst_n_i       ),
        
        .en_A_i         ( en_A_fsm      ), 
        .addr_A_i       ( addr_A_i      ),
        .wd_A_i         ( wd_A.data     ), 
        
        .en_B_i         ( en_A_fsm      ), 
        .addr_B_i       ( addr_A_fsm    ),
        .rd_B_o         ( rd_A.data     ),
        .rd_B_valid_o   ( rd_A.valid    )
        );
        
        
        
    wght_matrix_mem#(
        .DATA_WIDTH     ( IP_WGHT_WIDTH ),
        .MATRIX_WIDTH   ( OP_NEUR_WIDTH ),
        .MATRIX_HIGHT   ( IP_NEUR_WIDTH )
        )weights(
        .clk_i          ( clk_i         ), 
        .rst_n_i        ( rst_n_i       ), 
        
        .en_A_i         ( en_B          ), 
        .addr_A_i       ( addr_B_mod    ),
        .wd_A_i         ( wd_BK_i[IP_WGHT_WIDTH-1:0]),
        
        .en_B_i         ( en_B          ), 
        .addr_B_i       ( addr_B_fsm    ),
        .rd_B_o         ( rd_B          )
        );
    
        
    bias_matrix_mem#(
        .DATA_WIDTH     ( IP_BIAS_WIDTH ),
        .MATRIX_WIDTH   ( OP_NEUR_WIDTH ),
        .MATRIX_HIGHT   ( IP_NEUR_HIGHT )
        )biases(
        .clk_i          ( clk_i         ), 
        .rst_n_i        ( rst_n_i       ), 
        
        .en_A_i         ( en_K          ), 
        .addr_A_i       ( addr_K_mod    ),
        .wd_A_i         ( wd_BK_i[IP_BIAS_WIDTH-1:0]),
        
        .en_B_i         ( en_K          ), 
        .addr_B_i       ( addr_K_fsm    ),
        .rd_B_o         ( rd_K          )
        );
    
    
    
    mmul_control_logic #(
    .IP_NEUR_WIDTH  (IP_NEUR_WIDTH)  ,
    .OP_NEUR_WIDTH  (OP_NEUR_WIDTH)  ,
    .IP_NEUR_HIGHT  (IP_NEUR_HIGHT)   
    ) control_fsm (
    .clk_i          ( clk_i         ), 
    .rst_n_i        ( rst_n_i       ), 
    .data_ready_i   ( data_ready_i  ),
    .write_done_i   ( write_done_i  ), 
    .read_done_i    ( read_done_i   ),
    .en_A_o         ( en_A_fsm      ),      
    .en_B_o         ( en_B          ),  
    .en_C_o         ( en_C_o        ), 
    .en_K_o         ( en_K          ), 
    .en_A_i         ( en_A_i        ),  
    .en_BK_i        ( en_BK_i       ),
    .BK_sel_i       ( BK_sel_i      ),
    .state_o        ( state_o       ),
    .addr_A_o       ( addr_A_fsm    ),
    .addr_B_o       ( addr_B_fsm    ),
    .addr_C_o       ( addr_C_fsm_o  ),
    .addr_K_o       ( addr_K_fsm    ),
    .accel_rst_o    ( accel_rst_fsm ),
    .accel_done_o   ( accel_done_o  ),
    .accel_ready_o  ( accel_ready_o )
    );
    
    mmul#(
    .IPDATA_BNNENC (IPDATA_BNNENC),
    .IPWGHT_BNNENC (IPWGHT_BNNENC),
    .OP_ACTV_LAYER (OP_ACTV_LAYER),
    .IP_DATA_WIDTH (IP_DATA_WIDTH),
    .IP_WGHT_WIDTH (IP_WGHT_WIDTH),
    .IP_BIAS_WIDTH (IP_BIAS_WIDTH),
    .IP_NEUR_WIDTH (IP_NEUR_WIDTH),
    .OP_DATA_WIDTH (OP_DATA_WIDTH),
    .IP_DECBIAS_EN (IP_DECBIAS_EN)
    
    
    ) accel (
    .clk_i          ( clk_i         ), 
    .rst_n_i        ( rst_n_i       ),
    .sm_rst_i       ( accel_rst_fsm ),
    .clc_done_i     ( en_C_o.we     ),
    .rd_A_i         ( rd_A.data     ), 
    .rd_B_i         ( rd_B          ),
    .rd_K_i         ( rd_K          ),
    .wd_C_o         ( wd_C_o        )
    );
    
endmodule
