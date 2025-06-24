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



    logic   [1:0]    init_array_wt_0   [IP_NEUR_WIDTH[0]*OP_NEUR_WIDTH[0]]     ;
    logic   [1:0]    init_array_wt_1   [IP_NEUR_WIDTH[1]*OP_NEUR_WIDTH[1]]     ;
    logic   [1:0]    init_array_wt_2   [IP_NEUR_WIDTH[2]*OP_NEUR_WIDTH[2]]     ;
    
    logic   [MAX_BSWT_WIDTH-1:0]    init_array_bias_0  [IP_NEUR_HIGHT[0]*OP_NEUR_WIDTH[0]]     ; 
    logic   [MAX_BSWT_WIDTH-1:0]    init_array_bias_1  [IP_NEUR_HIGHT[1]*OP_NEUR_WIDTH[1]]     ; 
    logic   [MAX_BSWT_WIDTH-1:0]    init_array_bias_2  [IP_NEUR_HIGHT[2]*OP_NEUR_WIDTH[2]]     ; 
    
    
    logic   [1:0]    wt              [NUMBER_OF_LAYERS][][]    ;
    logic   [1:0]    init_array_wt   [NUMBER_OF_LAYERS][]     ;
    
    
    logic   [MAX_BSWT_WIDTH-1:0]    bias            [NUMBER_OF_LAYERS][][]    ;
    logic   [MAX_BSWT_WIDTH-1:0]    init_array_bias [NUMBER_OF_LAYERS][]     ; 
 
 
 
    parameter string BSWT_DIR = "../../../../BNN_accel.srcs/sim_1/pruned_weights/"; // Or "C:/my_project/data/"
        
        string lyr_0_wght;
        string lyr_1_wght;
        string lyr_2_wght;
        
        string lyr_0_bias;
        string lyr_1_bias;
        string lyr_2_bias;
        
    
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

        $sformat(lyr_0_wght, "%sfc1_folded_weight_2bit.txt", BSWT_DIR);
        $sformat(lyr_1_wght, "%sfc2_folded_weight_2bit.txt", BSWT_DIR);
        $sformat(lyr_2_wght, "%sfc3_weight_2bit.txt", BSWT_DIR);

        $sformat(lyr_0_bias, "%sfc1_folded_bias_fixed.mem", BSWT_DIR);
        $sformat(lyr_1_bias, "%sfc2_folded_bias_fixed.mem", BSWT_DIR);
        $sformat(lyr_2_bias, "%sfc3_bias_fixed.mem", BSWT_DIR);
        
        
        $readmemb(lyr_0_wght, init_array_wt_0);
        $readmemb(lyr_1_wght, init_array_wt_1);
        $readmemb(lyr_2_wght, init_array_wt_2);
                  
        $readmemh(lyr_0_bias, init_array_bias_0);
        $readmemh(lyr_1_bias, init_array_bias_1);
        $readmemh(lyr_2_bias, init_array_bias_2);
        
        init_array_wt[0]     = init_array_wt_0      ;
        init_array_wt[1]     = init_array_wt_1      ;
        init_array_wt[2]     = init_array_wt_2      ;
        
        init_array_bias[0]   = init_array_bias_0    ;
        init_array_bias[1]   = init_array_bias_1    ;
        init_array_bias[2]   = init_array_bias_2    ;
//_______________________Vivado Workaround_______________________________________________        
        
        
        
    for (int i = 0; i < NUMBER_OF_LAYERS; i++) begin
        
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



//____________________________________________________________________________________________________________
//#################################################Signal Declaration#########################################
//____________________________________________________________________________________________________________

    // logic [0:0] mult_out[0:2][0:6] = '{default:'h0};
    logic [0:0] inf_out[1][10] = '{default:'h0};

    logic             data_ready, write_done, read_done ;

    logic            accel_ready, accel_done ;

    logic    rd_C                    ;
    
    
    enum logic [2:0] {IDLE, WRITE, WAIT_CALC, READ, VERIFY} state, nxt_state;
    
ip_data_port data_port_A    ;
ip_bswt_port bswt_port_B    ;
op_addr_port addr_C         ;
    
    
    logic [IP_DATA_WIDTH[0]-1:0]   ip_img  [1][0:783]  ;
    logic [15:0]   ip_lbl           ;
    logic [15:0]   op_lbl           ;
//____________________________________________________________________________________________________________
//################################################# Write Bias Task #########################################
//____________________________________________________________________________________________________________
    
