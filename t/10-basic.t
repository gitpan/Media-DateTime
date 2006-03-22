use strict;
use warnings;

use Test::More tests => 4;

use Media::DateTime;
use DateTime;

my $dater = Media::DateTime->new();
ok $dater, "Created new Media::DateTime";

my $s = 't/ex/src';

is $dater->datetime( "$s/normal.jpg" ),  date(2005,7,29,15,00,42), 'date from normal jpg';

SKIP:{
	skip 'need to implement a better filesystem/default test', 2;
	is $dater->datetime( "$s/no-exif.jpg" ), date(2004,7,1,6,25,4),  'fails correct for no exif';
	is $dater->datetime( "$s/textfile.txt" ), date(2006,3,20,13,33,50), 'date for txt1';
}

sub date {
	return DateTime->new(
			year =>	$_[0],
			month => $_[1],
			day => $_[2],
		    hour => $_[3],
			minute => $_[4],
			second => $_[5],
		);
}

