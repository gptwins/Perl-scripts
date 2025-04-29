#!/usr/bin/perl

$::help=<<EOHelp;
$0 [-s seconds_since_the_epoch] [-h] 
OPTIONS:
\t-h\tPrint this, the help page
\t-s num\tThe -s option is the number of seconds since the Ephoc.
\t\tThis value will be converted to the local date and time
\t\tfor the value provided. Note: Most Unix/Linux operating
\t\tsystem passowrd files uses days sincethe Epoch.
\t-d num\tThe -d option is the number of days since the Ephoc.
\t\tThis value is converted to the the location date and time
\t\tfor the vule provided.  Note: IBM password files use
\t\tdays since the Epoch.
Example 1.
$0 
Today, 02/20/2014 09:49, is day 16121 since the Epoch.

Example 2.
$0 -s 1390921824
Today, 02/20/2014 09:41, is day 16121 since the Epoch.
The date/time of the value entered is: 01/28/2014 09:10

Example 3.
$0 -d 16400
Today, 07/01/2014 11:43, is day 16252 since the Epoch.
The date/time of the value entered is: 11/25/2014 18:00

Version 0.6
EOHelp


MAIN: 
{

# 60 seconds in an hour * 60 minutes in an hour * 24 hours in a day = 86400 seconds in a day
my $today = time() / 86400;
my $imin, $ihour, $imday, $imon, $iyear;


while (@ARGV)
	{
	my $element = shift(@ARGV);
	SWITCH:
		{
		if ($element eq "-s")
			{
			$element = shift(@ARGV);
			($imin, $ihour, $imday, $imon, $iyear)=((localtime($element))[1,2,3,4,5]);
			$iyear += 1900;
			$imon++;
			last;
			}
		if ($element eq "-d")
			{
			$element = shift(@ARGV);
			$element *= 86400;
			($imin, $ihour, $imday, $imon, $iyear)=((localtime($element))[1,2,3,4,5]);
            $iyear += 1900;
            $imon++;
            last;	
			}
		if ($element eq "-h") { print "$::help"; exit 0; }
		print "$::help"; exit 1; 
		}	#end SWITCH tree.
	}	#end while @ARGV is still populated.

#get system time but just the minutes, hour, day, month, year, and Daylight Saving Time bit.
my ($min, $hour, $mday, $mon, $year)=((localtime(time()))[1,2,3,4,5]);
$year+=1900;
$mon++;
printf("Today, %02d/%02d/%4d %02d:%02d, is day %d since the Epoch.\n",$mon,$mday,$year,$hour,$min,$today);
# printf("%02d/%02d/%4d %02d:%02d\n",$mon,$mday,$year,$hour,$min);

if ( $imday ) { printf("The date/time of the value entered is: %02d/%02d/%4d %02d:%02d\n",$imon,$imday,$iyear,$ihour,$imin); }

}	#end MAIN routine.
