LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY priority_encoder IS
       PORT (
              reset, SFD, SRD, SFA, SW, ST : IN STD_LOGIC;
              temperature : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
              reversed_priority : IN STD_LOGIC;
              A : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE priority_encoder OF priority_encoder IS
BEGIN
       PROCESS (reset, SFD, SRD, SFA, SW, ST, temperature, reversed_priority)
       BEGIN
              IF reversed_priority = '0' THEN
                     IF reset = '1' THEN
                            A <= "000";
                     ELSIF SFD = '1' THEN
                            A <= "001";
                     ELSIF SRD = '1' THEN
                            A <= "010";
                     ELSIF SFA = '1' THEN
                            A <= "011";
                     ELSIF SW = '1' THEN
                            A <= "100";
                     ELSIF (ST = '1') AND (temperature < "001001") THEN--temperature is less than 50F
                            A <= "101";
                     ELSIF (ST = '1') AND (temperature > "011101") THEN --temperature is greater than 70F
                            A <= "110";
                     ELSE
                            A <= "000";
                     END IF;
              ELSE
                     IF reset = '1' THEN
                            A <= "000";
                     ELSIF (ST = '1') AND (temperature > "011101") THEN --temperature is greater than 70F
                            A <= "110";
                     ELSIF (ST = '1') AND (temperature < "001001") THEN --temperature is less than 50F
                            A <= "101";
                     ELSIF SW = '1' THEN
                            A <= "100";
                     ELSIF SFA = '1' THEN
                            A <= "011";
                     ELSIF SRD = '1' THEN
                            A <= "010";
                     ELSIF SFD = '1' THEN
                            A <= "001";
                     ELSE
                            A <= "000";
                     END IF;
              END IF;
       END PROCESS;

END ARCHITECTURE;