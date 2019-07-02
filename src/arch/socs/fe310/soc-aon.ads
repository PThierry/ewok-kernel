--  This spec has been automatically generated from FE310.svd

with system;
with types; use types;

package soc.aon is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype LFROSCCFG_DIV_Field is soc.bits_6;
   subtype LFROSCCFG_TRIM_Field is soc.bits_5;
   subtype LFROSCCFG_ENABLE_Field is soc.bit;
   subtype LFROSCCFG_READY_Field is soc.bit;

   --  LF Ring Oscillator Configuration Register.
   type LFROSCCFG_Register is record
      DIV            : LFROSCCFG_DIV_Field := 16#0#;
      --  unspecified
      Reserved_6_15  : soc.bits_10 := 16#0#;
      TRIM           : LFROSCCFG_TRIM_Field := 16#0#;
      --  unspecified
      Reserved_21_29 : soc.bits_9 := 16#0#;
      ENABLE         : LFROSCCFG_ENABLE_Field := 16#0#;
      READY          : LFROSCCFG_READY_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          bit_Order => System.Low_Order_First;

   for LFROSCCFG_Register use record
      DIV            at 0 range 0 .. 5;
      Reserved_6_15  at 0 range 6 .. 15;
      TRIM           at 0 range 16 .. 20;
      Reserved_21_29 at 0 range 21 .. 29;
      ENABLE         at 0 range 30 .. 30;
      READY          at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  AON Clock Configuration.
   type AON_Peripheral is record
      --  LF Ring Oscillator Configuration Register.
      LFROSCCFG : aliased LFROSCCFG_Register;
   end record
     with Volatile;

   for AON_Peripheral use record
      LFROSCCFG at 0 range 0 .. 31;
   end record;

   --  AON Clock Configuration.
   AON_Periph : aliased AON_Peripheral
     with Import, Address => AON_Base;

end soc.aon;
