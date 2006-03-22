package Media::DateTime::JPEG;

use strict;
use warnings;

use Carp;
use Image::Info qw(image_info);
use DateTime;

our $VERSION = '0.20';

sub datetime {
	my ($self, $f) = @_;

	my $info = image_info($f);
	croak "Can't parse image ($f) info: " . $info->{error}
			if $info->{error};

	do {
		carp "JPEG does not contain DateTimeOriginal exif entry ($f),\nfallback to file timestamp.\n";
		return undef;
	} unless exists $info->{DateTimeOriginal};


	# DateTime format = yyyy:mm:dd hh:mm:ss
	my ($y,$m,$d,$h,$min,$s) = $info->{DateTime} =~ m/
						(\d{4})  :	# year
						(\d{2})  :  # month
						(\d{2})     # day
							\s		# space
						(\d{2})  :  # hour 
						(\d{2})  :  # min
						(\d{2})     # sec
					/x
		or croak "failed DateTime pattern match in $f\n";

	my $date = DateTime->new(	year	=> $y,
								month	=> $m,
								day		=> $d,
		   						hour	=> $h,
								minute	=> $min,
								second	=> $s,
					) or croak "couldnt create DateTime";
}

sub match { 
	my ($self,$f) = @_;

	return $f =~ /\.jpe?g$/i;
	# TODO: should we use something more complicated here? maybe mime type?
}   

1;

__END__

=head1 NAME

Media::DateTime::JPEG - A plugin for the C<Media::DateTime> module to support
JPEG files.

=head1 SYNOPSIS

C<Media::DateTime::JPEG> shouldn't be used directly. See C<Media::DateTime>.

=head1 METHODs

=over 2

=item match

Takes a filename as an arguement. Used by the plugin system to determine if
this plugin should be utilized for the file. Returns true if the filename
ends in .jpeg or .jpg. 

=item datetime

Takes a filename as an arguement and returns the creation date or a false
value if we are unable to parse it.

=back

=head1 SEE ALSO

See C<Media::DateTime> for usage. C<Image::Info> is used to extract data from
JPEG files.

=head1 AUTHOR

Mark V. Grimes, E<lt>mgrimes@cpan.org<gt>

=head1 FUTURE PLANS

May use a more flexible approach to assertaining if a file is a jpeg and 
might check that exif data exists in the C<match> method.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by mgrimes

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
