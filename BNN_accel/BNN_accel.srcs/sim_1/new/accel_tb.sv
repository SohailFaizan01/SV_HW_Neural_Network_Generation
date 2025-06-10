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



    
 
    
    // reg [7:0] in1[0:7][0:7] =
    // '{
        // '{8'd244,8'd079,8'd122,8'd027,8'd165,8'd011,8'd146,8'd060},
		// '{8'd219,8'd114,8'd095,8'd245,8'd049,8'd056,8'd155,8'd124},
		// '{8'd142,8'd192,8'd187,8'd060,8'd125,8'd082,8'd079,8'd244},
		// '{8'd233,8'd074,8'd101,8'd019,8'd163,8'd091,8'd183,8'd212},
		// '{8'd127,8'd094,8'd034,8'd060,8'd002,8'd029,8'd148,8'd246},
		// '{8'd164,8'd244,8'd207,8'd066,8'd062,8'd009,8'd162,8'd169},
		// '{8'd025,8'd187,8'd025,8'd096,8'd043,8'd126,8'd065,8'd051},
		// '{8'd007,8'd101,8'd208,8'd116,8'd196,8'd156,8'd037,8'd006}
    // };
 
    
    reg [7:0] in1[0:1][0:7] =
    '{
        '{8'd244,8'd079,8'd122,8'd027,8'd165,8'd011,8'd146,8'd060},
		'{8'd219,8'd114,8'd095,8'd245,8'd049,8'd056,8'd155,8'd124}
		// '{8'd142,8'd192,8'd187,8'd060,8'd125,8'd082,8'd079,8'd244},
		// '{8'd233,8'd074,8'd101,8'd019,8'd163,8'd091,8'd183,8'd212},
		// '{8'd127,8'd094,8'd034,8'd060,8'd002,8'd029,8'd148,8'd246},
		// '{8'd164,8'd244,8'd207,8'd066,8'd062,8'd009,8'd162,8'd169},
		// '{8'd025,8'd187,8'd025,8'd096,8'd043,8'd126,8'd065,8'd051},
		// '{8'd007,8'd101,8'd208,8'd116,8'd196,8'd156,8'd037,8'd006}
    };

    // reg [7:0] in2[0:7][0:7] =
    // '{
		// '{8'd013,8'd192,8'd234,8'd012,8'd176,8'd242,8'd214,8'd155},
		// '{8'd114,8'd052,8'd080,8'd180,8'd128,8'd248,8'd067,8'd068},
		// '{8'd039,8'd196,8'd080,8'd193,8'd066,8'd166,8'd238,8'd044},
		// '{8'd152,8'd087,8'd148,8'd028,8'd141,8'd124,8'd251,8'd189},
		// '{8'd006,8'd200,8'd132,8'd199,8'd251,8'd129,8'd095,8'd058},
		// '{8'd252,8'd051,8'd134,8'd112,8'd229,8'd062,8'd167,8'd110},
		// '{8'd070,8'd053,8'd108,8'd210,8'd044,8'd084,8'd083,8'd171},
		// '{8'd254,8'd159,8'd237,8'd221,8'd100,8'd253,8'd095,8'd075}
    // };
    reg [7:0] in2[0:7][0:6] =
    '{
		'{8'd013,8'd192,8'd234,8'd012,8'd176,8'd242,8'd214},
		'{8'd114,8'd052,8'd080,8'd180,8'd128,8'd248,8'd067},
		'{8'd039,8'd196,8'd080,8'd193,8'd066,8'd166,8'd238},
		'{8'd152,8'd087,8'd148,8'd028,8'd141,8'd124,8'd251},
		'{8'd006,8'd200,8'd132,8'd199,8'd251,8'd129,8'd095},
		'{8'd252,8'd051,8'd134,8'd112,8'd229,8'd062,8'd167},
		'{8'd070,8'd053,8'd108,8'd210,8'd044,8'd084,8'd083},
		'{8'd254,8'd159,8'd237,8'd221,8'd100,8'd253,8'd095}
    };

    // reg [19:0] mult_out_reference[0:7][0:7] =
	// '{
		 // '{20'd050262,20'd128056,20'd130414,20'd119437,20'd121273,20'd151651,20'd128652,20'd093909},
		 // '{20'd113540,20'd128498,20'd164326,20'd124320,20'd138294,20'd181605,20'd177261,20'd136989},
		 // '{20'd129067,20'd151285,20'd166276,20'd178608,20'd148399,20'd210039,20'd158124,20'd102713},
		 // '{20'd108860,20'd150681,20'd175052,20'd164052,20'd150829,20'd189537,20'd149638,20'd115839},
		 // '{20'd102977,20'd089993,20'd127274,20'd115778,20'd083343,20'd143856,20'd097315,20'd085977},
		 // '{20'd104959,20'd138806,20'd151163,20'd172402,20'd124715,20'd207667,20'd154170,20'd108557},
		 // '{20'd086724,20'd054356,20'd078685,20'd089063,20'd091129,20'd100202,20'd083292,20'd067129},
		 // '{20'd081951,20'd107527,20'd095720,20'd127228,20'd131392,20'd115236,20'd135198,20'd074334}
    // };    
    
    reg [19:0] mult_out_reference[0:1][0:6] =
	'{
		 '{20'd050262,20'd128056,20'd130414,20'd119437,20'd121273,20'd151651,20'd128652},
		 '{20'd113540,20'd128498,20'd164326,20'd124320,20'd138294,20'd181605,20'd177261}
		 // '{20'd129067,20'd151285,20'd166276,20'd178608,20'd148399,20'd210039,20'd158124},
		 // '{20'd108860,20'd150681,20'd175052,20'd164052,20'd150829,20'd189537,20'd149638},
		 // '{20'd102977,20'd089993,20'd127274,20'd115778,20'd083343,20'd143856,20'd097315},
		 // '{20'd104959,20'd138806,20'd151163,20'd172402,20'd124715,20'd207667,20'd154170},
		 // '{20'd086724,20'd054356,20'd078685,20'd089063,20'd091129,20'd100202,20'd083292},
		 // '{20'd081951,20'd107527,20'd095720,20'd127228,20'd131392,20'd115236,20'd135198}
    };

