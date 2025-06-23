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
    parameter           IPDATA_BNNENC = 0,
    parameter           IPWGHT_BNNENC = 0,
    parameter           OP_ACTV_LAYER = 0,
    parameter           IP_DATA_WIDTH = 8,
    parameter           IP_WGHT_WIDTH = 2,
    parameter           IP_BIAS_WIDTH = 32,
    parameter           IP_NEUR_WIDTH = 784,
    parameter           OP_DATA_WIDTH = 1,
    parameter           IP_DECBIAS_EN = 1
    )(
    input  clk_i, rst_n_i,
    input  sm_rst_i [2],
    input  clc_done_i,
    input           [(IP_DATA_WIDTH-1):0] rd_A_i,
    input           [(IP_WGHT_WIDTH-1):0] rd_B_i,
    input signed    [(IP_BIAS_WIDTH-1):0] rd_K_i,
    output logic    [(OP_DATA_WIDTH-1):0] wd_C_o
    );
    
    // accumulator width $clog2(IP_NEUR_WIDTH) + IP_DATA_WIDTH + 2
    
    localparam ACCUM_NO_BIAS    =   (IPWGHT_BNNENC == 1) ? ($clog2(IP_NEUR_WIDTH)+IP_DATA_WIDTH+1) : ($clog2(IP_NEUR_WIDTH)+(IP_DATA_WIDTH+IP_WGHT_WIDTH));
    localparam ACCUM_RS_WIDTH   =   (IP_DECBIAS_EN == 0 )       ? ACCUM_NO_BIAS         :
                                    (ACCUM_NO_BIAS + 1 > 32)    ? (ACCUM_NO_BIAS + 1)   : 33;
    
    reg signed  [ACCUM_NO_BIAS-1:0]       accum_q ;
    logic signed [ACCUM_RS_WIDTH-1:0]     accum_biased;
    
generate
if ((IPDATA_BNNENC == 1) && (IPWGHT_BNNENC == 1))  begin 


 
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 'h0;
        else if (sm_rst_i[0])
            accum_q <= 'h0;
        else begin
            if (rd_B_i[1])//(rd_B_i >= 'h2)
                accum_q <= accum_q ;
            else begin
                if      (rd_B_i[0]~^rd_A_i)
                    accum_q <= accum_q + 2'sd1 ;
                else 
                    accum_q <= accum_q - 2'sd1 ;
            end
        end
    end

    
end 
else if ((IPDATA_BNNENC == 0) && (IPWGHT_BNNENC == 1)) begin

     logic   signed  [IP_DATA_WIDTH:0]       rd_A    ; 
     assign rd_A = {1'b0, rd_A_i} ;

    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 'h0;
        else if (sm_rst_i[0])
            accum_q <= 'h0;
        else begin
            if      (rd_B_i == 'h1)
                accum_q <= accum_q + rd_A   ;
            else if (rd_B_i == 'h0)
                accum_q <= accum_q - rd_A ;
            else
                accum_q <= accum_q          ;
        end
    end


end
else begin
    
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 'h0;
        else if (sm_rst_i[0])
            accum_q <= 'h0;
        else 
                accum_q <= accum_q + rd_A_i*rd_B_i   ;
    end



end
endgenerate
    
always_comb
        accum_biased = accum_q + rd_K_i;
    
    
generate
if (OP_ACTV_LAYER == 1) begin  : activation_gen   
    logic actv    ; 
    always_comb begin
        if (accum_biased[ACCUM_RS_WIDTH-1])
            actv = 1'b0 ;
        else 
            actv = 1'b1 ;
    end
    
    always_comb begin
        if (clc_done_i)
            wd_C_o  =   actv ;
        else 
            wd_C_o  =   'h0;
    end
            
end
else if (OP_ACTV_LAYER == 2) begin

    reg signed [ACCUM_RS_WIDTH-1:0] maxval, maxval_nxt;
    
    always_latch begin
        if (!rst_n_i)
            maxval_nxt <= 'h0;
        else if (sm_rst_i[1])
            maxval_nxt <= 'h0;
        else begin
            if (clc_done_i) begin
                if (maxval <= accum_biased) 
                    maxval_nxt = accum_biased;
                else 
                    maxval_nxt = maxval_nxt;
            end else
                maxval_nxt = maxval_nxt;
        end
    end
                
    always_comb begin
        if (clc_done_i) begin
                if (maxval <= accum_biased)
                    wd_C_o = 1'b1;
                else
                    wd_C_o = 1'b0;
        end else
                    wd_C_o = 1'b0;
    
    end
    
    
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)
            maxval  <=   'h0;
        else
            maxval <= maxval_nxt;
    end
        
        
        



end
else begin

    always_comb begin
        if (clc_done_i)
            wd_C_o  =   accum_biased ;
        else 
            wd_C_o  =   'h0;
    end
    
end
endgenerate

endmodule
