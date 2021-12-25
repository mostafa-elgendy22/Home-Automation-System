/*
 * Created by 
   ../bin/Linux-x86_64-O/oasysGui 19.2-p002 on Sun Dec 26 00:10:15 2021
 * (C) Mentor Graphics Corporation
 */
/* CheckSum: 2696644781 */

module counter(clk, enable, reset, Q);
   input clk;
   input enable;
   input reset;
   inout [3:0]Q;

   wire n_0_0;
   wire n_0_3;
   wire n_0_0_0;
   wire n_0_4;
   wire n_0_5;
   wire n_0_0_1;
   wire n_0_2;
   wire n_0_1;

   CLKGATETST_X1 clk_gate_Q_reg (.CK(clk), .E(enable), .SE(1'b0), .GCK(n_0_0));
   DFFR_X1 \Q_reg[3]  (.D(n_0_5), .RN(n_0_1), .CK(n_0_0), .Q(Q[3]), .QN());
   DFFR_X1 \Q_reg[2]  (.D(n_0_4), .RN(n_0_1), .CK(n_0_0), .Q(Q[2]), .QN());
   DFFR_X1 \Q_reg[1]  (.D(n_0_3), .RN(n_0_1), .CK(n_0_0), .Q(Q[1]), .QN());
   DFFR_X1 \Q_reg[0]  (.D(n_0_2), .RN(n_0_1), .CK(n_0_0), .Q(Q[0]), .QN());
   AOI21_X1 i_0_0_0 (.A(n_0_0_0), .B1(Q[0]), .B2(Q[1]), .ZN(n_0_3));
   OAI21_X1 i_0_0_1 (.A(n_0_0_1), .B1(Q[0]), .B2(Q[1]), .ZN(n_0_0_0));
   MUX2_X1 i_0_0_2 (.A(Q[2]), .B(Q[1]), .S(Q[0]), .Z(n_0_4));
   XNOR2_X1 i_0_0_3 (.A(Q[3]), .B(n_0_0_1), .ZN(n_0_5));
   NAND2_X1 i_0_0_4 (.A1(Q[2]), .A2(Q[0]), .ZN(n_0_0_1));
   INV_X1 i_0_0_5 (.A(Q[0]), .ZN(n_0_2));
   INV_X1 i_0_0_6 (.A(reset), .ZN(n_0_1));
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

   AOI221_X1 i_0_0 (.A(reset), .B1(reversed_priority), .B2(n_0_0), .C1(n_0_2), 
      .C2(n_0_18), .ZN(A[0]));
   NOR2_X1 i_0_1 (.A1(n_0_4), .A2(n_0_1), .ZN(n_0_0));
   AOI211_X1 i_0_2 (.A(SW), .B(n_0_11), .C1(SRD), .C2(n_0_17), .ZN(n_0_1));
   OAI22_X1 i_0_3 (.A1(SFA), .A2(n_0_4), .B1(n_0_3), .B2(reversed_priority), 
      .ZN(n_0_2));
   AOI21_X1 i_0_4 (.A(SRD), .B1(n_0_17), .B2(SW), .ZN(n_0_3));
   AND2_X1 i_0_5 (.A1(n_0_14), .A2(n_0_19), .ZN(n_0_4));
   NOR2_X1 i_0_6 (.A1(n_0_5), .A2(reset), .ZN(A[1]));
   OAI22_X1 i_0_7 (.A1(n_0_11), .A2(n_0_7), .B1(n_0_6), .B2(reversed_priority), 
      .ZN(n_0_5));
   AOI21_X1 i_0_8 (.A(SFD), .B1(SW), .B2(n_0_9), .ZN(n_0_6));
   AOI21_X1 i_0_9 (.A(n_0_9), .B1(n_0_13), .B2(reversed_priority), .ZN(n_0_7));
   NOR3_X1 i_0_10 (.A1(reset), .A2(n_0_10), .A3(n_0_8), .ZN(A[2]));
   AOI21_X1 i_0_11 (.A(reversed_priority), .B1(n_0_9), .B2(n_0_18), .ZN(n_0_8));
   NOR2_X1 i_0_12 (.A1(SRD), .A2(SFA), .ZN(n_0_9));
   NOR2_X1 i_0_13 (.A1(n_0_13), .A2(n_0_11), .ZN(n_0_10));
   AOI21_X1 i_0_14 (.A(n_0_16), .B1(n_0_12), .B2(n_0_19), .ZN(n_0_11));
   NAND4_X1 i_0_15 (.A1(temperature[4]), .A2(temperature[3]), .A3(temperature[2]), 
      .A4(temperature[1]), .ZN(n_0_12));
   OR2_X1 i_0_16 (.A1(SW), .A2(n_0_14), .ZN(n_0_13));
   AOI211_X1 i_0_17 (.A(temperature[4]), .B(n_0_16), .C1(n_0_15), .C2(
      temperature[3]), .ZN(n_0_14));
   OR3_X1 i_0_18 (.A1(temperature[2]), .A2(temperature[1]), .A3(temperature[0]), 
      .ZN(n_0_15));
   INV_X1 i_0_19 (.A(ST), .ZN(n_0_16));
   INV_X1 i_0_20 (.A(SFA), .ZN(n_0_17));
   INV_X1 i_0_21 (.A(SFD), .ZN(n_0_18));
   INV_X1 i_0_22 (.A(temperature[5]), .ZN(n_0_19));
endmodule

module DFF_register(D, clk, enable, reset, Q);
   input [2:0]D;
   input clk;
   input enable;
   input reset;
   output [2:0]Q;

   INV_X1 i_0_0 (.A(reset), .ZN(n_0));
   DFFR_X2 \Q_reg[1]  (.D(D[1]), .RN(n_0), .CK(clk), .Q(Q[1]), .QN());
   DFFR_X2 \Q_reg[2]  (.D(D[2]), .RN(n_0), .CK(clk), .Q(Q[2]), .QN());
   DFFR_X2 \Q_reg[0]  (.D(D[0]), .RN(n_0), .CK(clk), .Q(Q[0]), .QN());
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
   wire n_0_2;
   wire n_1_0;
   wire n_1_1;
   wire n_2_0;
   wire n_3_0;
   wire n_3_1;
   wire n_4_0;
   wire n_5_0;

   INV_X1 i_0_0 (.A(n_0_0), .ZN(front_door));
   NAND3_X1 i_0_1 (.A1(n_0_2), .A2(n_0_1), .A3(A[0]), .ZN(n_0_0));
   INV_X1 i_0_2 (.A(A[1]), .ZN(n_0_1));
   INV_X1 i_0_3 (.A(A[2]), .ZN(n_0_2));
   INV_X1 i_1_0 (.A(n_1_0), .ZN(rear_door));
   NAND2_X1 i_1_1 (.A1(A[1]), .A2(n_1_1), .ZN(n_1_0));
   NOR2_X1 i_1_2 (.A1(A[2]), .A2(A[0]), .ZN(n_1_1));
   NAND2_X1 i_2_0 (.A1(A[0]), .A2(A[1]), .ZN(n_2_0));
   NOR2_X1 i_2_1 (.A1(n_2_0), .A2(A[2]), .ZN(alarm_buzzer));
   INV_X1 i_3_0 (.A(n_3_0), .ZN(window_buzzer));
   NAND2_X1 i_3_1 (.A1(A[2]), .A2(n_3_1), .ZN(n_3_0));
   NOR2_X1 i_3_2 (.A1(A[1]), .A2(A[0]), .ZN(n_3_1));
   NAND2_X1 i_4_0 (.A1(A[0]), .A2(A[2]), .ZN(n_4_0));
   NOR2_X1 i_4_1 (.A1(n_4_0), .A2(A[1]), .ZN(heater));
   NAND2_X1 i_5_0 (.A1(A[1]), .A2(A[2]), .ZN(n_5_0));
   NOR2_X1 i_5_1 (.A1(n_5_0), .A2(A[0]), .ZN(cooler));
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
