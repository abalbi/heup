package Service::Atributo;
use strict;
use fields qw(_atributos);
use Data::Dumper;

our $instancia;

sub new {
	my $self = shift;
	my $args = shift;
	$self = fields::new($self);
	return $self;
}

sub instancia {
	my $class = shift;
	$instancia = __PACKAGE__->new if !$instancia;
	return $instancia;
}

sub atributos {
	return [qw(name)];
}

sub asignar_a {
	my $class = shift;
	my $self = __PACKAGE__->instancia;
	my $personaje = shift;
	my $key = shift;
	my $valor = shift;
	my $atributo = $self->traer($key);
	my $propiedad = $personaje->propiedad($key);
	$valor = $propiedad->alguno($valor);
	$propiedad->valor($valor);
	$personaje->prop($propiedad);
}

sub traer {
	my $class = shift;
	my $self = __PACKAGE__->instancia;
	my $key = shift;
	if(!$self->{_atributos}->{$key}) {
		if($key eq 'name') {
		  $self->{_atributos}->{$key} = Atributo->new({
		  	nombre => $key,
		  	es_requerido => 1,
		  	posibles => sub {
					my $self = shift;
					my $propiedad = shift;
					my $nombres = [];
					push @$nombres, qw(Lucia Maria Martina Paula Daniela Sofia Valeria Carla Sara Alba Julia Noa Emma Claudia Carmen Marta Valentina Irene Adriana Ana Laura Elena Alejandra Ines Marina Vera Candela Laia Ariadna Lola Andrea Rocio Angela Vega Nora Jimena Blanca Alicia Clara Olivia Celia Alma Eva Elsa Leyre Natalia Victoria Isabel Cristina Lara Abril Triana Nuria Aroa Carolina Manuela Chloe Mia Mar Gabriela Mara Africa Iria Naia Helena Paola Noelia Nahia Miriam Salma);
		      push @$nombres, qw(Hugo Daniel Pablo Alejandro Alvaro Adrian David Martin Mario Diego Javier Manuel Lucas Nicolas Marcos Leo Sergio Mateo Izan Alex Iker Marc Jorge Carlos Miguel Antonio Angel Gonzalo Juan Ivan Eric Ruben Samuel Hector Victor Enzo Jose Gabriel Bruno Dario Raul Adam Guillermo Francisco Aaron Jesus Oliver Joel Aitor Pedro Rodrigo Erik Marco Alberto Pau Jaime Asier Luis Rafael Mohamed Dylan Marti Ian Pol Ismael Oscar Andres Alonso Biel Rayan Jan Fernando Thiago Arnau Cristian Gael Ignacio Joan);
					return $nombres;	
		  	}
		  });
		}
	}
	return $self->{_atributos}->{$key};
}


1;