/*
 * Created by 
   ../bin/Linux-x86_64-O/oasysGui 19.2-p002 on Sun Jan  2 15:38:45 2022
 * (C) Mentor Graphics Corporation
 */
/* CheckSum: 1004719113 */

module counter(clk, enable, reset, Q);
   input clk;
   input enable;
   input reset;
   inout [3:0]Q;

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

   CLKGATETST_X1 clk_gate_Q_reg (.CK(clk), .E(n_0_1), .SE(1'b0), .GCK(n_0_0));
   DFF_X1 \Q_reg[3]  (.D(n_0_4), .CK(n_0_0), .Q(Q[3]), .QN());
   DFF_X1 \Q_reg[2]  (.D(n_0_3), .CK(n_0_0), .Q(Q[2]), .QN());
   DFF_X1 \Q_reg[1]  (.D(n_0_2), .CK(n_0_0), .Q(Q[1]), .QN());
   DFF_X1 \Q_reg[0]  (.D(n_0_5), .CK(n_0_0), .Q(Q[0]), .QN());
   OR2_X1 i_0_0_0 (.A1(reset), .A2(enable), .ZN(n_0_1));
   NOR2_X1 i_0_0_1 (.A1(Q[0]), .A2(reset), .ZN(n_0_5));
   AOI211_X1 i_0_0_2 (.A(reset), .B(n_0_0_0), .C1(Q[1]), .C2(Q[0]), .ZN(n_0_2));
   AOI21_X1 i_0_0_3 (.A(Q[1]), .B1(n_0_0_5), .B2(Q[0]), .ZN(n_0_0_0));
   NOR2_X1 i_0_0_4 (.A1(reset), .A2(n_0_0_1), .ZN(n_0_3));
   AOI22_X1 i_0_0_5 (.A1(Q[1]), .A2(Q[0]), .B1(Q[2]), .B2(n_0_0_4), .ZN(n_0_0_1));
   AOI211_X1 i_0_0_6 (.A(reset), .B(n_0_0_2), .C1(Q[3]), .C2(n_0_0_3), .ZN(n_0_4));
   NOR2_X1 i_0_0_7 (.A1(Q[3]), .A2(n_0_0_3), .ZN(n_0_0_2));
   NOR2_X1 i_0_0_8 (.A1(n_0_0_5), .A2(n_0_0_4), .ZN(n_0_0_3));
   INV_X1 i_0_0_9 (.A(Q[0]), .ZN(n_0_0_4));
   INV_X1 i_0_0_10 (.A(Q[2]), .ZN(n_0_0_5));
endmodule

module priority_encoder(reset, SFD, SRD, SFA, SW, ST, temperature, 
      reversed_priority, A);
   input reset;
   input SFD;
   input SRD;
   input SFA;
   input SW;
   input ST;
   input [5:0]temperature;
   input reversed_priority;
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
   wire n_0_31;
   wire n_0_32;
   wire n_0_33;
   wire n_0_34;

   INV_X1 i_0_0 (.A(n_0_0), .ZN(A[0]));
   OAI211_X1 i_0_1 (.A(n_0_1), .B(n_0_20), .C1(n_0_3), .C2(SFD), .ZN(n_0_0));
   OAI211_X1 i_0_2 (.A(n_0_6), .B(reversed_priority), .C1(n_0_22), .C2(n_0_2), 
      .ZN(n_0_1));
   OAI21_X1 i_0_3 (.A(n_0_10), .B1(n_0_18), .B2(SFA), .ZN(n_0_2));
   AOI21_X1 i_0_4 (.A(n_0_4), .B1(n_0_6), .B2(n_0_17), .ZN(n_0_3));
   AOI21_X1 i_0_5 (.A(reversed_priority), .B1(n_0_5), .B2(n_0_18), .ZN(n_0_4));
   NAND2_X1 i_0_6 (.A1(n_0_17), .A2(SW), .ZN(n_0_5));
   NAND3_X1 i_0_7 (.A1(n_0_30), .A2(n_0_25), .A3(n_0_27), .ZN(n_0_6));
   AOI21_X1 i_0_8 (.A(n_0_7), .B1(n_0_11), .B2(n_0_21), .ZN(A[1]));
   INV_X1 i_0_9 (.A(n_0_8), .ZN(n_0_7));
   AOI21_X1 i_0_10 (.A(reset), .B1(n_0_9), .B2(n_0_13), .ZN(n_0_8));
   OAI21_X1 i_0_11 (.A(n_0_19), .B1(n_0_12), .B2(n_0_10), .ZN(n_0_9));
   INV_X1 i_0_12 (.A(SW), .ZN(n_0_10));
   OAI21_X1 i_0_13 (.A(n_0_12), .B1(n_0_26), .B2(n_0_13), .ZN(n_0_11));
   NAND2_X1 i_0_14 (.A1(n_0_18), .A2(n_0_17), .ZN(n_0_12));
   INV_X1 i_0_15 (.A(reversed_priority), .ZN(n_0_13));
   AOI21_X1 i_0_16 (.A(n_0_14), .B1(n_0_21), .B2(n_0_26), .ZN(A[2]));
   OAI21_X1 i_0_17 (.A(n_0_20), .B1(n_0_15), .B2(reversed_priority), .ZN(n_0_14));
   INV_X1 i_0_18 (.A(n_0_16), .ZN(n_0_15));
   NAND3_X1 i_0_19 (.A1(n_0_19), .A2(n_0_18), .A3(n_0_17), .ZN(n_0_16));
   INV_X1 i_0_20 (.A(SFA), .ZN(n_0_17));
   INV_X1 i_0_21 (.A(SRD), .ZN(n_0_18));
   INV_X1 i_0_22 (.A(SFD), .ZN(n_0_19));
   INV_X1 i_0_23 (.A(reset), .ZN(n_0_20));
   INV_X1 i_0_24 (.A(n_0_22), .ZN(n_0_21));
   AOI21_X1 i_0_25 (.A(n_0_24), .B1(n_0_23), .B2(n_0_25), .ZN(n_0_22));
   NAND4_X1 i_0_26 (.A1(temperature[4]), .A2(temperature[3]), .A3(temperature[2]), 
      .A4(temperature[1]), .ZN(n_0_23));
   INV_X1 i_0_27 (.A(ST), .ZN(n_0_24));
   INV_X1 i_0_28 (.A(temperature[5]), .ZN(n_0_25));
   AOI21_X1 i_0_29 (.A(SW), .B1(n_0_30), .B2(n_0_27), .ZN(n_0_26));
   INV_X1 i_0_30 (.A(n_0_28), .ZN(n_0_27));
   NAND2_X1 i_0_31 (.A1(n_0_29), .A2(ST), .ZN(n_0_28));
   INV_X1 i_0_32 (.A(temperature[4]), .ZN(n_0_29));
   NAND2_X1 i_0_33 (.A1(n_0_31), .A2(temperature[3]), .ZN(n_0_30));
   NAND3_X1 i_0_34 (.A1(n_0_34), .A2(n_0_33), .A3(n_0_32), .ZN(n_0_31));
   INV_X1 i_0_35 (.A(temperature[0]), .ZN(n_0_32));
   INV_X1 i_0_36 (.A(temperature[1]), .ZN(n_0_33));
   INV_X1 i_0_37 (.A(temperature[2]), .ZN(n_0_34));
endmodule

module DFF_register(D, clk, enable, reset, Q);
   input [2:0]D;
   input clk;
   input enable;
   input reset;
   output [2:0]Q;

   wire n_0_0;

   DFF_X1 \Q_reg[0]  (.D(n_0), .CK(clk), .Q(Q[0]), .QN());
   DFF_X1 \Q_reg[1]  (.D(n_1), .CK(clk), .Q(Q[1]), .QN());
   DFF_X1 \Q_reg[2]  (.D(n_2), .CK(clk), .Q(Q[2]), .QN());
   AND2_X1 i_0_1 (.A1(n_0_0), .A2(D[0]), .ZN(n_0));
   AND2_X1 i_0_2 (.A1(n_0_0), .A2(D[1]), .ZN(n_1));
   AND2_X1 i_0_3 (.A1(n_0_0), .A2(D[2]), .ZN(n_2));
   INV_X1 i_0_0 (.A(reset), .ZN(n_0_0));
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

   wire reversed_priority;
   wire [2:0]A;
   wire n_0_0_0;
   wire counter_enable;

   counter counter (.clk(clk), .enable(counter_enable), .reset(reset), .Q({
      reversed_priority, uc_0, uc_1, uc_2}));
   priority_encoder priority_encoder (.reset(reset), .SFD(SFD), .SRD(SRD), 
      .SFA(SFA), .SW(SW), .ST(ST), .temperature(temperature), .reversed_priority(
      reversed_priority), .A(A));
   DFF_register state_holder (.D(A), .clk(clk), .enable(), .reset(reset), 
      .Q(display));
   decoder output_decoder (.A(display), .front_door(front_door), .rear_door(
      rear_door), .alarm_buzzer(alarm_buzzer), .window_buzzer(window_buzzer), 
      .heater(heater), .cooler(cooler));
   OR4_X1 i_0_0_0 (.A1(ST), .A2(SW), .A3(SFA), .A4(SRD), .ZN(n_0_0_0));
   OR2_X1 i_0_0_1 (.A1(n_0_0_0), .A2(SFD), .ZN(counter_enable));
endmodule
