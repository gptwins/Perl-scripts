#!/usr/bin/perl

$::help=<<eohelp;
$0 [-s seconds_since_epoch | -d days_since_epoch]
Version 0.2
 
AIX stores password age as seconds since the epoch so use the -s option.
Solaris and Linux stores password age in days since the epoch so use the -d option.
 
eohelp
MAIN:
{
my $time;
my @months = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
 
OPTSW:
while( @ARGV )
    {
    my $opt = shift(@ARGV);
    if ( "$opt" eq "-s" ) { $time = shift(@ARGV); next OPTSW; }
    if ( "$opt" eq "-d" )
        {
        $time = shift(@ARGV);
        $time = ( $time * 24 * 60 * 60 );
        next OPTSW;
        }
    if ( "$opt" eq "-h" ) { print $::help; exit 0; }
    print $::help; exit 1;
    }
 
if ( !$time ) { $time = time(); }
 
my ($sec, $min, $hour, $day, $month, $year) = (localtime($time))[0,1,2,3,4,5];
# print "Epoch is: ".$time.", converts to this date: ".$day." ".$months[$month]." ".($year+1900)." -- ".$hour.":".$min.":".$sec."\n";
printf ("Epoch is: %s, Converts to this Date: %02d %s %04d, and Time: %02d:%02d:%02d\n",$time,$day,$months[$month],($year+1900),$hour,$min,$sec);
}   #end main block
