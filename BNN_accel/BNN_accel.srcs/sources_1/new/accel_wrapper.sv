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


module accel_wrapper#(
    parameter IP_DATA_WIDTH = 8,
    parameter IP_WGHT_WIDTH = 8,
    parameter IP_NEUR_WIDTH = 8,
    parameter OP_NEUR_WIDTH = 8,
    parameter IP_NEUR_HIGHT = 8
    
    )(
    input   clk_i, rst_n_i,
    input   data_ready_i, write_done_i, read_done_i,
    input   we_A_ext_i,
    input   wght_mod_i,
    input  [$clog2(IP_NEUR_WIDTH)-1:0] addr_Ax_i ,
    input  [$clog2(IP_NEUR_HIGHT)-1:0] addr_Ay_i ,
    input  [$clog2(OP_NEUR_WIDTH)-1:0] addr_Bx_i ,
    input  [$clog2(IP_NEUR_WIDTH)-1:0] addr_By_i ,
    
    output [$clog2(OP_NEUR_WIDTH)-1:0] addr_Cx_fsm_o,
    output [$clog2(IP_NEUR_HIGHT)-1:0] addr_Cy_fsm_o,
    
    input   [(IP_DATA_WIDTH-1):0] wd_A_i,
    input   [(IP_WGHT_WIDTH-1):0] wd_B_i,
    input   wd_C_i,
    // output  rd_C_o,
    output  [1:0]   state_o,
    
    output          en_C_o, we_C_o,
    output  logic   wd_C_o,
    output          accel_done_o, accel_ready_o
    );
    
    
    logic accel_rst_fsm;
    // logic en_A, we_A, en_B, we_B, en_C, we_C;
    logic en_A, we_A, en_B, we_B ;
    
    logic [$clog2(IP_NEUR_WIDTH)-1:0] addr_Ax_fsm ; 
    logic [$clog2(IP_NEUR_HIGHT)-1:0] addr_Ay_fsm ; 
    logic [$clog2(OP_NEUR_WIDTH)-1:0] addr_Bx_fsm ; 
    logic [$clog2(IP_NEUR_WIDTH)-1:0] addr_By_fsm ; 

    
    // logic [$clog2(OP_NEUR_WIDTH)-1:0] addr_Cx_fsm;
    // logic [$clog2(IP_NEUR_HIGHT)-1:0] addr_Cy_fsm;
    
    // assign addr_Cx_fsm_o = addr_Cx_fsm  ;
    // assign addr_Cy_fsm_o = addr_Cy_fsm  ;
    
    
    typedef struct {
    logic [(IP_DATA_WIDTH-1):0]  data   ;
    logic                        valid     ;
    } valid_data;
    
    logic wd_C_accel;
    valid_data rd_A ;
    valid_data wd_A ;
    
    logic [IP_WGHT_WIDTH-1:0] rd_B ;
    
    assign wd_A.data = wd_A_i ;
  
  
    data_matrix_mem #(
    .DATA_WIDTH     (IP_DATA_WIDTH) ,

    .MATRIX_WIDTH (IP_NEUR_WIDTH),
    .MATRIX_HIGHT (IP_NEUR_HIGHT)
    
    ) data (
    .clk_i      (clk_i      ), 
    .rst_n_i    (rst_n_i    ),
    .we_A_i     (en_A && we_A && we_A_ext_i), 
    .re_B_i     (en_A      ), 
    .addr_Ax_i  (addr_Ax_i     ),
    .addr_Ay_i  (addr_Ay_i     ),
    .addr_Bx_i  (addr_Ax_fsm     ),
    .addr_By_i  (addr_Ay_fsm     ),
    .wd_A_i     (wd_A.data     ), 
    .rd_B_o     (rd_A.data       ),
    .rd_B_valid_o (rd_A.valid       )
    );


    
    
    
wght_matrix_mem#(
    .WGHT_FILE    ("wght.txt"),
    .DATA_WIDTH   (IP_WGHT_WIDTH),
    .MATRIX_WIDTH (OP_NEUR_WIDTH),
    .MATRIX_HIGHT (IP_NEUR_WIDTH)
    )weights(
    .clk_i   (clk_i       ), 
    .rst_n_i (rst_n_i     ), 
    .we_i    (en_B && we_B), 
    .re_i    (en_B        ), 
    .addrx_i (addr_Bx_fsm     ),
    .addry_i (addr_By_fsm     ),    
    .wd_i    (wd_B_i),
    .rd_o    (rd_B )
    );
    
    
    
     
    // data_matrix_mem #(
    // .DATA_WIDTH     (1) ,

    // .MATRIX_WIDTH (OP_NEUR_WIDTH),
    // .MATRIX_HIGHT (IP_NEUR_HIGHT)
    
    // ) op_mem (
    // .clk_i      (clk_i      ), 
    // .rst_n_i    (rst_n_i    ),
    // .we_A_i     (en_C && we_C), 
    // .re_B_i     (en_C      ), 
    // .addr_Ax_i  (addr_Cx_fsm     ),
    // .addr_Ay_i  (addr_Cy_fsm     ),
    // .addr_Bx_i  (addr_Cx_i     ),
    // .addr_By_i  (addr_Cy_i     ),
    // .wd_A_i     (wd_C     ), 
    // .rd_B_o       (rd_C_o       ),
    // .rd_B_valid_o ()
    // );

    
    mmul_control_logic #(
    .IP_NEUR_WIDTH  (IP_NEUR_WIDTH)  ,
    .OP_NEUR_WIDTH  (OP_NEUR_WIDTH)  ,
    .IP_NEUR_HIGHT  (IP_NEUR_HIGHT)   
    ) control_fsm (
    .clk_i          (clk_i      ), 
    .rst_n_i         (rst_n_i    ), 
    .data_ready_i    (data_ready_i),
    .write_done_i    (write_done_i), 
    .read_done_i     (read_done_i),
    .en_A_o         (en_A      ),  
    .we_A_o         (we_A      ),     
    .en_B_o         (en_B      ),  
    .we_B_o         (we_B      ), 
    .en_C_o          (en_C_o       ), 
    .we_C_o          (we_C_o       ),
    .wght_mod_i       (wght_mod_i),
    .state_o          (state_o),
    .addr_Ax_o        (addr_Ax_fsm ),
    .addr_Ay_o        (addr_Ay_fsm ),
    .addr_Bx_o        (addr_Bx_fsm ),
    .addr_By_o        (addr_By_fsm ),
    .addr_Cx_o        (addr_Cx_fsm_o ),
    .addr_Cy_o        (addr_Cy_fsm_o ),
    .accel_rst_o     (accel_rst_fsm),
    .accel_done_o    (accel_done_o ),
    .accel_ready_o   (accel_ready_o)
    );
    
    mmul#(
    .IP_DATA_WIDTH (IP_DATA_WIDTH),
    .IP_WGHT_WIDTH (IP_WGHT_WIDTH),
    .IP_NEUR_WIDTH (IP_NEUR_WIDTH)
    ) accel (
    .clk_i           (clk_i          ), 
    .rst_n_i         (rst_n_i        ),
    .sm_rst_i        (accel_rst_fsm  ),
    .rd_A_i          (rd_A.data           ), 
    .rd_B_i          (rd_B           ),
    .wd_C_o          (wd_C_accel     )
    );
    
always_comb begin
    if ((state_o == 2'h0)||(state_o == 2'h1)) begin
        if (wght_mod_i) 
            wd_C_o    = wd_C_i;
        end else begin
            wd_C_o    = wd_C_accel    ;
        end
    end
endmodule
