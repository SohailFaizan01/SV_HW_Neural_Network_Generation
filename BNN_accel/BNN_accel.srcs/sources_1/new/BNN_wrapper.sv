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
import cfg_param::*;
module BNN_wrapper
// #(
    // parameter IP_DATA_WIDTH = 8,
    // parameter IP_WGHT_WIDTH = 8,
    // parameter IP_NEUR_WIDTH = 8,
    // parameter OP_NEUR_WIDTH = 8,
    // parameter IP_NEUR_HIGHT = 8
    
    
    // )
    (
    input   clk_i, rst_n_i,
    input   data_ready_i, write_done_i, read_done_i, we_A_ext_i,
    input   wght_mod_i,
   
    ram_addr_port addr_A_i,
    ram_addr_port addr_B_i,
    ram_addr_port addr_C_i,
    
    input   [(IP_DATA_WIDTH[0]-1):0] wd_A_i,
    input   [(IP_WGHT_WIDTH[0]-1):0] wd_B_i,    
    // input   [(IP_DATA_WIDTH-1):0] wd_A_i,
    // input   [(IP_WGHT_WIDTH-1):0] wd_B_i,
    input   wd_C_i,
    output  rd_C_o,
    output  accel_done_o, accel_ready_o
    );

    // struct {
    // parameter NUMBER_OF_LAYERS = 3 ;
    // parameter WEIGHTS_FILE  [0:NUMBER_OF_LAYERS-1] = '{"fc1_folded_weight_2bit.txt", "fc2_folded_weight_2bit.txt", "fc3_weight_2bit.txt"}   ;
    // parameter IPDATA_BNNENC [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;
    // parameter IPWGHT_BNNENC [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;
    // parameter OP_ACTV_LAYER [0:NUMBER_OF_LAYERS-1] = '{"BNN", "BNN", "ARGMAX"}   ;
    // parameter IP_DATA_WIDTH [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;
    // parameter IP_WGHT_WIDTH [0:NUMBER_OF_LAYERS-1] = '{2, 2, 2}   ;
    // parameter IP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{784, 512, 256}   ;
    // parameter OP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{512, 256, 10}   ;
    // parameter IP_NEUR_HIGHT [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;
    // } cfg_prm;
    
        
//____________________________________________________________________________________________________________________________
//###################### Automatic Generation Code - Xilinx Error Might work in Genus #########################################
//____________________________________________________________________________________________________________________________
    
    
 // genvar neur;
    
// generate
// for (neur = 0; neur < NUMBER_OF_LAYERS; neur++) begin : neuron_signals
    
    

    // logic data_ready, write_done, read_done, we_A_ext ;
    
    // ram_addr_port #(.RAM_WIDTH (IP_NEUR_WIDTH[neur]), .RAM_HIGHT (IP_NEUR_HIGHT[neur])) addr_A();
    // ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH[neur]), .RAM_HIGHT (IP_NEUR_WIDTH[neur])) addr_B();
    // ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH[neur]), .RAM_HIGHT (IP_NEUR_HIGHT[neur])) addr_C_fsm();

    // logic wd_A;
    // logic wd_B;
    // logic wd_C;
    
    // logic wd_C_out;
    // rw_en en_C ;
    // logic [1:0] state ;
    // logic accel_done , accel_ready;
    
// end    
// endgenerate

