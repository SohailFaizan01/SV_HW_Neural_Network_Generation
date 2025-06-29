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
import type_pkg::*;
interface ram_addr_port #(
    parameter RAM_WIDTH = 8,
    parameter RAM_HIGHT = 8
    );
    localparam RAM_WIDTH_CLOG = (RAM_WIDTH == 1) ? 2 : RAM_WIDTH;
    localparam RAM_HIGHT_CLOG = (RAM_HIGHT == 1) ? 2 : RAM_HIGHT;
    
    logic [$clog2(RAM_WIDTH_CLOG)-1:0] x;
    logic [$clog2(RAM_HIGHT_CLOG)-1:0] y;
endinterface


interface ram_port #(
    parameter   DATA_WIDTH  = 8,
    parameter   RAM_WIDTH   = 8,
    parameter   RAM_HIGHT   = 8
    );
    
    ram_addr_port #(.RAM_WIDTH(RAM_WIDTH), .RAM_HIGHT(RAM_HIGHT)) addr;
    
    logic [DATA_WIDTH-1:0]  data    ;
    rw_en                   en      ;
    
endinterface