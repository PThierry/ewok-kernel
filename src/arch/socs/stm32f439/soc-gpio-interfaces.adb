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


package body soc.gpio.interfaces
   with spark_mode => on
is

   procedure configure
     (port     : in  unsigned_8;
      pin      : in  unsigned_8;
      mode     : in  t_pin_mode;
      otype    : in  t_pin_output_type;
      ospeed   : in  t_pin_output_speed;
      pupd     : in  t_pin_pupd;
      af       : in  t_pin_alt_func;
      success  : out types.c.t_retval)
   is
      gpio_port : t_gpio_port_index;
      gpio_pin  : t_gpio_pin_index;
   begin

      if port > t_gpio_port_index'pos (t_gpio_port_index'last) then
         success := types.c.FAILURE;
         return;
      end if;

      gpio_port := t_gpio_port_index'val (port);

      if pin > t_gpio_pin_index'pos (t_gpio_pin_index'last) then
         success := types.c.FAILURE;
         return;
      end if;

      gpio_pin  := t_gpio_pin_index'val (pin);

      soc.gpio.enable_clock (gpio_port);
      soc.gpio.set_mode (gpio_port, gpio_pin, mode);
      soc.gpio.set_type (gpio_port, gpio_pin, otype);
      soc.gpio.set_speed (gpio_port, gpio_pin, ospeed);
      soc.gpio.set_pupd (gpio_port, gpio_pin, pupd);
      soc.gpio.set_af (gpio_port, gpio_pin, af);

      success := types.c.SUCCESS;
   end configure;


end soc.gpio.interfaces;
