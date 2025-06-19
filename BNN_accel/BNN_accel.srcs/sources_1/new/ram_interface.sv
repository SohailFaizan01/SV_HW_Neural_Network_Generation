`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2025 03:13:04 AM
// Design Name: 
// Module Name: ram_interface
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

interface ram_addr_port #(
    parameter RAM_WIDTH = 8,
    parameter RAM_HIGHT = 8
    );
    
    
    logic [$clog2(RAM_WIDTH)-1:0] x;
    logic [$clog2(RAM_HIGHT)-1:0] y;
    
    
    
    // function bus_t pack();
        // bus_t temp;
        // temp.data  = data;
        // temp.valid = valid;
        // temp.ready = ready;
        // return temp;
    // endfunction

  // // Unpack a struct into the interface fields
  // task unpack(bus_t s);
    // data  = s.data;
    // valid = s.valid;
    // ready = s.ready;
  // endtask

endinterface