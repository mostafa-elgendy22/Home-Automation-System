
// 	Mon Jan  3 13:21:49 2022
//	vlsi
//	192.168.247.128

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
wire n_0_2;
wire n_1_0;
wire n_1_1;
wire n_2_0;
wire n_3_0;
wire n_3_1;
wire n_4_0;
wire n_5_0;


NOR2_X1 i_5_1 (.ZN (cooler), .A1 (n_5_0), .A2 (A[0]));
NAND2_X1 i_5_0 (.ZN (n_5_0), .A1 (A[1]), .A2 (A[2]));
NOR2_X1 i_4_1 (.ZN (heater), .A1 (n_4_0), .A2 (A[1]));
NAND2_X1 i_4_0 (.ZN (n_4_0), .A1 (A[0]), .A2 (A[2]));
NOR2_X1 i_3_2 (.ZN (n_3_1), .A1 (A[1]), .A2 (A[0]));
NAND2_X1 i_3_1 (.ZN (n_3_0), .A1 (A[2]), .A2 (n_3_1));
INV_X1 i_3_0 (.ZN (window_buzzer), .A (n_3_0));
NOR2_X1 i_2_1 (.ZN (alarm_buzzer), .A1 (n_2_0), .A2 (A[2]));
NAND2_X1 i_2_0 (.ZN (n_2_0), .A1 (A[0]), .A2 (A[1]));
NOR2_X1 i_1_2 (.ZN (n_1_1), .A1 (A[2]), .A2 (A[0]));
NAND2_X1 i_1_1 (.ZN (n_1_0), .A1 (A[1]), .A2 (n_1_1));
INV_X1 i_1_0 (.ZN (rear_door), .A (n_1_0));
INV_X1 i_0_3 (.ZN (n_0_2), .A (A[2]));
INV_X1 i_0_2 (.ZN (n_0_1), .A (A[1]));
NAND3_X1 i_0_1 (.ZN (n_0_0), .A1 (n_0_2), .A2 (n_0_1), .A3 (A[0]));
INV_X1 i_0_0 (.ZN (front_door), .A (n_0_0));

endmodule //decoder

module DFF_register (D, clk, enable, reset, Q);

output [2:0] Q;
input [2:0] D;
input clk;
input enable;
input reset;
wire n_0_0;
wire n_2;
wire n_3;
wire n_0;
wire n_1;


DFF_X2 \Q_reg[0]  (.Q (Q[0]), .CK (n_3), .D (n_0));
DFF_X2 \Q_reg[1]  (.Q (Q[1]), .CK (n_3), .D (n_1));
INV_X1 i_0_4 (.ZN (n_3), .A (clk));
INV_X1 i_0_3 (.ZN (n_0_0), .A (reset));
AND2_X1 i_0_2 (.ZN (n_2), .A1 (D[2]), .A2 (n_0_0));
AND2_X1 i_0_1 (.ZN (n_1), .A1 (D[1]), .A2 (n_0_0));
AND2_X1 i_0_0 (.ZN (n_0), .A1 (D[0]), .A2 (n_0_0));
DFF_X2 \Q_reg[2]  (.Q (Q[2]), .CK (n_3), .D (n_2));

endmodule //DFF_register

module priority_encoder (reset, SFD, SRD, SFA, SW, ST, temperature, state, A);

output [2:0] A;
input SFA;
input SFD;
input SRD;
input ST;
input SW;
input reset;
input [2:0] state;
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
wire n_0_20;
wire n_0_21;
wire n_0_22;
wire n_0_23;
wire n_0_24;
wire n_0_25;
wire n_0_26;
wire n_0_27;
wire n_0_28;
wire n_0_29;
wire n_0_30;
wire n_2;
wire n_3;
wire n_1;
wire n_0;


