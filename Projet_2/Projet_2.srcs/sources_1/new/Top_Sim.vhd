--------------------------------------------------------------------------------
-- Titre    : Top Simulation
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : Top_Sim.vhd
-- Auteur   : Guillaume et James
-- Création : 2024-02-26
--------------------------------------------------------------------------------
-- Description : Top Level Entity pour rouler les simulations
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned

entity Top_Sim is
  -- La section generic contient les paramètres de configuration du module.
  generic (
    G_H_0    : integer := 10; -- valeur maximum pour le délai
    G_H_1    : integer := 10; -- valeur maximum pour le délai
    G_H_2    : integer := 10; -- valeur maximum pour le délai
    G_H_3    : integer := 10; -- valeur maximum pour le délai
    G_H_4    : integer := 10; -- valeur maximum pour le délai
    G_H_5    : integer := 10; -- valeur maximum pour le délai
    G_H_6    : integer := 10; -- valeur maximum pour le délai
    G_H_7    : integer := 10 -- valeur maximum pour le délai    
  );

  -- La section port contient les entrées-sorties du module.
  port (
    i_clk      : in  std_logic;
    RESET_G    : in  std_logic;
    i_cen      : in  std_logic;
    i_switch   : in  std_logic;
    BUS_SORTIE : out signed(16 downto 0)
  );
end;



architecture rtl of Top_Sim is
    -- Déclaration du composant pour le FIR
    component FIR is
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
            i_rst   : in  std_logic;
            i_cen   : in  std_logic;
            i_fen   : in  std_logic;
            i_cos   : in  signed(7  downto 0);
            o_sig   : out signed(16 downto 0)
        );
    end component;
    
    
    -- Déclaration du composant pour le Générateur de Cosinus
    component Gen_Sig is        
        port (
            i_clk   : in  std_logic;
            i_rst   : in  std_logic;
            i_cen   : in  std_logic;
            o_sig   : out signed(7 downto 0)
        );
    end component;
    
    -- Déclaration du composant pour le Multiplexeur de Sortie 
    component Mux is
        port (
            i_switch   : in  std_logic;
            i_cos      : in  signed( 7 downto 0);
            i_filtre   : in  signed(16 downto 0);
            o_fen      : out std_logic;
            BUS_SORTIE : out signed(16 downto 0)
        );
    end component;
    
    -- Signaux internes pour les connexions intermodules
    signal cos_int     : signed(7  downto 0);
    signal cos_fir_int : signed(16 downto 0);
    signal fen_int     : std_logic;

begin
    -- Instantiation du FIR
    FIR_INST : FIR
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
            i_clk => i_clk,
            i_rst => RESET_G,
            i_cen => i_cen,
            i_fen => fen_int,
            i_cos => cos_int,
            o_sig => cos_fir_int
        );


    -- Instantiation du Générateur de Cosinus
    Gen_sig_INST : Gen_sig        
        port map(
            i_clk => i_clk,
            i_rst => RESET_G,
            i_cen => i_cen,
            o_sig => cos_int
        );
        
    -- Instantiation du Multiplexeur de Sortie
    Mux_INST : Mux        
        port map(
            i_switch   => i_switch,
            i_cos      => cos_int,
            i_filtre   => cos_fir_int,
            o_fen      => fen_int,
            BUS_SORTIE => BUS_SORTIE
        );
end rtl;
