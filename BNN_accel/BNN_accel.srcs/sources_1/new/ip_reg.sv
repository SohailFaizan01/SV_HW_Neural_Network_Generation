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
    parameter WGHT_WIDTH = 8,
    parameter MATRIX_A_WIDTH = 8,
    parameter MATRIX_A_HIGHT = 8,
    parameter MATRIX_B_WIDTH = 8,
    parameter MATRIX_B_HIGHT = 8
    )(
    input  clk_i, rst_n_i, en_A_i, en_B_i, we_A_i, we_B_i,
    input  [$clog2(MATRIX_A_WIDTH)-1:0] addr_Ax_i ,
    input  [$clog2(MATRIX_A_HIGHT)-1:0] addr_Ay_i ,
    input  [$clog2(MATRIX_B_WIDTH)-1:0] addr_Bx_i ,
    input  [$clog2(MATRIX_B_HIGHT)-1:0] addr_By_i ,

    input  [(DATA_WIDTH-1):0] wd_A_i, wd_B_i,
    output [(DATA_WIDTH-1):0] rd_A_o, rd_B_o
    );


// reg [(DATA_WIDTH-1):0] ram_A [(IP_NEUR_HIGHT-1):0]  [(IP_NEUR_WIDTH-1):0] = '{default:'h0};
// reg [(WGHT_WIDTH-1):0] ram_B [(IP_NEUR_WIDTH-1):0]   [(OP_NEUR_WIDTH-1):0] = '{default:'h0};

reg [(DATA_WIDTH-1):0] ram_A [(MATRIX_A_HIGHT-1):0]  [(MATRIX_A_WIDTH-1):0] = '{default:'h0};
reg [(WGHT_WIDTH-1):0] ram_B [(MATRIX_B_HIGHT-1):0]  [(MATRIX_B_WIDTH-1):0] = '{default:'h0};
reg [(DATA_WIDTH-1):0] rd_A_q;
reg [(WGHT_WIDTH-1):0] rd_B_q ;


assign rd_A_o = rd_A_q ;
assign rd_B_o = rd_B_q ;

always_ff @ (posedge clk_i, negedge rst_n_i) begin
    if (!rst_n_i) begin 
        rd_A_q <= 'h0;
        rd_B_q<= 'h0;
    end
    else begin
        if (en_A_i) begin
            if (we_A_i)
                ram_A[addr_Ay_i][addr_Ax_i] <= wd_A_i;
                
            rd_A_q <= ram_A[addr_Ay_i][addr_Ax_i];
        end
    
        if (en_B_i) begin
            if (we_B_i)
                ram_B[addr_By_i][addr_Bx_i] <= wd_B_i;
    
        rd_B_q <= ram_B[addr_By_i][addr_Bx_i];
        rd_B_q <= ram_B[addr_By_i][addr_Bx_i];
        end
    end
end

endmodule
