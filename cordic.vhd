-- ========================================= REGISTER 16 BIT ====================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register16bit is
    port (
        Number  : in    signed(15 downto 0); -- NILAI YANG AKAN DISIMPAN
        En      : in    std_logic;          -- IZIN MENYIMPAN
        Res     : in    std_logic;          -- RESET REGISTER
        Clk     : in    std_logic;          -- CLOCK
        Data    : out   signed(15 downto 0); -- DATA TERSIMPAN
        regdone : out   std_logic           -- STATUS PENYIMPANAN
    );
end register16bit;

-- DEFINISI ARCHITECTURE
architecture rtl of register16bit is
    signal v_data    : signed(15 downto 0) := (others => '0'); -- Inisialisasi ke nol
    signal v_regdone : std_logic := '0'; -- Inisialisasi ke nol
begin
    process (Clk)
    begin
        if rising_edge(Clk) then
            if (Res = '1') then
                -- Reset register dan sinyal regdone
                v_data <= (others => '0');
                v_regdone <= '0';
            elsif (En = '1') then
                -- Simpan nilai dan aktifkan regdone
                v_data <= Number;
                v_regdone <= '1';
            else
                -- Nonaktifkan regdone jika tidak ada aktivitas penyimpanan
                v_regdone <= '0';
            end if;
        end if;
    end process;

    -- Output data dan status regdone
    Data <= v_data;
    regdone <= v_regdone;

end rtl;

