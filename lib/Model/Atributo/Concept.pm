package Atributo::Concept;
use strict; 
use JSON;
use base 'Atributo';
use fields qw( _alteraciones _herencias);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub alteraciones {
    my $self = shift;
    return $self->{_alteraciones};
  }

  sub herencia {
    my $self = shift;
    return $self->{_herencias};
  }


1;