// generate
// for (neur = 0; neur < NUMBER_OF_LAYERS; neur++) begin : neuron_layer    
    // if (neur == 0) begin
        // accel_wrapper
        // #(
            // .WEIGHTS_FILE   ( WEIGHTS_FILE [neur]),
            // .IPDATA_BNNENC  ( IPDATA_BNNENC[neur] ),
            // .IPWGHT_BNNENC  ( IPWGHT_BNNENC[neur] ),
            // .OP_ACTV_LAYER  ( OP_ACTV_LAYER[neur] ),
            // .IP_DATA_WIDTH  ( IP_DATA_WIDTH[neur] ),
            // .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH[neur] ),
            // .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH[neur] ),
            // .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH[neur] ),
            // .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT[neur] )
        // )neuron(
            // .clk_i          ( clk_i          ), 
            // .rst_n_i        ( rst_n_i        ),
            // .data_ready_i   ( data_ready_i   ), 
            // .write_done_i   ( write_done_i   ), 
            // .read_done_i    ( read_done_i    ),
            // .we_A_ext_i     ( we_A_ext_i     ),
            // .wght_mod_i     ( wght_mod_i     ),
                            
            // .addr_A_i       ( addr_A_i       ), 
            // .addr_B_i       ( addr_B_i       ),
                            
                            
            // .addr_C_fsm_o   ( neuron_signals[neur].addr_C_fsm   ),
                            
            // .wd_A_i         ( wd_A_i         ), 
            // .wd_B_i         ( wd_B_i         ),
            // .wd_C_i         ( wd_C_i         ),
            // .wd_C_o         ( neuron_signals[neur].wd_C_out       ),
            // .en_C_o         ( neuron_signals[neur].en_C           ), 
            // .state_o        ( neuron_signals[neur].state          ),
            // .accel_done_o   ( neuron_signals[neur].accel_done     ), 
            // .accel_ready_o  ( neuron_signals[neur].accel_ready    )
        // );   
    // end
    // else begin
        // accel_wrapper
        // #(
            // .WEIGHTS_FILE   ( WEIGHTS_FILE [neur]),
            // .IPDATA_BNNENC  ( IPDATA_BNNENC[neur] ),
            // .IPWGHT_BNNENC  ( IPWGHT_BNNENC[neur] ),
            // .OP_ACTV_LAYER  ( OP_ACTV_LAYER[neur] ),
            // .IP_DATA_WIDTH  ( IP_DATA_WIDTH[neur] ),
            // .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH[neur] ),
            // .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH[neur] ),
            // .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH[neur] ),
            // .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT[neur] )
        // )neuron(
            // .clk_i          ( clk_i          ), 
            // .rst_n_i        ( rst_n_i        ),
            // .data_ready_i   ( neuron_signals[neur].state[1:0] == 2  ), 
            // .write_done_i   ( neuron_signals[neur].accel_done   ), 
            // .read_done_i    ( read_done_i    ),
            // .we_A_ext_i     ( neuron_signals[neur-1].en_C.we     ),
            // .wght_mod_i     ( wght_mod_i     ),
                            
            // .addr_A_i       ( neuron_signals[neur-1].addr_C_fsm   ), 
            // .addr_B_i       ( neuron_signals[neur].addr_B ),
                            
                            
            // .addr_C_fsm_o   ( neuron_signals[neur].addr_C_fsm   ),
                            
            // .wd_A_i         ( neuron_signals[neur-1].wd_C_out ), 
            // .wd_B_i         ( neuron_signals[neur].wd_B         ),
            // .wd_C_i         ( neuron_signals[neur].wd_C         ),
            // .wd_C_o         ( neuron_signals[neur].wd_C_out       ),
            // .en_C_o         ( neuron_signals[neur].en_C           ), 
            // .state_o        ( neuron_signals[neur].state          ),
            // .accel_done_o   ( neuron_signals[neur].accel_done     ), 
            // .accel_ready_o  ( neuron_signals[neur].accel_ready    )
        // );   
    
    
    
    // end
// end    
// endgenerate
    
// data_matrix_mem #(
    // .DATA_WIDTH     (IP_DATA_WIDTH[NUMBER_OF_LAYERS-1]) ,

    // .MATRIX_WIDTH   ( OP_NEUR_WIDTH[NUMBER_OF_LAYERS-1] ),
    // .MATRIX_HIGHT   ( IP_NEUR_HIGHT[NUMBER_OF_LAYERS-1] )
    
    // ) op_mem (
    // .clk_i          ( clk_i     ), 
    // .rst_n_i        ( rst_n_i   ),
    // .en_i           ( neuron_signals[NUMBER_OF_LAYERS-1].en_C         ),
    // .addr_A_i       ( neuron_signals[NUMBER_OF_LAYERS-1].addr_C_fsm   ),   
    // .addr_B_i       ( addr_C_i   ),
    // .wd_A_i         ( neuron_signals[NUMBER_OF_LAYERS-1].wd_C_out     ), 
    // .rd_B_o         ( rd_C_o                                        ),
    // .rd_B_valid_o   ()
    // );
//____________________________________________________________________________________________________________________________
    
     genvar neur;
    
generate
for (neur = 0; neur < NUMBER_OF_LAYERS; neur++) begin : neuron_signals
    
    


    

    logic wd_A;
    logic wd_B;
    logic wd_C;
    
    logic wd_C_out;
    rw_en en_C ;
    logic [1:0] state ;
    logic accel_done , accel_ready;
    
