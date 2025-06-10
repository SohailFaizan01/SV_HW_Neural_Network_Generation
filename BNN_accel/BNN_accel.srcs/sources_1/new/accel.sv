`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 07:36:37 PM
// Design Name: 
// Module Name: accel
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

module mmul#(
    parameter IP_DATA_WIDTH = 8,
    parameter OP_DATA_WIDTH = 20
    )(
    input  clk_i, rst_n_i, sm_rst_i,
    input  [(IP_DATA_WIDTH-1):0] rd_A_i, rd_B_i,
    output [(OP_DATA_WIDTH-1):0] wd_C_o
    );
    reg  [(OP_DATA_WIDTH-1):0] accum_q;
    // logic [(OP_DATA_WIDTH-1):0] accum_d;


    assign wd_C_o = accum_q;


    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 0;
        else if (sm_rst_i)
            accum_q <= 0;
        else
            accum_q <= accum_q + (rd_A_i*rd_B_i);
    end
    
endmodule
