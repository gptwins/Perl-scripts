#!/usr/bin/perl


$::help=<<EOHelp;
$0 [-h] 
Description:
The $0 program mods the day of the year against the number of 
available tape drives.  The program then writes a new 
tape job configuration file telling the computer which tape
drive to send the backup data to.

Options:
-h\tThis help screen
-c\t -c <filename> tell the server the name of the configuration
  \tfile to write.
-t\t -t <number> the number of available tape drives to choose from.

Version: 0.3a
EOHelp

use strict;
use warnings;
MAIN:
{
my $today = time() / 86400;
my $num_tape_drives=2;
my $st = 0;
my $backup_file="/home/geen/etc/tapejob.conf";

while (@ARGV)
    {
    my $element = shift(@ARGV);
    SWITCH:
        {
        if ($element eq "-c") { $backup_file = shift(@ARGV); last; }
        if ($element eq "-t") { $num_tape_drives = shift(@ARGV); last; }
        if ($element eq "-h") { print "$::help"; exit 0; }
        print "$::help"; exit 1;
        }   #end SWITCH tree.
    }   #end while @ARGV is still populated.


$today = int($today);
$st = ($today % $num_tape_drives);
print "$today : $num_tape_drives : $st\n";

open(my $CFGfh, ">", $backup_file) || die "ERROR: Could not open $backup_file for write. $!\n";

print($CFGfh "TARCMD=\"tar -b 128\" \n");
print($CFGfh "TAPEDEVICE=/dev/st$st\n");
print($CFGfh "EJECTCMD=\"/bin/mt -f /dev/st$st eject\" \n");
close($CFGfh);
}
