------------------------------------------------------------------------
----      Copyright (c) 15-01-2018, ANSSI
----      All rights reserved.
----
---- This file is autogenerated by tools/gen_ld.pl
----
---- This file describes the applications layout and permissions for
---- the current build.
---- Please see the above script for details.
----
--------------------------------------------------------------------------

--
-- This file is autogenerated ! Don't try to update it as it is
-- regenerated each time the kernel is built !
--

with interfaces;        use interfaces;
with types;             use types;
with ewok.tasks_shared; use ewok.tasks_shared;
with ewok.tasks;	    use ewok.tasks;
with m4.mpu;
with soc.layout;    use soc.layout;


package config.applications is

   -- we define a memory offset as an unsigned value up to 4Mb. On a
   -- microkernel system, this should be enough for nearly all needs.
   -- FIXME: this type can be added to the types.ads package after the
   -- end of the newmem tests
   subtype memory_offset is unsigned_32 range 0 .. 4194304;
   -- an application section can be up to 512K length
   subtype application_section_size is unsigned_32 range 0 .. 524288;

   type t_application is record
      -- task name
      name              : ewok.tasks.t_task_name;
      -- task text section addr in flash
      text_off          : memory_offset;
      -- task text size, in bytes
      text_size         : application_section_size;
      -- task data address, in RAM
      data_off          : memory_offset;
      -- task data size
      data_size         : application_section_size;
      -- task BSS size
      bss_size          : application_section_size;
      -- task heap size
      heap_size         : application_section_size;
      -- task requested stack size
      stack_size        : application_section_size;
      -- entrypoint offset, starting at application text start addr
      entrypoint_off    : memory_offset;
      -- isr_entrypoint offset, starting at  application text start addr
      isr_entrypoint_off: memory_offset;
      -- task security domain
      domain            : unsigned_8;
      -- task priority
      priority          : unsigned_8;
   end record;


   -- list of activated applications
   subtype t_real_task_id is t_task_id
