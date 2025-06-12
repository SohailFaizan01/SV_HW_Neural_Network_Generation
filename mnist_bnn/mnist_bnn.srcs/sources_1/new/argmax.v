`timescale 1ns / 1ps

module argmax #(
    parameter NUM_CLASSES = 10,
    parameter POPCOUNT_WIDTH = 8
)(
    input  wire [NUM_CLASSES*POPCOUNT_WIDTH-1:0] popcounts_flat,  // ±‚∆ΩªØ ‰»Î
    output reg  [$clog2(NUM_CLASSES)-1:0] predicted_label
);

    integer i;
    reg [POPCOUNT_WIDTH-1:0] popcount;
    reg [POPCOUNT_WIDTH-1:0] max_val;

    always @(*) begin
        max_val = 0;
        predicted_label = 0;
        for (i = 0; i < NUM_CLASSES; i = i + 1) begin
            popcount = popcounts_flat[(i+1)*POPCOUNT_WIDTH-1 -: POPCOUNT_WIDTH];
            if (popcount > max_val) begin
                max_val = popcount;
                predicted_label = i[$clog2(NUM_CLASSES)-1:0];
            end
        end
    end

endmodule
