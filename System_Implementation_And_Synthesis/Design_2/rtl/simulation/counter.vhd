LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY counter IS
       PORT (
              clk, enable, reset : IN STD_LOGIC;
              Q : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE counter OF counter IS
BEGIN
       PROCESS (clk)
       BEGIN
              IF rising_edge(clk) THEN
                     IF reset = '1' THEN
                            Q <= (OTHERS => '0');
                     ELSIF enable = '1' THEN
                            IF Q = "100" THEN
                                   Q <= "000";
                            ELSE
                                   Q <= Q + 1;
                            END IF;
                     END IF;
              END IF;
       END PROCESS;
END ARCHITECTURE;