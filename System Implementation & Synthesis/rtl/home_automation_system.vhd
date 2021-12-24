LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

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

       SIGNAL A : STD_LOGIC_VECTOR(2 DOWNTO 0);

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
                     A => A
              );
       -- output_decoder : ENTITY work.decoder
       --        PORT MAP(
       --               A => A,

       --        );

END ARCHITECTURE;