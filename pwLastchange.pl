#!/usr/bin/perl

$::help=<<EOHelp;
$0 [-e exludesfile] [-f inputfilename] [-h] 

ProgramId : "pwLastchange"
Author : "G D Geen"
DateWritten : "24 January 2011"
DateUpdated : "1 February 2011"
Version : "0.2a"

-e	:	<exclude_filename>. A file containing a list of login names to programatically exclude from password age checking.
	:	Each login name must be separated by a white space, preferrably a new-line character.
-f	:	<input_filename>.  Alternate shadow file name.  The default is /etc/shadow.
-h	:	Help, this text.
EOHelp


MAIN: 
{

my $today = time() / 86400;
my $shadow = "/etc/shadow";
my @pw, $loginname, $password, $lastchange, $pwage, $excludefile;

while (@ARGV)
	{
	my $element = shift(@ARGV);
	SWITCH:
		{
		if ($element eq "-h") { print "$::help"; exit 0; }
		if ($element eq "-e") { $excludefile = shift(@ARGV); last SWITCH; }
		if ($element eq "-f") { $shadow = shift(@ARGV); last SWITCH; }
		print "$::help"; exit 1; 
		}	#end SWITCH tree.
	}	#end while @ARGV is still populated.

printf("Today is day %d since the Epoch.\n",$today);
#Open the shadow file for read only.  Process each record in the shadow file
open (SHADOW, "$shadow") || die("ERROR: cannot open $shadow.  $!\n");
while (<SHADOW>)
	{
	($loginname, $password, $lastchange, undef) = split(/:/,$_,4);
	$pwage = $today - $lastchange;

	if ($lastchange eq "") { $lastchange=0; }
	if ( $password eq "NP" || $password eq "*NP*" || $password =~ /\*LK\*.*/ )
		{ 
		#do nothing 
		}
	elsif ($pwage > 91) { printf("%s password is %d days old.  Change password, lock account, or file an RA.\n",$loginname,$pwage); }

	}	#end while elements of shadow still exist

}	#end MAIN routine.
