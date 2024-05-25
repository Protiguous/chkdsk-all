chkdsk All
==========

This batch file will run CHKDSK on all local drives in a mostly unattended parallel manner.
CHKDSK will be done in two steps for a safer execution.

NOTE: The _useless_ automatic shutdown has been removed.

Supports:
 * NTFS 
 * FAT32 
 * Modern CKHDSK commands (/scan /perf) 
 * Scanning of SYSTEM drive (C: by default) now also includes "sfc.exe /scannow" to check system file integrity.
