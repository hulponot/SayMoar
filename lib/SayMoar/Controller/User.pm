package SayMoar::Controller::User;

use strict;
use warnings;
use Kelp::Base 'SayMoar::Controller';

sub profile {
    my $self = shift;
    return $self->template('profile', { name => $self->param('name')});
}

1;
