package Util;
use Data::Dumper;
use lib 'lib';
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(l azar t es_traducible);
use JSON;
use YAML qw(LoadFile);

our $trans = {};
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
	return $valor->[int rand scalar @$valor] if ref $valor eq 'ARRAY'; 
	return int rand $valor + 1 if $valor =~ /^\d+$/;
	return undef;
}

sub t {
  my $string = shift;
  my $temp = $string;
  my $i = [];
  my $t = [];
  my $stash = '';
  foreach my $l (split '', $string) {
    if($l =~ /\w/) {
      $stash .= $l;
    } else {
      $stash = traducciones($stash) if es_traducible($stash);
      push @$i, $stash;
      $stash = '';
      push @$i, $l;
    }
  }
  return join '', @$i;  
}

sub traducciones {
  my $w = shift;
  $trans = LoadFile('etc/trans.yaml') if not scalar keys %$trans;
  return $trans->{$w};
}

sub es_traducible {
  my $w = shift;
  $trans = LoadFile('etc/trans.yaml') if not scalar keys %$trans;
  return 1 if exists $trans->{$w};
  return 0;
}
1;