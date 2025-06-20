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

module bias_matrix_mem#(
    parameter string    BIASES_FILE       ,
    parameter           DATA_WIDTH      = 8 ,
    parameter           MATRIX_WIDTH    = 8 ,
    parameter           MATRIX_HIGHT    = 8
    )(
    input  clk_i, rst_n_i, 
    input  rw_en  en_i,
    ram_addr_port addr_i ,


    input  signed   [(DATA_WIDTH-1):0]  wd_i,
    output signed   [(DATA_WIDTH-1):0]  rd_o
    );
    



logic signed    [(DATA_WIDTH-1):0] rd_q;

// logic   [(DATA_WIDTH-1):0] ram [(MATRIX_HIGHT-1):0]  [(MATRIX_WIDTH-1):0] = '{default:'h0};
logic signed    [(DATA_WIDTH-1):0] ram [MATRIX_HIGHT]  [MATRIX_WIDTH] ;
logic signed    [(DATA_WIDTH-1):0] init_array [(MATRIX_HIGHT*MATRIX_WIDTH)]   ;

initial begin
    $readmemh(BIASES_FILE, init_array);
    for (int x = 0; x<MATRIX_WIDTH; x++) begin
        for (int y = 0; y<MATRIX_HIGHT; y++)
            ram[y][x] = init_array[y+MATRIX_HIGHT*x];
    end
end






assign rd_o       = rd_q ;

always_ff @ (posedge clk_i, negedge rst_n_i) begin
    if (!rst_n_i) begin
        rd_q <= 'sh0;
    end 
    else begin
        if (en_i.we)
            ram[addr_i.y][addr_i.x] <= wd_i;  
        if (en_i.re)
            rd_q <= ram[addr_i.y][addr_i.x];
        else            
            rd_q <= 'sh0;
            
    end
end

endmodule
