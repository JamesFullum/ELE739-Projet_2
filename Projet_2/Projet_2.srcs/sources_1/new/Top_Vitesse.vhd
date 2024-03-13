--------------------------------------------------------------------------------
-- Titre      : Top Experimental - Phase 2
-- Projet     : ELE739 - Phase 2
--------------------------------------------------------------------------------
-- Fichier    : Top_Vitesse.vhd
-- Auteur     : James
-- Création   : 2024-03-03
--------------------------------------------------------------------------------
-- Description : Top physique pour implémenter sur la carte Basys3
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;  -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;     -- Pour les types signed et unsigned

entity Top_Vitesse is
  generic (
    -- Coefficients du filtre FIR
    G_H_0          : integer  := 32;
    G_H_1          : integer  := 31;
    G_H_2          : integer  := 30;
    G_H_3          : integer  := 29;
    G_H_4          : integer  := -32;
    G_H_5          : integer  := -31;
    G_H_6          : integer  := -30;
    G_H_7          : integer  := -29;
    -- Nombre d'échantillons a prendre
    NB_ECHANTILLON : positive := 16;
    -- Taille de la sortie du generateur de signal
    BIT_WIDTH      : positive :=  8;
    -- Taille de la sortie du module
    BUS_SIZE       : positive := 16
  );
  port (
    clk  : in  std_logic; -- Horloge du Basys3
    btnC : in  std_logic; -- Bouton pour le reset
    led  : out std_logic_vector(15 downto 0)
  );
  
end Top_Vitesse;

architecture rtl of Top_Vitesse is

    -- Déclaration du composant à tester
    component FIR_T is
        generic (
            G_H_0 : integer;
            G_H_1 : integer;
            G_H_2 : integer;
            G_H_3 : integer;
            G_H_4 : integer;
            G_H_5 : integer;
            G_H_6 : integer; 
            G_H_7 : integer    
        );
        port (
            i_clk   : in  std_logic;
            RESET_G : in  std_logic;
            i_cen   : in  std_logic;
            i_fen   : in  std_logic;
            i_cos   : in  signed(7  downto 0);
            o_sig   : out signed(15 downto 0)
        );
    end component; 
    
    -- Signaux internes du Top Experimental
    signal BUS_SORTIE_int : signed(BUS_SIZE-1 downto 0);

begin

    -- Instantiation du FIR
    FIR_INST : FIR_T
        generic map(
            G_H_0 => G_H_0,
            G_H_1 => G_H_1,
            G_H_2 => G_H_2,
            G_H_3 => G_H_3,
            G_H_4 => G_H_4,
            G_H_5 => G_H_5,
            G_H_6 => G_H_6,
            G_H_7 => G_H_7
        )
        port map(
            i_clk   => clk,
            RESET_G => btnC,
            i_cen   => '1',
            i_fen   => '1',
            i_cos   => "11111111",
            o_sig   => BUS_SORTIE_int
        );

     led <= std_logic_vector(BUS_SORTIE_int);

end rtl;
