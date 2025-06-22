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
    import type_pkg::*;

module mmul_control_logic#(
    parameter IP_NEUR_WIDTH = 8,
    parameter OP_NEUR_WIDTH = 8,
    parameter IP_NEUR_HIGHT = 8
    )(
    input clk_i, rst_n_i, data_ready_i, write_done_i, read_done_i,
    output rw_en en_A_o, en_B_o, en_C_o, en_K_o,

    ram_addr_port addr_A_o,
    ram_addr_port addr_B_o,
    ram_addr_port addr_C_o,
    ram_addr_port addr_K_o,
    
    input   rw_en       en_A_i,  en_BK_i,
    input               BK_sel_i [2],
    
    output [1:0] state_o,
    output accel_rst_o, accel_done_o, accel_ready_o
    );
    
    
    rw_en                     en_A, en_B, en_C, en_K;
    
    logic                     accel_rst, accel_done, accel_ready;

    
    struct {
        logic [($clog2(IP_NEUR_WIDTH)):0] x;
        logic [($clog2(IP_NEUR_HIGHT))-1:0] y;
    } addr_A;
    
    struct {
        logic [($clog2(OP_NEUR_WIDTH))-1:0] x;
        logic [($clog2(IP_NEUR_WIDTH)):0] y;
    } addr_B;
    
    struct {
        logic [($clog2(OP_NEUR_WIDTH))-1:0] x;
        logic [($clog2(IP_NEUR_HIGHT)):0] y;
    } addr_K;
    
    struct {
        logic [($clog2(OP_NEUR_WIDTH))-1:0] x;
        logic [($clog2(IP_NEUR_HIGHT)):0] y;
    } addr_C;
    

    
    
    reg [$clog2(IP_NEUR_WIDTH):0] accum_counter;

    localparam IDLE        = 2'h0    ;
    localparam LOAD        = 2'h1    ;
    localparam CALC        = 2'h2    ;
    localparam MATRIX_DONE = 2'h3    ;
    
    reg [1:0] state, nxt_state ;
    
    assign state_o = state;
    
    enum {ACCUMULATE, WAIT, STORE} accum_state, accum_nxt_state;

    assign en_A_o  =   en_A   ;
    assign en_B_o  =   en_B   ;
    assign en_C_o  =   en_C    ;
    assign en_K_o  =   en_K    ;

    
    assign addr_A_o.x   =   addr_A.x[$clog2(IP_NEUR_WIDTH)-1:0] ;
    assign addr_A_o.y   =   addr_A.y                            ;
    assign addr_B_o.x   =   addr_B.x                            ;
    assign addr_B_o.y   =   addr_B.y[$clog2(IP_NEUR_WIDTH)-1:0] ;
    
    assign addr_C_o.x   =   addr_C.x    ;
    assign addr_C_o.y   =   addr_C.y[($clog2(IP_NEUR_HIGHT))-1:0]    ;    
    
    assign addr_K_o.x   =   addr_C.x    ;
    assign addr_K_o.y   =   addr_C.y[($clog2(IP_NEUR_HIGHT))-1:0]    ;
    
    assign accel_rst_o      = accel_rst     ;
    assign accel_done_o     = accel_done    ;
    assign accel_ready_o    = accel_ready   ;

   
