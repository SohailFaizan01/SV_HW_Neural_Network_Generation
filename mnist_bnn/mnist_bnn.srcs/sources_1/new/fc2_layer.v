`timescale 1ns / 1ps

module fc2_layer #(
    parameter INPUT_SIZE = 256,
    parameter NUM_CLASSES = 10
)(
    input  wire [INPUT_SIZE-1:0] in_vector,
    input  wire [INPUT_SIZE*NUM_CLASSES-1:0] weight_flatten,
    output wire [8*NUM_CLASSES-1:0] popcounts_flat
);

    wire [INPUT_SIZE-1:0] weight_vectors [0:NUM_CLASSES-1];
    wire [INPUT_SIZE-1:0] xnor_results   [0:NUM_CLASSES-1];
    reg  [7:0]            popcounts      [0:NUM_CLASSES-1];

    genvar i;
    generate
        for (i = 0; i < NUM_CLASSES; i = i + 1) begin : fc2_expand
            assign weight_vectors[i] = weight_flatten[(i+1)*INPUT_SIZE-1 -: INPUT_SIZE];
            assign xnor_results[i]   = ~(in_vector ^ weight_vectors[i]);
        end
    endgenerate

    integer j, k;
    always @(*) begin
        for (j = 0; j < NUM_CLASSES; j = j + 1) begin
            popcounts[j] = 0;
            for (k = 0; k < INPUT_SIZE; k = k + 1)
                popcounts[j] = popcounts[j] + xnor_results[j][k];
        end
    end

    // ±âÆ½»¯Êä³ö
    generate
        for (i = 0; i < NUM_CLASSES; i = i + 1) begin : flatten_output
            assign popcounts_flat[(i+1)*8-1 -: 8] = popcounts[i];
        end
    endgenerate

endmodule
