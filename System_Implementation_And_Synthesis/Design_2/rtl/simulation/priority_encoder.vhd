LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY priority_encoder IS
       PORT (
              reset, SFD, SRD, SFA, SW, ST : IN STD_LOGIC;
              temperature : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
              state : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              A : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE priority_encoder OF priority_encoder IS
BEGIN
       PROCESS (reset, SFD, SRD, SFA, SW, ST, state)
       BEGIN
              IF state = "000" THEN
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
              ELSIF state = "001" THEN
                     IF reset = '1' THEN
                            A <= "000";
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
                     ELSIF SFD = '1' THEN
                            A <= "001";
                     ELSE
                            A <= "000";
                     END IF;
              ELSIF state = "010" THEN
                     IF reset = '1' THEN
                            A <= "000";
                     ELSIF SFA = '1' THEN
                            A <= "011";
                     ELSIF SW = '1' THEN
                            A <= "100";
                     ELSIF (ST = '1') AND (temperature < "001001") THEN--temperature is less than 50F
                            A <= "101";
                     ELSIF (ST = '1') AND (temperature > "011101") THEN --temperature is greater than 70F
                            A <= "110";
                     ELSIF SFD = '1' THEN
                            A <= "001";
                     ELSIF SRD = '1' THEN
                            A <= "010";
                     ELSE
                            A <= "000";
                     END IF;
              ELSIF state = "011" THEN
                     IF reset = '1' THEN
                            A <= "000";
                     ELSIF SW = '1' THEN
                            A <= "100";
                     ELSIF (ST = '1') AND (temperature < "001001") THEN --temperature is less than 50F
                            A <= "101";
                     ELSIF (ST = '1') AND (temperature > "011101") THEN --temperature is greater than 70F
                            A <= "110";
                     ELSIF SFD = '1' THEN
                            A <= "001";
                     ELSIF SRD = '1' THEN
                            A <= "010";
                     ELSIF SFA = '1' THEN
                            A <= "011";
                     ELSE
                            A <= "000";
                     END IF;
              ELSE
                     IF reset = '1' THEN
                            A <= "000";
                     ELSIF (ST = '1') AND (temperature < "001001") THEN--temperature is less than 50F
                            A <= "101";
                     ELSIF (ST = '1') AND (temperature > "011101") THEN --temperature is greater than 70F
                            A <= "110";
                     ELSIF SFD = '1' THEN
                            A <= "001";
                     ELSIF SRD = '1' THEN
                            A <= "010";
                     ELSIF SFA = '1' THEN
                            A <= "011";
                     ELSIF SW = '1' THEN
                            A <= "100";
                     ELSE
                            A <= "000";
                     END IF;
              END IF;
       END PROCESS;

END ARCHITECTURE;