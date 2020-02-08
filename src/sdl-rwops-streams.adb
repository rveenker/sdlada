--------------------------------------------------------------------------------------------------------------------
--  Copyright (c) 2013-2020, Luke A. Guest
--
--  This software is provided 'as-is', without any express or implied
--  warranty. In no event will the authors be held liable for any damages
--  arising from the use of this software.
--
--  Permission is granted to anyone to use this software for any purpose,
--  including commercial applications, and to alter it and redistribute it
--  freely, subject to the following restrictions:
--
--     1. The origin of this software must not be misrepresented; you must not
--     claim that you wrote the original software. If you use this software
--     in a product, an acknowledgment in the product documentation would be
--     appreciated but is not required.
--
--     2. Altered source versions must be plainly marked as such, and must not be
--     misrepresented as being the original software.
--
--     3. This notice may not be removed or altered from any source
--     distribution.
--------------------------------------------------------------------------------------------------------------------
with SDL.Error;

package body SDL.RWops.Streams is
   use type Interfaces.C.unsigned_long;

   function Open (Op : in RWops) return RWops_Stream is
   begin
      return (Ada.Streams.Root_Stream_Type with Context => Op);
   end Open;

   procedure Open (Op : in RWops; Stream : out RWops_Stream) is
   begin
      Stream.Context := Op;
   end Open;

   overriding
   procedure Read (Stream : in out RWops_Stream;
                   Item   : out Ada.Streams.Stream_Element_Array;
                   Last   : out Ada.Streams.Stream_Element_Offset)
   is
      Objects_Read : Interfaces.C.unsigned_long := 0;

      function SDL_Read (Context : in RWops_Pointer;
                         Ptr     : in System.Address;
                         Size    : in C.unsigned_long;
                         Max_Num : in C.unsigned_long
                        ) return C.unsigned_long;
      pragma Import (C, SDL_Read, "read_wrap");
   begin
      --  Re-implemented c-macro:
      --  #define SDL_RWread(ctx, ptr, size, n)   (ctx)->read(ctx, ptr, size, n)

      --  Read   : access function
      --    (context : RWops_Pointer;
      --     ptr     : System.Address;
      --     size    : Interfaces.C.unsigned_long;
      --     maxnum  : Interfaces.C.unsigned_long) return Interfaces.C.unsigned_long;

      Objects_Read := SDL_Read (Context => RWops_Pointer (Stream.Context),
                                Ptr     => Item'Address,
                                Size    => C.unsigned_long (Item'Length),
                                Max_Num => 1);

      if Objects_Read = 0 then
         raise RWops_Error with SDL.Error.Get;
      end if;

      Last := Ada.Streams.Stream_Element_Offset (Objects_Read);
   end Read;

   overriding
   procedure Write (Stream : in out RWops_Stream; Item : Ada.Streams.Stream_Element_Array)
   is
      Objects_Written : Interfaces.C.unsigned_long := 0;

      function SDL_Write (Context : in RWops_Pointer;
                          Ptr     : in System.Address;
                          Size    : in C.unsigned_long;
                          Num     : in C.unsigned_long
                         ) return C.unsigned_long;
      pragma Import (C, SDL_Write, "write_wrap");
   begin
      --  Re-implemented c-macro:
      --  #define SDL_RWwrite(ctx, ptr, size, n)  (ctx)->write(ctx, ptr, size, n)

      --  Write  : access function
      --    (Context : RWops_Pointer;
      --     Ptr     : System.Address;
      --     Size    : Interfaces.C.unsigned_long;
      --     Num     : Interfaces.C.unsigned_long) return Interfaces.C.unsigned_long;

      Objects_Written := SDL_Write
        (Context => RWops_Pointer (Stream.Context),
         Ptr     => Item'Address,
         Size    => C.unsigned_long (Item'Length),
         Num     => 1);

      if Objects_Written = 0 then
         raise RWops_Error with SDL.Error.Get;
      end if;
   end Write;

   procedure Close (Stream : in out RWops_Stream)
   is
      use type C.int;
      Res : C.int := 0;

      function SDL_Close (Context : in RWops_Pointer) return C.int;
      pragma Import (C, SDL_Close, "close_wrap");
   begin
      --  Re-implemented c-macro:
      --  #define SDL_RWclose(ctx)                (ctx)->close(ctx)

      --  Close  : access function
      --    (Context : RWops_Pointer) return Interfaces.C.int;

      Res := SDL_Close (Context => RWops_Pointer (Stream.Context));

      if Res /= 0 then
         raise RWops_Error with SDL.Error.Get;
      end if;
   end Close;


end SDL.RWops.Streams;
