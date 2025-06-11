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
    input  [$clog2(IP_NEUR_WIDTH)-1:0] addr_Ax_i ,
    input  [$clog2(IP_NEUR_HIGHT)-1:0] addr_Ay_i ,
    input  [$clog2(OP_NEUR_WIDTH)-1:0] addr_Bx_i ,
    input  [$clog2(IP_NEUR_WIDTH)-1:0] addr_By_i ,
    
    input [$clog2(OP_NEUR_WIDTH)-1:0] addr_Cx_i ,
    input [$clog2(IP_NEUR_HIGHT)-1:0] addr_Cy_i ,
    
    input   [(IP_DATA_WIDTH-1):0] wd_A_i,
    input   [(IP_WGHT_WIDTH-1):0] wd_B_i,
    input   wd_C_i,
    output  rd_C_o,
    output  accel_done_o, accel_ready_o
    );
    
    
    
    logic accel_rst_fsm;
    logic en_AB, we_AB, en_C, we_C;
    
    logic [$clog2(IP_NEUR_WIDTH)-1:0] addr_Ax , addr_Ax_fsm ; 
    logic [$clog2(IP_NEUR_HIGHT)-1:0] addr_Ay , addr_Ay_fsm ; 
    logic [$clog2(OP_NEUR_WIDTH)-1:0] addr_Bx , addr_Bx_fsm ; 
    logic [$clog2(IP_NEUR_WIDTH)-1:0] addr_By , addr_By_fsm ; 

    
    logic [$clog2(OP_NEUR_WIDTH)-1:0] addr_Cx , addr_Cx_fsm;
    logic [$clog2(IP_NEUR_HIGHT)-1:0] addr_Cy , addr_Cy_fsm;
    
    typedef struct {
    logic [(IP_DATA_WIDTH-1):0]  data   ;
    logic                        valid     ;
    } valid_data;
    
    logic wd_C_accel, wd_C;
    valid_data rd_A, rd_B ;
    valid_data wd_A, wd_B ;
    
    
    assign wd_A.data = wd_A_i ;
    assign wd_B.data = wd_B_i ;
  
  
    dualport_matrix_mem #(
    .DATA_WIDTH     (IP_DATA_WIDTH) ,

    .MATRIX_WIDTH (IP_NEUR_WIDTH),
    .MATRIX_HIGHT (IP_NEUR_HIGHT)
    
    ) data (
    .clk_i      (clk_i      ), 
    .rst_n_i    (rst_n_i    ),
    .we_A_i     (en_AB && we_AB), 
    .re_B_i     (en_AB      ), 
    .addr_Ax_i  (addr_Ax     ),
    .addr_Ay_i  (addr_Ay     ),
    .addr_Bx_i  (addr_Ax     ),
    .addr_By_i  (addr_Ay     ),
    .wd_A_i     (wd_A.data     ), 
    .rd_B_o     (rd_A.data       ),
    .rd_B_valid_o (rd_A.valid       )
    );
    
        
    dualport_matrix_mem #(
    .DATA_WIDTH     (IP_WGHT_WIDTH) ,

    .MATRIX_WIDTH (OP_NEUR_WIDTH),
    .MATRIX_HIGHT (IP_NEUR_WIDTH)
    
    ) weights (
    .clk_i      (clk_i      ), 
    .rst_n_i    (rst_n_i    ),
    .we_A_i     (en_AB && we_AB), 
    .re_B_i     (en_AB      ), 
    .addr_Ax_i  (addr_Bx     ),
    .addr_Ay_i  (addr_By     ),
    .addr_Bx_i  (addr_Bx     ),
    .addr_By_i  (addr_By     ),
    .wd_A_i     (wd_B.data     ), 
    .rd_B_o       (rd_B.data       ),
    .rd_B_valid_o (rd_B.valid       )
    );
    
    
    
    
     
    dualport_matrix_mem #(
    .DATA_WIDTH     (1) ,

    .MATRIX_WIDTH (OP_NEUR_WIDTH),
    .MATRIX_HIGHT (IP_NEUR_HIGHT)
    
    ) op_mem (
    .clk_i      (clk_i      ), 
    .rst_n_i    (rst_n_i    ),
    .we_A_i     (en_C && we_C), 
    .re_B_i     (en_C      ), 
    .addr_Ax_i  (addr_Cx     ),
    .addr_Ay_i  (addr_Cy     ),
    .addr_Bx_i  (addr_Cx     ),
    .addr_By_i  (addr_Cy     ),
    .wd_A_i     (wd_C     ), 
    .rd_B_o       (rd_C_o       ),
    .rd_B_valid_o ()
    );

    
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
    .en_AB_o         (en_AB      ),  
    .we_AB_o         (we_AB      ), 
    .en_C_o          (en_C       ), 
    .we_C_o          (we_C       ),
    .addr_Ax_o        (addr_Ax_fsm ),
    .addr_Ay_o        (addr_Ay_fsm ),
    .addr_Bx_o        (addr_Bx_fsm ),
    .addr_By_o        (addr_By_fsm ),
    .addr_Cx_o        (addr_Cx_fsm ),
    .addr_Cy_o        (addr_Cy_fsm ),
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
    .rd_B_i          (rd_B.data           ),
    .wd_C_o          (wd_C_accel     )
    );
    
    always_comb begin
        if ((!accel_done_o) && (!accel_ready_o)) begin
            addr_Ax  <= addr_Ax_fsm    ; 
            addr_Ay  <= addr_Ay_fsm    ; 
            addr_Bx  <= addr_Bx_fsm    ;
            addr_By  <= addr_By_fsm    ;
            addr_Cx  <= addr_Cx_fsm    ;
            addr_Cy  <= addr_Cy_fsm    ;
            wd_C    <= wd_C_accel    ;
        end else begin
            addr_Ax  <= addr_Ax_i    ;
            addr_Ay  <= addr_Ay_i    ;
            addr_Bx  <= addr_Bx_i    ;
            addr_By  <= addr_By_i    ;
            addr_Cx  <= addr_Cx_i    ;
            addr_Cy  <= addr_Cy_i    ;
            wd_C    <= wd_C_i;
        end
    end
endmodule