task automatic write_bias_2d(
    ref ip_bswt_port port,
    input logic [$clog2(NUMBER_OF_LAYERS)-1:0]    lyr_sel,
    input logic [1:0]                             BK_sel ,
    input logic [(MAX_BSWT_WIDTH-1):0]                            bias_matrix [][]
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
    
//____________________________________________________________________________________________________________
//################################################# Write Weight Task ########################################
//____________________________________________________________________________________________________________
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

//____________________________________________________________________________________________________________
//################################################# Write Data Task ########################################
//____________________________________________________________________________________________________________    

task automatic write_data_2d(
    ref ip_data_port port,
    input logic [(IP_DATA_WIDTH[0]-1):0] data_matrix [][]
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
 
//____________________________________________________________________________________________________________
//################################################# Read Data Task ########################################
//____________________________________________________________________________________________________________    
    
task automatic read_data_bnn_2d(
    ref op_addr_port port     ,
    // ref logic rd              ,
    ref logic [0:0] output_reg [IP_NEUR_HIGHT[NUMBER_OF_LAYERS-1]][OP_NEUR_WIDTH[NUMBER_OF_LAYERS-1]] 
);
    int X = OP_NEUR_WIDTH[NUMBER_OF_LAYERS-1];
    int Y = IP_NEUR_HIGHT[NUMBER_OF_LAYERS-1];
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


//____________________________________________________________________________________________________________
//########################################### Custom ARGMAX Decoder Task #####################################
//____________________________________________________________________________________________________________    
    
task automatic argmax_decode_bnn_row(
    ref logic [0:0] output_reg [IP_NEUR_HIGHT[NUMBER_OF_LAYERS-1]][OP_NEUR_WIDTH[NUMBER_OF_LAYERS-1]] ,
    ref logic [15:0] argmax
);
    int X = OP_NEUR_WIDTH[NUMBER_OF_LAYERS-1];
    int Y = IP_NEUR_HIGHT[NUMBER_OF_LAYERS-1];  
    for (int y = Y-1; y >= 0; y--) begin
        for (int x = X-1; x >= 0; x--) begin
            if (output_reg[y][x]) begin
                    argmax = x;
                    // return;
                    disable argmax_decode_bnn_row;
            end
        end
    end
                
        
endtask
 
//____________________________________________________________________________________________________________
//################################## Read File (1-bit) Task ##################################################
//____________________________________________________________________________________________________________    
 
parameter string DATA_DIR = "../../../../BNN_accel.srcs/sim_1/img_and_label/";
// Made for Img files 00000-09999 and label files 10000-19999
task automatic read_test_vectors(
  input int index,
  ref   logic       img [0:783],    // Image Vector
  ref   logic [15:0]  lbl           // Label vector
);

  string  img_filename;
  string  lbl_filename;
  int  img_file_handle = 0; // Image file name number
  int  lbl_file_handle = 0; // Label file name number

  // Path and filenames
  $sformat(img_filename, "%simg_%05d.mem", DATA_DIR, index);
  $sformat(lbl_filename, "%slbl_%05d.txt", DATA_DIR, index + 10000);

  $display("[INFO] Reading test vector for index %0d...", index);
  $display("[INFO]   Image file: %s", img_filename);
  $display("[INFO]   Label file: %s", lbl_filename);


  // Read contiguous string from the image file ---
  img_file_handle = $fopen(img_filename, "r");
  if (img_file_handle) begin
    string image_line; // Entire line of 784 characters
    
    // Read single line from the file
    if ($fgets(image_line, img_file_handle) > 0) begin
      for (int i = 0; i < 784; i++) begin
        img[i] = image_line[i] - "0";
      end
    end else begin
        $error("Could not read line from %s", img_filename);
    end
    $fclose(img_file_handle);
  end else begin
    $fatal(1, "ERROR: Could not open image file '%s'.", img_filename);
  end


  // Read label file (hex) 
  lbl_file_handle = $fopen(lbl_filename, "r");
  if (lbl_file_handle) begin
    
    if ($fscanf(lbl_file_handle, "%h", lbl) != 1) begin
      $error("Could not read a hex value from %s", lbl_filename);
    end
    $fclose(lbl_file_handle);
  end else begin
    $fatal(1, "ERROR: Could not open label file '%s'.", lbl_filename);
  end

endtask
 
//____________________________________________________________________________________________________________
//################################## Read File (8-bit) Task ##################################################
//____________________________________________________________________________________________________________    
parameter string DATA8b_DIR = "../../../../BNN_accel.srcs/sim_1/8bimg_and_label/"; 
 
task automatic read_8bit_image_task(
  input int index,
  ref   logic [7:0]   img [0:783],  // Image: 784 pixels, each 8 bits wide
  ref   logic [15:0]  lbl           // Label vector
);

  string  img_filename;
  string  lbl_filename;
  int     img_file_handle = 0;
  int     lbl_file_handle = 0;
  int     dest_index = 0;

  // Path and filenames
  $sformat(img_filename, "%simg_%05d.mem", DATA8b_DIR, index);
  $sformat(lbl_filename, "%slbl_%05d.txt", DATA8b_DIR, index + 10000);

  $display("[INFO] Reading 8-bit test vector for index %0d...", index);
  $display("[INFO]   Image file: %s", img_filename);
  $display("[INFO]   Label file: %s", lbl_filename);


  // --- Read the 28-line image file and parse the 8-bit pixels ---
  img_file_handle = $fopen(img_filename, "r");
  if (img_file_handle) begin
    string image_line;

    for (int line_num = 0; line_num < 28; line_num++) begin
      if ($fgets(image_line, img_file_handle) > 0) begin
        
        for (int pixel_in_line = 0; pixel_in_line < 28; pixel_in_line++) begin
          logic [7:0] temp_pixel;

          for (int bit_num = 0; bit_num < 8; bit_num++) begin
            int char_index = (pixel_in_line * 8) + bit_num;
            temp_pixel[7 - bit_num] = image_line[char_index] - "0";
          end


          dest_index = (line_num * 28) + pixel_in_line;

          // Store the fully assembled 8-bit pixel in the output array
          img[dest_index] = temp_pixel;
        end

      end else begin
        $error("Could not read line %0d from %s", line_num, img_filename);
        break;
      end
    end
    $fclose(img_file_handle);
  end else begin
    $fatal(1, "ERROR: Could not open image file '%s'.", img_filename);
  end


  // --- Read label file (hex) - This logic remains unchanged ---
  lbl_file_handle = $fopen(lbl_filename, "r");
  if (lbl_file_handle) begin
    if ($fscanf(lbl_file_handle, "%h", lbl) != 1) begin
      $error("Could not read a hex value from %s", lbl_filename);
    end
    $fclose(lbl_file_handle);
  end else begin
    $fatal(1, "ERROR: Could not open label file '%s'.", lbl_filename);
  end

endtask

//____________________________________________________________________________________________________________
//################################## Read File (1-bit) Task ##################################################
//____________________________________________________________________________________________________________  

 

        
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
    
    
    
    
    
    int     infer = 0;
    int     prediction_rght = 0;
    int     prediction_wrng = 0;
    real    prediction_accuracy = 0.0;
    
    logic [$clog2(NUMBER_OF_LAYERS)-1:0] j;
    
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            // mult_out <= '{default:'h0};
            inf_out <= '{default:'h0};
            state   <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    // mult_out <= '{default:'h0};
                    inf_out <= '{default:'h0};
                    
                    read_test_vectors(
                        .index  (infer),
                        .img    (ip_img[0]),
                        .lbl    (ip_lbl)
                    );
                    // read_8bit_image_task(
                        // .index  (infer),
                        // .img    (ip_img[0]),
                        // .lbl    (ip_lbl)
                    // );
                    if (infer == 0) begin // Write weights and biases in first cycle
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
                        end
                    end
                    if (accel_ready) 
                        state <= WRITE;
                end
                WRITE: begin
                    write_data_2d(
                        .port(data_port_A),
                        .data_matrix (ip_img)
                        );
                    state <= WAIT_CALC;
                end
                WAIT_CALC: begin
                    if (accel_done) 
                        state <= READ;
                end
                READ: begin
                    read_data_bnn_2d( .port(addr_C),.output_reg (inf_out) );
                    argmax_decode_bnn_row( .output_reg (inf_out), .argmax (op_lbl) );
                    state <= VERIFY;
                end
                VERIFY: begin
                
                    if (op_lbl == ip_lbl) begin
                        prediction_rght++;
                        $display($time, " << Inference Image %05d - Correct>>",infer);
                    end else begin
                        prediction_wrng++;
                        $display($time, " << Inference Image %05d - Incorrect>>",infer);
                    end  
                        
                    if (infer == 1000) begin   
                        $display($time, " << Inference Done>>");
                        prediction_accuracy = ((prediction_rght*100)/ (prediction_rght + prediction_wrng));
                        $display($time, " << Prediction Accuracy - %0.3f %%>>",prediction_accuracy);
                        $stop;
                    end else begin
                        infer++;
                        state <= IDLE;
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
