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
import type_pkg::*;

module wght_matrix_mem#(
    parameter           DATA_WIDTH      = 8 ,
    parameter           MATRIX_WIDTH    = 8 ,
    parameter           MATRIX_HIGHT    = 8
    )(
    input  clk_i, rst_n_i, 
    input  rw_en  en_A_i, en_B_i,
    ram_addr_port addr_A_i ,
    ram_addr_port addr_B_i ,


    input  [(DATA_WIDTH-1):0]  wd_A_i,
    output [(DATA_WIDTH-1):0]  rd_B_o
    );
    



logic   [(DATA_WIDTH-1):0] rd_q;


logic   [(DATA_WIDTH-1):0] ram [MATRIX_HIGHT]  [MATRIX_WIDTH] ;







assign rd_B_o       = rd_q ;

always_ff @ (posedge clk_i, negedge rst_n_i) begin
    if (!rst_n_i) begin
        rd_q <= 'h0;
    end 
    else begin
        if (en_A_i.we)
            ram[addr_A_i.y][addr_A_i.x] <= wd_A_i;  
        
        if (en_B_i.re)
            rd_q <= ram[addr_B_i.y][addr_B_i.x];
        else            
            rd_q <= 'h2;
            
    end
end

endmodule
