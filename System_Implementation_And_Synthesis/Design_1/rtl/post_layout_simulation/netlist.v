
// 	Mon Jan  3 02:23:39 2022
//	vlsi
//	localhost.localdomain

module decoder (A, front_door, rear_door, alarm_buzzer, window_buzzer, heater, cooler);

output alarm_buzzer;
output cooler;
output front_door;
output heater;
output rear_door;
output window_buzzer;
input [2:0] A;
wire n_0_0;
wire n_0_1;


INV_X1 i_0_7 (.ZN (n_0_1), .A (A[1]));
INV_X1 i_0_6 (.ZN (n_0_0), .A (A[0]));
NOR3_X1 i_0_5 (.ZN (front_door), .A1 (A[1]), .A2 (n_0_0), .A3 (A[2]));
NOR3_X1 i_0_4 (.ZN (rear_door), .A1 (A[2]), .A2 (n_0_1), .A3 (A[0]));
NOR3_X1 i_0_3 (.ZN (alarm_buzzer), .A1 (A[2]), .A2 (n_0_1), .A3 (n_0_0));
AND3_X1 i_0_2 (.ZN (window_buzzer), .A1 (A[2]), .A2 (n_0_0), .A3 (n_0_1));
AND3_X1 i_0_1 (.ZN (heater), .A1 (n_0_1), .A2 (A[0]), .A3 (A[2]));
AND3_X1 i_0_0 (.ZN (cooler), .A1 (A[2]), .A2 (n_0_0), .A3 (A[1]));

endmodule //decoder

module DFF_register (D, clk, enable, reset, Q);

output [2:0] Q;
input [2:0] D;
input clk;
input enable;
input reset;
wire n_0_0;
wire n_0;
wire n_1;
wire n_2;


INV_X1 i_0_0 (.ZN (n_0_0), .A (reset));
AND2_X1 i_0_3 (.ZN (n_2), .A1 (n_0_0), .A2 (D[2]));
AND2_X1 i_0_2 (.ZN (n_1), .A1 (n_0_0), .A2 (D[1]));
AND2_X1 i_0_1 (.ZN (n_0), .A1 (n_0_0), .A2 (D[0]));
DFF_X1 \Q_reg[2]  (.Q (Q[2]), .CK (clk), .D (n_2));
DFF_X1 \Q_reg[1]  (.Q (Q[1]), .CK (clk), .D (n_1));
DFF_X1 \Q_reg[0]  (.Q (Q[0]), .CK (clk), .D (n_0));

endmodule //DFF_register

module priority_encoder (reset, SFD, SRD, SFA, SW, ST, temperature, reversed_priority, 
    A);

output [2:0] A;
input SFA;
input SFD;
input SRD;
input ST;
input SW;
input reset;
input reversed_priority;
input [5:0] temperature;
wire n_0_0;
wire n_0_1;
wire n_0_2;
wire n_0_3;
wire n_0_4;
wire n_0_5;
wire n_0_6;
wire n_0_7;
wire n_0_8;
wire n_0_9;
wire n_0_10;
wire n_0_11;
wire n_0_12;
wire n_0_13;
wire n_0_14;
wire n_0_15;
wire n_0_16;
wire n_0_17;
wire n_0_18;
wire n_0_19;


INV_X1 i_0_22 (.ZN (n_0_19), .A (temperature[5]));
INV_X1 i_0_21 (.ZN (n_0_18), .A (SFD));
INV_X1 i_0_20 (.ZN (n_0_17), .A (SFA));
INV_X1 i_0_19 (.ZN (n_0_16), .A (ST));
OR3_X1 i_0_18 (.ZN (n_0_15), .A1 (temperature[2]), .A2 (temperature[1]), .A3 (temperature[0]));
AOI211_X1 i_0_17 (.ZN (n_0_14), .A (temperature[4]), .B (n_0_16), .C1 (n_0_15), .C2 (temperature[3]));
OR2_X1 i_0_16 (.ZN (n_0_13), .A1 (SW), .A2 (n_0_14));
NAND4_X1 i_0_15 (.ZN (n_0_12), .A1 (temperature[4]), .A2 (temperature[3]), .A3 (temperature[2]), .A4 (temperature[1]));
AOI21_X1 i_0_14 (.ZN (n_0_11), .A (n_0_16), .B1 (n_0_12), .B2 (n_0_19));
NOR2_X1 i_0_13 (.ZN (n_0_10), .A1 (n_0_13), .A2 (n_0_11));
NOR2_X1 i_0_12 (.ZN (n_0_9), .A1 (SRD), .A2 (SFA));
AOI21_X1 i_0_11 (.ZN (n_0_8), .A (reversed_priority), .B1 (n_0_9), .B2 (n_0_18));
NOR3_X1 i_0_10 (.ZN (A[2]), .A1 (reset), .A2 (n_0_10), .A3 (n_0_8));
AOI21_X1 i_0_9 (.ZN (n_0_7), .A (n_0_9), .B1 (n_0_13), .B2 (reversed_priority));
AOI21_X1 i_0_8 (.ZN (n_0_6), .A (SFD), .B1 (SW), .B2 (n_0_9));
OAI22_X1 i_0_7 (.ZN (n_0_5), .A1 (n_0_11), .A2 (n_0_7), .B1 (n_0_6), .B2 (reversed_priority));
NOR2_X1 i_0_6 (.ZN (A[1]), .A1 (n_0_5), .A2 (reset));
AND2_X1 i_0_5 (.ZN (n_0_4), .A1 (n_0_14), .A2 (n_0_19));
AOI21_X1 i_0_4 (.ZN (n_0_3), .A (SRD), .B1 (n_0_17), .B2 (SW));
OAI22_X1 i_0_3 (.ZN (n_0_2), .A1 (SFA), .A2 (n_0_4), .B1 (n_0_3), .B2 (reversed_priority));
AOI211_X1 i_0_2 (.ZN (n_0_1), .A (SW), .B (n_0_11), .C1 (SRD), .C2 (n_0_17));
NOR2_X1 i_0_1 (.ZN (n_0_0), .A1 (n_0_4), .A2 (n_0_1));
AOI221_X1 i_0_0 (.ZN (A[0]), .A (reset), .B1 (reversed_priority), .B2 (n_0_0), .C1 (n_0_2), .C2 (n_0_18));

