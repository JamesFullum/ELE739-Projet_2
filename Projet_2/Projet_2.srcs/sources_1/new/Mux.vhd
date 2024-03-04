--------------------------------------------------------------------------------
-- Titre    : Mux
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : Mux.vhd
-- Auteur   : Guillaume
-- Création : 2024-02-26
--------------------------------------------------------------------------------
-- Description : Multiplexeur pour les signaux de sorties
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux is
    generic (  
        BIT_WIDTH       : positive := 8;      --Nombre de bits pour représenter l'amplitude
        BUS_SIZE        : positive := 16      --Nombre de bits pour le BUS DE SORTIE
    );
    port ( 
        i_mode          : in  std_logic;
        i_generateur    : in  signed(BIT_WIDTH-1 downto 0);
        i_filtre        : in  signed(BUS_SIZE-1 downto 0);
        o_fen           : out std_logic;
        BUS_SORTIE      : out std_logic_vector(BUS_SIZE-1 downto 0)
    );
end Mux;

architecture rtl of Mux is

begin
    process(i_mode, i_filtre, i_generateur)
    begin
        if i_mode = '1' then
            BUS_SORTIE <= std_logic_vector(i_filtre);
            o_fen      <= '1';
        else
            BUS_SORTIE(15 downto 8) <= std_logic_vector(i_generateur); 
            BUS_SORTIE( 7 downto 0) <= (others => '0');
            o_fen                   <= '0';
        end if;
    end process;
end rtl;
