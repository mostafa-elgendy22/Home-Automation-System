LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY home_automation_system IS
       PORT (
              clk : IN STD_LOGIC;
              reset : IN STD_LOGIC;
              SFD, SRD, SFA, SW, ST : IN STD_LOGIC;
              --The temperature range from 41 to 104 degree fahrenheit (5 to 40 degree celsius) (can be represented with 6-bits "floor(log2(104 - 41 + 1))")
              temperature : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
              front_door, rear_door, alarm_buzzer, window_buzzer, heater, cooler : OUT STD_LOGIC;
              display : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE arch1 OF home_automation_system IS

       SIGNAL counter_enable : STD_LOGIC;
       SIGNAL counter_Q : STD_LOGIC_VECTOR(2 DOWNTO 0);
       SIGNAL A : STD_LOGIC_VECTOR(2 DOWNTO 0);
       SIGNAL state : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

       priority_encoder : ENTITY work.priority_encoder
              PORT MAP(
                     reset => reset,
                     SFD => SFD,
                     SRD => SRD,
                     SFA => SFA,
                     SW => SW,
                     ST => ST,
                     temperature => temperature,
                     state => counter_Q,
                     A => A
              );

       counter_enable <= SFD OR SRD OR SFA OR SW OR ST;
       counter : ENTITY work.counter
              PORT MAP(
                     clk => clk,
                     reset => reset,
                     enable => counter_enable,
                     Q => counter_Q
              );
       state_holder : ENTITY work.DFF_register
              generic map(data_width => 3)
              port map(
                     clk => clk,
                     reset => reset,
                     enable => '1',
                     D => A,
                     Q => state
              );
       output_decoder : ENTITY work.decoder
              PORT MAP(
                     A => state,
                     front_door => front_door,
                     rear_door => rear_door,
                     alarm_buzzer => alarm_buzzer,
                     window_buzzer => window_buzzer,
                     heater => heater,
                     cooler => cooler
              );
       display <= state;

END ARCHITECTURE;