-- ========================================= ADDER - SUBTRACTOR ===================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity addsub is
    Port (
        Bilangan       : in  signed(15 downto 0); -- Bilangan yang akan dikurangi atau ditambah
        Pengoperasi    : in  signed(15 downto 0); -- Bilangan yang akan mengurangi atau menambah (didapat dari fungsi cordic)
        add_sub        : in  std_logic;           -- Kontrol: '0' untuk penjumlahan, '1' untuk pengurangan. Ini nanti didapat dari hasil komparator
        Result         : out signed(15 downto 0); -- Hasil operasi Q3.13 ((1 sign, 2 integer, 13 fraction dengan asumsi input di rentang -1 sampai 1)
        enableaddsub  : in std_logic
        );

    -- Catatan input 1 sign 2 integer 5 fraction. Input maksimal bernilai dari -1 sampai 1
end addsub;

architecture Behavioral of addsub is
    -- signal temp_result : signed(7 downto 0); --- Tambahin satu bit di depan buat jaga-jaga overflow dulu
begin
  
    process(Bilangan, Pengoperasi, add_sub, enableaddsub)
    begin
        if (enableaddsub = '1') then 
            if add_sub = '0' then
                -- Penjumlahan
                Result <= Bilangan+Pengoperasi;
                -- resize menambahkan satu bit 0 MSB (tidak mengubah nilai, hanya memperluas rentang jadi 17 bit)
            else
                -- Pengurangan
                Result <= Bilangan-Pengoperasi;
            end if;
        end if;
    end process;

end Behavioral;

-- ========================================= CEK TANDA ===================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity getsign is
    Port (
        Parameter   : in  signed(15 downto 0); -- Parameter input
        Result      : out std_logic;          -- Tanda dari Parameter
        cekdone     : out std_logic;          -- Status selesai
        enablecek   : in  std_logic           -- Enable operasi
    );
end getsign;

architecture Behavioral of getsign is
    signal v_cekdone : std_logic := '0'; -- Internal cekdone signal
begin
    process(enablecek, Parameter)
    begin
        if enablecek = '1' then
            -- Ambil tanda dari Parameter
            Result <= Parameter(15);
            v_cekdone <= '1'; -- Berikan pulse selesai
        else
            -- Matikan cekdone jika tidak ada operasi
            v_cekdone <= '0';
        end if;
    end process;

    -- Assign cekdone output
    cekdone <= v_cekdone;
end Behavioral;


-- ========================================= MULTIPLIER ===================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity multiplier24to16bit is
    Port (
        Bilangan         : in  signed(7 downto 0);  -- Bilangan input
        Pengoperasi      : in  signed(15 downto 0); -- Bilangan pengoperasi
        Result           : out signed(15 downto 0); -- Hasil operasi (Q3.13 format)
        enablemultiplier : in  std_logic;          -- Enable operasi
        multdone         : out std_logic           -- Status selesai
    );
end multiplier24to16bit;

architecture Behavioral of multiplier24to16bit is
    signal temp_result  : signed(23 downto 0); -- Intermediate result
    signal v_multdone   : std_logic := '0';    -- Internal multdone signal
begin
    process(enablemultiplier, Bilangan, Pengoperasi)
    begin
        if enablemultiplier = '1' then
            -- Lakukan operasi perkalian
            temp_result <= Bilangan * Pengoperasi;

            -- Berikan pulse selesai
            v_multdone <= '1';
        else
            -- Nonaktifkan multdone jika tidak ada operasi
            v_multdone <= '0';
        end if;
    end process;

    -- Konversi hasil operasi ke format Q3.13
    Result <= (temp_result(23) & temp_result(19 downto 5)); -- Pilih bit-bit yang relevan
    multdone <= v_multdone; -- Outputkan sinyal multdone
end Behavioral;


-- ========================================= 2i TABEL ===================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity mux2i is
    Port (
        i       : in  std_logic_vector(3 downto 0); -- Index
        keluaran: out  signed(15 downto 0); -- Bilangan yang akan mengurangi atau menambah (didapat dari fungsi cordic)
        enablemux : in std_logic
    );

end mux2i;

architecture Behavioral of mux2i is
    begin
        process(i, enablemux)
        begin
            if enablemux = '1' then 
                case i is
                    when "0000" => keluaran <= "0010000000000000";
                    when "0001" => keluaran <= "0001000000000000";
                    when "0010" => keluaran <= "0000100000000000";
                    when "0011" => keluaran <= "0000010000000000";
                    when "0100" => keluaran <= "0000001000000000";
                    when "0101" => keluaran <= "0000000100000000";
                    when "0110" => keluaran <= "0000000010000000";
                    when "0111" => keluaran <= "0000000001000000";
                    when "1000" => keluaran <= "0000000000100000";
                    when others => keluaran <= "0000000000000000"; 
                end case;
            end if;
        end process;
end Behavioral;

-- ========================================= ARCTAN TABEL ===================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity muxtantable is
    Port (
        i       : in  std_logic_vector(3 downto 0); -- Index
        atan  : out  signed(15 downto 0); -- Bilangan yang akan mengurangi atau menambah (didapat dari fungsi cordic)
        enablemux : in std_logic
    );

end muxtantable;

architecture Behavioral of muxtantable is
    begin
        process(i, enablemux)
        begin
            if enablemux = '1' then 
                case i is
                    when "0000" => atan <= "0001100100100010";
                    when "0001" => atan <= "0000111011010110";
                    when "0010" => atan <= "0000011111010110";
                    when "0011" => atan <= "0000001111111010";
                    when "0100" => atan <= "0000000111111111";
                    when "0101" => atan <= "0000000100000000";
                    when "0110" => atan <= "0000000010000000";
                    when "0111" => atan <= "0000000001000000";
                    when "1000" => atan <= "0000000000100000";
                    when others => atan <= "0000000000000000";
                end case;
            end if;
        end process;
end Behavioral;

-- ========================================= ROUNDER 8 ===================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity round8 is
    Port (
        Bilangan       : in  signed(15 downto 0); -- 
        Result         : out signed(7 downto 0) --
    );

    -- Catatan input 1 sign 2 integer 5 fraction. Input maksimal bernilai dari -1 sampai 1
end round8;

architecture Behavioral of round8 is
    -- signal temp_result : signed(7 downto 0); --- Tambahin satu bit di depan buat jaga-jaga overflow dulu
begin
    Result <= Bilangan(15 downto 8);
end Behavioral;


-- ========================================= COUNTER 4 BIT ===================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter4bit is
    port (
        En         : in    std_logic;
        Res        : in    std_logic;
        Clk        : in    std_logic;
        Count      : out   std_logic_vector (3 downto 0);
        countdone  : out   std_logic
    );
end counter4bit;

architecture rtl of counter4bit is
    signal count_reg     : unsigned(3 downto 0) := (others => '0'); -- Register internal
    signal clk_div       : unsigned(2 downto 0) := (others => '0'); -- Divider untuk 6 clock
    signal v_countdone   : std_logic := '0'; -- Inisialisasi dengan nilai default
begin
    process (Clk, Res)
    begin
        if Res = '1' then
            count_reg <= (others => '0'); -- Reset counter ke 0000
            clk_div <= (others => '0'); -- Reset divider
            v_countdone <= '0'; -- Reset sinyal countdone
        elsif rising_edge(Clk) then
            if En = '1' then
                if clk_div = 5 then
                    -- Jika divider mencapai 5, reset divider dan naikkan counter
                    clk_div <= (others => '0');
                    count_reg <= count_reg + 1;
                    v_countdone <= '1'; -- Set countdone menjadi '1' saat count bertambah
                else
                    -- Inkrementasi divider
                    clk_div <= clk_div + 1;
                    v_countdone <= '0'; -- Set countdone kembali ke '0'
                end if;
            else
                v_countdone <= '0'; -- Set countdone kembali ke '0' jika En = '0'
            end if;
        end if;
    end process;

    -- Keluarkan nilai counter dalam format std_logic_vector
    Count <= std_logic_vector(count_reg);
    countdone <= v_countdone;

end rtl;


-- ========================================= MUX 2 TO 1  =====================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2to1 is
    port (
        Nprev  : in    signed (15 downto 0);
        Nnext  : in    signed (15 downto 0);
        Sel     : in    std_logic;
        Data    : out  signed (15 downto 0);
        enablemux : in std_logic
    );
end mux2to1;

architecture rtl of mux2to1 is
begin
    process (enablemux, Sel, Nprev, Nnext)
    begin
        if enablemux = '1' then
            if (Sel = '1') then
                Data <= Nnext;
            else
                Data <= Nprev;
            end if;
        end if;
    end process;
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic is
    port (
        START       : in    std_logic;
        STOP        : in    std_logic;
        Clk         : in    std_logic;
        Xin         : in    signed(15 downto 0);
        Yin         : in    signed(15 downto 0);
        Zout        : out   signed(15 downto 0)
    );
end cordic;

architecture structural of cordic is
    signal X_reg, Y_reg, Z_reg, arkestan    : signed(15 downto 0);
    signal Zin                    : signed (15 downto 0) := "0000000000000000";
    signal index                    : std_logic_vector(3 downto 0);
    signal enable_regX, enable_regY, enable_regZ, enable_counteri, reset_counteri : std_logic;
    signal X_muxed                  : signed(15 downto 0); -- Output dari mux x
    signal Y_muxed                  : signed(15 downto 0); -- Output dari mux y
    signal Z_muxed                  : signed(15 downto 0); -- Output dari mux z
    signal Sel_signal, operasi      : std_logic; --selector bergantung pada index
    signal berhenti                 : std_logic; -- bergantung pada counter index
    signal sub_resultX, sub_resultY, sub_resultZ : signed(15 downto 0);
    signal X_rounded, Y_rounded     : signed(7 downto 0);
    signal duapangkat               : signed(15 downto 0);
    signal A, B                     : signed(15 downto 0);
    signal add_sub_signal, addsubcomand, enmux, enablemultiplier, multdone, regdoneX, regdoneY, regdoneZ, cekdone, enablecek, countdone: std_logic;

    type state_type is (Init, Prepare, Cek, Calculate, Done);
    signal current_state : state_type;
    begin
    process(operasi)
        begin
            -- Tentukan nilai add_sub berdasarkan operasi
            add_sub_signal <= not operasi; -- atau operasi sesuai logika Anda
    end process;

    -- Instantiate Mux for selecting input to Register X
    muxX: entity work.mux2to1 port map (
        Nprev => Xin,
        Nnext => sub_resultX,
        Sel => Sel_signal,
        Data => X_muxed,
        enablemux => enmux
    );

    -- Instantiate Mux for selecting input to Register Y
    muxY: entity work.mux2to1 port map (
        Nprev => Yin,
        Nnext => sub_resultY,
        Sel => Sel_signal,
        Data => Y_muxed,
        enablemux => enmux

    );

    -- Instantiate Mux for selecting input to Register Z
    muxZ: entity work.mux2to1 port map (
        Nprev => Zin,
        Nnext => sub_resultZ,
        Sel => Sel_signal,
        Data => Z_muxed,
        enablemux => enmux
    );

    -- Instantiate Register X
    regX: entity work.register16bit port map (
        Number => X_muxed,  
        En      => enable_regX,   
        Res     => berhenti,
        Clk     => Clk,   
        Data    => X_reg,
        regdone => regdoneX
    );

    -- Instantiate Register Y
    regB: entity work.register16bit port map (
        Number => Y_muxed,
        En => enable_regY,
        Res => berhenti,
        Clk => Clk,
        Data => Y_reg,
        regdone => regdoneY
    );

    -- Instantiate Register Z
     regZ: entity work.register16bit port map (
        Number => Z_muxed,  
        En      => enable_regZ,   
        Res     => berhenti,
        Clk     => Clk,   
        Data    => Z_reg,
        regdone => regdoneZ
     );

    -- Instantiate Counter
    counter: entity work.counter4bit port map (
        En => enable_counteri,
        Res => reset_counteri,
        Clk => Clk,
        Count => index,
        countdone => countdone
    );

    -- Instantiate Rounder X
    rounderX : entity work.round8 port map(
        Bilangan => X_reg,
        Result =>  X_rounded
    );

    -- Instantiate Rounder Y
    rounderY : entity work.round8 port map(
        Bilangan => Y_reg,
        Result => Y_rounded
    );

    -- Instantiate 2i table
    index2table : entity work.mux2i port map(
        i => index,     
        keluaran => duapangkat,
        enablemux => enmux
    );

    -- Instantiate Multiplier X
    multiplierX : entity work.multiplier24to16bit port map(
        Bilangan => X_rounded,
        Pengoperasi => duapangkat,
        Result => A,   
        enablemultiplier => enablemultiplier,
        multdone => multdone
    );

    -- Instantiate Multiplier Y
    multiplierY : entity work.multiplier24to16bit port map(
        Bilangan => Y_rounded,
        Pengoperasi => duapangkat,
        Result => B,     
        enablemultiplier => enablemultiplier,
        multdone => multdone
    );


    -- Instantiate arctantable
    arctantable : entity work.muxtantable port map (
        i => index, 
        atan => arkestan,
        enablemux => enmux
    );

    -- Instantiate getsign for Y
    cektanda : entity work.getsign port map(
        Parameter => Y_reg,
        Result => operasi,
        cekdone => cekdone,
        enablecek => enablecek
    );

    -- Add/Sub X
    addsubX: entity work.addsub port map (
        Bilangan => X_reg,
        Pengoperasi => B,
        add_sub => operasi, 
        Result => sub_resultX,
        enableaddsub => addsubcomand
    );

    -- Add/Sub X
    addsubY: entity work.addsub port map (
        Bilangan => Y_reg,
        Pengoperasi => A,
        add_sub => add_sub_signal, 
        Result => sub_resultY,
        enableaddsub => addsubcomand
    );

    -- Add/Sub X
    addsubZ: entity work.addsub port map (
        Bilangan => Z_reg,
        Pengoperasi => arkestan,
        add_sub => operasi, 
        Result => sub_resultZ,
        enableaddsub => addsubcomand
    );

    -- FSM Process

    process(Clk, START, index, STOP, regdoneX, regdoneY, cekdone, multdone, countdone)
    begin
        if rising_edge(Clk) then
            case current_state is
                -- State S0
                when Init =>
                    if (START = '0' and STOP = '0') then
                        current_state <= Init;     -- Transisi ke S1
                    elsif (START = '1' and STOP = '0') then
                        current_state <= Prepare;
                    end if;
                when Prepare =>
                    if  (multdone = '1' and regdoneX = '1' and regdoneY = '1') then 
                        current_state <= Cek;
                        -- Inisiasi semua variabel di sini enable counternya juga dibikin 1
                    else
                        current_state <= Prepare;
                    end if;
                when Cek =>
                    if (cekdone = '1') then
                        current_state <= Calculate;
                    end if;
                when Calculate =>
                    if (index = "1000") then
                        current_state <= Done;     -- Transisi ke S2
                    elsif(countdone = '1') then
                        current_state <= Prepare;
                    end if;
                when Done => 
                    if (STOP = '0') then
                        current_state <= Done;
                    else
                        current_state <= Init;
                    end if;
            end case;
        end if;
    end process;

    process(Xin, Yin, Clk, START, STOP, index)
    begin
        case current_state is
            -- State S0
            when Init =>
                -- Inisiasi sinyal Xin, Yin, dan Zin. Hanya ada 3 sinyal itu. Jangan disimpan dulu ke register, counter ga boleh ngitung dan masih default, pemilihan mmux untuk register pada input, semua operasi aritmatika unable
                enable_regX <= '0';
                enable_regY <= '0';
                enable_regZ <= '0';
                enable_counteri <= '0';
                reset_counteri <= '1';
                Sel_signal <= '0';
                Zin <= "0000000000000000";
                berhenti <= '0'; 
                addsubcomand <= '0';
                enmux <= '0';
                enablemultiplier <= '0';
            -- State S1

            when Prepare =>
                -- sel sinyal diambil dari input,  memasukkan Xin Yin ke Zin ke dalam register. Multiiplier jalan agar dapat A dan B, abis itu unable. counter mulai ngitung dari 0. Simpan A dan B dalam register. Indikator pindah, register A dan B keisi
                enable_regX <= '1';
                enable_regY <= '1';
                enable_regZ <= '1';
                enable_counteri <= '1';
                reset_counteri <= '0';
                if (index = "0000") then 
                    Sel_signal <= '0';
                else 
                    Sel_signal <= '1';
                end if;
                berhenti <= '0'; 
                addsubcomand <= '0';
                enmux <= '1';
                enablemultiplier <= '1';
                enablecek <= '0';
                
            
            when Cek => 
                enable_regX <= '0';
                enable_regY <= '0';
                enable_regZ <= '0';
                enable_counteri <= '1';
                reset_counteri <= '0';
                Sel_signal <= '0';
                berhenti <= '0'; 
                addsubcomand <= '0';
                enmux <= '0';
                enablemultiplier <= '0';
                enablecek <= '1';
                

            when Calculate =>
                addsubcomand <= '1';
                enable_regX <= '0';
                enable_regY <= '0';
                enable_regZ <= '0';
                enable_counteri <= '1';
                reset_counteri <= '0';

            when Done =>
                Zout <= Z_reg;
                berhenti <= '1';
                -- regdoneX <= '0';
                -- regdoneY <= '0';
                -- regdoneZ <= '0';
                -- multdone <= '0';
                -- cekdone <= '0';

            end case;
    end process;
    


end structural;
