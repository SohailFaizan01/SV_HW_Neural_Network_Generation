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
    parameter  string   OP_ACTV_LAYER = "NONE",
    parameter           IP_DATA_WIDTH = 8,
    parameter           IP_WGHT_WIDTH = 2,
    parameter           IP_NEUR_WIDTH = 784,
    parameter           OP_DATA_WIDTH = 1
    )(
    input  clk_i, rst_n_i, sm_rst_i,
    input  [(IP_DATA_WIDTH-1):0] rd_A_i,
    input  [(IP_WGHT_WIDTH-1):0] rd_B_i,
    output [(OP_DATA_WIDTH-1):0] wd_C_o
    );
    
    // accumulator width $clog2(IP_NEUR_WIDTH) + IP_DATA_WIDTH + 2
    
    localparam ACCUM_WIDTH =     (IPWGHT_BNNENC == 1) ? ($clog2(IP_NEUR_WIDTH)+IP_DATA_WIDTH+1) : ($clog2(IP_NEUR_WIDTH)+(IP_DATA_WIDTH+IP_WGHT_WIDTH));
                                
    reg signed  [ACCUM_WIDTH-1:0]       accum_q ;
    
generate
if ((IPDATA_BNNENC == 1) && (IPWGHT_BNNENC == 1))  begin : accum_gen
    // reg signed  [($clog2(IP_NEUR_WIDTH)+IP_DATA_WIDTH):0]       accum_q ;


 
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 'h0;
        else if (sm_rst_i)
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
   
    // reg signed  [($clog2(IP_NEUR_WIDTH)+IP_DATA_WIDTH):0]       accum_q ;

     logic   signed  [IP_DATA_WIDTH:0]       rd_A    ; 
     assign rd_A = {1'b0, rd_A_i} ;

    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 'h0;
        else if (sm_rst_i)
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

    // reg signed  [($clog2(IP_NEUR_WIDTH)+(IP_DATA_WIDTH+IP_WGHT_WIDTH)-1):0]       accum_q ;
    
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i)    
            accum_q <= 'h0;
        else if (sm_rst_i)
            accum_q <= 'h0;
        else 
                accum_q <= accum_q + rd_A_i*rd_B_i   ;
    end



end
endgenerate
    
generate
if (OP_ACTV_LAYER == "BNN") begin  : activation_gen   
    logic actv    ; 
    always_comb begin
        if (accum_q[$left(accum_q)])
            actv = 1'b0 ;
        else 
            actv = 1'b1 ;
    end
    
    assign wd_C_o = actv;
end
else if (OP_ACTV_LAYER == "NONE") begin
    assign  wd_C_o  =   accum_q ;
    
    
end
endgenerate

endmodule
