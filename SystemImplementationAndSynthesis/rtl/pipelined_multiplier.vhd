LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pipelined_multiplier IS
       PORT (
              A, B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
              clk : IN STD_LOGIC;
              enable : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
              C : OUT STD_LOGIC_VECTOR(30 DOWNTO 0));
END ENTITY;

ARCHITECTURE pipelined_multiplier OF pipelined_multiplier IS

       SIGNAL first_stage_operand1 : STD_LOGIC_VECTOR(14 DOWNTO 0);
       SIGNAL first_stage_operand2 : STD_LOGIC_VECTOR(14 DOWNTO 0);
       SIGNAL negative_product_second_stage : STD_LOGIC;
       SIGNAL negative_product_third_stage : STD_LOGIC;
       SIGNAL product : STD_LOGIC_VECTOR(29 DOWNTO 0);

       COMPONENT first_stage IS
              PORT (
                     A, B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                     clk, enable : IN STD_LOGIC;
                     negative_product_second_stage : OUT STD_LOGIC;
                     operand1, operand2 : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
              );
       END COMPONENT;

       COMPONENT second_stage IS
              PORT (
                     operand1, operand2 : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                     clk, enable : IN STD_LOGIC;
                     negative_product : IN STD_LOGIC;
                     negative_product_third_stage : OUT STD_LOGIC;
                     product : OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
              );
       END COMPONENT;

       COMPONENT third_stage IS
              PORT (
                     clk, enable : IN STD_LOGIC;
                     negative_product : IN STD_LOGIC;
                     product : IN STD_LOGIC_VECTOR(29 DOWNTO 0);
                     C : OUT STD_LOGIC_VECTOR(30 DOWNTO 0)
              );
       END COMPONENT;
BEGIN
       stage1 : first_stage PORT MAP(
              A => A,
              B => B,
              clk => clk,
              enable => enable(2),
              negative_product_second_stage => negative_product_second_stage,
              operand1 => first_stage_operand1,
              operand2 => first_stage_operand2
       );

       stage2 : second_stage PORT MAP(
              operand1 => first_stage_operand1,
              operand2 => first_stage_operand2,
              clk => clk,
              enable => enable(1),
              negative_product => negative_product_second_stage,
              negative_product_third_stage => negative_product_third_stage,
              product => product
       );

       stage3 : third_stage PORT MAP(
              clk => clk,
              enable => enable(0),
              negative_product => negative_product_third_stage,
              product => product,
              C => C
       );
END ARCHITECTURE;

------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY first_stage IS
       PORT (
              A, B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
              clk, enable : IN STD_LOGIC;
              negative_product_second_stage : OUT STD_LOGIC;
              operand1, operand2 : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE first_stage OF first_stage IS
BEGIN
       PROCESS (clk, enable)
       BEGIN
              IF rising_edge(clk) AND enable = '1' THEN
                     IF A(15) = '1' THEN
                            operand1 <= - A(14 DOWNTO 0);
                     ELSE
                            operand1 <= A(14 DOWNTO 0);
                     END IF;

                     IF B(15) = '1' THEN
                            operand2 <= - B(14 DOWNTO 0);
                     ELSE
                            operand2 <= B(14 DOWNTO 0);
                     END IF;
                     negative_product_second_stage <= A(15) XOR B(15);
              END IF;
       END PROCESS;
END ARCHITECTURE;

------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY second_stage IS
       PORT (
              operand1, operand2 : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
              clk, enable : IN STD_LOGIC;
              negative_product : IN STD_LOGIC;
              negative_product_third_stage : OUT STD_LOGIC;
              product : OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
       );

END ENTITY;

ARCHITECTURE second_stage OF second_stage IS
BEGIN
       PROCESS (clk, enable)
       BEGIN
              IF rising_edge(clk) AND enable = '1' THEN
                     product <= operand1 * operand2;
              END IF;

              IF falling_edge(clk) AND enable = '1' THEN
                     negative_product_third_stage <= negative_product;
              END IF;

       END PROCESS;
END ARCHITECTURE;

------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_signed.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY third_stage IS
       PORT (
              clk, enable : IN STD_LOGIC;
              negative_product : IN STD_LOGIC;
              product : IN STD_LOGIC_VECTOR(29 DOWNTO 0);
              C : OUT STD_LOGIC_VECTOR(30 DOWNTO 0)
       );

END ENTITY;

ARCHITECTURE third_stage OF third_stage IS
BEGIN
       PROCESS (clk, enable)
       BEGIN
              IF falling_edge(clk) AND enable = '1' THEN
                     IF negative_product = '1' THEN
                            C <= '1' & (-product);
                     ELSE
                            C <= '0' & product;
                     END IF;
              END IF;
       END PROCESS;
END ARCHITECTURE;