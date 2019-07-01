`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/17 08:36:29
// Design Name: 
// Module Name: counter_1
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


module counter_1(an0,an1,an2,an3,ca,cb,cc,cd,ce,cf,cg,q0,q1,q2,q3,switch,clk,rst);
    input switch;
    input clk;
    input rst;
    output q0;
    output q1;
    output q2;
    output q3;
    output ca;
    output cb;
    output cc;
    output cd;
    output ce;
    output cf;
    output cg;
    output an0;
    output an1;
    output an2;
    output an3;
    reg [3:0] counter = 0;
    reg [6:0] ssd = 0;
    assign an0 = 0;
    assign an1 = 1;
    assign an2 = 1;
    assign an3 = 1;
//    reg q0 = 0;
//    reg q1 = 0;
//    reg q2 = 0;
//    reg q3 = 0;
    always @(posedge clk or posedge rst)
    begin
    if (switch == 1) 
        begin
            if (counter == 4'b1111) counter <= 4'b0000;
            else  counter <= counter + 1;
        end   
    else
        begin
         if (counter == 4'b0000) counter <= 4'b1111;
         else counter <= counter -1;
        end    
    if(rst == 1) 
        begin
         counter <= 4'b0;
        end
    end
    always @(*)
    begin
        case (counter)
            4'b0000: ssd <= 7'b0000001; //0
            4'b0001: ssd <= 7'b1001111; //1
            4'b0010: ssd <= 7'b0010010; //2
            4'b0011: ssd <= 7'b0000110; //3
            4'b0100: ssd <= 7'b1001100; //4
            4'b0101: ssd <= 7'b0100100; //5
            4'b0110: ssd <= 7'b0100000; //6
            4'b0111: ssd <= 7'b0001111; //7
            4'b1000: ssd <= 7'b0000000; //8
            4'b1001: ssd <= 7'b0000100; //9
            4'b1010: ssd <= 7'b0001000; //A
            4'b1011: ssd <= 7'b1100000; //b
            4'b1100: ssd <= 7'b0110001; //C
            4'b1101: ssd <= 7'b1000010; //d
            4'b1110: ssd <= 7'b0110000; //E
            4'b1111: ssd <= 7'b0111000; //F
            default ssd <= 7'b0000000;   
          endcase
    end
    assign q0 = counter[0];
    assign q1 = counter[1];
    assign q2 = counter[2];
    assign q3 = counter[3];
    assign ca = ssd[6];
    assign cb = ssd[5];
    assign cc = ssd[4];
    assign cd = ssd[3];
    assign ce = ssd[2];
    assign cf = ssd[1];
    assign cg = ssd[0];
endmodule
