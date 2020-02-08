
-- ----------------------------------------------------------------- --
--                AdaSDL                                             --
--                Thin binding to Simple Direct Media Layer          --
--                Copyright (C) 2000-2012  A.M.F.Vargas              --
--                Antonio M. M. Ferreira Vargas                      --
--                Manhente - Barcelos - Portugal                     --
--                http://adasdl.sourceforge.net                      --
--                E-mail: amfvargas@gmail.com                        --
-- ----------------------------------------------------------------- --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-- ----------------------------------------------------------------- --

--  **************************************************************** --
--  This is an Ada binding to SDL ( Simple DirectMedia Layer from    --
--  Sam Lantinga - www.libsld.org )                                  --
--  **************************************************************** --
--  In order to help the Ada programmer, the comments in this file   --
--  are, in great extent, a direct copy of the original text in the  --
--  SDL header files.                                                --
--  **************************************************************** --

with SDL.Byteorder.Extra;
with SDL.RWops; use SDL.RWops;

with Ada.Strings.UTF_Encoding.Strings;

package body SDL.Audio is

   --  Mode strings.
   --  "rb"
   Mode_RB     : aliased  C.char_array := C.To_C ("rb");
   Mode_RB_Ptr : constant C.Strings.chars_ptr := C.Strings.To_Chars_Ptr (Mode_RB'Access);

   use type C.int;

   -------------
   -- LoadWAV --
   -------------

   function SDL_LoadWAV
     (file      : C.Strings.chars_ptr;
      spec      : AudioSpec_ptr;
      audio_buf : Uint8_ptr_ptr;
      audio_len : Uint32_ptr)
      return AudioSpec_ptr is
      Filename : constant String := C.Strings.Value (file);
   begin
      return SDL_LoadWAV_RW (
                             --  RWFromFile (
                             --      file,
                             --      Mode_RB_Ptr),
                             RWops.From_File (Ada.Strings.UTF_Encoding.Strings.Encode (Filename),
                               RWops.Read_Binary),
                             1,
                             spec,
                             audio_buf,
                             audio_len);
   end SDL_LoadWAV;

   -------------
   -- LoadWAV_VP --
   -------------

   --     procedure Load_WAV (
   --        file : C.Strings.chars_ptr;
   --        spec : AudioSpec_ptr;      -- out AudioSpec
   --        audio_buf : Uint8_ptr_ptr; -- out Uint8_ptr
   --        audio_len : Uint32_ptr;    -- out Uint32
   --        Valid_WAV : out Boolean)
   --     is
   --        use SDL.RWops;
   --        Audio_Spec_Pointer : AudioSpec_ptr;
   --     begin
   --        Audio_Spec_Pointer := LoadWAV_RW (
   --           RWFromFile (
   --              file,
   --              Mode_RB_Ptr),
   --           1,
   --           spec,
   --           audio_buf,
   --           audio_len);
   --
   --        --  LoadWAV_RW_VP (
   --        --     Audio_Spec_Pointer,
   --        --     RWFromFile (
   --        --        file,
   --        --        Mode_RB_Ptr ("rb")),
   --        --     1,
   --        --     spec,
   --        --     audio_buf,
   --        --     audio_len);
   --
   --        Valid_WAV := Audio_Spec_Pointer /= null;
   --     end Load_WAV;

   -----------------------
   -- Get_Audio_S16_Sys --
   -----------------------

   function Get_Audio_S16_Sys return Format_Flag is
      use SDL.Byteorder;
      use SDL.Byteorder.Extra;
   begin
      if BYTE_ORDER = LIL_ENDIAN then
         return AUDIO_S16LSB;
      else
         return AUDIO_S16MSB;
      end if;
   end Get_Audio_S16_Sys;

   -----------------------
   -- Get_Audio_U16_Sys --
   -----------------------

   function Get_Audio_U16_Sys return Format_Flag is
      use SDL.Byteorder;
      use SDL.Byteorder.Extra;
   begin
      if BYTE_ORDER = LIL_ENDIAN then
         return AUDIO_U16LSB;
      else
         return AUDIO_S16LSB;
      end if;
   end Get_Audio_U16_Sys;

end SDL.Audio;

