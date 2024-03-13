--------------------------------------------------------------------------------
-- Titre      : Top Experimental - Phase 2
-- Projet     : ELE739 - Phase 2
--------------------------------------------------------------------------------
-- Fichier    : Top_Exp.vhd
-- Auteur     : James
-- Création   : 2024-03-03
--------------------------------------------------------------------------------
-- Description : Top physique pour implémenter sur la carte Basys3
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;  -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;     -- Pour les types signed et unsigned

entity Top_Exp is
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
    clk  : in  std_logic; -- Horloge du Basys3
    btnC : in  std_logic; -- Bouton pour le reset
    sw   : in  std_logic_vector(0 downto 0); -- Interrupteur pour contrôler la sortie du module
    led  : out std_logic_vector(15 downto 0)
  );
  
end Top_Exp;

architecture rtl of Top_Exp is

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
    
    -- Declaration du prescalar
    component PRESCALAR is
        generic (
            G_DELAI          : positive;
            G_DELAI_SIZE     : positive
        );
        port (
            i_clk      : in  std_logic;
            i_rst      : in  std_logic;
            i_cen      : in  std_logic;
            o_fin      : out std_logic
        );
    end component;  
    
    -- Declaration du ILA
    component ila_0
        port(
            clk    : in std_logic;
            probe0 : in std_logic;
            probe1 : in std_logic;
            probe2 : in std_logic;
            probe3 : in std_logic_vector(BUS_SIZE-1 downto 0)      
        );
    end component;
    
    -- Signaux internes du Top Experimental
    signal cen_int        : std_logic;
    signal BUS_SORTIE_int : std_logic_vector(BUS_SIZE-1 downto 0);

begin

    led         <= BUS_SORTIE_int;

    -- Instantiation du module
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
            RESET_G    => btnC,
            i_cen      => cen_int,
            i_switch   => sw(0),
            BUS_SORTIE => BUS_SORTIE_int
        );

     -- Instantiation du PRESCALAR
    PRESCALAR_INST: PRESCALAR
        generic map(
            G_DELAI      => 1,
            G_DELAI_SIZE => 1
        )
        port map(
            i_clk => clk,
            i_rst => btnC,
            i_cen => '1',
            o_fin => cen_int
        ); 

     -- Instantiation du ILA
     ILA_INST : ila_0
        port map(
            clk     => clk,
            probe0  => btnC,
            probe1  => cen_int,
            probe2  => sw(0),
            probe3  => BUS_SORTIE_int  
        );

end rtl;
