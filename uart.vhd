-- uart.vhd: UART controller - receiving part
-- Author(s): xgolik00
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity UART_RX is
port(	
  CLK      : in std_logic;
	RST      : in std_logic;
	DIN      : in std_logic;
	DOUT     : out std_logic_vector(7 downto 0);
	DOUT_VLD : out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is  
signal cnt_time : integer range 0 to 23;
signal cnt_bits : integer range 0 to 8;
signal rx_en    : std_logic;
begin
FSM: entity work.UART_FSM(behavioral)
  port map (
      CLK 	    => CLK,
      RST 	    => RST,
      DIN 	    => DIN,
      CNT_TIME => cnt_time,
      CNT_BITS => cnt_bits,
      RX_EN    => rx_en
  );

process(CLK) begin
    if rising_edge(CLK) then
        if cnt_time = 0 then 
            if cnt_bits = 8 then
                DOUT <= "00000000";
                DOUT_VLD <= '0';
                cnt_bits <= 0;
            elsif cnt_bits = 0 then 
                DOUT <= "00000000";
                DOUT_VLD <= '0';
            end if;
        end if;
      
        if cnt_time = 23 then 
            if cnt_bits < 8 then
                cnt_time <= 0;
            end if;    
        else
            cnt_time <= cnt_time + 1;
        end if;
        
        if rx_en = '1' then 
            if cnt_time = 15 then
                cnt_time <= 0;
                case cnt_bits is
                
                when 0  => DOUT(0) <= DIN;
                           cnt_bits <= cnt_bits + 1; 
                
                when 1  => DOUT(1) <= DIN;
                           cnt_bits <= cnt_bits + 1;
                
                when 2  => DOUT(2) <= DIN;
                           cnt_bits <= cnt_bits + 1;
                
                when 3  => DOUT(3) <= DIN;
                           cnt_bits <= cnt_bits + 1;
                
                when 4  => DOUT(4) <= DIN;
                           cnt_bits <= cnt_bits + 1;
                
                when 5  => DOUT(5) <= DIN;
                           cnt_bits <= cnt_bits + 1;
                
                when 6  => DOUT(6) <= DIN;
                           cnt_bits <= cnt_bits + 1;
                
                when 7  => DOUT(7) <= DIN;
                           cnt_bits <= cnt_bits + 1;
                           DOUT_VLD <= '1';
                  
                when others => null;
                
                end case;
            end if;      
        end if;
    end if;
end process;
end behavioral;
