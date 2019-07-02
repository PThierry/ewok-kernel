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

with system.machine_code;

package body riscv.cpu.instructions
   with spark_mode => off
is


   procedure full_memory_barrier
   is
   begin
      system.machine_code.asm
        ("fence" & "iorw,iorw"  & ascii.lf,
         volatile => true);
   end full_memory_barrier;

   procedure BKPT
   is
   begin
      system.machine_code.asm ("ebreak", volatile => true);
   end BKPT;


   procedure WFI
   is
   begin
      system.machine_code.asm ("wfi", volatile => true);
   end WFI;

end riscv.cpu.instructions;
