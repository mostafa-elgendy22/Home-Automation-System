/*
 * Created by 
   ../bin/Linux-x86_64-O/oasysGui 19.2-p002 on Sun Jan  2 16:34:29 2022
 * (C) Mentor Graphics Corporation
 */
/* CheckSum: 651239963 */

module counter(clk, enable, reset, Q);
   input clk;
   input enable;
   input reset;
   inout [2:0]Q;

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

   DFF_X1 \Q_reg[0]  (.D(n_0_2), .CK(clk), .Q(Q[0]), .QN());
   DFF_X1 \Q_reg[1]  (.D(n_0_1), .CK(clk), .Q(Q[1]), .QN());
   DFF_X1 \Q_reg[2]  (.D(n_0_0), .CK(clk), .Q(Q[2]), .QN());
   MUX2_X1 i_0_0_0 (.A(Q[0]), .B(n_0_4), .S(n_0_3), .Z(n_0_2));
   MUX2_X1 i_0_0_1 (.A(Q[1]), .B(n_0_5), .S(n_0_3), .Z(n_0_1));
   MUX2_X1 i_0_0_2 (.A(Q[2]), .B(n_0_6), .S(n_0_3), .Z(n_0_0));
   HA_X1 i_0_1_0 (.A(Q[1]), .B(Q[0]), .CO(n_0_1_0), .S(n_0_1_1));
   OR2_X1 i_0_1_1 (.A1(reset), .A2(enable), .ZN(n_0_3));
   NOR2_X1 i_0_1_2 (.A1(n_0_1_3), .A2(Q[0]), .ZN(n_0_4));
   NOR2_X1 i_0_1_3 (.A1(n_0_1_6), .A2(n_0_1_3), .ZN(n_0_5));
   NOR2_X1 i_0_1_4 (.A1(n_0_1_3), .A2(n_0_1_2), .ZN(n_0_6));
   XNOR2_X1 i_0_1_5 (.A(Q[2]), .B(n_0_1_0), .ZN(n_0_1_2));
   OR2_X1 i_0_1_6 (.A1(reset), .A2(n_0_1_4), .ZN(n_0_1_3));
   NOR3_X1 i_0_1_7 (.A1(n_0_1_5), .A2(Q[0]), .A3(Q[1]), .ZN(n_0_1_4));
   NAND2_X1 i_0_1_8 (.A1(enable), .A2(Q[2]), .ZN(n_0_1_5));
   INV_X1 i_0_1_9 (.A(n_0_1_1), .ZN(n_0_1_6));
endmodule

module priority_encoder(reset, SFD, SRD, SFA, SW, ST, temperature, state, A);
   input reset;
   input SFD;
   input SRD;
   input SFA;
   input SW;
   input ST;
   input [5:0]temperature;
   input [2:0]state;
   output [2:0]A;

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

   DLH_X1 \A_reg[2]  (.D(n_2), .G(n_3), .Q(A[2]));
   DLH_X1 \A_reg[1]  (.D(n_1), .G(n_3), .Q(A[1]));
   DLH_X1 \A_reg[0]  (.D(n_0), .G(n_3), .Q(A[0]));
   AOI21_X1 i_0_0 (.A(reset), .B1(n_0_0), .B2(n_0_3), .ZN(n_0));
   AOI221_X1 i_0_1 (.A(n_0_5), .B1(n_0_16), .B2(state[1]), .C1(n_0_1), .C2(n_0_9), 
      .ZN(n_0_0));
   AOI21_X1 i_0_2 (.A(n_0_15), .B1(n_0_10), .B2(n_0_2), .ZN(n_0_1));
   NAND3_X1 i_0_3 (.A1(n_0_23), .A2(SFA), .A3(n_0_29), .ZN(n_0_2));
   OAI211_X1 i_0_4 (.A(n_0_29), .B(n_0_15), .C1(n_0_4), .C2(SFA), .ZN(n_0_3));
   NOR2_X1 i_0_5 (.A1(SW), .A2(n_0_10), .ZN(n_0_4));
   NOR4_X1 i_0_6 (.A1(reset), .A2(n_0_8), .A3(n_0_6), .A4(n_0_5), .ZN(n_1));
   NOR3_X1 i_0_7 (.A1(n_0_26), .A2(state[1]), .A3(state[2]), .ZN(n_0_5));
   NOR3_X1 i_0_8 (.A1(SFA), .A2(SRD), .A3(n_0_7), .ZN(n_0_6));
   AOI21_X1 i_0_9 (.A(n_0_23), .B1(n_0_28), .B2(SW), .ZN(n_0_7));
   AOI211_X1 i_0_10 (.A(n_0_16), .B(n_0_15), .C1(n_0_10), .C2(n_0_9), .ZN(n_0_8));
   OAI22_X1 i_0_11 (.A1(SW), .A2(state[2]), .B1(state[1]), .B2(state[0]), 
      .ZN(n_0_9));
   AOI22_X1 i_0_12 (.A1(ST), .A2(n_0_20), .B1(n_0_23), .B2(SFD), .ZN(n_0_10));
   NOR3_X1 i_0_13 (.A1(n_0_13), .A2(n_0_11), .A3(reset), .ZN(n_2));
   INV_X1 i_0_14 (.A(n_0_12), .ZN(n_0_11));
   OAI22_X1 i_0_15 (.A1(state[1]), .A2(state[0]), .B1(n_0_16), .B2(state[2]), 
      .ZN(n_0_12));
   OAI21_X1 i_0_16 (.A(n_0_14), .B1(n_0_18), .B2(SW), .ZN(n_0_13));
   OAI21_X1 i_0_17 (.A(state[2]), .B1(state[1]), .B2(state[0]), .ZN(n_3));
   OAI33_X1 i_0_18 (.A1(SFA), .A2(SRD), .A3(n_0_25), .B1(n_0_17), .B2(n_0_16), 
      .B3(n_0_15), .ZN(n_0_14));
   NOR2_X1 i_0_19 (.A1(state[2]), .A2(state[1]), .ZN(n_0_15));
   AND3_X1 i_0_20 (.A1(n_0_28), .A2(n_0_27), .A3(SFA), .ZN(n_0_16));
   NOR2_X1 i_0_21 (.A1(n_0_28), .A2(n_0_18), .ZN(n_0_17));
   NAND2_X1 i_0_22 (.A1(n_0_23), .A2(n_0_19), .ZN(n_0_18));
   NAND2_X1 i_0_23 (.A1(ST), .A2(n_0_20), .ZN(n_0_19));
   NOR3_X1 i_0_24 (.A1(temperature[5]), .A2(temperature[4]), .A3(n_0_21), 
      .ZN(n_0_20));
   NOR2_X1 i_0_25 (.A1(n_0_22), .A2(n_0_30), .ZN(n_0_21));
   NOR3_X1 i_0_26 (.A1(temperature[2]), .A2(temperature[1]), .A3(temperature[0]), 
      .ZN(n_0_22));
   OAI21_X1 i_0_27 (.A(ST), .B1(n_0_24), .B2(temperature[5]), .ZN(n_0_23));
   AND4_X1 i_0_28 (.A1(temperature[4]), .A2(temperature[3]), .A3(temperature[2]), 
      .A4(temperature[1]), .ZN(n_0_24));
   INV_X1 i_0_29 (.A(n_0_26), .ZN(n_0_25));
   NAND2_X1 i_0_30 (.A1(n_0_27), .A2(SFD), .ZN(n_0_26));
   INV_X1 i_0_31 (.A(state[0]), .ZN(n_0_27));
   INV_X1 i_0_32 (.A(state[2]), .ZN(n_0_28));
   INV_X1 i_0_33 (.A(SRD), .ZN(n_0_29));
   INV_X1 i_0_34 (.A(temperature[3]), .ZN(n_0_30));
