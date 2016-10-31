package Util;
use Data::Dumper;
use lib 'lib';
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(l azar);
use JSON;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');

sub l {
	my $param = shift;
	return 'UNDEF' if not defined $param;
	if(ref $param) {
		my $json = JSON->new->canonical(1)->allow_blessed(1);
		return $json->encode($param);
	}
	return $param;
}

sub azar {
	my $valor = shift;
	return int rand $valor + 1 if $valor =~ /^\d+$/;
	return $valor->[int rand scalar @$valor] if ref $valor eq 'ARRAY'; 
	return undef;
}
1;