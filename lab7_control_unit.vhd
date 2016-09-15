library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab7_control_unit is

port(
        Instruction : in std_logic_vector(15 downto 0);
        Status_Bits : in std_logic_vector(2 downto 0);
        AccLoad : out std_logic;
        Memory_Write : out std_logic;
        ALUinSel : out std_logic;
        MUX1Sel : out std_logic;
        MUX2Sel : out std_logic_vector(1 downto 0);
        Memory_Address : out std_logic_vector(15 downto 0);
        Opcode : out std_logic_vector(5 downto 0);
        from_control_unit : out std_logic_vector(7 downto 0));


end lab7_control_unit;

architecture Behavioral of lab7_control_unit is
begin
  process (Instruction)
  variable Lower8: std_logic_vector (7 downto 0);
  variable Opcode: std_logic_vector (7 downto 0);
  variable Opcode_first_nybble: std_logic_vector (3 downto 0);
  variable Opcode_second_nybble: std_logic_vector (3 downto 0);
  variable PC_Register: std_logic_vector (15 downto 0);
  begin
  Opcode := Instruction(15 downto 8);
  Lower8 := Instruction(7 downto 0);
  Opcode_first_nybble := Instruction(15 downto 12);
  Opcode_second_nybble := Instruction(11 downto 8);

  from_control_unit<=Lower8;

  case Opcode_first_nybble is

    when "0010" =>  -- Branch - FINE
      MUX2Sel <= "00";
      AccLoad <= '0';
      ALUinSel <= '0';
      Memory_Write <= '0';

    when "1010" =>    -- immediate - FINE
      MUX1Sel <= '0';
      MUX2Sel <= "00";

      if (Opcode_second_nybble = "0001") then
        AccLoad <= '0';
      else
        AccLoad <= '1';
      end if;

      ALUinSel <= '1';
      Memory_Write <= '0';


    when "0100" =>      -- inherent - FINE
      MUX2Sel <= "00";
      AccLoad <= '1';
      ALUinSel <= '0';
      Memory_Write <= '0';

    when "0011" =>      -- direct - FINE
      MUX1Sel <= '1';
      MUX2Sel <= "00";
      AccLoad <= '0';
      ALUinSel <= '1';
      if ((Opcode_second_nybble = "0111")) then
          -- EXCEPT STA ???
      else
        Memory_Write <= NOT(Opcode(7));
      end if;

    when "1011" =>      -- direct - FINE
      MUX1Sel <= '1';
      MUX2Sel <= "00";

      if ((Opcode_second_nybble = "0001") OR (Opcode_second_nybble = "0111")) then
        AccLoad <= '0';
      else
        AccLoad <= '1';
      end if;

      ALUinSel <= '1';
      if ((Opcode_second_nybble = "0111")) then
          -- EXCEPT STA ???
      else
        Memory_Write <= NOT(Opcode(7));
      end if;

  	when others =>

    end case;
  end process;
end Behavioral;