// always @(*) begin
always_latch begin
        if (!rst_n_i) begin
            nxt_state       <=  IDLE    ;
            accum_state <=  ACCUMULATE  ;
        end else begin
            case(nxt_state)
                IDLE : begin
                    accum_state <=  ACCUMULATE  ;
                    if (data_ready_i) 
                        nxt_state   <=  LOAD    ;
                end
                LOAD : begin
                    if (write_done_i)
                        nxt_state <= CALC;
                end
                CALC : begin
                    case (accum_state)
                        ACCUMULATE : begin
                            if ((accum_counter==(IP_NEUR_WIDTH))) 
                                accum_state <= WAIT    ;
                        end 
                        WAIT : begin
                            if ((accum_counter==(IP_NEUR_WIDTH+1))) 
                                accum_state <= STORE    ;
                        end
                        STORE : begin
                                    // if ((addr_C_cell == (OP_NEUR_WIDTH*IP_NEUR_HIGHT)) ) 
                                    if ( (addr_C.x == 'h0) && (addr_C.y ==(IP_NEUR_HIGHT)) ) 
                                        nxt_state <= MATRIX_DONE;
                                    else 
                                        accum_state <= ACCUMULATE;
                        end
                        default: accum_state <= accum_state;
                     endcase
                end
                MATRIX_DONE : begin
                    accum_state <=  ACCUMULATE  ;
                    if(read_done_i)
                        nxt_state <= IDLE;
                end
                default : begin
                    nxt_state <= IDLE;
                    accum_state <=  ACCUMULATE  ;
                end
            endcase    
        end
    end
    
            
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i) begin
            state       <=  IDLE        ;
            // accum_state <=  ACCUMULATE  ;
        end else begin
            state       <=  nxt_state       ;
            // accum_state <=  accum_nxt_state ;
        end
    end
    
       
always_comb begin
        if (!rst_n_i) begin
            accel_ready =  1'b0    ;
            accel_done  =  1'b0    ;
            accel_rst   =  1'b1    ;
            en_A        =  '{re: 1'b0, we: 1'b0};            
            en_B        =  '{re: 1'b0, we: 1'b0};
            en_C        =  '{re: 1'b0, we: 1'b0};
            en_K        =  '{re: 1'b0, we: 1'b0};
            
            addr_A      = '{x: 1'b0, y: 1'b0}   ;
            addr_B      = '{x: 1'b0, y: 1'b0}   ;
            
        end else begin
            case(state)
                IDLE : begin
                    accel_ready =  1'b1    ;
                    accel_done  =  1'b0    ;
                    accel_rst   =  1'b1    ;
                    en_A        =  '{re: 1'b0, we: 1'b0};
                    en_C        =  '{re: 1'b0, we: 1'b0};
                    addr_A      =   '{x: 1'b0, y: 1'b0}   ;
                    addr_B      =   '{x: 1'b0, y: 1'b0}   ;
                    
                    if      ( BK_sel_i[0] ) begin
                        en_B    =   en_BK_i ;
                        en_K    =   '{re: 1'b0, we: 1'b0};
                    end else if ( BK_sel_i[1] ) begin
                        en_B    =   '{re: 1'b0, we: 1'b0};
                        en_K    =   en_BK_i;
                    end else begin
                        en_B    =  '{re: 1'b0, we: 1'b0};
                        en_K    =  '{re: 1'b0, we: 1'b0};
                    end
                end
                LOAD : begin
                    accel_ready =   1'b0    ;
                    accel_done  =   1'b0    ;
                    accel_rst   =   1'b1    ;
                    en_A        =   en_A_i  ;
                    en_C        =   '{re: 1'b0, we: 1'b0};
                    en_B        =   '{re: 1'b0, we: 1'b0};
                    en_K        =   '{re: 1'b0, we: 1'b0};
                    addr_A      =   '{x: 1'b0, y: 1'b0}   ;
                    addr_B      =   '{x: 1'b0, y: 1'b0}   ;
                end
                CALC : begin
                    accel_ready =  1'b0     ;
                    accel_done  =  1'b0     ;
                    

                    case (accum_state)
                        ACCUMULATE : begin
                            en_A        =  '{re: 1'b1, we: 1'b0};
                            en_B        =  '{re: 1'b1, we: 1'b0};
                            en_C        =  '{re: 1'b0, we: 1'b0};
                            en_K        =  '{re: 1'b0, we: 1'b0};
                            
                            addr_A      = '{   x: accum_counter,    y: addr_C.y                }   ;
                            addr_B      = '{   x: addr_C.x               ,    y: accum_counter }   ;
                            if ((accum_counter==0)) 
                                accel_rst   =  1'b1;
                            else
                                accel_rst   =  1'b0;
                        end 
                        WAIT : begin
                            en_A        =  '{re: 1'b0, we: 1'b0};
                            en_B        =  '{re: 1'b0, we: 1'b0};
                            en_C        =  '{re: 1'b0, we: 1'b0};
                            en_K        =  '{re: 1'b1, we: 1'b0};
                            
                            addr_A      = '{   x: 'h0, y: 'h0}   ;
                            addr_B      = '{   x: 'h0, y: 'h0}   ;
                        
                        end
                        
                        
                        STORE : begin
                            en_C        =  '{re: 1'b0, we: 1'b1};
                            en_K        =  '{re: 1'b0, we: 1'b0};
                            accel_rst   = 1'b1    ;
                        end
                        default : begin
                            accel_rst   =  1'b0            ;
                            en_A        =  '{re: 1'b0, we: 1'b0};
                            en_B        =  '{re: 1'b0, we: 1'b0};
                            en_C        =  '{re: 1'b0, we: 1'b0};
                            en_K        =  '{re: 1'b0, we: 1'b0};
                            addr_A      =  '{x: 'h0, y: 'h0}   ;
                            addr_B      =  '{x: 'h0, y: 'h0}   ;
                        end
                    endcase  
                end
                MATRIX_DONE : begin
                    accel_ready =   1'b0    ;
                    accel_done  =   1'b0    ;
                    accel_rst   =   1'b1    ;
                    en_A        =  '{re: 1'b0, we: 1'b0};            
                    en_B        =  '{re: 1'b0, we: 1'b0};
                    en_K        =  '{re: 1'b0, we: 1'b0};
                    en_C        =  '{re: 1'b1, we: 1'b0};
                    addr_A      = '{x: 1'b0, y: 1'b0}   ;
                    addr_B      = '{x: 1'b0, y: 1'b0}   ;
                    accel_done  = 1'b1;
                end
                default : begin
                    accel_ready =   'h0;
                    accel_done  =   'h0;
                    accel_rst   =   'h0;
                    en_A        =  '{re: 1'b0, we: 1'b0 }   ;            
                    en_B        =  '{re: 1'b0, we: 1'b0 }   ;
                    en_K        =  '{re: 1'b0, we: 1'b0 }   ;
                    en_C        =  '{re: 1'b0, we: 1'b0 }   ;
                    addr_A      =  '{x: 1'b0, y: 1'b0   }   ;
                    addr_B      =  '{x: 1'b0, y: 1'b0   }   ;
                end
            endcase    
        end
    end
    
    
    
    
    
        
    always_ff @(posedge clk_i, negedge rst_n_i) begin
        if (!rst_n_i) begin
            accum_counter   <=  'h0 ;
            addr_C          <=  '{x:'h0,y:'h0} ;
        end
        else begin 
            case(state)
                IDLE : begin
                    accum_counter   <=  'h0 ;
                    addr_C          <=  '{x:'h0,y:'h0} ;
                end
                LOAD : begin
                    accum_counter   <=  'h0 ;
                    addr_C          <=  '{x:'h0,y:'h0} ;
                end
                CALC : begin
                    case (accum_state)
                        ACCUMULATE, WAIT : begin
                            accum_counter   <= accum_counter+1    ;
                            addr_C          <= addr_C;
                        end
                        STORE : begin
                            accum_counter   <= 'h0          ;
                            if (addr_C.x == OP_NEUR_WIDTH-1)
                                addr_C      <=  '{x:'h0,y: (addr_C.y + 1'b1)} ;
                            else
                                addr_C.x    <= addr_C.x + 1'b1;
                                
                        end
                    endcase  
                end
                MATRIX_DONE : begin
                    accum_counter   <=  'h0 ;
                    addr_C          <=  '{x:'h0,y:'h0} ;
                end
                default : begin
                    accum_counter   <=  'h0      ;
                    addr_C          <=  '{x:'h0,y:'h0} ;
                end
            endcase
        end
    end
        
endmodule
