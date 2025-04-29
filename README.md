This is just a collection of Perl scripts written over time.

The cdtlight.zip: password=trend, is a perl script written to collect log file information for Trend Micro Apex One (formerly OfficeScan).  These logs are useful for debugging issues with the Apex One agent.
DTCONVERT.PL: Enter a number, -s seconds since the epoch, or -d days since the epoch, to convert current date and time.
EPOC2DATE.PL: just an earlier version of dtconvert.pl
PWLASTCHANGE.PL: reads through the /etc/shadow file, captures the login name, password value, and last change date.  Prints out the login name and password age if more than 91 days old.
STATIT.PL: gathers file information such as name, last read, last modified, and last change, size, inodes used, blocks use, and block size.  Usefull for forensic purposes.
TAPEROTATE.PL: Creates a tape rotation configuration file.  Tested with up-to five tape drives.  Allows you to similate a tape robot.  Ejects the tape after a backup is created.
