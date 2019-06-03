--
-- Copyright 2018 The wookey project team <wookey@ssi.gouv.fr>
--   - Ryad     Benadjila
--   - Arnauld  Michelizza
--   - Mathieu  Renard
--   - Philippe Thierry
--   - Philippe Trebuchet
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
--     Unless required by applicable law or agreed to in writing, software
--     distributed under the License is distributed on an "AS IS" BASIS,
--     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--     See the License for the specific language governing permissions and
--     limitations under the License.
--
--

with ewok.perm;                  use ewok.perm;
with ewok.interrupts;            use ewok.interrupts;
with ewok.exti;
with ewok.mpu;
with ewok.dma;
with ewok.tasks;
with ewok.debug;
with m4.systick;
with m4.cpu;
with m4.cpu.instructions;
with c.kernel; use c.kernel;
with types.c;

with Ada.Command_line; use Ada.Command_Line;

-- This entrypoint is still a DRAFT and is not yet compiled. The goal
-- here is to replace the previously C-based main() function with the ewok.init.entrypoint() function.
--
-- This update requires:
--    * an binary target GPRBuild instead of a library
--    * a C library for residual C files instead of linking them
--
-- This operation request to invert the Makefile mechanism and highly reduce the Makefile content, replaced by
-- the GPRBuild system for the overall kernel build
--
-- The final build (when no C file others than user-exported headers for libstd) should be a fully GPRBuild-based
-- build system
package body ewok.init
   with spark_mode => off
is

   yellow : constant c_string := "\x1b[1;33;40m";
   whilte : constant c_string := "\x1b[1;37;40m";

   function entrypoint
      return int
   is
      seed         : unsigned_32;
      base_address : unsigned_32;
      success      : boolean;
   begin
      -- disable interrupts first
      m4.cpu.disable_irq;

      -- then initialize basics
      ewok.interrupts.init;
      m4.systick.init;

      -- imported from C kernel by now
      log_init;
      log(yellow & "EWOK - Embedded lightWeight Opensource Kernel" & whilte & "\n\n");
      flush;


      soc.dwt.init;
      if get_random_u32(seed'address) <>  SUCCESS then
         log("RNG initialization failed!\n");
         flush;
         debug.panic("Halting!\n");
      end if;

      -- this is useful while there is some C code in the kernel. It will then be removed
      -- as the Ada language is a countermeasure against various overflows.
      init_stack_chk_guard;

      -- initializing DMA contolers
      ewok.dma.init;

      -- initializing EXTI
      ewok.exti.init;

      if Ada.CommandLine.Argument_Count = 1 then
         base_address := unsigned_32'value(Argument(1));
         system_init(base_address);
      else
         debug.panic("Unable to get base address, to support PIE");
      end if;

      ewok.mpu.init(success);
      if (success = false then
         debug.panic("Unable to initalize MPU!");
      end if;

      m4.cpu.instructions.full_memory_barrier;

      ewok.tasks.task_init;

      ewok.devices.init;

      -- imported from C kernel by now
      usart_init;

      ewok.softirq.init;

      -- we initialize the scheduler. This call schedule the initial thread (IDLE) and wait for
      -- the first SYSTICK interrupt to schedule the fist task. From now on, this very context,
      -- executed using the MSP stack, disappear
      ewok.sched.init;

      debug.panic("This part of the code should never be executed!\n");

      return 0;

   end entrypoint;

end ewok.init;
