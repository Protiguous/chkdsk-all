ScanDisk All
==========

This program will run CHKDSK on all drives in an unattended manner.
CHKDSK will be done in a two-steps way for safer execution.
The computer will be shutdown after finishing, but can be aborted
by pressing enter.

UPDATE: The automatic shutdown has been removed.

Supports:
 * NTFS 
 * FAT32 
 * New generation CKHDSK commands (/scan /perf ...) 
 * Scanning of SYSTEM drive (C: by default) now includes "sfc.exe /scannow" for check system file integrity.