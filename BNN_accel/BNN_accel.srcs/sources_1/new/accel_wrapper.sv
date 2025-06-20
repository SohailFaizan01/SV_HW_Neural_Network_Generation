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

module accel_wrapper#(
    parameter string    WEIGHTS_FILE    ,
    parameter string    BIASES_FILE     ,
    parameter           IPDATA_BNNENC = 0,
    parameter           IPWGHT_BNNENC = 0,
    parameter string    OP_ACTV_LAYER = "NONE",
    parameter           IP_DATA_WIDTH = 8,
    parameter           IP_WGHT_WIDTH = 8,
    parameter           IP_BIAS_WIDTH = 32,
    parameter           IP_NEUR_WIDTH = 8,
    parameter           OP_NEUR_WIDTH = 8,
    parameter           IP_NEUR_HIGHT = 8,
    parameter           IP_DECBIAS_EN = 1,
    parameter           OP_DATA_WIDTH = ( ((OP_ACTV_LAYER == "BNN") || OP_ACTV_LAYER == "ARGMAX")   ? 1: 
                                        ( ((IPDATA_BNNENC == 0) && (IPWGHT_BNNENC == 0))            ? ($clog2(IP_NEUR_WIDTH)+(IP_DATA_WIDTH+IP_WGHT_WIDTH)) : ($clog2(IP_NEUR_WIDTH)+IP_DATA_WIDTH+1))  )
    
    )(
    input   clk_i, rst_n_i,
    input   data_ready_i, write_done_i, read_done_i,
    input   we_A_ext_i,
    input   wght_mod_i,
    
    ram_addr_port addr_A_i ,
    ram_addr_port addr_B_i ,
    ram_addr_port addr_C_fsm_o,
    
    
    input   [(IP_DATA_WIDTH-1):0] wd_A_i,
    input   [(IP_WGHT_WIDTH-1):0] wd_B_i,
    input   [(OP_DATA_WIDTH-1):0] wd_C_i,
    input   [(IP_BIAS_WIDTH-1):0] wd_K_i,
    // output  rd_C_o,
    output  [1:0]   state_o,
    
    output  rw_en                       en_C_o,
    output  logic  [OP_DATA_WIDTH-1:0]  wd_C_o,
    output                              accel_done_o, accel_ready_o
    );
    
    
    logic accel_rst_fsm;
    rw_en en_A, en_A_fsm , en_B, en_K ;
    
    ram_addr_port #(.RAM_WIDTH (IP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_A_fsm();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_WIDTH)) addr_B_fsm();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_K_fsm();
    
    
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
        .clk_i          (clk_i          ), 
        .rst_n_i        ( rst_n_i       ),
        .en_i           ( en_A          ), 
        .addr_A_i       ( addr_A_i      ),
        .addr_B_i       ( addr_A_fsm    ),
        .wd_A_i         ( wd_A.data     ), 
        .rd_B_o         ( rd_A.data     ),
        .rd_B_valid_o   ( rd_A.valid    )
        );
        
        
        
    wght_matrix_mem#(
        .WEIGHTS_FILE   ( WEIGHTS_FILE  ),
        .DATA_WIDTH     ( IP_WGHT_WIDTH ),
        .MATRIX_WIDTH   ( OP_NEUR_WIDTH ),
        .MATRIX_HIGHT   ( IP_NEUR_WIDTH )
        )weights(
        .clk_i          ( clk_i         ), 
        .rst_n_i        ( rst_n_i       ), 
        .en_i           ( en_B          ), 
        .addr_i         ( addr_B_fsm    ),
        .wd_i           ( wd_B_i        ),
        .rd_o           ( rd_B          )
        );
    
        
    bias_matrix_mem#(
        .BIASES_FILE    ( BIASES_FILE   ),
        .DATA_WIDTH     ( IP_BIAS_WIDTH ),
        .MATRIX_WIDTH   ( OP_NEUR_WIDTH ),
        .MATRIX_HIGHT   ( IP_NEUR_HIGHT )
        )biases(
        .clk_i          ( clk_i         ), 
        .rst_n_i        ( rst_n_i       ), 
        .en_i           ( en_K          ), 
        .addr_i         ( addr_K_fsm    ),
        .wd_i           ( wd_K_i        ),
        .rd_o           ( rd_K          )
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
    .wght_mod_i     ( wght_mod_i    ),
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
    .wd_C_o         ( wd_C_accel    )
    );
    
always_comb begin
    en_A = '{re: en_A_fsm.re, we: (en_A_fsm.we && we_A_ext_i)};
    if ((state_o == 2'h0)||(state_o == 2'h1)) begin
        if (wght_mod_i) 
            wd_C_o    = wd_C_i;
        end else begin
            wd_C_o    = wd_C_accel    ;
        end
    end
endmodule
