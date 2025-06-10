`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 09:19:17 PM
// Design Name: 
// Module Name: op_reg
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

module singleport_matrix_mem#(
    parameter DATA_WIDTH = 8,
    parameter MATRIX_A_WIDTH = 8,
    parameter MATRIX_A_HIGHT = 8
    )(
    input  clk_i, rst_n_i, en_A_i, we_A_i,
    input  [$clog2(MATRIX_A_WIDTH)-1:0] addr_Ax_i ,
    input  [$clog2(MATRIX_A_HIGHT)-1:0] addr_Ay_i,
    input  [(DATA_WIDTH-1):0] wd_A_i,
    output [(DATA_WIDTH-1):0] rd_A_o
    );


reg [(DATA_WIDTH-1):0] ram [(MATRIX_A_HIGHT-1):0] [(MATRIX_A_WIDTH-1):0] = '{default:'h0};
reg [(DATA_WIDTH-1):0] rd_A_q ;
assign rd_A_o = rd_A_q ;


always @ (posedge clk_i, negedge rst_n_i) begin
    if (!rst_n_i) 
        rd_A_q <= 'h0;
    else begin
        if (en_A_i) begin
            if (we_A_i)
                ram[addr_Ay_i][addr_Ax_i] <= wd_A_i;
                
            rd_A_q <= ram[addr_Ay_i][addr_Ax_i];
        end
    end
end


endmodule