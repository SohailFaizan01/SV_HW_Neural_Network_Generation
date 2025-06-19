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





module accel_tb;

reg clk, rst_n;


 initial begin
    $display($time, " << Starting the Simulation >>");
    clk     = 1'b0; // at time 0
    rst_n      = 1'b0; // reset is active
    #20 rst_n  = 1'b1; // at time 20 release reset
 end
 
    always # 10 clk = ~clk;


    
 
    
    reg [7:0] in1[0:2][0:7] =
    '{
        '{8'd244,8'd079,8'd122,8'd027,8'd165,8'd011,8'd146,8'd060},
		'{8'd219,8'd114,8'd095,8'd245,8'd049,8'd056,8'd155,8'd124},
		'{8'd142,8'd192,8'd187,8'd060,8'd125,8'd082,8'd079,8'd244}
		// '{8'd233,8'd074,8'd101,8'd019,8'd163,8'd091,8'd183,8'd212},
		// '{8'd127,8'd094,8'd034,8'd060,8'd002,8'd029,8'd148,8'd246},
		// '{8'd164,8'd244,8'd207,8'd066,8'd062,8'd009,8'd162,8'd169},
		// '{8'd025,8'd187,8'd025,8'd096,8'd043,8'd126,8'd065,8'd051},
		// '{8'd007,8'd101,8'd208,8'd116,8'd196,8'd156,8'd037,8'd006}
    };


    reg [0:0] in2[0:7][0:6] =
    '{
		'{1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1},
		'{1'b0,1'b1,1'b1,1'b0,1'b1,1'b1,1'b0},
		'{1'b1,1'b0,1'b1,1'b0,1'b0,1'b1,1'b0},
		'{1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0},
		'{1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1},
		'{1'b0,1'b1,1'b0,1'b1,1'b1,1'b0,1'b1},
		'{1'b1,1'b0,1'b0,1'b1,1'b0,1'b1,1'b1},
		'{1'b0,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0}
    };         
    reg [0:0] in3[0:6][0:6] =
    '{
		'{1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1},
		'{1'b0,1'b1,1'b1,1'b0,1'b1,1'b1,1'b0},
		'{1'b1,1'b0,1'b1,1'b0,1'b0,1'b1,1'b0},
		'{1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0},
		'{1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1},
		'{1'b0,1'b1,1'b0,1'b1,1'b1,1'b0,1'b1},
		'{1'b1,1'b0,1'b0,1'b1,1'b0,1'b1,1'b1}
    };         

    
    reg mult_out_reference_l1[0:2][0:6] =
	'{ 
  '{1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1},
  '{1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0},
  '{1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0}
};
//______________________________________________________________________
  // BNN test - pass, wght_2 file data
//______________________________________________________________________
    // reg mult_out_reference[0:2][0:6] =
	// '{ 
  // '{1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1},
  // '{1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0},
  // '{1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0}
// }; 

// 1 0 1 0 1 0 1 
// 0 1 0 1 0 1 0 
// 1 1 1 1 0 0 0 
// 0 0 0 0 1 1 1 
// 1 1 0 0 1 1 0 
// 1 1 1 0 0 0 1 
// 1 0 0 0 1 1 1
//______________________________________________________________________

    reg mult_out_reference[0:2][0:6] =
    '{ 
  '{1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1},
  '{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0},
  '{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0}
}; // Custom ARGMAX test
     

     

    
// reg mult_out_reference[0:1][0:6] =
	// '{
        // '{1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1},  // Row 0
        // '{1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1}   // Row 1
    // };

reg mult_out[0:2][0:6] = '{default:'h0};

