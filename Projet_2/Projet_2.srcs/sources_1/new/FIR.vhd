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

entity FIR is
  -- La section generic contient les paramètres de configuration du module.
  generic (
    G_H_0       : integer := 10; -- valeur maximum pour le délai
    G_H_1       : integer := 10; -- valeur maximum pour le délai
    G_H_2       : integer := 10; -- valeur maximum pour le délai
    G_H_3       : integer := 10; -- valeur maximum pour le délai
    G_H_4       : integer := 10; -- valeur maximum pour le délai
    G_H_5       : integer := 10; -- valeur maximum pour le délai
    G_H_6       : integer := 10; -- valeur maximum pour le délai
    G_H_7       : integer := 10 -- valeur maximum pour le délai    
  );

  -- La section port contient les entrées-sorties du module.
  port (
    i_clk   : in  std_logic;
    i_rst   : in  std_logic;
    i_cen   : in  std_logic;
    i_fen   : in  std_logic;
    i_cos   : in  signed(7  downto 0);
    o_sig   : out signed(16 downto 0)
  );
end;

architecture rtl of FIR is

   type t_cos is array (7 downto 0) of signed(7 downto 0);
   signal cos_int : t_cos;
   
   type t_h is array (7 downto 0) of signed(5 downto 0);
   signal h_int : t_h;
   
   type t_m_out is array (7 downto 0) of signed(13 downto 0);
   signal m_out_int : t_m_out;
   
   signal a_out_int_1 : signed(14 downto 0);
   signal a_out_int_2 : signed(14 downto 0);
   signal a_out_int_3 : signed(14 downto 0);
   signal a_out_int_4 : signed(14 downto 0);
   
   signal a_out_fin_1 : signed(15 downto 0);
   signal a_out_fin_2 : signed(15 downto 0);
   
begin

    h_int(0) <= to_signed(G_H_0,h_int(0)'length);
    h_int(1) <= to_signed(G_H_1,h_int(1)'length);
    h_int(2) <= to_signed(G_H_2,h_int(2)'length);
    h_int(3) <= to_signed(G_H_3,h_int(3)'length);
    h_int(4) <= to_signed(G_H_4,h_int(4)'length);
    h_int(5) <= to_signed(G_H_5,h_int(5)'length);
    h_int(6) <= to_signed(G_H_6,h_int(6)'length);
    h_int(7) <= to_signed(G_H_7,h_int(7)'length);

-------------------------------
---         Donnees         ---
-------------------------------
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                for i in 0 to 7 loop 
                    cos_int(i) <= (others => '0');
                end loop;
            else
                if i_cen = '1' and i_fen = '1' then
                    cos_int(0) <= i_cos; 
                    for i in 0 to 6 loop 
                        cos_int(i+1) <= cos_int(i);
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
           if i_rst = '1' then
             for i in 0 to 7 loop 
                 m_out_int(i) <= (others => '0');
             end loop;
           else
              if i_cen = '1' and i_fen = '1' then
                for i in 0 to 7 loop 
                    m_out_int(i) <= resize((cos_int(i) * h_int(i)), m_out_int(i)'length);
                end loop;
              end if;
           end if;
        end if;
    end process;

-------------------------------
---        Addition         ---
-------------------------------
    process(i_clk)
    begin
        if rising_edge(i_clk) then
           if i_rst = '1' then
              a_out_int_1 <= (others => '0');
              a_out_int_2 <= (others => '0');
              a_out_int_3 <= (others => '0');
              a_out_int_4 <= (others => '0');
           else
              if i_cen = '1' and i_fen = '1' then
                a_out_int_1 <= resize(m_out_int(0),a_out_int_1'length)+resize(m_out_int(1),a_out_int_1'length);
                a_out_int_2 <= resize(m_out_int(2),a_out_int_2'length)+resize(m_out_int(3),a_out_int_2'length);
                a_out_int_3 <= resize(m_out_int(4),a_out_int_3'length)+resize(m_out_int(5),a_out_int_3'length);
                a_out_int_4 <= resize(m_out_int(6),a_out_int_4'length)+resize(m_out_int(7),a_out_int_4'length);
              end if;
          end if;
        end if;
    end process;

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
               a_out_fin_1 <= (others => '0');
               a_out_fin_2 <= (others => '0');
            else
               if i_cen = '1' and i_fen = '1' then
                a_out_fin_1 <= resize(a_out_int_1,a_out_fin_1'length)+resize(a_out_int_2,a_out_fin_1'length);
                a_out_fin_2 <= resize(a_out_int_3,a_out_fin_2'length)+resize(a_out_int_4,a_out_fin_2'length);
               end if;
            end if;
        end if;
    end process;
    
-------------------------------
---         Output          ---
-------------------------------
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
               o_sig <= (others => '0');
            else
               if i_cen = '1' and i_fen = '1' then
                o_sig <= resize(a_out_fin_1,o_sig'length)+resize(a_out_fin_2,o_sig'length);
               end if;
            end if;
        end if;
    end process;

end architecture;