-- FE310 RISC-V Memory protection unit (RISC-V PMP) implementation.
-- In order to keep an abstration of the memory protection technology, the package
-- name keeps the generic terminology 'MPU' (versus 'MMU' for memory management units).
--
-- The SoC-specific MPU implementation is compliance to the RISC-V ABI:
-- Only pmpcfg0 & pmpcfg1 are implemented. pmpcfg2 & pmpcfg3 are hardwired to 0.
--
-- The EwoK support keeps the SoC upper API compatible with the other SoCs to reduce the
-- complexity of upper, generic, kernel parts. This API should be easily compatible with
-- any MPU-based implementations.
--
with system;
with types; use types;

-- PMP support
package soc.mpu
is

   function to_subregion_mask is new ada.unchecked_conversion
      (unsigned_8, t_subregion_mask);

   function to_unsigned_8 is new ada.unchecked_conversion
      (t_subregion_mask, unsigned_8);

   type t_region_config is record
      region_number  : t_region_number;
      addr           : system_address;
      size           : t_region_size;
      access_perm    : t_region_perm;
      xn             : boolean;  -- Execute Never
      b              : boolean;
      s              : boolean;
      subregion_mask : t_subregion_mask;
   end record;

   procedure is_mpu_available
     (success  : out boolean)
      with
         inline_always,
         Global         => (In_Out => MPU);

   procedure enable
      with
         inline_always,
         global => (in_out => (MPU));

   procedure disable
      with
         inline_always,
         global => (in_out => (MPU));

   procedure disable_region
     (region_number : in t_region_number)
      with
         inline_always,
         global => (in_out => (MPU));

    procedure init
      with
         global => (in_out => (MPU, m4.scb.SCB));

   procedure enable_unrestricted_kernel_access
      with
         inline_always,
         global => (in_out => (MPU));

   procedure disable_unrestricted_kernel_access
      with
         inline_always,
         global => (in_out => (MPU));

   procedure configure_region
     (region   : in t_region_config)
      with
         global => (in_out => (MPU)),
         pre =>
           (region.region_number in 0 .. 7
            and
            (region.addr and 2#11111#) = 0
            and
            region.size >= 4
            and
            (region.addr and get_region_size_mask(region.size)) = 0)
            and not region_rwx (region);



   
end soc.mpu;
