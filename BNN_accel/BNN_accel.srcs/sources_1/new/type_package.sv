`timescale 1ns / 1ps
package type_pkg;
import cfg_param::*;

  typedef struct {
    logic we;
    logic re;
  } rw_en;

typedef struct {
logic [$clog2(IP_NEUR_WIDTH[0])-1:0] x;
logic [$clog2(IP_NEUR_HIGHT[0])-1:0] y;
logic [(IP_DATA_WIDTH[0]-1):0]       data;
rw_en                                en;
} ip_data_port;


typedef struct {
logic   [$clog2(MAX_NEUR_WIDTH)-1:0]    x   ;
logic   [$clog2(MAX_NEUR_WIDTH)-1:0]    y   ;
logic   [(MAX_BSWT_WIDTH-1):0]          data;
rw_en                                   en  ;
logic   [$clog2(NUMBER_OF_LAYERS)-1:0]  lyr_sel ;
logic                                   BK_sel [2] ;
} ip_bswt_port;

typedef struct {
logic   [$clog2(OP_NEUR_WIDTH[2])-1:0]    x   ;
logic   [$clog2(IP_NEUR_HIGHT[2])-1:0]    y   ;

} op_addr_port;

endpackage