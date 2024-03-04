--------------------------------------------------------------------------------
-- Titre      : Banc d'essai Phase 2
-- Projet     : ELE739 - Phase 2
--------------------------------------------------------------------------------
-- Fichier    : Feu_Traffique.vhd
-- Auteur     : Guillaume et James
-- Création   : 2024-02-26
--------------------------------------------------------------------------------
-- Description : Banc d'essai pour la phase 2
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;  -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;     -- Pour les types signed et unsigned

-- L'entité d'un banc d'essai est toujours vide
entity TB_Phase_2 is
end entity TB_Phase_2;

architecture testbench of TB_Phase_2 is

  -- Définition des paramètres génériques du module testé en constantes 
  -- Coefficients du filtre FIR
  constant G_H_0          : integer  := 31; 
  constant G_H_1          : integer  := 31; 
  constant G_H_2          : integer  := 31; 
  constant G_H_3          : integer  := 31; 
  constant G_H_4          : integer  := -32; 
  constant G_H_5          : integer  := -32; 
  constant G_H_6          : integer  := -32; 
  constant G_H_7          : integer  := -32; 
  -- Nombre d'échantillons a prendre
  constant NB_ECHANTILLON : positive := 16;
  -- Taille de la sortie du generateur de signal
  constant BIT_WIDTH      : positive := 8;
  -- Taille de la sortie du module
  constant BUS_SIZE       : positive := 16;

  -- Déclaration du composant à tester
  component Top_Sim is
    generic (
       -- Coefficients du filtre FIR
       G_H_0          : integer  := 10;
       G_H_1          : integer  := 10;
       G_H_2          : integer  := 10;
       G_H_3          : integer  := 10;
       G_H_4          : integer  := 10;
       G_H_5          : integer  := 10;
       G_H_6          : integer  := 10;
       G_H_7          : integer  := 10;
       -- Nombre d'échantillons a prendre
       NB_ECHANTILLON : positive := 16;
       -- Taille de la sortie du generateur de signal
       BIT_WIDTH      : positive :=  8;
       -- Taille de la sortie du module
       BUS_SIZE       : positive := 16
    );
    port (
       i_clk      : in  std_logic; -- Horloge du module
       RESET_G    : in  std_logic; -- Reset du module   
       i_cen      : in  std_logic; -- Enable de l'horloge
       i_switch   : in  std_logic; -- Interrupteur pour changer le mode de sortiedu module 
       BUS_SORTIE : out std_logic_vector(BUS_SIZE-1 downto 0) -- La sortie du module
    );
    end component;

  -- Définition des ports du module testé en signaux
  signal clk        : std_logic;
  signal reset      : std_logic;  
  signal cen        : std_logic;
  signal switch     : std_logic;
  signal BUS_SORTIE : std_logic_vector(BUS_SIZE-1 downto 0);

begin

--------------------------------------------------------------------------------
-- Simulation de l'horloge et du reset
--------------------------------------------------------------------------------
  clk_gen : process
  begin
    -- Simulation d'une horloge de 50MHz avec un taux de charge de 50%
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
  end process clk_gen;

  reset_gen : process
  begin
     reset <= '1';
     wait for 100 ns;
     reset <= '0';
     wait for 35000 ns;
  end process;

--------------------------------------------------------------------------------
-- Simulation des stimuli
--------------------------------------------------------------------------------
  main : process
  begin
    cen    <= '1';
    switch <= '1';
    wait for 5000 ns;
    switch <= '0';
    wait for 5000 ns;
  end process;

--------------------------------------------------------------------------------
-- Configuration du module à tester
--------------------------------------------------------------------------------
    DUT : Top_Sim
        generic map (
            G_H_0 => G_H_0,
            G_H_1 => G_H_1,
            G_H_2 => G_H_2,
            G_H_3 => G_H_3,
            G_H_4 => G_H_4,
            G_H_5 => G_H_5,
            G_H_6 => G_H_6,
            G_H_7 => G_H_7
        )
        port map (
            i_clk      => clk,
            RESET_G    => reset,
            i_cen      => cen,
            i_switch   => switch,
            BUS_SORTIE => BUS_SORTIE
        );

end architecture testbench;