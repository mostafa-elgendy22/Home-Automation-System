LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY decoder IS
       PORT (
              A : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
              front_door, rear_door, alarm_buzzer, window_buzzer, heater, cooler : OUT STD_LOGIC
       );
END ENTITY;

ARCHITECTURE decoder OF decoder IS
BEGIN

       front_door <= '1' WHEN A = "001" ELSE
              '0';

       rear_door <= '1' WHEN A = "010" ELSE
              '0';

       alarm_buzzer <= '1' WHEN A = "011" ELSE
              '0';

       window_buzzer <= '1' WHEN A = "100" ELSE
              '0';

       heater <= '1' WHEN A = "101" ELSE
              '0';

       cooler <= '1' WHEN A = "110" ELSE
              '0';

END ARCHITECTURE;