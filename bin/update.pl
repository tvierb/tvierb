#!/usr/bin/perl

use strict;
use warnings;
$| = 1;

# menu processing
# build menu
my $menu = "";
for my $mname (glob("Menu_*"))
{
	next unless -l $mname;
	my $entry = substr( $mname, 5 );
	my $target = readlink( $mname );
	$menu .= "[$entry]($target) ";
}
print "$menu\n";

# update md files:
my $marker1 = "[\/\/]: # MENUSTART";
my $marker2 = "[\/\/]: # ENDMENU";
for my $mdfile (glob("*.md"))
{
	print "Updating $mdfile ";
	open my $fh, '<', $mdfile or die "Can't open file $!";
	read $fh, my $file_content, -s $fh;
	close $fh;
	my $m1 = index($file_content, $marker1);
	my $m2 = index($file_content, $marker2);
	next unless (($m1 > -1) && ($m2 > -1) && ($m1 < $m2));
	my $new_content = substr( $file_content, 0, $m1 + length($marker1) )
		. "\n" . $menu . "\n"
		. substr( $file_content, $m2 );
	print "new content:\n$new_content\n";
	# open my $fh, '>', $mdfile or die "Cannot open for writing: $!";
	# print $fh $file_content;
	# close( $fh );
}
