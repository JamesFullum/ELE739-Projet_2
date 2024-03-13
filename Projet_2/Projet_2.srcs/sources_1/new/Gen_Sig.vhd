--------------------------------------------------------------------------------
-- Titre    : Generateur de signal
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : Gen_Sig.vhd
-- Auteur   : Guillaume
-- Création : 2024-02-XX
--------------------------------------------------------------------------------
-- Description : Generateur de signal pour le cosinus
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Gen_sig is
  generic (
           NB_ECHANTILLON : positive := 16;    --Nombre d'échantillon pour une période complète du cosinus   
           BIT_WIDTH      : positive := 8      --Nombre de bits pour représenter l'amplitude
  );
  
  Port ( 
        i_clk     : in std_logic;
        RESET_G   : in std_logic;                       --Reset global controllé par un bouton
        i_cen     : in std_logic;
        i_fen     : in std_logic;
        o_cos     : out signed (BIT_WIDTH-1 downto 0)   --Signal de sortie échantillonné du cosinus (Amplitude)
  );
end Gen_sig;

architecture rtl of Gen_sig is
    signal echantillon_index    : natural range 0 to NB_ECHANTILLON-1 :=0;           -- Intervalle d'échantillonnage
    
    signal fen_del  : std_logic;
    signal fen_chng : std_logic;
    
    type   tableau_cosinus is array (0 to NB_ECHANTILLON-1) of signed(7 downto 0);     -- Tableau contenant les valeurs d'amplitude  
    signal cos_s : tableau_cosinus := (
        "01111111", -- nouveau = 127 =           127 ancien: x"3F" = 63
        "01101111", -- nouveau = 111 = sqrt(3)/2*127, ancien: x"3A" = 58
        "01011011", -- nouveau = 91  = sqrt(2)/2*127, ancien: x"2C" = 44
        "01000000", -- nouveau = 64  =       1/2*127, ancien: x"18" = 24
        "00000000", -- 0
        "11000000", -- nouveau =-64 =      -1/2*128, ancien: x"98" = -104
        "10100101", -- nouveau =-91 =-sqrt(2)/2*128, ancien: x"AC" = -84
        "10010001", -- nouveau =-111=-sqrt(3)/2*128, ancien: x"BA" = -70
        "10000001", -- nouveau =-127=        -128+1, ancien: x"BF" = -65
        "10010001", -- nouveau =-111=-sqrt(3)/2*128, ancien: x"BA" = -70
        "10100101", -- nouveau =-91 =-sqrt(2)/2*128, ancien: x"AC" = -84
        "11000000", -- nouveau =-64 =      -1/2*128, ancien: x"98" = -104
        "00000000", -- 0
        "01000000", -- nouveau = 64 =       1/2*127, ancien: x"18" = 24
        "01011011", -- nouveau = 91 = sqrt(2)/2*127, ancien: x"2C" = 44
        "01101111"  -- nouveau = 111= sqrt(3)/2*127, ancien: x"3A" = 58
        );
    -- Le MSB a gauche est le bit de signe, le point se situe entre le 1ere et 2eme bit ce qui donne une variation de [0.984375;-0.992187]

begin
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' or (fen_chng = '1') then
                echantillon_index <= 0;
                o_cos <= (others => '0');
            else
                if i_cen = '1' then
                   o_cos <= cos_s(echantillon_index);
                   echantillon_index <= (echantillon_index+1) mod NB_ECHANTILLON;
                end if;   
            end if;
        end if; 
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' then
                fen_del <= '0';
            else
                if i_cen = '1' then
                    fen_del <= i_fen;
                end if;
            end if;
        end if;
    end process;    
    
    fen_chng <= fen_del xor i_fen;
      
end rtl;
