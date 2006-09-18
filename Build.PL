use Module::Build;
my $build = Module::Build->new(
	module_name				=> 'Media::DateTime',
	license					=> 'perl',
	create_readme			=>  1,
	requires				=> {
			'perl'				=> '5.008',
			'Carp'				=> 0,
			'Hash::Util'		=> 0.05,
			'Module::Pluggable'	=> 0,
			'Image::ExifTool'	=> 0,
			'DateTime'			=> 0,
		},
	recommends				=> {
		},
);

# $build->add_build_element('gif');
$build->create_build_script;


