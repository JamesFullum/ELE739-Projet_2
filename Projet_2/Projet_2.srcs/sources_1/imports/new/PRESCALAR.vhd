--------------------------------------------------------------------------------
-- Titre    : Feu Traffique
-- Projet   : ELE739 Phase 1
--------------------------------------------------------------------------------
-- Fichier  : PRESCALAR.vhd
-- Auteur   : Guillaume et James
-- Cr�ation : 2024-02-08
--------------------------------------------------------------------------------
-- Description : Feu de traffique param�trable avec signal d'activation
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned

entity PRESCALAR is
  -- La section generic contient les param�tres de configuration du module.
  generic (
    G_DELAI       : positive := 10; -- valeur maximum pour le d�lai
    G_DELAI_SIZE  : positive := 7  -- taille en bits du registre du compteur
  );

  -- La section port contient les entr�es-sorties du module.
  port (
    i_clk   : in  std_logic;
    i_rst   : in  std_logic;
    i_cen   : in  std_logic;
    o_fin   : out std_logic
  );
end PRESCALAR;

architecture rtl of PRESCALAR is

   -- Compteur pour la dur�e du feu
   signal delai_sig: unsigned(G_DELAI_SIZE-1 downto 0);

begin
   
   process(i_clk)
   begin
      if rising_edge(i_clk) then
         if i_rst = '1' then
            o_fin <= '0';
            delai_sig <= (others => '0');
         else
            if i_cen = '1' then
               if delai_sig = G_DELAI then
                  delai_sig <= (others => '0');
                  o_fin     <= '1';
               else
                  delai_sig <= delai_sig + 1;
                  o_fin     <= '0';
               end if;
            end if;
         end if;
      end if;
   end process;
   
end rtl;