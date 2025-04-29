#!/bin/perl
#Program ID. statit.pl
#Author.	Glen D. Geen
#email.	ggeen@tx.rr.com
#Version. 1.3
#Date-written.	can't remember.
#Date-modified.	23 December 2010
#Date-modified.  9 March 2011
#Date-modified.  4 April 2011
#Description:
########################################################################
# The statit.pl script performs a simple function of collecting file
# access/change/modify times and producing an output as comma 
# separated values for easy importation into Microsoft Excel. 
# 
# The statit.pl command executes simply, just supply the command with
# a file name or a list of file names.  Wild cards are welcome.
# Output is produced to standard out for easy rediretion to a file
# or for quick viewing.
#
# March 2011 update: Added the help option.  More update coming soon.
# 	Made the file stat process its own subroutine. 
#
# April 2011 update: Quoted the date/time/time zone in the teaders to
# to produce a single cell with that information.  
# Also quoted the file name after reviewing file names today that
# contained commas.  Now, really, who does that!?!
########################################################################

use strict;

$::help=<<EOHelp;

$0 [-h] [-H] <list_of_file_names>

-h | --help		: At present, this script has two command line options
				and the only command line argument is a file name, list of 
				file names, or wild cards that the script may expand into
				a file name list.

				Example 1.  $0 test1.txt 
	  			Example 2.  $0 test1.txt test2.txt test3.txt
	  			Example 3.  $0 *.txt

-H | --Headers	: If the -H or --Headers command line option is given,
				then the script will produce two lines of header 
				information.  The first line of header information
				is the system date, time, timezone if set, and 
				whether the system is using Daylight Saving Time.  The
				second line of information is the output from the Unix
				uname -a command.

				Additionally, the --Headers option produces a set of column
				headings in comma separated values format that line up with the
				CSV format of the output file stat data.

	  			Example 4.
	  			hostname.some.domain.com[5]% ./statit.pl
	  			Tue 8 Mar 2011, 14:24:30, TZ=US/Central, DST=No
	  			SunOS hostname.some.domain.com 5.10 Generic_141444-09 sun4u sparc SUNW,Sun-Blade-1000

				Filename,Mode,Owner,Group,Access Date/Time,Modify Date/Time,Change Date/Time,Size in Bytes,Inode,Number of blocks,Block Size
EOHelp

MAIN:
{
#set up my variables that will be used.
my $UNAME;
my $os = $^O;
my ($currentsec,$currentmin,$currenthour,$currentmday,$currentmon,$currentyear,$currentwday,$currentyday,$currentisdst);
my @day=('Sum','Mon','Tue','Wed','Thu','Fri','Sat');
my @mo=('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

if ( $os eq "solaris" || $os eq "linux" ) { $UNAME="/bin/uname"; }
elsif ( $os eq "darwin" ) { $UNAME="/usr/bin/uname"; }
else { $UNAME="";}

while (@ARGV)
	{
	ARGVSW:
		{
		if ($ARGV[0] eq "-h" || $ARGV[0] eq "--help" ) { print "$::help"; exit 0; }
		if ( $ARGV[0] eq "-H" || $ARGV[0] eq "--Headers" ) 
			{
			# Get the system time and convert it to local time as per the system.
			($currentsec,$currentmin,$currenthour,$currentmday,$currentmon,$currentyear,$currentwday,$currentyday,$currentisdst) = localtime(time());
			#print the current date and time.
			printf("\"%s %s %s %s, %02d:%02d:%02d, TZ=%s, DST=%s\"\n",$day[$currentwday],$currentmday,$mo[$currentmon],$currentyear+=1900, $currenthour,$currentmin,$currentsec,$ENV{TZ}, $currentisdst==1?"Yes":"No");
			#print the system identification.
			printf("\"%s\"\n", `$UNAME  -a`);
			#print header information
			print "Filename,Mode,Owner,Group,Access Date/Time,Modify Date/Time,Change Date/Time,Size in Bytes,Inode,Number of blocks,Block Size\n";
			shift (@ARGV);
			last ARGVSW;
			}
		} #end ARGVSW
	my $filename = shift(@ARGV);
	&statfiles($filename);
	}	#end While (@ARGV)

exit 0;
}	#end main routine.

########################################################################
# The statfiles subroutine is the is the real workhorse of this program.
# This is where we stat the filename  to retrieve the Access, Modify,
# and Change date/times of each filename in the list.  I include other
# useful information as well such as the inode number, the block count
# and the system block size.  This can assist in carving out files
########################################################################
sub statfiles
{
my ($filename) = @_;
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat($filename); # Get the file and return values
	my ($grname,$grpasswd,$grgid,$grmembers) = getgrgid($gid);													# Get the group name from the GID
	my ($pwname,$pwpasswd,$pwuid,$pwgid,$pwquota,$pwcomment,$pwgcos,$pwdir,$pwshell) = getpwuid($uid);			# Get login name from UID
	if ( $grname eq "" ) { $grname = $gid; }
	if ( $pwname eq "" ) { $pwname = $uid; }
	printf("\"%s\",%04o,%s,%s,", $filename, $mode & 07777, $pwname, $grname); 									# Write file name, mode, owner, and group

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($atime);								# Convert last access time into readable format
	printf("%s/%s/%s %02d:%02d:%02d,",$mon+=1,$mday,$year+=1900, $hour,$min,$sec);

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($mtime);								# Convert last modified time into readable format
	printf("%s/%s/%s %02d:%02d:%02d,",$mon+=1,$mday,$year+=1900, $hour,$min,$sec);

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($ctime);								# Convert last change time into readable format
	printf("%s/%s/%s %02d:%02d:%02d,",$mon+=1,$mday,$year+=1900, $hour,$min,$sec);
	print "$size,$ino,$blocks,$blksize\n";
}	#end statfiles subroutine.
