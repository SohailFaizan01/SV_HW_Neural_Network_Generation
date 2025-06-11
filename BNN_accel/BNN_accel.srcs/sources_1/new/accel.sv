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
    parameter IP_WGHT_WIDTH = 2,
    parameter IP_NEUR_WIDTH = 784
    )(
    input  clk_i, rst_n_i, sm_rst_i,
    input  [(IP_DATA_WIDTH-1):0] rd_A_i,
    input  [(IP_WGHT_WIDTH-1):0] rd_B_i,
    // output [(OP_DATA_WIDTH-1):0] wd_C_o
    output  wd_C_o
    );
    logic   signed  [IP_DATA_WIDTH:0]       rd_A    ; 
    logic                                   actv    ; 
    reg     signed  [($clog2(IP_NEUR_WIDTH)+IP_DATA_WIDTH+1):0]       accum_q ;

    assign rd_A = {1'b0, rd_A_i} ;
    assign wd_C_o = actv;
    
    // accumulator width $clog2(IP_NEUR_WIDTH) + IP_DATA_WIDTH + 2
    
    
    always_comb begin
        if (accum_q[$left(accum_q)])
            actv = 1'b0 ;
        else 
            actv = 1'b1 ;
    end


    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 'h0;
        else if (sm_rst_i)
            accum_q <= 'h0;
        else
            if      (rd_B_i == 'h1)
                accum_q <= accum_q + rd_A_i ;
            else if (rd_B_i == 'h0)
                accum_q <= accum_q - rd_A_i ;
            else
                accum_q <= accum_q          ;
    end
    
endmodule
