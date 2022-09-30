`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Ratner Surf Designs
// Engineer:  James Ratner
// 
// Create Date: 07/07/2018 08:05:03 AM
// Design Name: 
// Module Name: fsm_template
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generic FSM model with both Mealy & Moore outputs. 
//    Note: data widths of state variables are not specified 
//
// Dependencies: 
// 
// Revision:
// Revision 1.00 - File Created (07-07-2018) 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fsm(go, rco, A_out, B_out, out_out, reset_n, ld_odd, odd, we, up, ld_A, ld_B, ld_out, sel_1, sel_2, cntr_clr, clk); 
    input  go, clk;
    input [7:0] A_out;
    input [7:0] B_out;
    input [7:0] out_out;
    input reset_n;
    input rco; 
    input odd;
    output reg up;
    output reg ld_odd;
    output reg ld_A;
    output reg ld_B;
    output reg ld_out;
    output reg sel_1;
    output reg sel_2;
    output reg cntr_clr;
    output reg we;

    
    //- next state & present state variables
    reg [2:0] NS, PS; 
    //- bit-level state representations
    parameter [2:0] init=3'b000, start=3'b001, calc=3'b010, ans=3'b011, fin=3'b100; 
    

    //- model the state registers
    always @ (negedge reset_n, posedge clk)
       if (reset_n == 0) 
          PS <= init; 
       else
          PS <= NS; 
    
    
    //- model the next-state and output decoders
    always @ (*)
    begin
       ld_A = 0; ld_B = 0; ld_out = 0; sel_1 = 0; sel_2 = 0; up = 0; ld_odd = 0; we = 0; cntr_clr = 0;// assign all outputs
       case(PS)
          init:
             begin
                sel_1 = 0;
                sel_2 = 0; 
                ld_A = 1; 
                ld_B = 1; 
                ld_out = 0;
                ld_odd = 0;
                we = 0;
                up = 1;
                if (go == 1)
                    begin
                        ld_odd = 1;
                        cntr_clr = 1;
                        we = 1;
                        NS = start;
                    end
                else
                if (go == 0)
                    begin 
                        NS = init;
                    end 

             end
             
          start:
            begin
                sel_1 = 1;
                sel_2 = 1; 
                ld_A = 0; 
                ld_B = 0; 
                ld_out = 1;
                ld_odd = 1;
                cntr_clr = 0;
                if (odd == 1)
                begin
                we = 1;
                end
                else
                begin
                we = 0;
                end
                up = 0;
                NS = calc;
            end
            
          calc:
            begin
                sel_1 = 1;
                sel_2 = 1; 
                ld_A = 1; 
                ld_B = 0; 
                ld_out = 0;
                cntr_clr = 0;
                if (odd == 1)
                    begin
                        up = 1;
                    end
                else
                    begin
                        up = 0;
                    end
                NS = ans;
            end
            
          ans:
            begin
                sel_1 = 1;
                sel_2 = 1; 
                ld_A = 0; 
                ld_B = 1; 
                ld_out = 0;
                ld_odd = 0;
                up = 0;
                cntr_clr = 0;
                if (rco == 1)
                    begin
                    NS = fin;
                    end
                else
                    begin
                    NS = start;
                    end
            end
          
          fin:
            begin
            sel_1 = 1;
            sel_2 = 1; 
            ld_A = 0; 
            ld_B = 0; 
            ld_out = 0;
            ld_odd = 0;
            up = 0;
            cntr_clr = 1;
            NS = init;

            end
            
          default: NS = init; 
            
          endcase
      end              
endmodule


