package Atributo::Altera;
use strict; 
use JSON;
use base 'Atributo';
use fields qw( _alteraciones);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub alteraciones {
    my $self = shift;
    return $self->{_alteraciones};
  }

1;