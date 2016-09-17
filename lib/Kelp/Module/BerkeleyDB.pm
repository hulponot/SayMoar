package Kelp::Module::BerkeleyDB;

use warnings;
use strict;
use BerkeleyDB;

use Kelp::Base 'Kelp::Module';

sub build {
    my $self = shift;
    my $user_db = new BerkeleyDB::Hash
        or dir ("berkley bad");

    my $wall_db = new BerkeleyDB::Hash
        -Property => DB_DUP
        or dir ("berkley bad");
    $self->register(user_db => sub {return $user_db} );
    $self->register(wall_db => sub {return $wall_db} );
}
1;
