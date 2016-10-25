package Util;
use Data::Dumper;
use lib 'lib';
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(l);
use JSON;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');

sub l {
	my $param = shift;
	return 'UNDEF' if not defined $param;
	if(ref $param) {
		my $json = JSON->new->canonical(1);
		return $json->encode($param);
	}
	return $param;
}
1;