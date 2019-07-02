--  This spec has been automatically generated from FE310.svd

with system;
with types; use types;

package soc.backup is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  

   type Backup_Registers is array (0 .. 31) of soc.unsigned_32;

   -----------------
   -- Peripherals --
   -----------------

   --  Backup Registers.
   type BACKUP_Peripheral is record
      Backup : aliased Backup_Registers;
   end record
     with Volatile;

   for BACKUP_Peripheral use record
      Backup at 0 range 0 .. 1023;
   end record;

   --  Backup Registers.
   BACKUP_Periph : aliased BACKUP_Peripheral
     with Import, Address => BACKUP_Base;

end soc.backup;
