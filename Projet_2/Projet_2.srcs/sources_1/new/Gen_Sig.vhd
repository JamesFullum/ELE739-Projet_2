--------------------------------------------------------------------------------
-- Titre    : FIR
-- Projet   : ELE739 Phase 2
--------------------------------------------------------------------------------
-- Fichier  : Gen_Sig.vhd
-- Auteur   : Guillaume et James
-- Cr�ation : 2024-02-24
--------------------------------------------------------------------------------
-- Description : Generateur de signal
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Pour les types std_logic et std_logic_vector
use ieee.numeric_std.all;    -- Pour les types signed et unsigned

entity Gen_Sig is
  -- La section generic contient les param�tres de configuration du module.
  -- La section port contient les entr�es-sorties du module.
  port (
    i_clk   : in  std_logic;
    i_rst   : in  std_logic;
    i_cen   : in  std_logic;
    o_sig   : out signed(7 downto 0)
  );
end;

architecture rtl of Gen_Sig is

   -- D�claration du composant pour le FIR
   component Cos_rom is
       port (
           i_addr  : in  unsigned(3 downto 0);
           o_dat   : out signed(7 downto 0)
       );
   end component;
   
    -- datatype pour g�r�es les �tats du M�F
    type cntr_state is (UP, DOWN); 
    
    -- signals pour le pr�sent et prochaine �tat
    signal current_state : cntr_state;
    signal next_state    : cntr_state;
   
   signal addr_int : unsigned(3 downto 0);
   
begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                addr_int <= (others => '0');
                current_state <= UP;
            else
                if i_cen = '1' then
                    case next_state is
                        when UP =>
                            addr_int <= addr_int + 1; 
                        when DOWN =>
                            addr_int <= addr_int - 1;
                    end case;
                    current_state <= next_state;
                end if;
            end if;
        end if;
   end process;


    process(addr_int, current_state)
    begin
        case current_state is
            when UP =>
                if addr_int = 8 then
                   next_state <= DOWN;
                else
                   next_state <= UP;
                end if;
            when DOWN =>
                if addr_int = 0 then
                   next_state <= UP;
                else
                   next_state <= DOWN;
                end if;
        end case;
   end process;

    ROM: Cos_rom
        port map(
            i_addr => addr_int,
            o_dat  => o_sig
        );

end architecture;