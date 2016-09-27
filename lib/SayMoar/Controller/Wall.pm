package SayMoar::Controller::Wall;

use strict;
use warnings;
use BerkeleyDB qw/ DB_NEXT_DUP DB_NEXT /;
use Kelp::Base 'SayMoar::Controller';


sub show {
    my $self = shift;
    my $name = $self->named->{name};

    $self->template('wall', {one => 1, name => $name,});
}

sub resolve_user {
    my $self = shift;
    $self->res->redirect_to("/wall/" . ($self->param('name') || $self->session->{user} || 'default'));
}
1;
