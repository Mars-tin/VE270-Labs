`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/21 17:28:06
// Design Name: 
// Module Name: lab_7
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

module lab_7(switch, clk_100M, reset, equal, AN, ssd, num, overflow);
input switch, clk_100M, reset, equal;
input [3:0] num;
output [6:0] ssd;
output [3:0] AN;
output overflow;
wire clk_500, clk_1, reset;
wire [17:0] count1;
wire [8:0] count2;
wire [3:0] Q0_r, Q1_r, Q2_r, Q3_r;
wire [3:0] sign, value;
wire [6:0] temp1, temp2, temp3, temp4, temp5, temp6;
//wire [3:0] stored = 4'b0000;
//wire [3:0] sum = 4'b0000;
wire [3:0] stored, sum;
reg [6:0] ssd;
//reg [3:0] AN;

clock_dividor_500 uut1 (clk_100M, reset, clk_500, count1);
clock_dividor_1 uut2 (clk_500, reset, clk_1, count2);
counter_ring_4 uut3 (clk_500, reset, AN); 
roller uut4 (clk_1, reset, Q0_r, Q1_r, Q2_r, Q3_r);
fourbit_ssd uut5(Q0_r, temp1);
fourbit_ssd uut6(Q1_r, temp2);
fourbit_ssd uut7(Q2_r, temp3);
fourbit_ssd uut8(Q3_r, temp4);
onebit_ssd uut9(sign, temp5);
fourbit_ssd_num uut10(value, temp6);
adder uut11 (stored, num, reset, equal, sum, overflow);
stored_value uut12 (clk_500, equal, reset, stored, sum);
sum_value uut13 (sum, value, sign);

always @(posedge clk_100M)
begin
    if(switch == 0)
    begin
        case (AN)
            4'b0111: ssd = temp1;
            4'b1011: ssd = temp2;
            4'b1101: ssd = temp3;
            4'b1110: ssd = temp4;
            default: ssd = 7'b1111111;
        endcase
    end
    else
    begin
        case (AN)
            4'b0111: ssd = 7'b1111111;
            4'b1011: ssd = 7'b1111111;
            4'b1101: ssd = temp5;
            4'b1110: ssd = temp6;
            default: ssd = 7'b1111111;
        endcase
    end
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

module roller(clk, reset, Q0, Q1, Q2, Q3);
input clk, reset; 
output [3:0] Q0, Q1, Q2, Q3; 
reg [3:0] Q0 = 4'b1111;
reg [3:0] Q1 = 4'b1111;
reg [3:0] Q2 = 4'b1111;
reg [3:0] Q3 = 4'b0;
always @ (posedge reset or posedge clk) 
begin
    if (reset == 1'b1)
        begin
            Q0 <= 4'b1111;
            Q1 <= 4'b1111;
            Q2 <= 4'b1111;
            Q3 <= 4'b0;
        end 
    else
        begin
	       Q0 <= Q1;
	       Q1 <= Q2;
	       Q2 <= Q3;
	       Q3 <= Q3 + 1;
        end
    end
endmodule

module fourbit_ssd_num(Q, ssd);
    output [3:0] Q;
    output [6:0] ssd;
    reg [6:0] ssd;
    always @ (Q)
    begin
    case (Q)
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
            default: ssd=7'b1111111; // default -> _
    endcase
    end
endmodule

module fourbit_ssd(Q, ssd);
    output [3:0] Q;
    output [6:0] ssd;
    reg [6:0] ssd;
    always @ (Q)
    begin
    case (Q)
        4'b0000: ssd=7'b1000001; // 0 -> V
        4'b0001: ssd=7'b0110000; // 1 -> E
        4'b0010: ssd=7'b0010010; // 2 -> 2
        4'b0011: ssd=7'b0001111; // 3 -> 7
        4'b0100: ssd=7'b0000001; // 4 -> 0
        4'b0101: ssd=7'b1111111; // 5 -> _
        4'b0110: ssd=7'b1001111; // 6 -> I
        4'b0111: ssd=7'b0100100; // 7 -> S
        4'b1000: ssd=7'b1111111; // 8 -> _
        4'b1001: ssd=7'b0110001; // 9 -> C
        4'b1010: ssd=7'b0000001; // 10 -> O
        4'b1011: ssd=7'b0000001; // 11 -> O
        4'b1100: ssd=7'b1110001; // 12 -> L
        4'b1101: ssd=7'b1111111; // 13 -> _
        4'b1110: ssd=7'b1111111; // 14 -> _
        4'b1111: ssd=7'b1111111; // 15 -> _
        default: ssd=7'b1111111; // default -> _
    endcase
    end
endmodule

module onebit_ssd(Q, ssd);
    input Q;
    output [6:0] ssd;
    reg [6:0] ssd;
    always @ (Q)
    begin
    case (Q)
        1'b0: ssd=7'b1111111; // 0 -> +
        1'b1: ssd=7'b1111110; // 1 -> -
        default: ssd=7'b1111111; // default -> +
    endcase
    end
endmodule

module adder(stored, num, reset, equal, sum, overflow);
    input equal, reset;
    input [3:0] stored, num;
    output overflow;
    output [3:0] sum;
    reg overflow = 1'b0;
    reg [3:0] sum = 4'b0000;
always @ (posedge reset or posedge equal) 
begin
    if (reset == 1'b1)
        begin
            overflow <= 1'b0;
            sum <= 4'b0000;
        end 
    else if (equal == 1'b1)
        begin
           overflow <= (num[3]==stored[3]) & ~(num[3]==sum[3]);
	       sum <= stored + num;
        end
    else
        begin
           overflow <= overflow;
	       sum <= sum;
        end
    end
endmodule

module sum_value(sum, value, sign);
input [3:0] sum;
output [3:0] value;
output sign;
reg [3:0] value = 4'b0000;
reg sign = 1'b0;
always @(sum)
begin
    if(sum[3] == 0)
        begin
            sign <= sum[3];
            value <= sum;
        end
    else
        begin
            sign <= sum[3];
            value <= (~sum[3:0]) + 1;
        end
end
endmodule

module stored_value(clk, equal, reset, stored, sum);
input clk, reset, equal;
input [3:0] sum;
output [3:0] stored;
reg [3:0] stored = 4'b0000;
    always @(posedge clk, posedge reset or posedge equal) 
        begin
            if(reset == 1)
                stored <= 4'b0000;
            else if (equal == 1)
                stored <= sum;
            else
                stored <= stored;
        end
endmodule

