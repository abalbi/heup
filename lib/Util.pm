package Util;
use Data::Dumper;
use lib 'lib';
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(l);

our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');

sub l {
	my $param = shift;
	return 'UNDEF' if not defined $param;
	return $param;
}
1;