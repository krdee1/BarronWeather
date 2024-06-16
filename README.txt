This is an automatic NOAA APT transmission receiving and decoding software suite for Raspberry Pi boards 3 and up with RTLSDR USB receivers.

This repo has most recently been updated to automatically use satdump in a tmux instance that is created on boot via a systemd service.
Output images are trimmed of leading/trailing static rows by a basic image processing algorithm run in Octave.
