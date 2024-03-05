--------------------------------------------------------------------------------
-- Titre    : FIR
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : FIR.vhd
-- Auteur   : James
-- Création : 2024-02-13
--------------------------------------------------------------------------------
-- Description : FIR à étages multiples de pipeline
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned

entity FIR is
  -- La section generic contient les paramètres de configuration du module.
  generic (
    -- Coefficients du filtre
    G_H_0       : integer := 10;
    G_H_1       : integer := 10;
    G_H_2       : integer := 10;
    G_H_3       : integer := 10;
    G_H_4       : integer := 10;
    G_H_5       : integer := 10;
    G_H_6       : integer := 10;
    G_H_7       : integer := 10   
  );

  -- La section port contient les entrées-sorties du module.
  port (
    i_clk   : in  std_logic;            -- Horloge du filtre
    RESET_G : in  std_logic;            -- Reset du filtre
    i_cen   : in  std_logic;            -- Enable de l'horloge
    i_fen   : in  std_logic;            -- Enable du filtre
    i_cos   : in  signed(7  downto 0);  -- Entree de la generateur du signal
    o_sig   : out signed(15 downto 0)   -- Sortie du filtre
  );
end;

architecture rtl of FIR is

   -- Array pour les donnees
   type t_cos is array (15 downto 0) of signed(7 downto 0);
   signal cos_int : t_cos;
   
   -- Array pour les coefficients du filtre
   type t_h is array (7 downto 0) of signed(5 downto 0);
   signal h_int : t_h;
   
   -- Array pour les resultats des multiplications
   type t_mult is array (7 downto 0) of signed(15 downto 0);
   signal mult_int : t_mult;
   
   -- Array pour les resultats des additions
   type t_add is array (7 downto 0) of signed(15 downto 0);
   signal add_int : t_add;
   
begin


------------------------------------------
---    Assignation des coefficients    ---
------------------------------------------
    h_int(0) <= to_signed(G_H_0,h_int(0)'length);
    h_int(1) <= to_signed(G_H_1,h_int(1)'length);
    h_int(2) <= to_signed(G_H_2,h_int(2)'length);
    h_int(3) <= to_signed(G_H_3,h_int(3)'length);
    h_int(4) <= to_signed(G_H_4,h_int(4)'length);
    h_int(5) <= to_signed(G_H_5,h_int(5)'length);
    h_int(6) <= to_signed(G_H_6,h_int(6)'length);
    h_int(7) <= to_signed(G_H_7,h_int(7)'length);

-------------------------------------
---    Propogation des Donnees    ---
------------------------------------- 
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' then
                for i in 0 to 15 loop
                    cos_int(i) <= (others => '0');
                end loop;
            else
                if i_cen = '1' and i_fen = '1' then
                    cos_int(15) <= i_cos;
                    for i in 0 to 14 loop
                        cos_int(i) <= cos_int(i+1);
                    end loop;
                end if;
            end if; 
        end if;
    end process;
    
-------------------------------
---     Multiplication      ---
-------------------------------
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' then
                for i in 0 to 7 loop 
                    mult_int(i) <= (others => '0');
                end loop;
            else
                if i_cen = '1' and i_fen = '1' then
                    for i in 0 to 7 loop
                        mult_int(i) <= resize((cos_int(15-2*i) * h_int(i)), mult_int(i)'length);
                    end loop;
                end if;
            end if;
        end if;
    end process;

-------------------------------
---       Accumulation      ---
-------------------------------
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if RESET_G = '1' then
                for i in 0 to 7 loop
                    add_int(i)   <= (others => '0');
                end loop;
            else
                if i_cen = '1' and i_fen = '1' then
                    add_int(7)  <= resize(mult_int(0)+"000000000000000", add_int(7)'length);
                    for i in 0 to 6 loop
                        add_int(i)   <= mult_int(7-i)+add_int(i+1);
                    end loop;
                end if;
            end if; 
        end if;
    end process;
    
-------------------------------
---         Output          ---
-------------------------------
    process(i_clk)
    begin
        if rising_edge (i_clk) then
            if RESET_G = '1' then
                o_sig <= (others => '0');
            else
                if i_cen = '1' and i_fen = '1' then
                    o_sig <= add_int(0);
                end if;
            end if;
        end if;
    end process;

end architecture;