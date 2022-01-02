LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY counter IS
       PORT (
              clk, enable, reset : IN STD_LOGIC;
              Q : INOUT STD_LOGIC_VECTOR (3 DOWNTO 0)
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
                            -- Q(3) <= ((NOT Q(3)) AND Q(2) AND Q(0)) OR (Q(3) AND ((NOT Q(2)) OR (NOT Q(0))));
                            -- Q(2) <= (Q(1) AND Q(0)) OR (Q(2) AND (NOT Q(0)));
                            -- Q(1) <= ((NOT Q(2)) AND (NOT Q(1)) AND Q(0)) OR (Q(1) AND (NOT Q(0)));
                            -- Q(0) <= NOT Q(0);
                            IF Q(2 DOWNTO 0) = "100" THEN
                                   Q(2 DOWNTO 0) <= "000";
                                   Q(3) <= NOT Q(3);
                            ELSE
                                   Q(2 DOWNTO 0) <= Q(2 DOWNTO 0) + 1;
                            END IF;
                     END IF;
              END IF;
       END PROCESS;
END ARCHITECTURE;