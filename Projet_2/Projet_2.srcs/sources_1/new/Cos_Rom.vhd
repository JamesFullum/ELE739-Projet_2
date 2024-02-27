--------------------------------------------------------------------------------
-- Titre    : Cos_Rom
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : Cos_Rom.vhd
-- Auteur   : Guillaume et James
-- Création : 2024-02-24
--------------------------------------------------------------------------------
-- Description : Generateur de signal
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned

entity Cos_Rom is
  port (
    i_addr  : in  unsigned(3 downto 0);
    o_dat   : out signed(7 downto 0)
  );
end Cos_Rom;

architecture rtl of Cos_Rom is

    type mem is array (0 to 8) of signed(7 downto 0);
    constant rom : mem := (
        0 => "01111110", --   126 0.9999
        1 => "01101111", --   111 sqrt(3)/2
        2 => "01011011", --    91 sqrt(2)/2
        3 => "01000000", --    64 1/2
        4 => "00000000", --     0 0
        5 => "11000000", --   -64 -1/2
        6 => "10100101", --   -91 -sqrt(2)/2
        7 => "10010001", --  -111 -sqrt(3)/2
        8 => "10000001"  --  -127 -0.9999  
    );

begin

    process(i_addr)
    begin
        case i_addr is
            when "0000" =>
                o_dat <= rom(0);
            when "0001" =>
                o_dat <= rom(1);
            when "0010" =>
                o_dat <= rom(2);
            when "0011" =>
                o_dat <= rom(3);
            when "0100" =>
                o_dat <= rom(4);
            when "0101" =>
                o_dat <= rom(5);
            when "0110" =>
                o_dat <= rom(6);
            when "0111" =>
                o_dat <= rom(7);
            when others =>
                o_dat <= rom(8);
        end case;
    end process;
   
end rtl;
