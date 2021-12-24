LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY priority_encoder IS
       PORT (
              reset, SFD, SRD, SFA, SW, ST : IN STD_LOGIC;
              temperature : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
              A : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE priority_encoder OF priority_encoder IS
BEGIN
       A <= "000" WHEN reset = '1'
              ELSE
              "001" WHEN SFD = '1'
              ELSE
              "010" WHEN SRD = '1'
              ELSE
              "011" WHEN SFA = '1'
              ELSE
              "100" WHEN SW = '1'
              ELSE
              "101" WHEN (ST = '1') AND (temperature < "001001")      --temperature is less than 50F
              ELSE
              "110" WHEN (ST = '1') AND (temperature > "011101")      --temperature is greater than 70F
              ELSE
              "000";
END ARCHITECTURE;