parameter IP_DATA_WIDTH = 8;
parameter IP_WGHT_WIDTH = 2;
parameter IP_NEUR_HIGHT = 3;
parameter IP_NEUR_WIDTH = 8;
parameter OP_NEUR_WIDTH = 7;

    reg             data_ready, write_done, read_done  ;
    reg     [6:0]   i,j                       ;
    // reg             clk_sync                       ;
    wire            accel_ready, accel_done ;
    // reg     [2:0]   addr_Ax ;
    // reg     [0:0]   addr_Ay           ;
    // reg     [2:0]   addr_Bx           ;
    // reg     [2:0]   addr_By           ;
    // reg     [2:0]   addr_Cx             ; 
    // reg     [0:0]   addr_Cy             ; 
    
    ram_addr_port #(.RAM_WIDTH (IP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_A();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_WIDTH)) addr_B();
    ram_addr_port #(.RAM_WIDTH (OP_NEUR_WIDTH), .RAM_HIGHT (IP_NEUR_HIGHT)) addr_C();
    
    reg     [IP_DATA_WIDTH-1:0]   wd_A              ;
    reg     [IP_WGHT_WIDTH-1:0]   wd_B              ;
    wire    rd_C                    ;
    
    int k,errors,correct;
    
    enum logic [2:0] {IDLE, WRITE, WAIT_CALC, READ, VERIFY} state, nxt_state;
    
    
    // always_ff @(posedge clk, negedge rst_n) begin
    
    
    
    
    
    always @(*) begin
        if (!rst_n) 
            nxt_state <= IDLE;
        else begin
            case (state)
                IDLE: begin       
                    #10
                    if (accel_ready)
                    nxt_state <= WRITE;  
                end
                WRITE: begin
                    if (i == 'd23)
                        nxt_state <= WAIT_CALC;
                end
                WAIT_CALC: begin

                    if (accel_done) 
                        nxt_state <= READ;
                end
                READ: begin

                    if (i == 'd21) //63 adresses + 1 for clk 
                        nxt_state   <= VERIFY   ;
                end
                VERIFY: begin

                    if (i == 'h1) begin
                        if (errors == 'h0) begin
                            $display($time, " << Simulation Complete - Successful >>");
                            $stop;
                        end else begin
                            $display($time, " << Simulation Failed >>", errors);
                            $stop;
                        end  
                    end
                end
                default : nxt_state <= nxt_state;
                
            endcase
        end
    end
    
    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) 
            state <= IDLE;
        else
            state <= nxt_state;
    end
        
    always_comb begin
        if (!rst_n) begin
            data_ready  <= 1'b0 ;
            write_done  <= 1'b0 ; 
            read_done   <= 1'b0 ;
            addr_A.x    <= 'h0 ;
            addr_A.y    <= 'h0 ;
            addr_B.x    <= 'h0 ;
            addr_B.y    <= 'h0 ;
            addr_C.x    <= 'h0 ;
            addr_C.y    <= 'h0 ;
            wd_A        <=  'h0 ;
            wd_B        <=  'h0 ;
            // errors      <=  'h0 ;
            // i           <=  'h0 ;
        // mult_out <= '{default:'h0};
        end else begin
            case (state)
                IDLE: begin
                    // i <= 'h0;
                    data_ready  <= 1'b0 ;
                    write_done  <= 1'b0 ; 
                    read_done   <= 1'b0 ;

                    // errors      <=  'h0 ;
                    

                end
                WRITE: begin
                    data_ready  <= 1'b1         ;
                    

                end
                WAIT_CALC: begin
                    data_ready  <=  'h0 ;
                    write_done  <= 1'b1 ;
                end
                READ: begin
                    write_done <= 1'b0;
                    addr_C.x <= i%7;
                    addr_C.y <= i/7;
                    
                end
                VERIFY: begin
                    read_done   <= 1'b1;
                    
                end
                
            endcase
        end
    end
    
    
    
    
    
    
    
    
    
    
    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            i   <=  'h0;
            mult_out <= '{default:'h0};
        end
        else begin
            case (state)
                IDLE: begin
                    i   <= 'h0;
                    mult_out <= '{default:'h0};
                    
                    addr_A.x     <= 'h0 ;
                    addr_A.y     <= 'h0 ;
                    addr_B.x     <= 'h0 ;
                    addr_B.y     <= 'h0 ;
                    addr_C.x     <= 'h0 ;
                    addr_C.y     <= 'h0 ;
                    wd_A        <=  'h0 ;
                    wd_B        <=  'h0 ;
                end
                WRITE: begin
                    i   <= i+1;
                    mult_out <= '{default:'h0};
                    
                    addr_A.x    <= (i[3:0]%8)  ;
                    addr_A.y    <= (i[4:0]/8)  ;
                    addr_B.x    <= (i[5:0]%7)  ;
                    addr_B.y    <= (i[5:0]/7)  ;
                    wd_A        <= in1[i[4:0]/8][i[3:0]%8]    ;
                    wd_B        <= in2[i/7][i%7]    ;
                    addr_C.x    <= i%7                ;
                    addr_C.y    <= i/7                ;

                end
                WAIT_CALC: begin
                    i   <= 'h0;
                    mult_out <= '{default:'h0};
                    
                    addr_A.x     <= 'h0 ;
                    addr_A.y     <= 'h0 ;
                    addr_B.x     <= 'h0 ;
                    addr_B.y     <= 'h0 ;
                    addr_C.x     <= 'h0 ;
                    addr_C.y     <= 'h0 ;
                    wd_A         <=  'h0 ;
                    wd_B         <=  'h0 ;
                end
                READ: begin
                    i   <= i+1;
                    j<= i; // 1 cycle delay of data from address
                    mult_out[(j)/7][(j)%7]<= rd_C;
                    
                end
                VERIFY: begin
                    i   <= i-1;
                    mult_out <= mult_out;
                    
                    addr_C.x     <= 'h0 ;
                    addr_C.y     <= 'h0 ;
                    
                    
                    if (mult_out[(i-2)/7][(i-2)%7] != mult_out_reference[((i-2)/7)][((i-2)%7)])
                            errors = errors + 1;
                    else correct = correct+1;
                end
            endcase         
        end
    end
    
BNN_wrapper
#(
    .IP_DATA_WIDTH (8 ),
    .IP_WGHT_WIDTH (2 ),
    .IP_NEUR_HIGHT (3 ),
    .IP_NEUR_WIDTH (8 ),
    .OP_NEUR_WIDTH (7 )
    )
    mmul_accel(
    .clk_i          ( clk           ), 
    .rst_n_i        ( rst_n         ),
    .data_ready_i   ( data_ready    ), 
    .write_done_i   ( write_done    ), 
    .read_done_i    ( read_done     ),
    .wght_mod_i     ( 1'b0          ),
    
    .addr_A_i       ( addr_A        ), 
    .addr_B_i       ( addr_B        ),
    .addr_C_i       ( addr_C        ),
    
    .wd_A_i         ( wd_A          ), 
    .wd_B_i         ( wd_B          ),
    .wd_C_i         ( 'h0           ),
    .rd_C_o         ( rd_C          ),
    .accel_done_o   ( accel_done    ), 
    .accel_ready_o  ( accel_ready   )
    );   
    
endmodule
