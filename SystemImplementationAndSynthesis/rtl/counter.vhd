LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
       PORT (
              clk, enable, reset : IN STD_LOGIC;
              Q : INOUT STD_LOGIC_VECTOR (3 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE counter OF counter IS
BEGIN
       PROCESS (clk, enable, reset)
       BEGIN
              IF reset = '1' THEN
                     Q <= (OTHERS => '0');
              ELSIF rising_edge(clk) AND enable = '1' THEN
                     Q(3) <= ((NOT Q(3)) AND Q(2) AND Q(0)) OR (Q(3) AND ((NOT Q(2)) OR (NOT Q(0))));
                     Q(2) <= (Q(1) AND Q(0)) OR (Q(2) AND (NOT Q(0)));
                     Q(1) <= ((NOT Q(2)) AND (NOT Q(1)) AND Q(0)) OR (Q(1) AND (NOT Q(0)));
                     Q(0) <= NOT Q(0);
              END IF;
       END PROCESS;
END ARCHITECTURE;