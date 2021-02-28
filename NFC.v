`timescale 1ns/100ps
`include "INOUT.v"
`include "MEM.v"
`include "CTL.v"
`include "MUX4B.v"
`include "MUX4A.v"
module NFC(clk, rst, done, F_IO_A, F_CLE_A, F_ALE_A, F_REN_A, F_WEN_A, F_RB_A, F_IO_B, F_CLE_B, F_ALE_B, F_REN_B, F_WEN_B, F_RB_B);

  input               clk;
  input               rst;
  output  wire        done;
  inout   wire  [7:0] F_IO_A;
  output  wire        F_CLE_A;
  output  wire        F_ALE_A;
  output  wire        F_REN_A;
  output  wire        F_WEN_A;
  input               F_RB_A;
  inout   wire [7:0]  F_IO_B;
  output  wire        F_CLE_B;
  output  wire        F_ALE_B;
  output  wire        F_REN_B;
  output  wire        F_WEN_B;
  input               F_RB_B;
//////////////// var //////////////////////////
  wire          En_A;
  wire          En_B;
  wire  [7:0]   F_IO_A_IN;
  wire  [7:0]   F_IO_A_OUT;
  wire  [7:0]   F_IO_B_OUT;
  wire  [511:0] En4Mem;
  wire  [8:0]   Sel4Mem;
  wire  [7:0]   Out_of_Mem;
  wire          Sel4Out_A;
  wire  [1:0]   Sel4Out_B;
  wire  [7:0]   CMD;
  wire  [7:0]   ADDR;
//////////////// module ///////////////////////
  INOUT in_out(
    .F_IO_A(F_IO_A),//inout 8
    .F_IO_B(F_IO_B),//inout 8
    .En_A(En_A),//in 1
    .En_B(En_B),//in 1
    .F_IO_A_IN(F_IO_A_IN),//out 8
    .F_IO_A_OUT(F_IO_A_OUT),//in 8
    .F_IO_B_OUT(F_IO_B_OUT)//in 8
    );
  MEM mem(
    .rst(rst),//in 1
    .clk(clk),//in 1
    .Data_in(F_IO_A_IN),//in 8
    .En4Mem(En4Mem),//in 512
    .Sel(Sel4Mem),//in 9
    .Data_out(Out_of_Mem)//out 8
    );
  CTL ctl(
    .rst(rst),//in 1
    .clk(clk),//in 1
    .done(done),//out 1
    .F_CLE_A(F_CLE_A),//out 1
    .F_ALE_A(F_ALE_A),//out 1
    .F_REN_A(F_REN_A),//out 1
    .F_WEN_A(F_WEN_A),//out 1
    .F_RB_A(F_RB_A),//in 1
    .F_CLE_B(F_CLE_B),//out 1
    .F_ALE_B(F_ALE_B),//out 1
    .F_REN_B(F_REN_B),//out 1
    .F_WEN_B(F_WEN_B),//out 1
    .F_RB_B(F_RB_B),//in 1
    .En_A(En_A),//out 1
    .En_B(En_B),//out 1
    .En4Mem(En4Mem),//out 512
    .Sel4Mem(Sel4Mem),//out 9
    .Sel4Out_A(Sel4Out_A),//out 1
    .Sel4Out_B(Sel4Out_B),//out 2
    .CMD(CMD),//out 8
    .ADDR(ADDR)//out 8
    );
  MUX4B mux4b(
    .Data(Out_of_Mem),//in 8
    .CMD(CMD),//in 8
    .ADDR(ADDR),//in 8
    .Sel4Out(Sel4Out_B),//in 2
    .Data_out(F_IO_B_OUT)//out 8
    );
  MUX4A mux4a(
    .CMD(CMD),//in 8
    .ADDR(ADDR),//in 8
    .Sel4Out(Sel4Out_A),//in 1
    .Data_out(F_IO_A_OUT)//out 8
    );

endmodule