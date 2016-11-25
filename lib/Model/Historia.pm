package Historia;
use strict; 
use JSON;
use fields qw(_roles _pasos _tipo _entorno);
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

  sub roles {
    my $self = shift;
    $self->{_roles} = {} if !$self->{_roles};
    return $self->{_roles};
  }

  sub pasos {
    my $self = shift;
    $self->{_pasos} = [] if !$self->{_pasos};
    return $self->{_pasos};
  }

  sub tipo {
    my $self = shift;
    my $tipo = shift;
    $self->{_tipo} = $tipo if defined $tipo;
    return $self->{_tipo};
  }

  sub entorno {
    my $self = shift;
    my $entorno = shift;
    $self->{_entorno} = $entorno if defined $entorno;
    return $self->{_entorno};
  }

  sub detalle_personajes {
    my $self = shift;
    return join("\n", map {$self->roles->{$_}->detalle} sort keys %{$self->roles})."\n";
  }
  
  sub detalle {
    my $self = shift;
    my $rtn = '';
    my $roles = {};
    map {$roles->{$_} = $self->roles->{$_}->name} sort keys %{$self->roles};
    foreach my $paso (@{$self->pasos}) {
      my $temp = $paso;
      foreach my $rol (sort keys %$roles) {
        my $name = $roles->{$rol};
        $temp =~ s/\<$rol\>/$name/g;
      }
      $rtn .= $temp."\n";
    }
    return $rtn;    
  }
1;