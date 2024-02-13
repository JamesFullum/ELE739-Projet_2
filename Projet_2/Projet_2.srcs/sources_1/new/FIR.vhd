--------------------------------------------------------------------------------
-- Titre    : Feu Traffique
-- Projet   : ELE739 Phase 1
--------------------------------------------------------------------------------
-- Fichier  : Feu_Traffique.vhd
-- Auteur   : Guillaume et James
-- Cr�ation : 2024-01-23
--------------------------------------------------------------------------------
-- Description : Feu de traffique param�trable avec signal d'activation
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned

entity Feu_Traffique is
  -- La section generic contient les param�tres de configuration du module.
  generic (
    G_DELAI       : positive := 10; -- valeur maximum pour le d�lai
    G_DELAI_JAUNE : positive := 3; -- Seuil ou la lumi�re va devenir jaune
    G_DELAI_SIZE  : positive := 7 -- taille en bits du registre du compteur
  );

  -- La section port contient les entr�es-sorties du module.
  port (
    i_clk   : in  std_logic;
    i_rst   : in  std_logic;
    i_cen   : in  std_logic;
    o_feu_v : out std_logic;
    o_feu_j : out std_logic;
    o_feu_r : out std_logic;
    o_fin   : out std_logic
  );
end;

architecture rtl of feu_traffique is
   -- Compteur pour la dur�e du feu
   signal delai_sig: unsigned(G_DELAI_SIZE-1 downto 0);
   
   type cmptr_state is (DONE, ROUGE, VERT, JAUNE);
   
   signal current_state : cmptr_state;
   signal next_state    : cmptr_state;
   
begin

  -------------------------------------
  -- Current State Logic
  -------------------------------------
  process(i_clk)
  begin
     if rising_edge(i_clk) then
        -- R�initialiser le compteur et �teindre la lumi�re
        if i_rst = '1' then
           delai_sig  <= (others => '0');
           o_feu_v    <= '0';
           o_feu_j    <= '0';
           o_feu_r    <= '1';
           o_fin      <= '0';
           current_state <= ROUGE;
        else
           if i_cen = '1' then
              case next_state is
                 when ROUGE  =>
                    o_feu_r <= '1';
                    o_feu_j <= '0';
                    o_feu_v <= '0';
                    o_fin   <= '0';
                    delai_sig <= (others => '0');
                 when DONE =>
                    o_feu_r <= '1';
                    o_feu_j <= '0';
                    o_feu_v <= '0';
                    o_fin   <= '1';
                    delai_sig <= (others => '0');
                 when JAUNE =>
                    o_feu_r <= '0';
                    o_feu_j <= '1';
                    o_feu_v <= '0';
                    o_fin   <= '0';
                    delai_sig <= delai_sig + 1;
                 when VERT  =>
                    o_feu_r <= '0';
                    o_feu_j <= '0';
                    o_feu_v <= '1';
                    o_fin   <= '0';  
                    delai_sig <= delai_sig + 1;        
                 when others =>
                    o_feu_r <= '1';
                    o_feu_j <= '0';
                    o_feu_v <= '0';
                    o_fin   <= '0';
                    delai_sig <= (others => '0');
                 end case;
                 current_state <= next_state;
            end if;
         end if;
      end if;
   end process;
      
  -------------------------------------
  -- Next State Logic
  -------------------------------------  
  process(delai_sig, current_state, i_cen)
  begin
     case current_state is
        when ROUGE =>
           if i_cen = '1' then
              next_state <= VERT;
           else
              next_state <= ROUGE;
           end if;
        when DONE =>
           next_state <= ROUGE;
        when JAUNE =>
           if delai_sig >= G_DELAI then
              next_state <= DONE;
           else
              next_state <= JAUNE;
           end if;
        when VERT =>
           if delai_sig >= G_DELAI_JAUNE then
              next_state <= JAUNE;
           else
              next_state <= VERT;
           end if;
        when others =>
           next_state <= ROUGE;
     end case;
  end process;

end architecture;