end    
endgenerate

    // ram_addr_port #(.RAM_WIDTH (IP_NEUR_WIDTH[neur]), .RAM_HIGHT (IP_NEUR_HIGHT[neur])) addr_A();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH[0]), .RAM_HIGHT (IP_NEUR_WIDTH[0])) addr_B_1();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH[1]), .RAM_HIGHT (IP_NEUR_WIDTH[1])) addr_B_2();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH[0]), .RAM_HIGHT (IP_NEUR_HIGHT[0])) addr_C_fsm_0();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH[1]), .RAM_HIGHT (IP_NEUR_HIGHT[1])) addr_C_fsm_1();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH[2]), .RAM_HIGHT (IP_NEUR_HIGHT[2])) addr_C_fsm_2();

    assign addr_B_1.x = 'h0;
    assign addr_B_1.y = 'h0;
    assign addr_B_2.x = 'h0;
    assign addr_B_2.y = 'h0;


        accel_wrapper
        #(
            .WEIGHTS_FILE   ( WEIGHTS_FILE [0]),
            .BIASES_FILE    ( BIASES_FILE [0]),
            .IPDATA_BNNENC  ( IPDATA_BNNENC[0] ),
            .IPWGHT_BNNENC  ( IPWGHT_BNNENC[0] ),
            .OP_ACTV_LAYER  ( OP_ACTV_LAYER[0] ),
            .IP_DATA_WIDTH  ( IP_DATA_WIDTH[0] ),
            .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH[0] ),
            .IP_BIAS_WIDTH  ( IP_BIAS_WIDTH[0] ),
            .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH[0] ),
            .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH[0] ),
            .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT[0] ),
            .IP_DECBIAS_EN  ( IP_DECBIAS_EN[0] )
        )layer_0(
            .clk_i          ( clk_i          ), 
            .rst_n_i        ( rst_n_i        ),
            .data_ready_i   ( data_ready_i   ), 
            .write_done_i   ( write_done_i   ), 
            .read_done_i    ( read_done_i    ),
            .we_A_ext_i     ( we_A_ext_i     ),
            .wght_mod_i     ( wght_mod_i     ),
                            
            .addr_A_i       ( addr_A_i       ), 
            .addr_B_i       ( addr_B_i       ),
                            
                            
            .addr_C_fsm_o   ( addr_C_fsm_0   ),
                            
            .wd_A_i         ( wd_A_i         ), 
            .wd_B_i         ( wd_B_i         ),
            .wd_C_i         ( wd_C_i         ),
            .wd_C_o         ( neuron_signals[0].wd_C_out       ),
            .en_C_o         ( neuron_signals[0].en_C           ), 
            .state_o        ( neuron_signals[0].state          ),
            .accel_done_o   ( neuron_signals[0].accel_done     ), 
            .accel_ready_o  ( neuron_signals[0].accel_ready    )
        );   


        accel_wrapper
        #(
            .WEIGHTS_FILE   ( WEIGHTS_FILE [1]),
            .BIASES_FILE    ( BIASES_FILE  [1]),
            .IPDATA_BNNENC  ( IPDATA_BNNENC[1] ),
            .IPWGHT_BNNENC  ( IPWGHT_BNNENC[1] ),
            .OP_ACTV_LAYER  ( OP_ACTV_LAYER[1] ),
            .IP_DATA_WIDTH  ( IP_DATA_WIDTH[1] ),
            .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH[1] ),
            .IP_BIAS_WIDTH  ( IP_BIAS_WIDTH[1] ),
            .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH[1] ),
            .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH[1] ),
            .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT[1] ),
            .IP_DECBIAS_EN  ( IP_DECBIAS_EN[1] )
        )layer_1(
            .clk_i          ( clk_i          ), 
            .rst_n_i        ( rst_n_i        ),
            .data_ready_i   ( neuron_signals[0].state[1:0] == 2  ), 
            .write_done_i   ( neuron_signals[0].accel_done   ), 
            .read_done_i    ( read_done_i    ),
            .we_A_ext_i     ( neuron_signals[0].en_C.we     ),
            .wght_mod_i     ( wght_mod_i     ),
                            
            .addr_A_i       ( addr_C_fsm_0   ), 
            .addr_B_i       ( addr_B_1 ),
                            
                            
            .addr_C_fsm_o   ( addr_C_fsm_1   ),
                            
            .wd_A_i         ( neuron_signals[0].wd_C_out ), 
            .wd_B_i         ( neuron_signals[1].wd_B         ),
            .wd_C_i         ( neuron_signals[1].wd_C         ),
            .wd_C_o         ( neuron_signals[1].wd_C_out       ),
            .en_C_o         ( neuron_signals[1].en_C           ), 
            .state_o        ( neuron_signals[1].state          ),
            .accel_done_o   ( neuron_signals[1].accel_done     ), 
            .accel_ready_o  ( neuron_signals[1].accel_ready    )
        );   
    
    
        accel_wrapper
        #(
            .WEIGHTS_FILE   ( WEIGHTS_FILE [2] ),
            .BIASES_FILE    ( BIASES_FILE  [2] ),
            .IPDATA_BNNENC  ( IPDATA_BNNENC[2] ),
            .IPWGHT_BNNENC  ( IPWGHT_BNNENC[2] ),
            .OP_ACTV_LAYER  ( OP_ACTV_LAYER[2] ),
            .IP_DATA_WIDTH  ( IP_DATA_WIDTH[2] ),
            .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH[2] ),
            .IP_BIAS_WIDTH  ( IP_BIAS_WIDTH[2] ),
            .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH[2] ),
            .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH[2] ),
            .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT[2] ),
            .IP_DECBIAS_EN  ( IP_DECBIAS_EN[2] )
        )layer_2(
            .clk_i          ( clk_i          ), 
            .rst_n_i        ( rst_n_i        ),
            .data_ready_i   ( neuron_signals[1].state[1:0] == 2  ), 
            .write_done_i   ( neuron_signals[1].accel_done   ), 
            .read_done_i    ( read_done_i    ),
            .we_A_ext_i     ( neuron_signals[1].en_C.we     ),
            .wght_mod_i     ( wght_mod_i     ),
                            
            .addr_A_i       ( addr_C_fsm_1   ), 
            .addr_B_i       ( addr_B_2 ),
                            
                            
            .addr_C_fsm_o   ( addr_C_fsm_2   ),
                            
            .wd_A_i         ( neuron_signals[1].wd_C_out ), 
            .wd_B_i         ( neuron_signals[2].wd_B         ),
            .wd_C_i         ( neuron_signals[2].wd_C         ),
            .wd_C_o         ( neuron_signals[2].wd_C_out       ),
            .en_C_o         ( neuron_signals[2].en_C           ), 
            .state_o        ( neuron_signals[2].state          ),
            .accel_done_o   ( neuron_signals[2].accel_done     ), 
            .accel_ready_o  ( neuron_signals[2].accel_ready    )
        );   
    
    
    

    