reg [19:0] mult_out[0:1][0:6] = '{default:'h0};


    reg             data_ready, write_done, read_done  ;
    reg     [2:0]   state                   ;
    reg     [6:0]   i                       ;
    // reg             clk_sync                       ;
    wire            accel_ready, accel_done ;
    reg     [2:0]   addr_Ax ;
    reg     [0:0]   addr_Ay           ;
    reg     [2:0]   addr_Bx           ;
    reg     [2:0]   addr_By           ;
    reg     [2:0]   addr_Cx             ; 
    reg     [0:0]   addr_Cy             ; 
    reg     [7:0]   wd_A, wd_B              ;
    wire    [19:0]  rd_C                    ;
    
    int k,errors,correct;
    
    parameter IDLE = 3'h0;
    parameter WRITE = 3'h1;
    parameter WAIT_CALC = 3'h2;
    parameter READ = 3'h3;
    parameter VERIFY = 3'h4;
    
    
    // always_ff @(posedge clk, negedge rst_n) begin
    always @(*) begin
        if (!rst_n) begin
            state       <= IDLE   ;
            data_ready  <= 1'b0 ;
            write_done  <= 1'b0 ; 
            read_done   <= 1'b0 ;
            addr_Ax      <= 'h0 ;
            addr_Ay      <= 'h0 ;
            addr_Bx      <= 'h0 ;
            addr_By      <= 'h0 ;
            addr_Cx      <= 'h0 ;
            addr_Cy      <= 'h0 ;
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
                    addr_Ax      <= 'h0 ;
                    addr_Ay      <= 'h0 ;
                    addr_Bx      <= 'h0 ;
                    addr_By      <= 'h0 ;
                    addr_Cx      <= 'h0 ;
                    addr_Cy      <= 'h0 ;
                    wd_A        <=  'h0 ;
                    wd_B        <=  'h0 ;
                    // errors      <=  'h0 ;
                    
                    #10
                    if (accel_ready)
                    state <= WRITE;  
                end
                WRITE: begin
                    data_ready  <= 1'b1         ;
                    addr_Ax      <= (i[3:0]%8)  ;
                    addr_Ay      <= (i[3:0]/8)  ;
                    addr_Bx      <= (i[5:0]%7)  ;
                    addr_By      <= (i[5:0]/7)  ;
                    wd_A        <= in1[i[3:0]/8][i[3:0]%8]    ;
                    wd_B        <= in2[i/7][i%7]    ;
                    addr_Cx      <= i%7                ;
                    addr_Cy      <= i/7                ;
                    // write_done  <= 1'b0 ;
                    if (i == 'd56)
                        state <= WAIT_CALC;
                end
                WAIT_CALC: begin
                    data_ready  <=  'h0 ;
                    addr_Ax      <= 'h0 ;
                    addr_Ay      <= 'h0 ;
                    addr_Bx      <= 'h0 ;
                    addr_By      <= 'h0 ;
                    addr_Cx      <= 'h0 ;
                    addr_Cy      <= 'h0 ;
                    wd_A        <=  'h0 ;
                    wd_B        <=  'h0 ;
                    write_done  <= 1'b1 ;
                    if (accel_done) 
                        state <= READ;
                end
                READ: begin
                    write_done <= 1'b0;
                    addr_Cx <= i%8;
                    addr_Cy <= i/8;
                    // mult_out[i/8][i%8]<= rd_C;
                    if (i == 'd16) //63 adresses + 1 for clk + 1 because 1 cycle read delay
                        state   <= VERIFY   ;
                end
                VERIFY: begin
                    read_done   <= 1'b1;
                    addr_Cx      <= 'h0 ;
                    addr_Cy      <= 'h0 ;
                    
                        
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
                default : state <= state;
                
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
                end
                WRITE: begin
                    i   <= i+1;
                    mult_out <= '{default:'h0};
                end
                WAIT_CALC: begin
                    i   <= 'h0;
                    mult_out <= '{default:'h0};
                end
                READ: begin
                    i   <= i+1;
                    mult_out[(i-1'b1)/8][(i-1'b1)%8]<= rd_C;
                end
                VERIFY: begin
                    i   <= i-1;
                    mult_out <= mult_out;
                    if (mult_out[(i-2)/7][(i-2)%7] != mult_out_reference[((i-2)/7)][((i-2)%7)])
                            errors = errors + 1;
                    else correct = correct+1;
                end
            endcase         
        end
    end
    
accel_wrapper
#(
    .IP_DATA_WIDTH (8 ),
    .OP_DATA_WIDTH (20),
    .WGHT_WIDTH    (8 ),
    .IP_NEUR_WIDTH (8 ),
    .OP_NEUR_WIDTH (7 ),
    .IP_NEUR_HIGHT (2 )
    )
    mmul_accel(
    .clk_i          (clk    ), 
    .rst_n_i        (rst_n  ),
    .data_ready_i   (data_ready), 
    .write_done_i   (write_done), 
    .read_done_i    (read_done),
    .addr_Ax_i   (addr_Ax     ), 
    .addr_Ay_i   (addr_Ay     ),
    .addr_Bx_i   (addr_Bx     ),
    .addr_By_i   (addr_By     ),
    .addr_Cx_i   (addr_Cx     ),
    .addr_Cy_i   (addr_Cy     ),
    .wd_A_i         (wd_A), 
    .wd_B_i         (wd_B),
    .wd_C_i         ('h0),
    .rd_C_o         (rd_C),
    .accel_done_o   (accel_done), 
    .accel_ready_o  (accel_ready)
    );   
    
endmodule