INV_X1 i_0_34 (.ZN (n_0_30), .A (temperature[3]));
INV_X1 i_0_33 (.ZN (n_0_29), .A (SRD));
INV_X1 i_0_32 (.ZN (n_0_28), .A (state[2]));
INV_X1 i_0_31 (.ZN (n_0_27), .A (state[0]));
NAND2_X1 i_0_30 (.ZN (n_0_26), .A1 (n_0_27), .A2 (SFD));
INV_X1 i_0_29 (.ZN (n_0_25), .A (n_0_26));
AND4_X1 i_0_28 (.ZN (n_0_24), .A1 (temperature[4]), .A2 (temperature[3]), .A3 (temperature[2]), .A4 (temperature[1]));
OAI21_X1 i_0_27 (.ZN (n_0_23), .A (ST), .B1 (n_0_24), .B2 (temperature[5]));
NOR3_X1 i_0_26 (.ZN (n_0_22), .A1 (temperature[2]), .A2 (temperature[1]), .A3 (temperature[0]));
NOR2_X1 i_0_25 (.ZN (n_0_21), .A1 (n_0_22), .A2 (n_0_30));
NOR3_X1 i_0_24 (.ZN (n_0_20), .A1 (temperature[5]), .A2 (temperature[4]), .A3 (n_0_21));
NAND2_X1 i_0_23 (.ZN (n_0_19), .A1 (ST), .A2 (n_0_20));
NAND2_X1 i_0_22 (.ZN (n_0_18), .A1 (n_0_23), .A2 (n_0_19));
NOR2_X1 i_0_21 (.ZN (n_0_17), .A1 (n_0_28), .A2 (n_0_18));
AND3_X1 i_0_20 (.ZN (n_0_16), .A1 (n_0_28), .A2 (n_0_27), .A3 (SFA));
NOR2_X1 i_0_19 (.ZN (n_0_15), .A1 (state[2]), .A2 (state[1]));
OAI33_X1 i_0_18 (.ZN (n_0_14), .A1 (SFA), .A2 (SRD), .A3 (n_0_25), .B1 (n_0_17), .B2 (n_0_16), .B3 (n_0_15));
OAI21_X1 i_0_17 (.ZN (n_3), .A (state[2]), .B1 (state[1]), .B2 (state[0]));
OAI21_X1 i_0_16 (.ZN (n_0_13), .A (n_0_14), .B1 (n_0_18), .B2 (SW));
OAI22_X1 i_0_15 (.ZN (n_0_12), .A1 (state[1]), .A2 (state[0]), .B1 (n_0_16), .B2 (state[2]));
INV_X1 i_0_14 (.ZN (n_0_11), .A (n_0_12));
NOR3_X1 i_0_13 (.ZN (n_2), .A1 (n_0_13), .A2 (n_0_11), .A3 (reset));
AOI22_X1 i_0_12 (.ZN (n_0_10), .A1 (ST), .A2 (n_0_20), .B1 (n_0_23), .B2 (SFD));
OAI22_X1 i_0_11 (.ZN (n_0_9), .A1 (SW), .A2 (state[2]), .B1 (state[1]), .B2 (state[0]));
AOI211_X1 i_0_10 (.ZN (n_0_8), .A (n_0_16), .B (n_0_15), .C1 (n_0_10), .C2 (n_0_9));
AOI21_X1 i_0_9 (.ZN (n_0_7), .A (n_0_23), .B1 (n_0_28), .B2 (SW));
NOR3_X1 i_0_8 (.ZN (n_0_6), .A1 (SFA), .A2 (SRD), .A3 (n_0_7));
NOR3_X1 i_0_7 (.ZN (n_0_5), .A1 (n_0_26), .A2 (state[1]), .A3 (state[2]));
NOR4_X1 i_0_6 (.ZN (n_1), .A1 (reset), .A2 (n_0_8), .A3 (n_0_6), .A4 (n_0_5));
NOR2_X1 i_0_5 (.ZN (n_0_4), .A1 (SW), .A2 (n_0_10));
OAI211_X1 i_0_4 (.ZN (n_0_3), .A (n_0_29), .B (n_0_15), .C1 (n_0_4), .C2 (SFA));
NAND3_X1 i_0_3 (.ZN (n_0_2), .A1 (n_0_23), .A2 (SFA), .A3 (n_0_29));
AOI21_X1 i_0_2 (.ZN (n_0_1), .A (n_0_15), .B1 (n_0_10), .B2 (n_0_2));
AOI221_X1 i_0_1 (.ZN (n_0_0), .A (n_0_5), .B1 (n_0_16), .B2 (state[1]), .C1 (n_0_1), .C2 (n_0_9));
AOI21_X1 i_0_0 (.ZN (n_0), .A (reset), .B1 (n_0_0), .B2 (n_0_3));
DLH_X1 \A_reg[0]  (.Q (A[0]), .D (n_0), .G (n_3));
DLH_X1 \A_reg[1]  (.Q (A[1]), .D (n_1), .G (n_3));
DLH_X1 \A_reg[2]  (.Q (A[2]), .D (n_2), .G (n_3));

