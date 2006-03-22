package Media::DateTime;

###########################################################################
# Media::DateTime
# Mark V. Grimes
#
# A simple module to extract the timestamp from media files in an flexible 
# manner.
#
# Copyright (c) 2006 Mark V. Grimes (mgrimes@cpan.org).
# All rights reserved. This program is free software; you can redistribute
# it and/or modify it under the same terms as Perl itself.
#
# Formatted with tabstops at 4
###########################################################################

use strict;
use warnings;

use Carp;
use DateTime;
use Module::Pluggable 
		search_path	=> 'Media::DateTime',
		require		=> 1,		
		sub_name	=> 'matchers';

our $VERSION = '0.20';

sub new {
	my $that  = shift;
	my $class = ref($that) || $that;	# Enables use to call $instance->new()
	return bless {}, $class;
}

sub datetime {
	my ($self,$f) = @_;
	for my $class ($self->matchers){
		if( $class->match( $f ) ){
			my $v = $class->datetime( $f );
			return $v if defined $v;
		}
	}
	return $self->_datetime_from_filesystem_stamp( $f );
}

sub _datetime_from_filesystem_stamp {
	my ($self, $f) = @_;

	my $c_date = (stat($f))[10];
	return DateTime->from_epoch( epoch => $c_date, time_zone => 'local' );
}

1;

__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Media::DateTime - An highly extensible module to extract the creation
date and time from a file.

=head1 SYNOPSIS

  use DateTime;
  use Media::DateTime;
  my $dt = Media::DateTime->datetime( $file );
  
  # or more cleanly OO
  my $dater = Media::DateTime->new;
  my $dt = $dater->datetime( $file );

=head1 DESCRIPTION

Provides a very simple, but highly extensible method of extracting the
creation date and time from a media file (any file really). The base
module comes with support for JPEG files that store the creation date 
in the exif header. 

Plugins can be written to support any file format. See the 
C<Media::DateTime::JPEG> module for an example.

If no plugin is found for a particular file (or the plugin returns 
a false vale) the file creation date as specified by the O/S is used.

Returns a C<DateTime> object.

=head1 METHODs

=over 2

=item new

Constructor that returns a C<Media::DateTime> object. Methods can be
called on either the class or an instance.

	my $dt = Media::DateTime->new;

=item datetime

Takes a file as an arguement and returns a C<DateTime> object representing
its creation date. Falls back to the creation date specified by the 
filesystem if no plugin is available.

	my $dt = Media::DateTime->datetime( $file );
	# or
	my $dt = $dater->datetime( $file );

=back

=head1 SEE ALSO

See the excellent C<DateTime> module which simplifies the handling of dates.
See C<Module::Pluggable> and C<Module::Pluggable::Ordered> which are used
to implement the plugin system. C<Image::Info> is used to extract data from
JPEG files for the C<Media::DateTime::JPEG> plugin.

=head1 AUTHOR

Mark V. Grimes, E<lt>mgrimes@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by mgrimes

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
