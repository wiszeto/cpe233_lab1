`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2022 08:21:12 PM
// Design Name: 
// Module Name: top_lab1
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


module top_lab1(
    input BTN,
    input clk,
    output [3:0] anodes,
    output [7:0] segments,
    output LEDS
    );
    wire [7:0] sel_A;
    wire [7:0] sel_B;
    wire [7:0] A_in;
    wire [7:0] A_out;
    wire [7:0] B_in;
    wire [7:0] B_out;
    wire [7:0] rca_out;
    wire rca_co;
    wire [7:0] out_out;
    wire ld_A;
    wire ld_B;
    wire ld_out;
    wire ld_odd;
    wire [7:0] odd_out;
    wire we;
    wire up;
    wire [3:0] cntr_out;
    wire [7:0] ram_out;
    wire rco;
    wire cntr_clr;
    
    
assign we = odd_out[0:0];
    
mux_A  #(.n(8)) my_2t1_muxA  (
     .SEL   (sel_A), 
     .D0    (8'b00000001), 
     .D1    (B_out), 
     .D_OUT (A_in) );

mux_B  #(.n(8)) my_2t1_muxB  (
     .SEL   (sel_B), 
     .D0    (8'b00000001), 
     .D1    (out_out), 
     .D_OUT (B_in) );
     
reg_A #(.n(8)) REG_A (
    .data_in  (A_in), 
    .ld       (ld_A), 
    .clk      (clk), 
    .clr      (), 
    .data_out (A_out)
    );

reg_B #(.n(8)) REG_B (
    .data_in  (B_in), 
    .ld       (ld_B), 
    .clk      (clk), 
    .clr      (), 
    .data_out (B_out)
    );
    
rca #(.n(8)) MY_RCA (
    .a   (A_out), 
    .b   (B_out), 
    .cin (1'b0), 
    .sum (rca_out), 
    .co  (rca_co)
    );
    
reg_out #(.n(8)) REG_OUT (
    .data_in  (rca_out), 
    .ld       (ld_out), 
    .clk      (clk), 
    .clr      (), 
    .data_out (out_out)
    );

reg_odd #(.n(8)) REG_ODD (
    .data_in  (A_in), 
    .ld       (ld_odd), 
    .clk      (clk), 
    .clr      (), 
    .data_out (odd_out)
    );

cntr_up_clr_nb #(.n(4)) MY_CNTR (
    .clk   (clk), 
    .clr   (cntr_clr), 
    .up    (up), 
    .ld    (1'b0), 
    .D     (1'b0), 
    .count (cntr_out), 
    .rco   (rco)   );    

ram_single_port #(.n(3),.m(8)) my_ram (
    .data_in  (odd_out),  // m spec
    .addr     (cntr_out),  // n spec 
    .we       (we),
    .clk      (clk),
    .data_out (ram_out)
    );

fsm FSM1 (
    .go(BTN), 
    .rco(rca_co), 
    .A_out(A_out), 
    .B_out(B_out), 
    .out_out(out_out),
    .reset_n(1'b1),  
    .odd(we),
    .up(up),
    .ld_odd(ld_odd),
    .ld_A(ld_A), 
    .ld_B(ld_B), 
    .ld_out(ld_out),
    .sel_1(sel_A),
    .sel_2(sel_B), 
    .cntr_clr(cntr_clr),
    .clk(clk)
);    

endmodule
