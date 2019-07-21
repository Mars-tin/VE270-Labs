module TP(clock,reset,row,col,ssd,state,AN,Row,Col);
input reset, clock;
input [3:0] row = 4'b0000;
output [3:0] AN;
output [3:0] col;
output [2:0] state;
output [3:0] Row, Col;
output [6:0] ssd;
wire [3:0] Q;
wire clock_1hz;
main UUT1(clock,reset,row,col,Q,state);
ssd UUT3(Q,ssd);
assign AN=4'b0111;
assign Row=row;
assign Col=col;
endmodule


module ssd(Q,ssd);
input [3:0] Q;
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

module clock_divider(clock, reset, clock_1hz);
input clock, reset;
output clock_1hz;
parameter N = 30, Division = 100000000; 
reg [N - 1:0] q = 0; 
reg clock_1hz;
always @(posedge clock or posedge reset) 
begin
    if (reset == 1) begin q <= 1'b0; clock_1hz <= 1'b0; end
    else
       if (q == Division - 1) begin q <= 0;clock_1hz <= 1'b1;end
       else begin q <= q + 1; clock_1hz <= 1'b0;end
end
endmodule





module main(clock,reset,row,col,Q,state);
input clock,reset;
input [3:0] row;
output [3:0] col;
reg [3:0] col;
output [3:0] Q;
reg [3:0] Q;
output [2:0] state;
reg [2:0] curr_state,next_state;
parameter state0 = 3'b000;
parameter state1 = 3'b001;
parameter state2 = 3'b010;
parameter state3 = 3'b011;
parameter state4 = 3'b100;
parameter state5 = 3'b101;
always @ (posedge clock or posedge reset)
    if (reset==1) curr_state<=state0;
    else curr_state<=next_state;
always @ (curr_state or row)
    case (curr_state)
        state0: begin if (row==0) next_state<=state0;
            else if (row>0)
                next_state<=state1;
            else next_state<=state0;
            col=4'b1111;
            end
        state1: begin if (row>0) next_state<=state5;
            else if (row==0)
                next_state<=state2;
            else next_state<=state0;
            col=4'b0001;
            end
        state2: begin if (row>0) next_state<=state5;
            else if (row==0)
                next_state<=state3;
            else next_state<=state0;
            col=4'b0010;
            end
        state3: begin if (row>0) next_state<=state5;
            else if (row==0)
                next_state<=state4;
            else next_state<=state0;
            col=4'b0100;
            end
        state4: begin if (row>0) next_state<=state5;
            else if (row==0)
                next_state<=state0;
            else next_state<=state0;
            col=4'b1000;
            end
        state5: begin
            if (row==4'b0001) begin
                if (col==4'b0001) Q<=0;
                else if (col==4'b0010) Q<=1;
                else if (col==4'b0100) Q<=2;
                else Q<=3;
            end
            else if (row==4'b0010) begin
                if (col==4'b0001) Q<=4;
                else if (col==4'b0010) Q<=5;
                else if (col==4'b0100) Q<=6;
                else Q<=7;
            end
            else if (row==4'b0100) begin
                if (col==4'b0001) Q<=8;
                else if (col==4'b0010) Q<=9;
                else if (col==4'b0100) Q<=10;
                else Q<=11;
            end
            else if (row==4'b1000) begin
                if (col==4'b0001) Q<=12;
                else if (col==4'b0010) Q<=13;
                else if (col==4'b0100) Q<=14;
                else Q<=15;
            end
            if (row>0) next_state<=state5;
            else if (row==0)
                next_state<=state0;
            else next_state<=state0;
            end
        default: next_state<=state0;
    endcase
assign state=curr_state;
endmodule


module keypad(but,col,row);
input [3:0] but,col;
output [3:0] row;
reg [3:0] row=4'b0000;
always @ (*)
    begin
    case (but)
        4'b0000: if (col[0]==1) row[0]=1;
        else row=0;
        4'b0001: if (col[1]==1) row[0]=1;
        else row=0;
        4'b0010: if (col[2]==1) row[0]=1;
        else row=0;
        4'b0011: if (col[3]==1) row[0]=1;
        else row=0;
        4'b0100: if (col[0]==1) row[1]=1;
        else row=0;
        4'b0101: if (col[1]==1) row[1]=1;
        else row=0;
        4'b0110: if (col[2]==1) row[1]=1;
        else row=0;
        4'b0111: if (col[3]==1) row[1]=1;
        else row=0;
        4'b1000: if (col[0]==1) row[2]=1;
        else row=0;
        4'b1001: if (col[1]==1) row[2]=1;
        else row=0;
        4'b1010: if (col[2]==1) row[2]=1;
        else row=0;
        4'b1011: if (col[3]==1) row[2]=1;
        else row=0;
        4'b1100: if (col[0]==1) row[3]=1;
        else row=0;
        4'b1101: if (col[1]==1) row[3]=1;
        else row=0;
        4'b1110: if (col[2]==1) row[3]=1;
        else row=0;
        4'b1111: if (col[3]==1) row[3]=1;
        else row=0;
    default: row=4'b0000;
    endcase
    end
endmodule
