#include <stdio.h>
#include "rwops_wrap.h"


size_t read_wrap (struct SDL_RWops * context, void *ptr, size_t size, size_t maxnum)
{
  return SDL_RWread (context, ptr, size, maxnum);
}

size_t write_wrap (struct SDL_RWops * context, const void *ptr, size_t size, size_t num)
{
  return SDL_RWwrite (context, ptr, size, num);
}

int close_wrap (struct SDL_RWops * context)
{
  return SDL_RWclose (context);
}

