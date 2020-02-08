
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
package body SDL.Types is

   --  ===================================================================
   --  generic
   --     type Data_Type is private;
   --     type Amount_Type is private;
   --  function Shift_Left (
   --     Data : Data_Type;
   --     Amount : Amount_Type) return Data_Type;

   --  function Shift_Left (
   --     Value : Value_Type;
   --     Amount : Amount_Type) return Data_Type
   --  is
   --     use Interfaces;
   --  begin
   --     return Uint8 (Shift_Left (Unsigned_8 (Value), Amount));
   --  end Shift_Left;

   --  ===================================================================
   function Shift_Left (
      Value : Uint8;
      Amount : Integer) return Uint8
   is
      use Interfaces;
   begin
      return Uint8 (Shift_Left (Unsigned_8 (Value), Amount));
   end Shift_Left;


   --  ===================================================================
   function Shift_Right (
      Value : Uint8;
      Amount : Integer) return Uint8
   is
      use Interfaces;
   begin
      return Uint8 (Shift_Right (Unsigned_8 (Value), Amount));
   end Shift_Right;

   --  ===================================================================
   function Shift_Left (
      Value : Uint16;
      Amount : Integer) return Uint16
   is
      use Interfaces;
   begin
      return Uint16 (Shift_Left (Unsigned_16 (Value), Amount));
   end Shift_Left;


   --  ===================================================================
   function Shift_Right (
      Value : Uint16;
      Amount : Integer) return Uint16
   is
      use Interfaces;
   begin
      return Uint16 (Shift_Right (Unsigned_16 (Value), Amount));
   end Shift_Right;

   --  ===================================================================
   function Shift_Left (
      Value : Uint32;
      Amount : Integer) return Uint32
   is
      use Interfaces;
   begin
      return Uint32 (Shift_Left (Unsigned_32 (Value), Amount));
   end Shift_Left;


   --  ===================================================================
   function Shift_Right (
      Value : Uint32;
      Amount : Integer) return Uint32
   is
      use Interfaces;
   begin
      return Uint32 (Shift_Right (Unsigned_32 (Value), Amount));
   end Shift_Right;

   --  ===================================================================
   function Increment (
      Pointer : Uint8_Ptrs.Object_Pointer;
      Amount : Natural) return Uint8_Ptrs.Object_Pointer
   is
      use Uint8_PtrOps;
   begin
      return Uint8_Ptrs.Object_Pointer (
                Uint8_PtrOps.Pointer (Pointer)
                + C.ptrdiff_t (Amount));
   end Increment;

   --  ===================================================================
   function Decrement (
      Pointer : Uint8_Ptrs.Object_Pointer;
      Amount : Natural) return Uint8_Ptrs.Object_Pointer
   is
      use Uint8_PtrOps;
   begin
      return Uint8_Ptrs.Object_Pointer (
                Uint8_PtrOps.Pointer (Pointer)
                - C.ptrdiff_t (Amount));
   end Decrement;

   --  ===================================================================
   function Increment (
      Pointer : Uint16_Ptrs.Object_Pointer;
      Amount : Natural) return Uint16_Ptrs.Object_Pointer
   is
      use Uint16_PtrOps;
   begin
      return Uint16_Ptrs.Object_Pointer (
                Uint16_PtrOps.Pointer (Pointer)
                + C.ptrdiff_t (Amount));
   end Increment;

   --  ===================================================================
   function Decrement (
      Pointer : Uint16_Ptrs.Object_Pointer;
      Amount : Natural) return Uint16_Ptrs.Object_Pointer
   is
      use Uint16_PtrOps;
   begin
      return Uint16_Ptrs.Object_Pointer (
                Uint16_PtrOps.Pointer (Pointer)
                - C.ptrdiff_t (Amount));
   end Decrement;

   --  ===================================================================
   function Increment (
      Pointer : Uint32_Ptrs.Object_Pointer;
      Amount : Natural) return Uint32_Ptrs.Object_Pointer
   is
      use Uint32_PtrOps;
   begin
      return Uint32_Ptrs.Object_Pointer (
                Uint32_PtrOps.Pointer (Pointer)
                + C.ptrdiff_t (Amount));
   end Increment;

   --  ===================================================================
   function Decrement (
      Pointer : Uint32_Ptrs.Object_Pointer;
      Amount : Natural) return Uint32_Ptrs.Object_Pointer
   is
      use Uint32_PtrOps;
   begin
      return Uint32_Ptrs.Object_Pointer (
                Uint32_PtrOps.Pointer (Pointer)
                - C.ptrdiff_t (Amount));
   end Decrement;

   --  ===================================================================
   procedure Copy_Array (
      Source : Uint8_Ptrs.Object_Pointer;
      Target : Uint8_Ptrs.Object_Pointer;
      Lenght : Natural)
   is
   begin
      Uint8_PtrOps.Copy_Array (
         Uint8_PtrOps.Pointer (Source),
         Uint8_PtrOps.Pointer (Target),
         C.ptrdiff_t (Lenght));
   end Copy_Array;

   --  ===================================================================
end SDL.Types;
