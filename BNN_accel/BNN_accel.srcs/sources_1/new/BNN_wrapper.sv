`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 02:33:13 AM
// Design Name: 
// Module Name: BNN_wrapper
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
module BNN_wrapper#(
    parameter IP_DATA_WIDTH = 8,
    parameter IP_WGHT_WIDTH = 8,
    parameter IP_NEUR_WIDTH = 8,
    parameter OP_NEUR_WIDTH = 8,
    parameter IP_NEUR_HIGHT = 8
    
    
    )(
    input   clk_i, rst_n_i,
    input   data_ready_i, write_done_i, read_done_i,
    input   wght_mod_i,
    

    ram_addr_port addr_A_i,
    ram_addr_port addr_B_i,
    ram_addr_port addr_C_i,
    
    input   [(IP_DATA_WIDTH-1):0] wd_A_i,
    input   [(IP_WGHT_WIDTH-1):0] wd_B_i,
    input   wd_C_i,
    output  rd_C_o,
    output  accel_done_o, accel_ready_o
    );

    
    // logic wd_C [2];
    
    // logic accel_done [2], accel_ready [2];

    
    // rw_en en_C [2];
    // logic [1:0] state [2];
    
    // assign accel_done_o = accel_done[1];
    // assign accel_ready_o = accel_ready[0] && accel_ready[1];

    // ram_addr_port #(.RAM_WIDTH ($clog2(OP_NEUR_WIDTH)), .RAM_HIGHT ($clog2(IP_NEUR_HIGHT))) addr_C_fsm_0();
    // ram_addr_port #(.RAM_WIDTH ($clog2(7)), .RAM_HIGHT ($clog2(IP_NEUR_HIGHT))) addr_C_fsm_1();
    
    
        // accel_wrapper
// #(
    // .WEIGHTS_FILE   ( "wght.txt"    ),
    // .BNN_ENCODING   ( 0             ),
    // .IP_DATA_WIDTH  ( IP_DATA_WIDTH ),
    // .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH ),
    // .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT ),
    // .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH ),
    // .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH )
    // )layer1(
    // .clk_i          ( clk_i         ), 
    // .rst_n_i        ( rst_n_i       ),
    // .data_ready_i   ( data_ready_i  ), 
    // .write_done_i   ( write_done_i  ), 
    // .read_done_i    ( read_done_i   ),
    // .we_A_ext_i     ( 1'b1          ),
    // .wght_mod_i     ( wght_mod_i    ),
    
    // .addr_A_i       ( addr_A_i      ), 
    // .addr_B_i       ( addr_B_i      ),
    
    
    // .addr_C_fsm_o   ( addr_C_fsm_0  ),
    
    // .wd_A_i         ( wd_A_i        ), 
    // .wd_B_i         ( wd_B_i        ),
    // .wd_C_i         ( wd_C_i        ),
    // .wd_C_o         ( wd_C[0]       ),
    // .en_C_o         ( en_C[0]        ), 
    // .state_o        ( state[0][1:0] ),
    // .accel_done_o   ( accel_done[0] ), 
    // .accel_ready_o  ( accel_ready[0] )
    // );     
        
        // accel_wrapper
// #(
    // .WEIGHTS_FILE   ( "wght2.txt"    ),
    // .BNN_ENCODING   ( 1             ),
    // .IP_DATA_WIDTH  ( 1 ),
    // .IP_WGHT_WIDTH  ( 2 ),
    // .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT ),
    // .IP_NEUR_WIDTH  ( 7 ),
    // .OP_NEUR_WIDTH  ( 7 )
    // )layer2(
    // .clk_i          ( clk_i         ), 
    // .rst_n_i        ( rst_n_i       ),
    // .data_ready_i   ( state[0][1:0] == 2  ), 
    // .write_done_i   ( accel_done[0]  ), 
    // .read_done_i    ( read_done_i   ),
    // .we_A_ext_i     ( en_C[0].we    ),
    // .wght_mod_i     ( wght_mod_i    ),
    
    // .addr_A_i       ( addr_C_fsm_0  ), 
    // .addr_B_i       ( addr_B_i      ),
    
    
    // .addr_C_fsm_o   ( addr_C_fsm_1  ),
    
    // .wd_A_i         ( wd_C[0]       ), 
    // .wd_B_i         ( wd_B_i        ),
    // .wd_C_i         ( wd_C_i        ),
    // .wd_C_o         ( wd_C[1]       ),
    // .en_C_o         ( en_C[1]       ), 
    // .state_o        ( state[1]      ),
    // .accel_done_o   ( accel_done[1] ), 
    // .accel_ready_o  ( accel_ready[1])
    // );     
    
    // data_matrix_mem #(
    // .DATA_WIDTH     (1) ,

    // .MATRIX_WIDTH   ( OP_NEUR_WIDTH ),
    // .MATRIX_HIGHT   ( IP_NEUR_HIGHT )
    
    // ) op_mem (
    // .clk_i          ( clk_i         ), 
    // .rst_n_i        ( rst_n_i       ),
    // .en_i           ( en_C[1]       ),
    // .addr_A_i       ( addr_C_fsm_1  ),   
    // .addr_B_i       ( addr_C_i      ),
    // .wd_A_i         ( wd_C[1]       ), 
    // .rd_B_o         ( rd_C_o        ),
    // .rd_B_valid_o   ()
    // );
    
    
    


        
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_C_fsm();
    logic wd_C;
    rw_en en_C;
    
    accel_wrapper
#(
    .WEIGHTS_FILE   ( "wght.txt"    ),
    .IPDATA_BNNENC  ( 0             ),
    .IPWGHT_BNNENC  ( 1             ),
    .OP_ACTV_LAYER  ( "BNN"         ),
    .IP_DATA_WIDTH  ( IP_DATA_WIDTH ),
    .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH ),
    .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH ),
    .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH ),
    .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT )
    
    )layer1(
    .clk_i          ( clk_i         ), 
    .rst_n_i        ( rst_n_i       ),
    .data_ready_i   ( data_ready_i  ), 
    .write_done_i   ( write_done_i  ), 
    .read_done_i    ( read_done_i   ),
    .we_A_ext_i     ( 1'b1          ),
    .wght_mod_i     ( wght_mod_i    ),
    
    .addr_A_i       ( addr_A_i      ), 
    .addr_B_i       ( addr_B_i      ),
    
    
    .addr_C_fsm_o   ( addr_C_fsm  ),
    
    .wd_A_i         ( wd_A_i        ), 
    .wd_B_i         ( wd_B_i        ),
    .wd_C_i         ( 'h0        ),
    .wd_C_o         ( wd_C          ),
    .en_C_o         ( en_C          ), 
    .state_o        (               ),
    .accel_done_o   ( accel_done_o  ), 
    .accel_ready_o  ( accel_ready_o )
    );     
    

    
        
    data_matrix_mem #(
    .DATA_WIDTH     (1) ,

    .MATRIX_WIDTH (OP_NEUR_WIDTH),
    .MATRIX_HIGHT (IP_NEUR_HIGHT)
    
    ) op_mem (
    .clk_i          ( clk_i         ), 
    .rst_n_i        ( rst_n_i       ),
    .en_i           ( en_C          ),
    .addr_A_i       ( addr_C_fsm    ),   
    .addr_B_i       ( addr_C_i      ),
    .wd_A_i         ( wd_C          ), 
    .rd_B_o         ( rd_C_o        ),
    .rd_B_valid_o   ()
    );
    
    
    

    
    
 endmodule   