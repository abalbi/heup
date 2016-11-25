package Entorno;
use strict; 
use JSON;
use fields qw(_personajes _id);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub new {
    my $self = shift;
    my $args = shift;
    $self = fields::new($self);
    foreach my $key (keys %$args) {
      $self->{'_'.$key} = $args->{$key};
    }
    return $self;
  }

  sub id {
    my $self = shift;
    my $id = shift;
    $self->{_id} = $id if defined $id;
    if(not defined $self->{_id}) {
      my @chars = ('0'..'9', 'A'..'F');
      my $len = 8;
      my $id;
      while($len--){ $id .= $chars[rand @chars] };
      $self->{_id} = $id;
    }
    return $self->{_id};
  }

  sub personaje {
    my $self = shift;
    my $key = shift;
    $Data::Dumper::Maxdepth = 2;
    return [grep {$_->name eq $key} @{$self->personajes}]->[0];    
  }

  sub personajes {
    my $self = shift;
    $self->{_personajes} = [] if !$self->{_personajes};
    return $self->{_personajes};
  }

  sub agregar {
    my $self = shift;
    my $item = shift;
    if (defined $item) {
      push @{$self->personajes}, $item;
    }
    return $self;
  }

  sub detalle {
    my $self = shift;
    my $str = '';
    foreach my $personaje (sort {$a->name cmp $b->name} @{$self->personajes}) {
      $str .= sprintf("%-10s\n", $personaje->name);
    }
    return $str;
  }
1;