data_matrix_mem #(
    .DATA_WIDTH     (IP_DATA_WIDTH[NUMBER_OF_LAYERS-1]) ,

    .MATRIX_WIDTH   ( OP_NEUR_WIDTH[NUMBER_OF_LAYERS-1] ),
    .MATRIX_HIGHT   ( IP_NEUR_HIGHT[NUMBER_OF_LAYERS-1] )
    
    ) op_mem (
    .clk_i          ( clk_i     ), 
    .rst_n_i        ( rst_n_i   ),
    .en_i           ( neuron_signals[NUMBER_OF_LAYERS-1].en_C         ),
    .addr_A_i       ( addr_C_fsm_2   ),   
    .addr_B_i       ( addr_C_i   ),
    .wd_A_i         ( neuron_signals[NUMBER_OF_LAYERS-1].wd_C_out     ), 
    .rd_B_o         ( rd_C_o                                        ),
    .rd_B_valid_o   ()
    );
    
    assign accel_done_o  = neuron_signals[NUMBER_OF_LAYERS-1].accel_done;
    assign accel_ready_o = neuron_signals[NUMBER_OF_LAYERS-1].accel_ready;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//____________________________________________________________________________________________________________________________
//############################################ 2 Neuron Layer Test ###########################################################
//____________________________________________________________________________________________________________________________
// genvar neur   ;
   // generate
// for (neur = 0; neur < 3; neur++) begin : neuron_layer
        // logic a, b, c;
        // ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_C_fsm_out();
// end
// endgenerate
    
    // assign neuron_layer[1].c = 1'b0;
    // assign neuron_layer[2].a = neuron_layer[1].c;
    
    
    // logic wd_C [2];
    
    // logic accel_done [2], accel_ready [2];

    
    // rw_en en_C [2];
    // logic [1:0] state [2];
    
    // assign accel_done_o = accel_done[1];
    // assign accel_ready_o = accel_ready[0] && accel_ready[1];

    // ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_C_fsm_0();
    // ram_addr_port #(.RAM_WIDTH (7), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_C_fsm_1();
    
        // accel_wrapper
