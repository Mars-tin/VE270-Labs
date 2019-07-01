`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/30 17:48:05
// Design Name: 
// Module Name: lab_5
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

module lab_5(clk_100M, reset, AN, ssd);
input clk_100M, reset;
output [6:0] ssd;
output [3:0] AN;
wire clk_500, clk_1, reset;
wire [17:0] count1;
wire [8:0] count2;
wire [3:0] QL, QR;
wire [6:0] temp1, temp2;
reg [6:0] ssd;
//reg [3:0] AN;

clock_dividor_500 uut1 (clk_100M, reset, clk_500, count1);
clock_dividor_1 uut2 (clk_500, reset, clk_1, count2);
counter_ring_4 uut3 (clk_500, reset, AN); 
timer uut4 (clk_1, reset, QL, QR);
fourbit_ssd uut5(QL, temp1);
fourbit_ssd uut6(QR, temp2);

always @(posedge clk_100M)
begin
    case (AN)
        4'b0111: ssd = 7'b1111111;
        4'b1011: ssd = 7'b1111111;
        4'b1101: ssd = temp1;
        4'b1110: ssd = temp2;
        default: ssd = 7'b1111111;
    endcase
end
endmodule

module clock_dividor_500(clk_100M, reset, clk_500, count);
parameter div = 200000;
input clk_100M, reset;
output clk_500;
output [17:0] count;
reg clk_500;
reg [17:0] count = 17'b0;
always @(posedge clk_100M or posedge reset) 
begin
    if (reset == 1)
        begin
            clk_500 <= 1'b0; 
            count <= 17'b0;
        end
    else if (count == div - 1) 
       begin 
            count <= 17'b0;
            clk_500 <= 1'b1;
       end
    else 
       begin 
            count <= count + 1;
            clk_500 <= 1'b0;
       end
end
endmodule

module clock_dividor_1(clk_500, reset, clk_1, count);
parameter div = 500;
input clk_500, reset;
output clk_1;
output [8:0] count;
reg clk_1;
reg [8:0] count = 9'b0;
always @(posedge clk_500 or posedge reset) 
begin
    if (reset == 1)
        begin
            clk_1 <= 1'b0; 
            count <= 9'b0;
        end
    else if (count == div - 1) 
       begin 
            count <= 9'b0;
            clk_1 <= 1'b1;
       end
    else 
       begin 
            count <= count + 1;
            clk_1 <= 1'b0;
       end
end
endmodule

module counter_ring_4 (clk_500, reset, AN); 
input clk_500, reset; 
output [3:0] AN; 
reg [3:0] AN = 4'b1110; 
always @ (posedge clk_500 or posedge reset)
begin
    if (reset == 1'b1) AN <= 4'b1110; 
    else
        begin
        AN[0] <= AN[1];
        AN[1] <= AN[2];
        AN[2] <= AN[3];
        AN[3] <= AN[0];
        end
end
endmodule 

module timer(clk, reset, QL, QR);
input clk, reset; 
output [3:0] QL,QR; 
reg [3:0] QL = 4'b0;
reg [3:0] QR = 4'b0;
always @ (posedge reset or posedge clk) 
begin
    if (reset == 1'b1)
        begin
            QR <= 0;
            QL <= 0;
        end 
    else if (QR == 4'b1001)
        begin
            if (QL == 4'b0101)
                begin
                     QR <= 0;
                     QL <= 0;
                end
            else
                begin
                     QR <= 0;
                     QL <= QL + 1;
                end
        end
    else QR <= QR + 1;
end
endmodule

module fourbit_ssd(Q, ssd);
output [3:0] Q;
output [6:0] ssd;
reg [6:0] ssd;
always @ (Q)
begin
case (Q)
4'b0000: ssd=7'b0000001;
4'b0001: ssd=7'b1001111;
4'b0010: ssd=7'b0010010;
4'b0011: ssd=7'b0000110;
4'b0100: ssd=7'b1001100;
4'b0101: ssd=7'b0100100;
4'b0110: ssd=7'b0100000;
4'b0111: ssd=7'b0001111;
4'b1000: ssd=7'b0000000;
4'b1001: ssd=7'b0000100;
4'b1010: ssd=7'b0001000;
4'b1011: ssd=7'b1100000;
4'b1100: ssd=7'b0110001;
4'b1101: ssd=7'b1000010;
4'b1110: ssd=7'b0110000;
4'b1111: ssd=7'b0111000;
default: ssd=7'b1111111;
endcase
end
endmodule