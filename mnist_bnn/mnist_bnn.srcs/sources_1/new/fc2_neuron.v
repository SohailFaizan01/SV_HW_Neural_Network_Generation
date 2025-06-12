`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module fc2_neuron #(parameter SIZE = 256)(
    input  wire [SIZE-1:0] in_vector,
    input  wire [SIZE-1:0] weight_vector,
    input  wire [9:0] threshold,  // Ò»°ãÎª SIZE/2 = 128
    output wire out
);
    wire [SIZE-1:0] xnor_result;
    wire [$clog2(SIZE+1)-1:0] sum;
    integer i;

    assign xnor_result = ~(in_vector ^ weight_vector);

    reg [$clog2(SIZE+1)-1:0] sum_reg;
    always @(*) begin
        sum_reg = 0;
        for (i = 0; i < SIZE; i = i + 1) begin
            sum_reg = sum_reg + xnor_result[i];
        end
    end
    assign sum = sum_reg;
    assign out = (sum >= threshold);
endmodule
