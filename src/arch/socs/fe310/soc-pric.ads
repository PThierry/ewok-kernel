--  This spec has been automatically generated from FE310.svd

with system;
with types; use types;

package soc.pric is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype HFROSCCFG_DIV_Field is soc.bits_6;
   subtype HFROSCCFG_TRIM_Field is soc.bits_5;
   subtype HFROSCCFG_ENABLE_Field is soc.bit;
   subtype HFROSCCFG_READY_Field is soc.bit;

   --  HF Ring Oscillator Configuration Register.
   type HFROSCCFG_Register is record
      DIV            : HFROSCCFG_DIV_Field := 16#0#;
      --  unspecified
      Reserved_6_15  : soc.bits_10 := 16#0#;
      TRIM           : HFROSCCFG_TRIM_Field := 16#0#;
      --  unspecified
      Reserved_21_29 : soc.bits_9 := 16#0#;
      ENABLE         : HFROSCCFG_ENABLE_Field := 16#0#;
      READY          : HFROSCCFG_READY_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          bit_Order => System.Low_Order_First;

   for HFROSCCFG_Register use record
      DIV            at 0 range 0 .. 5;
      Reserved_6_15  at 0 range 6 .. 15;
      TRIM           at 0 range 16 .. 20;
      Reserved_21_29 at 0 range 21 .. 29;
      ENABLE         at 0 range 30 .. 30;
      READY          at 0 range 31 .. 31;
   end record;

   subtype HFXOSCCFG_ENABLE_Field is soc.bit;
   subtype HFXOSCCFG_READY_Field is soc.bit;

   --  HF Crystal Oscillator Configuration Register.
   type HFXOSCCFG_Register is record
      --  unspecified
      Reserved_0_29 : soc.bits_30 := 16#0#;
      ENABLE        : HFXOSCCFG_ENABLE_Field := 16#0#;
      READY         : HFXOSCCFG_READY_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          bit_Order => System.Low_Order_First;

   for HFXOSCCFG_Register use record
      Reserved_0_29 at 0 range 0 .. 29;
      ENABLE        at 0 range 30 .. 30;
      READY         at 0 range 31 .. 31;
   end record;

   subtype PLLCFG_R_Field is soc.bits_3;
   subtype PLLCFG_F_Field is soc.bits_6;
   subtype PLLCFG_Q_Field is soc.bits_2;

   type PLLCFG_SEL_Field is
     (--  The HFROSCCLK directly drives HFCLK.
      Internal,
      --  Drive the final HFCLK with PLL output, bypassed or otherwise.
      Pll)
     with Size => 1;
   for PLLCFG_SEL_Field use
     (Internal => 0,
      Pll => 1);

   type PLLCFG_REFSEL_Field is
     (--  Internal Oscillator.
      Internal,
      --  Crystal OScillator.
      Crystal)
     with Size => 1;
   for PLLCFG_REFSEL_Field use
     (Internal => 0,
      Crystal => 1);

   subtype PLLCFG_BYPASS_Field is soc.bit;
   subtype PLLCFG_LOCK_Field is soc.bit;

   --  PLL Configuration Register.
   type PLLCFG_Register is record
      R              : PLLCFG_R_Field := 16#0#;
      --  unspecified
      Reserved_3_3   : soc.bit := 16#0#;
      F              : PLLCFG_F_Field := 16#0#;
      Q              : PLLCFG_Q_Field := 16#0#;
      --  unspecified
      Reserved_12_15 : soc.bits_4 := 16#0#;
      SEL            : PLLCFG_SEL_Field := soc.PRIC.Internal;
      REFSEL         : PLLCFG_REFSEL_Field := soc.PRIC.Internal;
      BYPASS         : PLLCFG_BYPASS_Field := 16#0#;
      --  unspecified
      Reserved_19_30 : soc.bits_12 := 16#0#;
      LOCK           : PLLCFG_LOCK_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          bit_Order => System.Low_Order_First;

   for PLLCFG_Register use record
      R              at 0 range 0 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      F              at 0 range 4 .. 9;
      Q              at 0 range 10 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      SEL            at 0 range 16 .. 16;
      REFSEL         at 0 range 17 .. 17;
      BYPASS         at 0 range 18 .. 18;
      Reserved_19_30 at 0 range 19 .. 30;
      LOCK           at 0 range 31 .. 31;
   end record;

   subtype PLLOUTDIV_DIV_Field is soc.bits_6;
   subtype PLLOUTDIV_DIV_BY_1_Field is soc.bit;

   --  PLL Output Divider Register.
   type PLLOUTDIV_Register is record
      DIV           : PLLOUTDIV_DIV_Field := 16#0#;
      --  unspecified
      Reserved_6_7  : soc.bits_2 := 16#0#;
      DIV_BY_1      : PLLOUTDIV_DIV_BY_1_Field := 16#0#;
      --  unspecified
      Reserved_9_31 : soc.bits_23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          bit_Order => System.Low_Order_First;

   for PLLOUTDIV_Register use record
      DIV           at 0 range 0 .. 5;
      Reserved_6_7  at 0 range 6 .. 7;
      DIV_BY_1      at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Power, Reset, Clock, Interrupt.
   type PRIC_Peripheral is record
      --  HF Ring Oscillator Configuration Register.
      HFROSCCFG : aliased HFROSCCFG_Register;
      --  HF Crystal Oscillator Configuration Register.
      HFXOSCCFG : aliased HFXOSCCFG_Register;
      --  PLL Configuration Register.
      PLLCFG    : aliased PLLCFG_Register;
      --  PLL Output Divider Register.
      PLLOUTDIV : aliased PLLOUTDIV_Register;
   end record
     with Volatile;

   for PRIC_Peripheral use record
      HFROSCCFG at 16#0# range 0 .. 31;
      HFXOSCCFG at 16#4# range 0 .. 31;
      PLLCFG    at 16#8# range 0 .. 31;
      PLLOUTDIV at 16#C# range 0 .. 31;
   end record;

   --  Power, Reset, Clock, Interrupt.
   PRIC_Periph : aliased PRIC_Peripheral
     with Import, Address => PRIC_Base;

end soc.pric;
