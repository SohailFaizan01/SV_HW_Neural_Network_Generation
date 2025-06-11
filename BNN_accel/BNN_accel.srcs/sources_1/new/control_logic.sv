`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 08:58:17 AM
// Design Name: 
// Module Name: control_logic
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


module mmul_control_logic#(
    parameter IP_NEUR_WIDTH = 8,
    parameter OP_NEUR_WIDTH = 8,
    parameter IP_NEUR_HIGHT = 8
    )(
    input clk_i, rst_n_i, data_ready_i, write_done_i, read_done_i,
    output en_AB_o, we_AB_o, en_C_o, we_C_o,
    
    // output [($clog2(MATRIX_WIDTH)-1):0] addr_A_o [1:0], addr_B_o [1:0],
    output  [$clog2(IP_NEUR_WIDTH)-1:0] addr_Ax_o ,
    output  [$clog2(IP_NEUR_HIGHT)-1:0] addr_Ay_o ,
    output  [$clog2(OP_NEUR_WIDTH)-1:0] addr_Bx_o ,
    output  [$clog2(IP_NEUR_WIDTH)-1:0] addr_By_o ,
    
    output [$clog2(OP_NEUR_WIDTH)-1:0] addr_Cx_o ,
    output [$clog2(IP_NEUR_HIGHT)-1:0] addr_Cy_o ,
    output accel_rst_o, accel_done_o, accel_ready_o
    );
    
    
    logic                     en_AB, we_AB, en_C, we_C;
    logic                     accel_rst, accel_done, accel_ready;
    // logic [($clog2(MATRIX_WIDTH)-1):0] addr_A [1:0], addr_B [1:0];
    
    logic  [$clog2(IP_NEUR_WIDTH)-1:0] addr_Ax ;
    logic  [$clog2(IP_NEUR_HIGHT)-1:0] addr_Ay ;
    logic  [$clog2(OP_NEUR_WIDTH)-1:0] addr_Bx ;
    logic  [$clog2(IP_NEUR_WIDTH)-1:0] addr_By ;
    
    
    
    
    
    
    
    
    reg [$clog2(OP_NEUR_WIDTH*IP_NEUR_HIGHT):0] addr_C;
    reg [$clog2(IP_NEUR_WIDTH):0] k;
    reg  write_clk_sync;

    enum {IDLE, LOAD, CALC, MATRIX_DONE} state, nxt_state;
    enum {ACCUMULATE, STORE} accum_state,nxt_accum_state;

    assign en_AB_o  =   en_AB   ;
    assign we_AB_o  =   we_AB   ;
    assign en_C_o   =   en_C    ;
    assign we_C_o   =   we_C    ;
    
    assign addr_Ax_o = addr_Ax ;
    assign addr_Ay_o = addr_Ay ;
    assign addr_Bx_o = addr_Bx ;
    assign addr_By_o = addr_By ;
    
    assign addr_Cx_o = addr_C%OP_NEUR_WIDTH ;
    assign addr_Cy_o = addr_C/OP_NEUR_WIDTH ;
    
    
    assign accel_rst_o      = accel_rst     ;
    assign accel_done_o     = accel_done    ;
    assign accel_ready_o    = accel_ready   ;

   
// always @(*) begin
always_latch begin
        if (!rst_n_i) begin
            state       <=  IDLE    ;
            accum_state <=  ACCUMULATE  ;
        end else begin
            case(state)
                IDLE : begin
                    accum_state <=  ACCUMULATE  ;
                    if (data_ready_i) 
                        state   <=  LOAD    ;
                end
                LOAD : begin
                    if (write_done_i)
                        state <= CALC;
                end
                CALC : begin
                    case (accum_state)
                        ACCUMULATE : begin
                            if ((k==(IP_NEUR_WIDTH+1'b1))) 
                                accum_state <= STORE    ;
                        end 
                        STORE : begin
                                    if ((addr_C == (OP_NEUR_WIDTH*IP_NEUR_HIGHT)) ) 
                                        state <= MATRIX_DONE;
                                    else 
                                        accum_state <= ACCUMULATE;
                        end
                        default: accum_state <= accum_state;
                     endcase
                end
                MATRIX_DONE : begin
                    if(read_done_i)
                        state <= IDLE;
                end
                default : state <= state;
            endcase    
        end
    end
    
       
always_comb begin
        if (!rst_n_i) begin
            accel_ready =  1'b0    ;
            accel_done  =  1'b0    ;
            accel_rst   =  1'b1    ;
            en_AB       =  1'b0    ;
            we_AB       =  1'b0    ;
            en_C        =  1'b0    ;
            we_C        =  1'b0    ;
            addr_Ax      =  'h0     ;
            addr_Bx      =  'h0     ;
            addr_Ay      =  'h0     ;
            addr_By      =  'h0     ;
        end else begin
            case(state)
                IDLE : begin
                    accel_ready =  1'b1    ;
                    accel_done  =  1'b0    ;
                    accel_rst   =  1'b1    ;
                    en_AB       =  1'b0    ;
                    we_AB       =  1'b0    ;
                    en_C        =  1'b0    ;
                    we_C        =  1'b0    ;
                    addr_Ax      =  'h0     ;
                    addr_Bx      =  'h0     ;
                    addr_Ay      =  'h0     ;
                    addr_By      =  'h0     ;
                end
                LOAD : begin
                    accel_ready =  1'b1    ;
                    accel_done  =  1'b0    ;
                    accel_rst   =  1'b1    ;
                    en_AB       =  1'b1    ;
                    we_AB       =  1'b1    ;                
                    en_C        =  1'b1    ;
                    we_C        =  1'b1    ;
                    addr_Ax      =  'h0     ;
                    addr_Bx      =  'h0     ;
                    addr_Ay      =  'h0     ;
                    addr_By      =  'h0     ;
                end
                CALC : begin
                    accel_ready =  1'b0     ;
                    accel_done  =  1'b0     ;
                    en_AB       =  1'b1     ;         
                    we_AB       =  1'b0     ;
                    addr_Ax      = k        ;
                    addr_Ay      = (addr_C/OP_NEUR_WIDTH);
                    addr_Bx      = (addr_C%OP_NEUR_WIDTH);
                    addr_By      =  k        ;
                    case (accum_state)
                        ACCUMULATE : begin
                            if (!write_clk_sync) begin
                                accel_rst   =  1'b0            ;
                                en_C        =  1'b0            ;
                                we_C        =  1'b0            ;
                            end
                            else begin
                            accel_rst   =  1'b1            ;
                            en_C        =  1'b1            ;
                            we_C        =  1'b1            ;
                            end
                        end 
                        STORE : begin
                            accel_rst   = 1'b0;
                            en_C        = 1'b1;
                            we_C        = 1'b1;
                            if (write_clk_sync)
                                accel_rst   =   1'b1    ;
                            else
                                accel_rst   =   1'b0    ;
                        end
                        default : begin
                            accel_rst   =  1'b0            ;
                            en_C        =  1'b0            ;
                            we_C        =  1'b0            ;
                        end
                    endcase  
                end
                MATRIX_DONE : begin
                    accel_ready =   1'b0    ;
                    accel_done  =   1'b0    ;
                    accel_rst   =   1'b1    ;
                    en_AB       =   1'b0    ;         
                    we_AB       =   1'b0    ; 
                    en_C        =   1'b1    ;
                    we_C        =   1'b0    ;
                    addr_Ax      =  'h0     ;
                    addr_Bx      =  'h0     ;
                    addr_Ay      =  'h0     ;
                    addr_By      =  'h0     ;
                    if (!write_clk_sync)
                        accel_done  = 1'b1;
                    else 
                        accel_done  = 1'b0;
                end
                default : begin
                    accel_ready =   'h0;
                    accel_done  =   'h0;
                    accel_rst   =   'h0;
                    en_AB       =   'h0;         
                    we_AB       =   'h0; 
                    en_C        =   'h0;
                    we_C        =   'h0;
                    addr_Ax      =  'h0     ;
                    addr_Bx      =  'h0     ;
                    addr_Ay      =  'h0     ;
                    addr_By      =  'h0     ;
                end
            endcase    
        end
    end
    
    
    
    
    
        
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i) begin
            k       <=  'h0 ;
            addr_C  <=  'h0 ;
            // accum_state <= ACCUMULATE ;
        end
        else begin 
            // accum_state <= nxt_accum_state;
            case(state)
                IDLE : begin
                    k       <=  'h0 ;
                    addr_C  <=  'h0 ;
                    write_clk_sync <= 'b0;
                end
                LOAD : begin
                    k       <=  'h0 ;
                    addr_C  <=  'h0 ;
                    write_clk_sync <= 'b0;
                end
                CALC : begin
                    

                    case (accum_state)
                        ACCUMULATE : begin
                            k <= k+1    ;
                            addr_C <= addr_C;
                            write_clk_sync <= 1'b0;
                        end
                        STORE : begin
                            k       <= 'h0          ;
                            write_clk_sync <= write_clk_sync+ 1'b1;
                             // if (write_clk_sync)
                                addr_C  <= addr_C + 1'b1   ;
                                
                        end
                    endcase  
                end
                MATRIX_DONE : begin
                    k       <=  'h0 ;
                    addr_C  <=  'h0 ;
                    write_clk_sync <= 'b0;
                end
                default : begin
                    k       <=  k      ;
                    addr_C  <=  addr_C ;
                    write_clk_sync <= 'b0;
                end
            endcase
        end
    end
        
endmodule