endmodule //priority_encoder

module counter (clk, enable, reset, Q);

inout [2:0] Q;
input clk;
input enable;
input reset;
wire n_0_2;
wire n_0_1;
wire n_0_0;
wire n_0_1_1;
wire n_0_1_0;
wire n_0_3;
wire n_0_4;
wire n_0_5;
wire n_0_6;
wire n_0_1_2;
wire n_0_1_3;
wire n_0_1_4;
wire n_0_1_5;
wire n_0_1_6;


INV_X1 i_0_1_9 (.ZN (n_0_1_6), .A (n_0_1_1));
NAND2_X1 i_0_1_8 (.ZN (n_0_1_5), .A1 (enable), .A2 (Q[2]));
NOR3_X1 i_0_1_7 (.ZN (n_0_1_4), .A1 (n_0_1_5), .A2 (Q[0]), .A3 (Q[1]));
OR2_X1 i_0_1_6 (.ZN (n_0_1_3), .A1 (reset), .A2 (n_0_1_4));
XNOR2_X1 i_0_1_5 (.ZN (n_0_1_2), .A (Q[2]), .B (n_0_1_0));
NOR2_X1 i_0_1_4 (.ZN (n_0_6), .A1 (n_0_1_3), .A2 (n_0_1_2));
NOR2_X1 i_0_1_3 (.ZN (n_0_5), .A1 (n_0_1_6), .A2 (n_0_1_3));
NOR2_X1 i_0_1_2 (.ZN (n_0_4), .A1 (n_0_1_3), .A2 (Q[0]));
OR2_X1 i_0_1_1 (.ZN (n_0_3), .A1 (reset), .A2 (enable));
HA_X1 i_0_1_0 (.CO (n_0_1_0), .S (n_0_1_1), .A (Q[1]), .B (Q[0]));
MUX2_X1 i_0_0_2 (.Z (n_0_0), .A (Q[2]), .B (n_0_6), .S (n_0_3));
MUX2_X1 i_0_0_1 (.Z (n_0_1), .A (Q[1]), .B (n_0_5), .S (n_0_3));
MUX2_X1 i_0_0_0 (.Z (n_0_2), .A (Q[0]), .B (n_0_4), .S (n_0_3));
DFF_X1 \Q_reg[2]  (.Q (Q[2]), .CK (clk), .D (n_0_0));
DFF_X1 \Q_reg[1]  (.Q (Q[1]), .CK (clk), .D (n_0_1));
DFF_X1 \Q_reg[0]  (.Q (Q[0]), .CK (clk), .D (n_0_2));

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
wire \A[2] ;
wire \A[1] ;
wire \A[0] ;
wire n_0_0_0;
wire counter_enable;
wire n_2;
wire n_1;
wire n_0;


OR2_X1 i_0_0_1 (.ZN (counter_enable), .A1 (n_0_0_0), .A2 (SFD));
OR4_X1 i_0_0_0 (.ZN (n_0_0_0), .A1 (ST), .A2 (SW), .A3 (SFA), .A4 (SRD));
decoder output_decoder (.alarm_buzzer (alarm_buzzer), .cooler (cooler), .front_door (front_door)
    , .heater (heater), .rear_door (rear_door), .window_buzzer (window_buzzer), .A ({
    display[2], display[1], display[0]}));
DFF_register state_holder (.Q ({display[2], display[1], display[0]}), .D ({\A[2] , 
    \A[1] , \A[0] }), .clk (clk), .reset (reset));
priority_encoder priority_encoder (.A ({\A[2] , \A[1] , \A[0] }), .SFA (SFA), .SFD (SFD)
    , .SRD (SRD), .ST (ST), .SW (SW), .reset (reset), .state ({n_2, n_1, n_0}), .temperature ({
    temperature[5], temperature[4], temperature[3], temperature[2], temperature[1], 
    temperature[0]}));
counter counter (.Q ({n_2, n_1, n_0}), .clk (clk), .enable (counter_enable), .reset (reset));

endmodule //home_automation_system


