LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY home_automation_system IS
       PORT (
              clk : IN STD_LOGIC;
              reset : IN STD_LOGIC;
              SFD, SRD, SW, SFA, ST : IN STD_LOGIC;
              --The temperature range from 41 to 104 degree fahrenheit (5 to 40 degree celsius) (can be represented with 6-bits "floor(log2(104 - 41 + 1))")
              temperature : IN STD_LOGIC_VECTOR(5 DOWNTO 0); 
              front_door, rear_door, window_buzzer, alarm_buzzer, heater, cooler : OUT STD_LOGIC;
              display : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
       );
END ENTITY;
