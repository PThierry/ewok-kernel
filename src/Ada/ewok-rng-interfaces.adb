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

package body ewok.rng.interfaces
   with spark_mode => off
is

   function get_random
     (s    : in  system_address;
      len  : in  unsigned_16)
      return types.c.t_retval
   is
      tab   : unsigned_8_array (1 .. unsigned_32 (len))
         with address => to_address (s);
      ok    : boolean;
   begin
      ewok.rng.random_array (tab, ok);
      if ok then
         return types.c.SUCCESS;
      else
         return types.c.FAILURE;
      end if;
   end get_random;

end ewok.rng.interfaces;



