package SayMoar;
use Kelp::Base 'Kelp';
use Mouse;
use SayMoar::Controller::Feed;
use SayMoar::Controller::Wall;
use SayMoar::Controller;
use SayMoar::Controller::User;

use Encode qw/ encode decode /;

sub build {
    my $self = shift;
    $self->load_module('DBD::SQLite');
    my $r    = $self->routes;

    $r->add( '/', 'home' );
    $r->add( '/profile', { to => 'auth#auth', bridge => 1 });
    $r->add( '/profile/:name', { method => 'GET', to => 'user#profile'} );
    $r->add( '/profile/:name', { method => 'POST', to => 'user#post'} );

    $r->add( '/post', 'wall#post');

    $r->add( '/text/:id', { method => 'GET', to => 'user#text'});
    $r->add( '/text/:id', { method => 'POST', to => 'user#comment'});

    $r->add( '/wall', 'wall#resolve_user');
    $r->add( '/wall/:user', 'wall#show');

    $r->add( '/config', sub { $_[0]->config_hash } );
    $r->add( '/login', {method => 'GET', to => 'auth#login'});
    $r->add( '/login', {method => 'POST', to => 'auth#check'} );
    $r->add( '/reg', {method => 'POST', to => 'auth#registration'} );
    $r->add( '/logout', {method => 'GET', to => 'auth#logout'} );
    
    $r->add( '/success', 'success' );
}

sub home {
    my $self = shift;
    $self->template('home');
}

sub success {
    my $self = shift;
    my $name = decode("UTF-8",$self->session->{name});
    $self->template('success', { message => $self->param('id') || 'something successed', name => $name});
}

1;