endmodule //priority_encoder

module counter (clk, enable, reset, Q);

inout [3:0] Q;
input clk;
input enable;
input reset;
wire n_0_0;
wire n_0_1;
wire n_0_5;
wire n_0_2;
wire n_0_0_0;
wire n_0_3;
wire n_0_0_1;
wire n_0_4;
wire n_0_0_2;
wire n_0_0_3;
wire n_0_0_4;
wire n_0_0_5;


INV_X1 i_0_0_10 (.ZN (n_0_0_5), .A (Q[2]));
INV_X1 i_0_0_9 (.ZN (n_0_0_4), .A (Q[0]));
NOR2_X1 i_0_0_8 (.ZN (n_0_0_3), .A1 (n_0_0_5), .A2 (n_0_0_4));
NOR2_X1 i_0_0_7 (.ZN (n_0_0_2), .A1 (Q[3]), .A2 (n_0_0_3));
AOI211_X1 i_0_0_6 (.ZN (n_0_4), .A (reset), .B (n_0_0_2), .C1 (Q[3]), .C2 (n_0_0_3));
AOI22_X1 i_0_0_5 (.ZN (n_0_0_1), .A1 (Q[1]), .A2 (Q[0]), .B1 (Q[2]), .B2 (n_0_0_4));
NOR2_X1 i_0_0_4 (.ZN (n_0_3), .A1 (reset), .A2 (n_0_0_1));
AOI21_X1 i_0_0_3 (.ZN (n_0_0_0), .A (Q[1]), .B1 (n_0_0_5), .B2 (Q[0]));
AOI211_X1 i_0_0_2 (.ZN (n_0_2), .A (reset), .B (n_0_0_0), .C1 (Q[1]), .C2 (Q[0]));
NOR2_X1 i_0_0_1 (.ZN (n_0_5), .A1 (Q[0]), .A2 (reset));
OR2_X1 i_0_0_0 (.ZN (n_0_1), .A1 (reset), .A2 (enable));
DFF_X1 \Q_reg[0]  (.Q (Q[0]), .CK (n_0_0), .D (n_0_5));
DFF_X1 \Q_reg[1]  (.Q (Q[1]), .CK (n_0_0), .D (n_0_2));
DFF_X1 \Q_reg[2]  (.Q (Q[2]), .CK (n_0_0), .D (n_0_3));
DFF_X1 \Q_reg[3]  (.Q (Q[3]), .CK (n_0_0), .D (n_0_4));
CLKGATETST_X1 clk_gate_Q_reg (.GCK (n_0_0), .CK (clk), .E (n_0_1), .SE (1'b0 ));

endmodule //counter

module home_automation_system (clk, reset, SFD, SRD, SFA, SW, ST, temperature, front_door, 
    rear_door, alarm_buzzer, window_buzzer, heater, cooler, display);

output alarm_buzzer;
output cooler;
output [2:0] display;
output front_door;
output heater;
output rear_door;
output window_buzzer;
input SFA;
input SFD;
input SRD;
input ST;
input SW;
input clk;
input reset;
input [5:0] temperature;
wire reversed_priority;
wire \A[2] ;
wire \A[1] ;
wire \A[0] ;
wire n_0_0_0;
wire counter_enable;
wire uc_0;
wire uc_1;
wire uc_2;


OR2_X1 i_0_0_1 (.ZN (counter_enable), .A1 (n_0_0_0), .A2 (SFD));
OR4_X1 i_0_0_0 (.ZN (n_0_0_0), .A1 (ST), .A2 (SW), .A3 (SFA), .A4 (SRD));
decoder output_decoder (.alarm_buzzer (alarm_buzzer), .cooler (cooler), .front_door (front_door)
    , .heater (heater), .rear_door (rear_door), .window_buzzer (window_buzzer), .A ({
    display[2], display[1], display[0]}));
DFF_register state_holder (.Q ({display[2], display[1], display[0]}), .D ({\A[2] , 
    \A[1] , \A[0] }), .clk (clk), .reset (reset));
priority_encoder priority_encoder (.A ({\A[2] , \A[1] , \A[0] }), .SFA (SFA), .SFD (SFD)
    , .SRD (SRD), .ST (ST), .SW (SW), .reset (reset), .reversed_priority (reversed_priority)
    , .temperature ({temperature[5], temperature[4], temperature[3], temperature[2], 
    temperature[1], temperature[0]}));
counter counter (.Q ({reversed_priority, uc_0, uc_1, uc_2}), .clk (clk), .enable (counter_enable), .reset (reset));

endmodule //home_automation_system


