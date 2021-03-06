package Personaje::Propiedad;
use strict; 
use JSON;
use fields qw(_valor _key _atributo _personaje _preasignado);
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub new {
    my $self = shift;
    my $key = shift;
    $self = fields::new($self);
    $self->key($key) if defined $key;
    $self->atributo(Service::Atributo->traer($key));
    return $self;
  }

  sub atributo {
    my $self = shift;
    my $atributo = shift;
    $self->{_atributo} = $atributo if defined $atributo;
    return $self->{_atributo};
  }

  sub personaje {
    my $self = shift;
    my $personaje = shift;
    $self->{_personaje} = $personaje if defined $personaje;
    return $self->{_personaje};
  }

  sub key {
    my $self = shift;
    my $key = shift;
    $self->{_key} = $key if defined $key;
    return $self->{_key};   
  }

  sub valor {
    my $self = shift;
    my $valor = shift;
    $self->{_valor} = $valor if defined $valor;
    return $self->{_valor};   
  }

  sub alguno {
    my $self = shift;
    return $self->atributo->alguno($self);
  }

  sub preasignado {
    my $self = shift;
    my $preasignado = shift;
    $self->{_preasignado} = $preasignado if defined $preasignado;
    return $self->{_preasignado};   

  }

  sub es_valido {
    my $self = shift;
    my $valor = shift;
    if($self->atributo->validos) {
      return 1 if scalar grep {$_ eq $valor} @{$self->atributo->validos};
      return 0;
    }
    return 1;
  }
1;