endmodule

module decoder(A, front_door, rear_door, alarm_buzzer, window_buzzer, heater, 
      cooler);
   input [2:0]A;
   output front_door;
   output rear_door;
   output alarm_buzzer;
   output window_buzzer;
   output heater;
   output cooler;

   wire n_0_0;
   wire n_0_1;

   AND3_X1 i_0_0 (.A1(A[2]), .A2(n_0_0), .A3(A[1]), .ZN(cooler));
   AND3_X1 i_0_1 (.A1(n_0_1), .A2(A[0]), .A3(A[2]), .ZN(heater));
   AND3_X1 i_0_2 (.A1(A[2]), .A2(n_0_0), .A3(n_0_1), .ZN(window_buzzer));
   NOR3_X1 i_0_3 (.A1(A[2]), .A2(n_0_1), .A3(n_0_0), .ZN(alarm_buzzer));
   NOR3_X1 i_0_4 (.A1(A[2]), .A2(n_0_1), .A3(A[0]), .ZN(rear_door));
   NOR3_X1 i_0_5 (.A1(A[1]), .A2(n_0_0), .A3(A[2]), .ZN(front_door));
   INV_X1 i_0_6 (.A(A[0]), .ZN(n_0_0));
   INV_X1 i_0_7 (.A(A[1]), .ZN(n_0_1));
endmodule

module home_automation_system(clk, reset, SFD, SRD, SFA, SW, ST, temperature, 
      front_door, rear_door, alarm_buzzer, window_buzzer, heater, cooler, 
      display);
   input clk;
   input reset;
   input SFD;
   input SRD;
   input SFA;
   input SW;
   input ST;
   input [5:0]temperature;
   output front_door;
   output rear_door;
   output alarm_buzzer;
   output window_buzzer;
   output heater;
   output cooler;
   output [2:0]display;

   wire n_0_0_0;
   wire counter_enable;

   counter counter (.clk(clk), .enable(counter_enable), .reset(reset), .Q({n_2, 
      n_1, n_0}));
   priority_encoder priority_encoder (.reset(reset), .SFD(SFD), .SRD(SRD), 
      .SFA(SFA), .SW(SW), .ST(ST), .temperature(temperature), .state({n_2, n_1, 
      n_0}), .A(display));
   decoder output_decoder (.A(display), .front_door(front_door), .rear_door(
      rear_door), .alarm_buzzer(alarm_buzzer), .window_buzzer(window_buzzer), 
      .heater(heater), .cooler(cooler));
   OR4_X1 i_0_0_0 (.A1(ST), .A2(SW), .A3(SFA), .A4(SRD), .ZN(n_0_0_0));
   OR2_X1 i_0_0_1 (.A1(n_0_0_0), .A2(SFD), .ZN(counter_enable));
endmodule
