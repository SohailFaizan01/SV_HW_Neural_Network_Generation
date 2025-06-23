`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2025 03:11:44 PM
// Design Name: 
// Module Name: accel_tb
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
import cfg_param::*;


module accel_tb;

reg clk, rst_n;


 initial begin
    $display($time, " << Starting the Simulation >>");
    clk     = 1'b0; // at time 0
    rst_n      = 1'b0; // reset is active
    #20 rst_n  = 1'b1; // at time 20 release reset
 end
 
    always # 10 clk = ~clk;
//____________________________________________________________________________________________________________  
//____________________________________________________________________________________________________________  
//____________________________________________________________________________________________________________  
    
    
    
    
     logic [7:0] in[0:2][0:7] =
    '{
        '{8'd244,8'd079,8'd122,8'd027,8'd165,8'd011,8'd146,8'd060},
		'{8'd219,8'd114,8'd095,8'd245,8'd049,8'd056,8'd155,8'd124},
		'{8'd142,8'd192,8'd187,8'd060,8'd125,8'd082,8'd079,8'd244}
    };


    reg mult_out_reference[0:2][0:6] =
    '{ 
  '{1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1},
  '{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0},
  '{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0}
}; // Custom ARGMAX OP test



    logic   [1:0]    init_array_wt_0   [IP_NEUR_WIDTH[0]*OP_NEUR_WIDTH[0]]     ;
    logic   [1:0]    init_array_wt_1   [IP_NEUR_WIDTH[1]*OP_NEUR_WIDTH[1]]     ;
    logic   [1:0]    init_array_wt_2   [IP_NEUR_WIDTH[2]*OP_NEUR_WIDTH[2]]     ;
    
    logic   [31:0]    init_array_bias_0  [IP_NEUR_HIGHT[0]*OP_NEUR_WIDTH[0]]     ; 
    logic   [31:0]    init_array_bias_1  [IP_NEUR_HIGHT[1]*OP_NEUR_WIDTH[1]]     ; 
    logic   [31:0]    init_array_bias_2  [IP_NEUR_HIGHT[2]*OP_NEUR_WIDTH[2]]     ; 
    

    logic   [31:0]    init_array_bias [NUMBER_OF_LAYERS][]     ; 
    logic   [1:0]    wt              [NUMBER_OF_LAYERS][][]    ;
    logic   [1:0]    init_array_wt   [NUMBER_OF_LAYERS][]     ;
    
    
    logic   [31:0]    bias            [NUMBER_OF_LAYERS][][]    ;
    logic   [31:0]    init_array_bias [NUMBER_OF_LAYERS][]     ; 

    


// localparam string WEIGHTS_FILE  [0:NUMBER_OF_LAYERS-1] = '{ "wght.txt" , "wght2.txt" , "wght3.txt" }    ; //Vivado is shit
// localparam string BIASES_FILE   [0:NUMBER_OF_LAYERS-1] = '{ "bias0.txt" , "bias0.txt" , "bias0.txt" }   ; //Vivado is shit
    
    
    
initial begin


    for (int j=0; j<NUMBER_OF_LAYERS; j++) begin
        wt[j]               = new[IP_NEUR_WIDTH[j]] ;  
        bias[j]             = new[IP_NEUR_HIGHT[j]] ;          
        init_array_wt[j]    = new[IP_NEUR_WIDTH[j]*OP_NEUR_WIDTH[j]]    ;
        init_array_bias[j]  = new[IP_NEUR_HIGHT[j]*OP_NEUR_WIDTH[j]]    ;
        for (int i = 0; i < IP_NEUR_WIDTH[j]; i++) 
            wt[j][i]   = new[OP_NEUR_WIDTH[j]];  
        for (int i = 0; i < IP_NEUR_HIGHT[j]; i++) 
            bias[j][i] = new[OP_NEUR_WIDTH[j]];  
    end
    
    
//_______________________Vivado Workaround_______________________________________________        
        $readmemb("wght.txt",  init_array_wt_0);
        $readmemb("wght2.txt", init_array_wt_1);
        $readmemb("wght3.txt", init_array_wt_2);
        
        $readmemh("bias0.txt", init_array_bias_0);
        $readmemh("bias0.txt", init_array_bias_1);
        $readmemh("bias0.txt", init_array_bias_2);
        
        init_array_wt[0]     = init_array_wt_0      ;
        init_array_wt[1]     = init_array_wt_1      ;
        init_array_wt[2]     = init_array_wt_2      ;
        
        init_array_bias[0]   = init_array_bias_0    ;
        init_array_bias[1]   = init_array_bias_1    ;
        init_array_bias[2]   = init_array_bias_2    ;
//_______________________Vivado Workaround_______________________________________________        
        
        
        
    for (int i = 0; i < NUMBER_OF_LAYERS; i++) begin
        // $readmemb(WEIGHTS_FILE[i], init_array_wt[i]); //Vivado is shit
        // $readmemh(BIASES_FILE [i], init_array_bias[i]); //Vivado is shit
        
        for (int x = 0; x<OP_NEUR_WIDTH[i]; x++) begin
            for (int y = 0; y<IP_NEUR_WIDTH[i]; y++)
                wt[i][y][x] = init_array_wt[i][y+IP_NEUR_WIDTH[i]*x];
        end
        
        
        for (int x = 0; x<OP_NEUR_WIDTH[i]; x++) begin
            for (int y = 0; y<IP_NEUR_HIGHT[i]; y++)
                bias[i][y][x] = init_array_bias[i][y+IP_NEUR_HIGHT[i]*x];
        end
    end
        
end



    


    logic [0:0] mult_out[0:2][0:6] = '{default:'h0};


    logic             data_ready, write_done, read_done ;

    logic            accel_ready, accel_done ;

    logic    rd_C                    ;
    
    
    enum logic [2:0] {IDLE, WRITE, WAIT_CALC, READ, VERIFY} state, nxt_state;
    
ip_data_port data_port_A    ;
ip_bswt_port bswt_port_B    ;
op_addr_port addr_C         ;
    
task automatic write_bias_2d(
    ref ip_bswt_port port,
    input logic [$clog2(NUMBER_OF_LAYERS)-1:0]    lyr_sel,
    input logic [1:0]                             BK_sel ,
    input logic [31:0]                            bias_matrix [][]
);
    int X = bias_matrix[0].size();
    int Y = bias_matrix.size();
    for (int y = 0; y < Y; y++) begin
        for (int x = 0; x < X; x++) begin
            @(posedge clk);
            port.x       = x;
            port.y       = y;
            port.data    = bias_matrix[y][x];
            port.en      = '{re:1'b0, we:1'b1};
            port.lyr_sel = lyr_sel;
            port.BK_sel[0]  = BK_sel[0];
            port.BK_sel[1]  = BK_sel[1];
        end
    end
    @(posedge clk);
    port.en = '{re:1'b0, we:1'b0};  // disable write after done
endtask    
    
task automatic write_wght_2d(
    ref ip_bswt_port port,
    input logic [$clog2(NUMBER_OF_LAYERS)-1:0]    lyr_sel,
    input logic [1:0]                             BK_sel ,
    input logic [1:0]                     wght_matrix [][]
);
    int X = wght_matrix[0].size();
    int Y = wght_matrix.size();
    for (int y = 0; y < Y; y++) begin
        for (int x = 0; x < X; x++) begin
            @(posedge clk);
            port.x       = x;
            port.y       = y;
            port.data    = wght_matrix[y][x];
            port.en      = '{re:1'b0, we:1'b1};
            port.lyr_sel = lyr_sel;
            port.BK_sel[0]  = BK_sel[0];
            port.BK_sel[1]  = BK_sel[1];
        end
    end
    @(posedge clk);
    port.en = '{re:1'b0, we:1'b0};  // disable write after done
endtask    


task automatic write_data_2d(
    ref ip_data_port port,
    input logic [7:0] data_matrix [][]
);
    int X = data_matrix[0].size();
    int Y = data_matrix.size();
    for (int y = 0; y < Y; y++) begin
        for (int x = 0; x < X; x++) begin
            @(posedge clk);
            port.x       = x;
            port.y       = y;
            port.data    = data_matrix[y][x];
            port.en      = '{re:1'b0, we:1'b1};
        end
    end
    @(posedge clk);
    port.en = '{re:1'b0, we:1'b0};  // disable write after done
endtask
 
    
task automatic read_data_2d(
    ref op_addr_port port     ,
    // ref logic rd              ,
    ref logic [0:0] output_reg [0:2][0:6] 
);
    int X = 7;
    int Y = 3;
    for (int y = 0; y < Y; y++) begin
        for (int x = 0; x < X; x++) begin
            @(posedge clk);
            port.x       = x;
            port.y       = y;
            @(posedge clk);
            @(posedge clk);
            output_reg[y][x]   = rd_C ;    
        end
    end
endtask
 

        
    always_comb begin
        if (!rst_n) begin
            data_ready  <= 1'b0 ;
            write_done  <= 1'b0 ; 
            read_done   <= 1'b0 ;
        end else begin
            case (state)
                IDLE: begin
                    data_ready  <= 1'b0 ;
                    write_done  <= 1'b0 ; 
                    read_done   <= 1'b0 ;
                end
                WRITE: begin
                    data_ready  <= 1'b1         ;

                end
                WAIT_CALC: begin
                    data_ready  <= 1'b0 ;
                    write_done  <= 1'b1 ;
                end
                READ: begin
                    write_done <= 1'b0;
                    
                end
                VERIFY: begin
                    read_done   <= 1'b1;
                end
                
            endcase
        end
    end
    
    
    
    
    
    
    
    logic [$clog2(NUMBER_OF_LAYERS)-1:0] j;
    
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            mult_out <= '{default:'h0};
            state   <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    mult_out <= '{default:'h0};
                    if (accel_ready) begin

                        for (j=0;j<NUMBER_OF_LAYERS;j++) begin
                            write_wght_2d (
                            .port (bswt_port_B),
                            .lyr_sel (j),
                            .BK_sel  (2'b01),
                            .wght_matrix (wt[j])
                            );
        
                            write_bias_2d (
                            .port (bswt_port_B),
                            .lyr_sel (j),
                            .BK_sel  (2'b10),
                            .bias_matrix (bias[j])
                            );
                        end
                    
                        state <= WRITE;
                    end
                end
                WRITE: begin
                    write_data_2d(
                        .port(data_port_A),
                        .data_matrix (in)
                        );
                    state <= WAIT_CALC;
                end
                WAIT_CALC: begin
                    
                    if (accel_done) 
                        state <= READ;
                end
                READ: begin
                    read_data_2d(
                        .port(addr_C)     ,
                        // .rd(rd_C)              ,
                        .output_reg (mult_out) 
                    );
                    state <= VERIFY;
                end
                VERIFY: begin
                    if (mult_out == mult_out_reference) begin
                            $display($time, " << Simulation Complete - Successful >>");
                            $stop;
                            state <= IDLE;
                        end else begin
                            $display($time, " << Simulation Failed >>");
                            $stop;
                        end  
                end
            endcase         
        end
    end
BNN_wrapper
    mmul_accel(
    .clk_i          ( clk           ), 
    .rst_n_i        ( rst_n         ),
    .data_ready_i   ( data_ready    ), 
    .write_done_i   ( write_done    ), 
    .read_done_i    ( read_done     ),
    .module_data_port_i ( data_port_A        ), 
    .module_bswt_port_i ( bswt_port_B        ),
    .addr_C_i           ( addr_C        ),

    .wd_C_i         ( 'h0           ),
    .rd_C_o         ( rd_C          ),
    .accel_done_o   ( accel_done    ), 
    .accel_ready_o  ( accel_ready   )
    );   
    
endmodule
