package Util;
use Data::Dumper;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(azar);
  sub azar {
  	my $param = shift;
  	return undef if not defined $param;
  	if (ref $param eq '') {
  		return int rand $param;
  	}
    if (ref $param) {
      if (ref $param eq 'ARRAY') {
        return $param->[int rand scalar @$param];
      }
    }
  }
1;
