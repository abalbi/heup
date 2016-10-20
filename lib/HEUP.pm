package HEUP;
use Data::Dumper;
use lib 'lib';

our $app_path = $ENV{PWD};
our $bin_path = $app_path.'/bin';
our $heup_path = $bin_path.'/heup';

chmod 0755, $heup_path if ! -X $heup_path;

sub ejecutar {
	return ':';
}

1;