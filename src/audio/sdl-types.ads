
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

with System.Address_To_Access_Conversions;
with Interfaces.C;
with Interfaces.C.Strings;
with Interfaces.C.Pointers;
with Interfaces.C.Extensions;
with UintN_PtrOps;
package SDL.Types is

   package C  renames Interfaces.C;
   package CE renames Interfaces.C.Extensions;
   --  SDL_TABLESIZE ???

   type SDL_bool is new C.int;
   SDL_False : constant SDL_bool := 0;
   SDL_True : constant  SDL_bool := 1;


   type Uint8 is new C.unsigned_char;
   type Uint8_ptr is access all Uint8;
   pragma Convention (C, Uint8_ptr);
   type Uint8_ptr_ptr  is access all Uint8_ptr;
   pragma Convention (C, Uint8_ptr_ptr);

   package Uint8_Ptrs  is
      new System.Address_To_Access_Conversions (Uint8);


   type Uint8_Array is array (C.size_t range <>)
         of aliased Uint8;
   package Uint8_PtrOps is
      new UintN_PtrOps (
         The_Element => Uint8,
         The_Element_Array => Uint8_Array);

   procedure Copy_Array (
      Source : Uint8_Ptrs.Object_Pointer;
      Target : Uint8_Ptrs.Object_Pointer;
      Lenght : Natural);
   pragma Inline (Copy_Array);

   function Increment (
      Pointer : Uint8_Ptrs.Object_Pointer;
      Amount : Natural) return Uint8_Ptrs.Object_Pointer;
   pragma Inline (Increment);

   function Decrement (
      Pointer : Uint8_Ptrs.Object_Pointer;
      Amount : Natural) return Uint8_Ptrs.Object_Pointer;
   pragma Inline (Decrement);

   function Shift_Left (
      Value : Uint8;
      Amount : Integer)
      return Uint8;
   pragma Inline (Shift_Left);

   function Shift_Right (
      Value : Uint8;
      Amount : Integer)
      return Uint8;
   pragma Inline (Shift_Right);


   type Sint8 is new C.char;
   type Sint8_ptr is access all Sint8;
   pragma Convention (C, Sint8_ptr);
   type Sint8_ptr_ptr is access all Sint8_ptr;
   pragma Convention (C, Sint8_ptr_ptr);

   type Uint16 is new C.unsigned_short;
   type Uint16_ptr is access all Uint16;
   pragma Convention (C, Uint16_ptr);
   type Uint16_ptr_ptr is access all Uint16_ptr;
   pragma Convention (C, Uint16_ptr_ptr);


   package Uint16_Ptrs  is
      new System.Address_To_Access_Conversions (Uint16);

   type Uint16_Array is array (C.size_t range <>)
         of aliased Uint16;
   package Uint16_PtrOps is
      new UintN_PtrOps (
         The_Element => Uint16,
         The_Element_Array => Uint16_Array);

   function Increment (
      Pointer : Uint16_Ptrs.Object_Pointer;
      Amount : Natural) return Uint16_Ptrs.Object_Pointer;
   pragma Inline (Increment);

   function Decrement (
      Pointer : Uint16_Ptrs.Object_Pointer;
      Amount : Natural) return Uint16_Ptrs.Object_Pointer;
   pragma Inline (Decrement);

   function Shift_Left (
      Value : Uint16;
      Amount : Integer)
      return Uint16;
   pragma Inline (Shift_Left);

   function Shift_Right (
      Value : Uint16;
      Amount : Integer)
      return Uint16;
   pragma Inline (Shift_Right);

   type Sint16 is new C.short;
   type Sint16_ptr is access all Sint16;
   pragma Convention (C, Sint16_ptr);
   type Sint16_ptr_ptr is access all Sint16_ptr;
   pragma Convention (C, Sint16_ptr_ptr);

   type Uint32 is new C.unsigned;
   type Uint32_ptr is access all Uint32;
   pragma Convention (C, Uint32_ptr);
   type Uint32_ptr_ptr is access all Uint32_ptr;
   pragma Convention (C, Uint32_ptr_ptr);

   package Uint32_Ptrs  is
      new System.Address_To_Access_Conversions (Uint32);

   type Uint32_Array is array (C.size_t range <>)
         of aliased Uint32;
   package Uint32_PtrOps is
      new UintN_PtrOps (
         The_Element => Uint32,
         The_Element_Array => Uint32_Array);

   function Increment (
      Pointer : Uint32_Ptrs.Object_Pointer;
      Amount : Natural) return Uint32_Ptrs.Object_Pointer;
   pragma Inline (Increment);

   function Decrement (
      Pointer : Uint32_Ptrs.Object_Pointer;
      Amount : Natural) return Uint32_Ptrs.Object_Pointer;
   pragma Inline (Decrement);

   function Shift_Left (
      Value : Uint32;
      Amount : Integer)
      return Uint32;
   pragma Inline (Shift_Left);

   function Shift_Right (
      Value : Uint32;
      Amount : Integer)
      return Uint32;
   pragma Inline (Shift_Right);

   type Sint32 is new C.int;
   type Sint32_ptr is access all Sint32;
   pragma Convention (C, Sint32_ptr);
   type Sint32_ptr_ptr is access all Sint32_ptr;
   pragma Convention (C, Sint32_ptr_ptr);

   type Uint64 is new CE.unsigned_long_long;
   type Uint64_ptr is access all Uint64;
   pragma Convention (C, Uint64_ptr);
   type Uint64_ptr_ptr is access all Uint64_ptr;
   pragma Convention (C, Uint64_ptr_ptr);

   type Sint64 is new CE.long_long;
   type Sint64_ptr is access all Sint64;
   pragma Convention (C, Sint64_ptr);
   type Sint64_ptr_ptr is access all Sint64_ptr;
   pragma Convention (C, Sint64_ptr_ptr);

   type bits1 is mod 2**1;
   --  for bits1'Size use 1;

   type bits6 is mod 2**6;
   --  for bits6'Size use 6;

   type bits16 is mod 2**16;
   --  for bits16'Size use 16;

   type bits31 is mod 2**31;
   --  for bits31'Size use 31;

   type void_ptr is new System.Address;

   type chars_ptr_ptr is access all C.Strings.chars_ptr;
   pragma Convention (C, chars_ptr_ptr);

   type int_ptr is access all C.int;
   pragma Convention (C, int_ptr);

   SDL_PRESSED  : constant := 16#01#;
   SDL_RELEASED : constant := 16#00#;

end SDL.Types;
