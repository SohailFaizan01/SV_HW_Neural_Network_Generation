`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 09:18:10 PM
// Design Name: 
// Module Name: ip_reg
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


module dualport_matrix_mem#(
    parameter DATA_WIDTH = 8,
    parameter MATRIX_WIDTH = 8,
    parameter MATRIX_HIGHT = 8
    )(
    input  clk_i, rst_n_i, we_A_i, re_B_i,
    input  [$clog2(MATRIX_WIDTH)-1:0] addr_Ax_i ,
    input  [$clog2(MATRIX_HIGHT)-1:0] addr_Ay_i ,    
    
    input  [$clog2(MATRIX_WIDTH)-1:0] addr_Bx_i ,
    input  [$clog2(MATRIX_HIGHT)-1:0] addr_By_i ,

    input  [(DATA_WIDTH-1):0]  wd_A_i,
    output [(DATA_WIDTH-1):0]  rd_B_o,
    output                     rd_B_valid_o
    );
    


typedef struct {
    logic   [(DATA_WIDTH-1):0]  data    ;
    logic                       valid   ;               
} valid_data;

valid_data ram [(MATRIX_HIGHT-1):0]  [(MATRIX_WIDTH-1):0] = '{default:'h0};
valid_data rd_q;


assign rd_B_o       = rd_q.data ;
assign rd_B_valid_o = rd_q.valid;

always_ff @ (posedge clk_i, negedge rst_n_i) begin
    if (!rst_n_i) begin
        rd_q.data   <= 'h0;
        rd_q.valid  <= 'h0;
    end 
    else begin
        if (we_A_i)
            ram[addr_Ay_i][addr_Ax_i].data <= wd_A_i;  
        if (re_B_i)
            rd_q <= ram[addr_By_i][addr_Bx_i];
    end
end

endmodule