// #(
    // .WEIGHTS_FILE   ( "wght.txt"    ),
    // .IPDATA_BNNENC  ( 0             ),
    // .IPWGHT_BNNENC  ( 1             ),
    // .OP_ACTV_LAYER  ( "BNN"         ),
    // .IP_DATA_WIDTH  ( IP_DATA_WIDTH ),
    // .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH ),
    // .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH ),
    // .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH ),
    // .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT )
    // )layer1(
    // .clk_i          ( clk_i         ), 
    // .rst_n_i        ( rst_n_i       ),
    // .data_ready_i   ( data_ready_i  ), 
    // .write_done_i   ( write_done_i  ), 
    // .read_done_i    ( read_done_i   ),
    // .we_A_ext_i     ( 1'b1          ),
    // .wght_mod_i     ( neuron_layer[2].a    ),
    
    // .addr_A_i       ( addr_A_i      ), 
    // .addr_B_i       ( addr_B_i      ),
    
    
    // .addr_C_fsm_o   ( addr_C_fsm_0  ),
    
    // .wd_A_i         ( wd_A_i        ), 
    // .wd_B_i         ( wd_B_i        ),
    // .wd_C_i         ( wd_C_i        ),
    // .wd_C_o         ( wd_C[0]       ),
    // .en_C_o         ( en_C[0]       ), 
    // .state_o        ( state[0][1:0] ),
    // .accel_done_o   ( accel_done[0] ), 
    // .accel_ready_o  ( accel_ready[0])
    // );     
        
        // accel_wrapper
// #(
    // .WEIGHTS_FILE   ( "wght2.txt"   ),
    // .IPDATA_BNNENC  ( 1             ),
    // .IPWGHT_BNNENC  ( 1             ),
    // .OP_ACTV_LAYER  ( "ARGMAX"         ),
    // .IP_DATA_WIDTH  ( 1 ),
    // .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH ),
    // .IP_NEUR_WIDTH  ( 7 ),
    // .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH ),
    // .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT )

    
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
    
    
//____________________________________________________________________________________________________________________________
//############################################ 1 Neuron Layer Test ###########################################################
//____________________________________________________________________________________________________________________________

        
    // ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_C_fsm();
    // logic wd_C;
    // rw_en en_C;
    
    // accel_wrapper
// #(
    // .WEIGHTS_FILE   ( "wght.txt"    ),
    // .IPDATA_BNNENC  ( 0             ),
    // .IPWGHT_BNNENC  ( 1             ),
    // .OP_ACTV_LAYER  ( "BNN"         ),
    // .IP_DATA_WIDTH  ( IP_DATA_WIDTH ),
    // .IP_WGHT_WIDTH  ( IP_WGHT_WIDTH ),
    // .IP_NEUR_WIDTH  ( IP_NEUR_WIDTH ),
    // .OP_NEUR_WIDTH  ( OP_NEUR_WIDTH ),
    // .IP_NEUR_HIGHT  ( IP_NEUR_HIGHT )
    
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
    
    
    // .addr_C_fsm_o   ( addr_C_fsm  ),
    
    // .wd_A_i         ( wd_A_i        ), 
    // .wd_B_i         ( wd_B_i        ),
    // .wd_C_i         ( 'h0        ),
    // .wd_C_o         ( wd_C          ),
    // .en_C_o         ( en_C          ), 
    // .state_o        (               ),
    // .accel_done_o   ( accel_done_o  ), 
    // .accel_ready_o  ( accel_ready_o )
    // );     
    

    
        
    // data_matrix_mem #(
    // .DATA_WIDTH     (1) ,

    // .MATRIX_WIDTH (OP_NEUR_WIDTH),
    // .MATRIX_HIGHT (IP_NEUR_HIGHT)
    
    // ) op_mem (
    // .clk_i          ( clk_i         ), 
    // .rst_n_i        ( rst_n_i       ),
    // .en_i           ( en_C          ),
    // .addr_A_i       ( addr_C_fsm    ),   
    // .addr_B_i       ( addr_C_i      ),
    // .wd_A_i         ( wd_C          ), 
    // .rd_B_o         ( rd_C_o        ),
    // .rd_B_valid_o   ()
    // );
    
    
    

    
    
 endmodule   