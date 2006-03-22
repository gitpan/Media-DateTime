use strict;
use warnings;

use Test::More tests => 2;

# Test set 1 -- can we load the library?
BEGIN { use_ok( 'Media::DateTime' ); };

# Test set 2 -- create client with ordered list of arguements
my $instance = Media::DateTime->new();
ok $instance, "Created new Media::DateTime";
