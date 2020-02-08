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
with Interfaces.C.Pointers;
generic
   type The_Element is mod <>;
   type The_Element_Array is
      array (Interfaces.C.size_t range <>) of aliased The_Element;
package UintN_PtrOps is
   package C renames Interfaces.C;

   package Operations is
      new Interfaces.C.Pointers (
         Index              => Interfaces.C.size_t,
         Element            => The_Element,
         Element_Array      => The_Element_Array,
         Default_Terminator => 0);

   subtype Pointer is Operations.Pointer;

   function Value
     (Ref        : in Pointer;
      Terminator : in The_Element)
      return       The_Element_Array renames Operations.Value;

   function Value
     (Ref    : in Pointer;
      Length : in C.ptrdiff_t)
      return   The_Element_Array renames Operations.Value;

   --------------------------------
   -- C-style Pointer Arithmetic --
   --------------------------------

   function "+" (Left : in Pointer;   Right : in C.ptrdiff_t) return Pointer
      renames Operations."+";
   function "+" (Left : in C.ptrdiff_t; Right : in Pointer)   return Pointer
      renames Operations."+";
   function "-" (Left : in Pointer;   Right : in C.ptrdiff_t) return Pointer
      renames Operations."-";
   function "-" (Left : in Pointer;   Right : in Pointer)   return C.ptrdiff_t
      renames Operations."-";

   procedure Increment (Ref : in out Pointer)
      renames Operations.Increment;
   procedure Decrement (Ref : in out Pointer)
      renames Operations.Increment;

   function Virtual_Length
     (Ref        : in Pointer;
      Terminator : in The_Element := 0)
      return       C.ptrdiff_t renames Operations.Virtual_Length;

   procedure Copy_Terminated_Array
     (Source     : in Pointer;
      Target     : in Pointer;
      Limit      : in C.ptrdiff_t := C.ptrdiff_t'Last;
      Terminator : in The_Element := 0)
   renames Operations.Copy_Terminated_Array;

   procedure Copy_Array
     (Source  : in Pointer;
      Target  : in Pointer;
      Length  : in C.ptrdiff_t)
   renames Operations.Copy_Array;

end UintN_PtrOps;

