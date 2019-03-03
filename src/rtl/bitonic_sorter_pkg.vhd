library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;

package bitonic_sorter_vhd_pkg is

  constant ASCENDING : integer := 1;
  constant DESCENDING : integer := 1;
  
  constant MUON_NUMBER : integer := 352;
  constant IDX_WIDTH : integer := integer(ceil(log(real(MUON_NUMBER), real(2))));
  constant PT_WIDTH : integer := 4;
  constant word_w : integer := PT_WIDTH+IDX_WIDTH;
  
  
    type muon_type is record
    idx : std_logic_vector(IDX_WIDTH-1 downto 0);
    pt     : std_logic_vector(PT_WIDTH-1 downto 0);    
  end record;
  

 	type muon_array is array (natural range <>) of muon_type;
	function to_array(data : std_logic_vector; N : integer) return muon_array;
	function to_stdv(muon : muon_array; N : integer) return std_logic_vector;

end bitonic_sorter_vhd_pkg;

package body bitonic_sorter_vhd_pkg is  
  
	function to_array(data : std_logic_vector; N : integer) return muon_array is
		variable muon : muon_array(0 to N-1);
	begin
		for i in muon'range  loop
			muon(i).pt := data((i+1)*word_w-1-IDX_WIDTH downto i*word_w);
      muon(i).idx := data((i+1)*word_w-1 downto i*word_w+PT_WIDTH);
		end loop;
		return muon;
	end to_array;
 
 	function to_stdv(muon : muon_array; N : integer) return std_logic_vector is
	 variable vector : std_logic_vector(N*word_w-1 downto 0);   
	begin
		for i in muon'range  loop
	vector((i+1)*word_w-1-IDX_WIDTH downto i*word_w):= muon(i).pt;
      vector((i+1)*word_w-1 downto i*word_w+PT_WIDTH) := muon(i).idx;
		end loop;
		return vector;
	end to_stdv;

end package body bitonic_sorter_vhd_pkg;
