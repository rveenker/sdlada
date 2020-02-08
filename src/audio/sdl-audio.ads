
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


--  Modified for SDL2 by R.H.I. Veenker
--  (c) RNLA/JIVC/SATS
-- ----------------------------------------------------------------- --

--  **************************************************************** --
--  This is an Ada binding to SDL ( Simple DirectMedia Layer from    --
--  Sam Lantinga - www.libsld.org )                                  --
--  **************************************************************** --
--  In order to help the Ada programmer, the comments in this file   --
--  are, in great extent, a direct copy of the original text in the  --
--  SDL header files.                                                --
--  **************************************************************** --

with System;
with Interfaces.C.Strings;
with SDL.Types; use SDL.Types;
with SDL.RWops;

package SDL.Audio is
   pragma Elaborate_Body;
   package C renames Interfaces.C;

   use type Interfaces.C.int;

   SDL_AUDIO_ALLOW_FREQUENCY_CHANGE : constant C.int := 16#00000001#;
   SDL_AUDIO_ALLOW_FORMAT_CHANGE    : constant C.int := 16#00000002#;
   SDL_AUDIO_ALLOW_CHANNELS_CHANGE  : constant C.int := 16#00000004#;
   SDL_AUDIO_ALLOW_ANY_CHANGE       : constant C.int := (SDL_AUDIO_ALLOW_FREQUENCY_CHANGE
                                                         + SDL_AUDIO_ALLOW_FORMAT_CHANGE
                                                         + SDL_AUDIO_ALLOW_CHANNELS_CHANGE);

   --  This function is called when the audio device needs more data.
   --
   --  \param userdata An application-specific parameter saved in
   --                  the SDL_AudioSpec structure
   --  \param stream A pointer to the audio data buffer.
   --  \param len    The length of that buffer in bytes.
   --
   --  Once the callback returns, the buffer will no longer be valid.
   --  Stereo samples are stored in a LRLRLR ordering.
   --
   --  You can choose to avoid callbacks and use SDL_QueueAudio() instead, if
   --  you like. Just open your audio device with a NULL callback.

   type Callback_ptr_Type is access procedure (
                                               userdata : void_ptr;
                                               stream   : Uint8_ptr;
                                               len      : C.int);
   pragma Convention (C, Callback_ptr_Type);

   --  The calculated values in this structure are calculated by SDL_OpenAudio().
   --
   --  For multi-channel audio, the default SDL channel mapping is:
   --  2:  FL FR                       (stereo)
   --  3:  FL FR LFE                   (2.1 surround)
   --  4:  FL FR BL BR                 (quad)
   --  5:  FL FR FC BL BR              (quad + center)
   --  6:  FL FR FC LFE SL SR          (5.1 surround - last two can also be BL BR)
   --  7:  FL FR FC LFE BC SL SR       (6.1 surround)
   --  8:  FL FR FC LFE BL BR SL SR    (7.1 surround)

   type AudioSpec is
      record
         freq     : C.int;   --  DSP frequency -- samples per second
         format   : Uint16;  --  Audio data format
         channels : Uint8;   --  Number of channels: 1 mono, 2 stereo
         silence  : Uint8;   --  Audio buffer silence value (calculated)
         samples  : Uint16;  --  Audio buffer size in samples
         padding  : Uint16;  --  Necessary for some compile environments
         size     : Uint32;  --  Audio buffer size in bytes (calculated)
         --  This function is called when the audio device needs more data.
         --  'stream' is a pointer to the audio data buffer
         --  'len' is the length of that buffer in bytes.
         --  Once the callback returns, the buffer will no longer be valid.
         --  Stereo samples are stored in a LRLRLR ordering.
         callback : Callback_ptr_Type;
         userdata : void_ptr;
      end record;
   pragma Convention (C, AudioSpec);

   type AudioSpec_ptr is access all AudioSpec;
   pragma Convention (C, AudioSpec_ptr);

   type Format_Flag is mod 2 ** 16;
   pragma Convention (C, Format_Flag);

   type Format_Flag_ptr is access Format_Flag;
   pragma Convention (C, Format_Flag_ptr);

   --  Audio format flags (defaults to LSB byte order)

   --  Unsigned 8-bit samples
   AUDIO_U8      : constant Format_Flag := 16#0008#;
   --  Signed 8-bit samples
   AUDIO_S8      : constant Format_Flag := 16#8008#;
   --  Unsigned 16-bit samples
   AUDIO_U16LSB  : constant Format_Flag := 16#0010#;
   --  Signed 16-bit samples
   AUDIO_S16LSB  : constant Format_Flag := 16#8010#;
   --  As above, but big-endian byte order
   AUDIO_U16MSB  : constant Format_Flag := 16#1010#;
   --  As above, but big-endian byte order
   AUDIO_S16MSB  : constant Format_Flag := 16#9010#;

   AUDIO_U16     : constant Format_Flag := AUDIO_U16LSB;
   AUDIO_S16     : constant Format_Flag := AUDIO_S16LSB;

   function Get_Audio_U16_Sys return Format_Flag;

   function Get_Audio_S16_Sys return Format_Flag;

   SDL_AUDIOCVT_MAX_FILTERS : constant := 9;

   --  \brief A structure to hold a set of audio conversion filters and buffers.
   --
   --  Note that various parts of the conversion pipeline can take advantage
   --  of SIMD operations (like SSE2, for example). SDL_AudioCVT doesn't require
   --  you to pass it aligned data, but can possibly run much faster if you
   --  set both its (buf) field to a pointer that is aligned to 16 bytes, and its
   --  (len) field to something that's a multiple of 16, if possible.

   --  This structure is 84 bytes on 32-bit architectures, make sure GCC doesn't
   --  pad it out to 88 bytes to guarantee ABI compatibility between compilers.
   --  vvv
   --  The next time we rev the ABI, make sure to size the ints and add padding.
   type AudioCVT;
   type AudioCVT_ptr is access all AudioCVT;
   pragma Convention (C, AudioCVT_ptr);
   type filter_ptr is access procedure (
                                        cvt    : AudioCVT_ptr;
                                        format : Uint16);
   pragma Convention (C, filter_ptr);
   type filters_array is array (0 .. 9) of filter_ptr;
   pragma Convention (C, filters_array);
   type AudioCVT is
      record
         needed       : C.int;     --  Set to 1 if conversion possible
         src_format   : Uint16;    --  Source audio format
         dst_format   : Uint16;    --  Target audio format
         rate_incr    : C.double;  --  Rate conversion increment
         buf          : Uint8_ptr; --  Buffer to hold entire audio data
         len          : C.int;     --  Length of original audio buffer
         len_cvt      : C.int;     --  Length of converted audio buffer
         len_mult     : C.int;     --  buffer must be len*len_mult big
         len_ratio    : C.double;  --  Given len, final size is len*len_ratio
         filters      : filters_array;
         filter_index : C.int;     --  Current audio conversion function
      end record;
   pragma Convention (C, AudioCVT);

   --  -------------------
   --  Function prototypes
   --  -------------------

   --  These functions return the list of built in audio drivers, in the
   --  order that they are normally initialized by default.
   function SDL_GetNumAudioDrivers return C.int;
   pragma Import (C, SDL_GetNumAudioDrivers, "SDL_GetNumAudioDrivers");

   function SDL_GetAudioDriver (
                                index  : C.int)
                                return C.Strings.chars_ptr;
   pragma Import (C, SDL_GetAudioDriver, "SDL_GetAudioDriver");

   --  These function and procedure  are used internally, and should not
   --  be used unless you have a specific need to specify the audio driver
   --  you want to use.You should normally use Init or InitSubSystem.
   function SDL_AudioInit (driver_name : C.Strings.chars_ptr) return C.int;
   pragma Import (C, SDL_AudioInit, "SDL_AudioInit");

   procedure SDL_AudioQuit;
   pragma Import (C, SDL_AudioQuit, "SDL_AudioQuit");

   --  This function returns the name of the current audio driver, or NULL
   --  if no driver has been initialized.
   function SDL_GetCurrentAudioDriver (
                                       namebuf : C.Strings.chars_ptr;
                                       maslen  : C.int)
                                       return C.Strings.chars_ptr;
   pragma Import (C, SDL_GetCurrentAudioDriver, "SDL_GetCurrentAudioDriver");

   --  This function opens the audio device with the desired parameters, and
   --  returns 0 if successful, placing the actual hardware parameters in the
   --  structure pointed to by \c obtained.  If \c obtained is NULL, the audio
   --  data passed to the callback function will be guaranteed to be in the
   --  requested format, and will be automatically converted to the hardware
   --  audio format if necessary.  This function returns -1 if it failed
   --  to open the audio device, or couldn't set up the audio thread.
   --
   --  When filling in the desired audio spec structure,
   --    - \c desired->freq should be the desired audio frequency in samples-per-
   --      second.
   --    - \c desired->format should be the desired audio format.
   --    - \c desired->samples is the desired size of the audio buffer, in
   --      samples.  This number should be a power of two, and may be adjusted by
   --      the audio driver to a value more suitable for the hardware.  Good values
   --      seem to range between 512 and 8096 inclusive, depending on the
   --      application and CPU speed.  Smaller values yield faster response time,
   --      but can lead to underflow if the application is doing heavy processing
   --      and cannot fill the audio buffer in time.  A stereo sample consists of
   --      both right and left channels in LR ordering.
   --      Note that the number of samples is directly related to time by the
   --      following formula:  \code ms = (samples*1000)/freq \endcode
   --    - \c desired->size is the size in bytes of the audio buffer, and is
   --      calculated by SDL_OpenAudio().
   --    - \c desired->silence is the value used to set the buffer to silence,
   --      and is calculated by SDL_OpenAudio().
   --    - \c desired->callback should be set to a function that will be called
   --      when the audio device is ready for more data.  It is passed a pointer
   --      to the audio buffer, and the length in bytes of the audio buffer.
   --      This function usually runs in a separate thread, and so you should
   --      protect data structures that it accesses by calling SDL_LockAudio()
   --      and SDL_UnlockAudio() in your code. Alternately, you may pass a NULL
   --      pointer here, and call SDL_QueueAudio() with some frequency, to queue
   --      more audio samples to be played (or for capture devices, call
   --      SDL_DequeueAudio() with some frequency, to obtain audio samples).
   --    - \c desired->userdata is passed as the first parameter to your callback
   --      function. If you passed a NULL callback, this value is ignored.
   --
   --  The audio device starts out playing silence when it's opened, and should
   --  be enabled for playing by calling \c SDL_PauseAudio(0) when you are ready
   --  for your audio callback function to be called.  Since the audio driver
   --  may modify the requested size of the audio buffer, you should allocate
   --  any local mixing buffers after you open the audio device.
   function SDL_OpenAudio (
                           desired  : AudioSpec_ptr;
                           obtained : AudioSpec_ptr)
                           return C.int;
   pragma Import (C, SDL_OpenAudio, "SDL_OpenAudio");

   --  ==========================================================================
   --  SDL Audio Device IDs:
   --  A successful call to SDL_OpenAudio() is always device id 1, and legacy
   --  SDL audio APIs assume you want this device ID. SDL_OpenAudioDevice() calls
   --  always returns devices >= 2 on success. The legacy calls are good both
   --  for backwards compatibility and when you don't care about multiple,
   --  specific, or capture devices.
   --  ==========================================================================

   --  Get the number of available devices exposed by the current driver.
   --  Only valid after a successfully initializing the audio subsystem.
   --  Returns -1 if an explicit list of devices can't be determined; this is
   --  not an error. For example, if SDL is set up to talk to a remote audio
   --  server, it can't list every one available on the Internet, but it will
   --  still allow a specific host to be specified to SDL_OpenAudioDevice().
   --
   --  In many common cases, when this function returns a value <= 0, it can still
   --  successfully open the default device (NULL for first argument of
   --  SDL_OpenAudioDevice()).
   function SDL_GetNumAudioDevices (
                                    iscapture : C.int)
                                    return C.int;
   pragma Import (C, SDL_GetNumAudioDevices, "SDL_GetNumAudioDevices");

   --  Get the human-readable name of a specific audio device.
   --  Must be a value between 0 and (number of audio devices-1).
   --  Only valid after a successfully initializing the audio subsystem.
   --  The values returned by this function reflect the latest call to
   --  SDL_GetNumAudioDevices(); recall that function to redetect available
   --  hardware.
   --
   --  The string returned by this function is UTF-8 encoded, read-only, and
   --  managed internally. You are not to free it. If you need to keep the
   --  string for any length of time, you should make your own copy of it, as it
   --  will be invalid next time any of several other SDL functions is called.
   function SDL_GetAudioDeviceName (
                                    index     : C.int;
                                    iscapture : C.int)
                                    return C.Strings.chars_ptr;
   pragma Import (C, SDL_GetAudioDeviceName, "SDL_GetAudioDeviceName");

   --  Open a specific audio device. Passing in a device name of NULL requests
   --  the most reasonable default (and is equivalent to calling SDL_OpenAudio()).
   --
   --  The device name is a UTF-8 string reported by SDL_GetAudioDeviceName(), but
   --  some drivers allow arbitrary and driver-specific strings, such as a
   --  hostname/IP address for a remote audio server, or a filename in the
   --  diskaudio driver.
   --
   --  \return 0 on error, a valid device ID that is >= 2 on success.
   --
   --  SDL_OpenAudio(), unlike this function, always acts on device ID 1.
   function SDL_OpenAudioDevice (
                                 device          : C.Strings.chars_ptr;
                                 iscapture       : C.int;
                                 desired         : AudioSpec_ptr;
                                 obtained        : AudioSpec_ptr;
                                 allowed_changes : C.int)
                                 return C.int;
   pragma Import (C, SDL_OpenAudioDevice, "SDL_OpenAudioDevice");

   --  Get the current audio state:
   type audiostatus is new C.int;
   AUDIO_STOPED  : constant := 0;
   AUDIO_PLAYING : constant := 1;
   AUDIO_PAUSED  : constant := 2;

   function SDL_GetAudioStatus return audiostatus;
   pragma Import (C, SDL_GetAudioStatus, "SDL_GetAudioStatus");

   function SDL_GetAudioDeviceStatus (dev : C.int) return audiostatus;
   pragma Import (C, SDL_GetAudioDeviceStatus, "SDL_GetAudioDeviceStatus");

   --  These functions pause and unpause the audio callback processing.
   --  They should be called with a parameter of 0 after opening the audio
   --  device to start playing sound.  This is so you can safely initialize
   --  data for your callback function after opening the audio device.
   --  Silence will be written to the audio device during the pause.
   procedure SDL_PauseAudio (pause_on : C.int);
   pragma Import (C, SDL_PauseAudio, "SDL_PauseAudio");

   procedure SDL_PauseAudioDevice (device   : C.int;
                                   pause_on : C.int);
   pragma Import (C, SDL_PauseAudioDevice, "SDL_PauseAudioDevice");

   --  This function loads a WAVE from the data source, automatically freeing
   --  that source if \c freesrc is non-zero.  For example, to load a WAVE file,
   --  you could do:
   --  \code
   --      SDL_LoadWAV_RW(SDL_RWFromFile("sample.wav", "rb"), 1, ...);
   --  \endcode
   --
   --  If this function succeeds, it returns the given SDL_AudioSpec,
   --  filled with the audio data format of the wave data, and sets
   --  \c  --audio_buf to a malloc()'d buffer containing the audio data,
   --  and sets \c  --audio_len to the length of that audio buffer, in bytes.
   --  You need to free the audio buffer with SDL_FreeWAV() when you are
   --  done with it.
   --
   --  This function returns NULL and sets the SDL error message if the
   --  wave file cannot be opened, uses an unknown data format, or is
   --  corrupt.  Currently raw and MS-ADPCM WAVE files are supported.
   function SDL_LoadWAV_RW (
                            src       : SDL.RWops.RWops;
                            freesrc   : C.int;
                            spec      : AudioSpec_ptr;
                            audio_buf : Uint8_ptr_ptr;
                            audio_len : Uint32_ptr)
                               return AudioSpec_ptr;
   pragma Import (C, SDL_LoadWAV_RW, "SDL_LoadWAV_RW");

   --  Loads a WAV from a file.
   --  Compatibility convenience function.

   function SDL_LoadWAV (
                         file      : C.Strings.chars_ptr;
                         spec      : AudioSpec_ptr;
                         audio_buf : Uint8_ptr_ptr;
                         audio_len : Uint32_ptr)
                            return AudioSpec_ptr;
   pragma Inline (SDL_LoadWAV);


   --  This function frees data previously allocated with SDL_LoadWAV_RW()
   procedure SDL_FreeWAV (audio_buf : Uint8_ptr);
   pragma Import (C, SDL_FreeWAV, "SDL_FreeWAV");

   --  This function takes a source format and rate and a destination format
   --  and rate, and initializes the \c cvt structure with information needed
   --  by SDL_ConvertAudio() to convert a buffer of audio data from one format
   --  to the other. An unsupported format causes an error and -1 will be returned.
   --
   --  \return 0 if no conversion is needed, 1 if the audio filter is set up,
   --  or -1 on error.
   function SDL_BuildAudioCVT (
                               cvt          : AudioCVT_ptr;
                               src_format   : Uint16;
                               src_channels : Uint8;
                               src_rate     : C.int;
                               dst_format   : Uint16;
                               dst_channels : Uint8;
                               dst_rate     : C.int)
                               return C.int;
   pragma Import (C, SDL_BuildAudioCVT, "SDL_BuildAudioCVT");

   --  Once you have initialized the 'cvt' structure using BuildAudioCVT,
   --  created an audio buffer cvt.buf, and filled it with cvt.len bytes of
   --  audio data in the source format, this function will convert it in-place
   --  to the desired format.
   --  The data conversion may expand the size of the audio data, so the buffer
   --  cvt.buf should be allocated after the cvt structure is initialized by
   --  BuildAudioCVT, and should be cvt.len * cvt.len_mult bytes long.
   function SDL_ConvertAudio (cvt : AudioCVT_ptr) return C.int;
   pragma Import (C, SDL_ConvertAudio, "SDL_ConvertAudio");


   --  =========================================================================
   --  Incomplete:
   --  Needs mixer support

   --  Test:
   --  This takes two audio buffers of the playing audio format and mixes
   --  them, performing addition, volume adjustment, and overflow clipping.
   --  The volume ranges from 0 - 128, and should be set to _MIX_MAXVOLUME
   --  for full audio volume.  Note this does not change hardware volume.
   --  This is provided for convenience -- you can mix your own audio data.
   MIX_MAXVOLUME : constant := 128;
   procedure MixAudio (
                       dst    : Uint8_ptr;
                       src    : Uint8_ptr;
                       len    : Uint32;
                       volume : C.int);
   pragma Import (c, MixAudio, "SDL_MixAudio");

   --  =========================================================================

  --  Queue more audio on non-callback devices.
  --
  --  (If you are looking to retrieve queued audio from a non-callback capture
  --  device, you want SDL_DequeueAudio() instead. This will return -1 to
  --  signify an error if you use it with capture devices.)
  --
  --  SDL offers two ways to feed audio to the device: you can either supply a
  --  callback that SDL triggers with some frequency to obtain more audio
  --  (pull method), or you can supply no callback, and then SDL will expect
  --  you to supply data at regular intervals (push method) with this function.
  --
  --  There are no limits on the amount of data you can queue, short of
  --  exhaustion of address space. Queued data will drain to the device as
  --  necessary without further intervention from you. If the device needs
  --  audio but there is not enough queued, it will play silence to make up
  --  the difference. This means you will have skips in your audio playback
  --  if you aren't routinely queueing sufficient data.
  --
  --  This function copies the supplied data, so you are safe to free it when
  --  the function returns. This function is thread-safe, but queueing to the
  --  same device from two threads at once does not promise which buffer will
  --  be queued first.
  --
  --  You may not queue audio on a device that is using an application-supplied
  --  callback; doing so returns an error. You have to use the audio callback
  --  or queue audio with this function, but not both.
  --
  --  You should not call SDL_LockAudio() on the device before queueing; SDL
  --  handles locking internally for this function.
  --
  --  \param dev The device ID to which we will queue audio.
  --  \param data The data to queue to the device for later playback.
  --  \param len The number of bytes (not samples!) to which (data) points.
  --  \return 0 on success, or -1 on error.
  --
  --  \sa SDL_GetQueuedAudioSize
  --  \sa SDL_ClearQueuedAudio
   function SDL_QueueAudio (device  : C.int;
                            data    : Uint8_ptr;
                            len     : Uint32)
                          return C.int;
   pragma Import (C, SDL_QueueAudio, "SDL_QueueAudio");

   --  Dequeue more audio on non-callback devices.
  --
  --  (If you are looking to queue audio for output on a non-callback playback
  --  device, you want SDL_QueueAudio() instead. This will always return 0
  --  if you use it with playback devices.)
  --
  --  SDL offers two ways to retrieve audio from a capture device: you can
  --  either supply a callback that SDL triggers with some frequency as the
  --  device records more audio data, (push method), or you can supply no
  --  callback, and then SDL will expect you to retrieve data at regular
  --  intervals (pull method) with this function.
  --
  --  There are no limits on the amount of data you can queue, short of
  --  exhaustion of address space. Data from the device will keep queuing as
  --  necessary without further intervention from you. This means you will
  --  eventually run out of memory if you aren't routinely dequeueing data.
  --
  --  Capture devices will not queue data when paused; if you are expecting
  --  to not need captured audio for some length of time, use
  --  SDL_PauseAudioDevice() to stop the capture device from queueing more
  --  data. This can be useful during, say, level loading times. When
  --  unpaused, capture devices will start queueing data from that point,
  --  having flushed any capturable data available while paused.
  --
  --  This function is thread-safe, but dequeueing from the same device from
  --  two threads at once does not promise which thread will dequeued data
  --  first.
  --
  --  You may not dequeue audio from a device that is using an
  --  application-supplied callback; doing so returns an error. You have to use
  --  the audio callback, or dequeue audio with this function, but not both.
  --
  --  You should not call SDL_LockAudio() on the device before queueing; SDL
  --  handles locking internally for this function.
  --
  --  \param dev The device ID from which we will dequeue audio.
  --  \param data A pointer into where audio data should be copied.
  --  \param len The number of bytes (not samples!) to which (data) points.
  --  \return number of bytes dequeued, which could be less than requested.
  --
  --  \sa SDL_GetQueuedAudioSize
  --  \sa SDL_ClearQueuedAudio
   function SDL_DequeueAudio (device  : C.int;
                              data    : Uint8_ptr;
                              len     : Uint32)
                             return Uint32;
   pragma Import (C, SDL_DequeueAudio, "SDL_DequeueAudio");

  --  Get the number of bytes of still-queued audio.
  --
  --  For playback device:
  --
  --    This is the number of bytes that have been queued for playback with
  --    SDL_QueueAudio(), but have not yet been sent to the hardware. This
  --    number may shrink at any time, so this only informs of pending data.
  --
  --    Once we've sent it to the hardware, this function can not decide the
  --    exact byte boundary of what has been played. It's possible that we just
  --    gave the hardware several kilobytes right before you called this
  --    function, but it hasn't played any of it yet, or maybe half of it, etc.
  --
  --  For capture devices:
  --
  --    This is the number of bytes that have been captured by the device and
  --    are waiting for you to dequeue. This number may grow at any time, so
  --    this only informs of the lower-bound of available data.
  --
  --  You may not queue audio on a device that is using an application-supplied
  --  callback; calling this function on such a device always returns 0.
  --  You have to queue audio with SDL_QueueAudio()/SDL_DequeueAudio(), or use
  --  the audio callback, but not both.
  --
  --  You should not call SDL_LockAudio() on the device before querying; SDL
  --  handles locking internally for this function.
  --
  --  \param dev The device ID of which we will query queued audio size.
  --  \return Number of bytes (not samples!) of queued audio.
  --
  --  \sa SDL_QueueAudio
  --  \sa SDL_ClearQueuedAudio
   function SDL_GetQueuedAudioSize (device : C.int)
                                 return Uint32;
   pragma Import (C, SDL_GetQueuedAudioSize, "SDL_GetQueuedAudioSize");

  --  Drop any queued audio data. For playback devices, this is any queued data
  --  still waiting to be submitted to the hardware. For capture devices, this
  --  is any data that was queued by the device that hasn't yet been dequeued by
  --  the application.
  --
  --  Immediately after this call, SDL_GetQueuedAudioSize() will return 0. For
  --  playback devices, the hardware will start playing silence if more audio
  --  isn't queued. Unpaused capture devices will start filling the queue again
  --  as soon as they have more data available (which, depending on the state
  --  of the hardware and the thread, could be before this function call
  --  returns!).
  --
  --  This will not prevent playback of queued audio that's already been sent
  --  to the hardware, as we can not undo that, so expect there to be some
  --  fraction of a second of audio that might still be heard. This can be
  --  useful if you want to, say, drop any pending music during a level change
  --  in your game.
  --
  --  You may not queue audio on a device that is using an application-supplied
  --  callback; calling this function on such a device is always a no-op.
  --  You have to queue audio with SDL_QueueAudio()/SDL_DequeueAudio(), or use
  --  the audio callback, but not both.
  --
  --  You should not call SDL_LockAudio() on the device before clearing the
  --  queue; SDL handles locking internally for this function.
  --
  --  This function always succeeds and thus returns void.
  --
  --  \param dev The device ID of which to clear the audio queue.
  --
  --  \sa SDL_QueueAudio
  --  \sa SDL_GetQueuedAudioSize
   procedure SDL_ClearQueuedAudio (device : C.int);
   pragma Import (C, SDL_ClearQueuedAudio, "SDL_ClearQueuedAudio");

   --  The lock manipulated by these functions protects the callback function.
   --  During a SDL_LockAudio()/SDL_UnlockAudio() pair, you can be guaranteed that
   --  the callback function is not running.  Do not call these from the callback
   --  function or you will cause deadlock.
   procedure LockAudio;
   pragma Import (C, LockAudio, "SDL_LockAudio");
   procedure SDL_LockAudioDevice (dev : C.int);
   pragma Import (C, SDL_LockAudioDevice, "SDL_LockAudioDevice");

   procedure UnlockAudio;
   pragma Import (C, UnlockAudio, "SDL_UnlockAudio");
   procedure SDL_UnlockAudioDevice (dev : C.int);
   pragma Import (C, SDL_UnlockAudioDevice, "SDL_UnlockAudioDevice");

   --  This procedure shuts down audio processing and closes the audio device.
   procedure CloseAudio;
   pragma Import (C, CloseAudio, "SDL_CloseAudio");
   procedure SDL_CloseAudioDevice (dev : C.int);
   pragma Import (C, SDL_CloseAudioDevice, "SDL_CloseAudioDevice");

end SDL.Audio;
