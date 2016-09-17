package SayMoar;
use Kelp::Base 'Kelp';
use Mouse;
use SayMoar::Controller::Feed;
use SayMoar::Controller::Wall;
use SayMoar::Controller;
use SayMoar::Controller::User;
use Kelp::Module::BerkeleyDB;

sub build {
    my $self = shift;
    $self->load_module('BerkeleyDB');
    my $r    = $self->routes;

    $r->add( '/', 'home');
    $r->add( '/profile', 'user#auth' );
    $r->add( '/profile/:name', 'user#profile' );
    $r->add( '/wall/:user', 'wall#show');
    $r->add( '/config', sub { $_[0]->config_hash } );
}

sub home {
    my $self = shift;
    $self->session->{name} = "plack is nice";
    $self->template('home');
}

1;
