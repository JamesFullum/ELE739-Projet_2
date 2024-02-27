--------------------------------------------------------------------------------
-- Titre    : FIR
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : FIR.vhd
-- Auteur   : Guillaume et James
-- Création : 2024-02-13
--------------------------------------------------------------------------------
-- Description : FIR à étages multiples de pipeline
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned


entity Mux is
  port (
    i_switch   : in  std_logic;
    i_cos      : in  signed( 7 downto 0);
    i_filtre   : in  signed(16 downto 0);
    o_fen      : out std_logic;
    BUS_SORTIE : out signed(16 downto 0)
  );
end Mux;

architecture rtl of Mux is

begin
    process(i_switch, i_filtre, i_cos)
    begin
        if i_switch = '1' then
            o_fen      <= '1';
            BUS_SORTIE <= i_filtre;
        else
            o_fen                   <= '0';
            BUS_SORTIE(16 downto 9) <= i_cos;
            BUS_SORTIE( 8 downto 0) <= (others => '0');
        end if;
    end process;
end rtl;
