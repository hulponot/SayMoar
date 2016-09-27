package Kelp::Module::DBD::SQLite;

use warnings;
use strict;
use DBI;

use Kelp::Base 'Kelp::Module';

sub build {
    my $self = shift;
   
    my $dbh = DBI->connect("dbi:SQLite:dbname=saymoar.db","","", 
        { 
            RaiseError => 1, 
            #sqlite_unicode => 1
        });
    $dbh->do("CREATE TABLE IF NOT EXISTS users(
                id INTEGER PRIMARY KEY,
                name TEXT,
                pass TEXT,
                token TEXT
            )");
    $dbh->do("CREATE TABLE IF NOT EXISTS posts(
                id INTEGER PRIMARY KEY,
                epoch INTEGER,
                title TEXT,
                text TEXT,
                owner INTEGER,
                FOREIGN KEY(owner) REFERENCES users(id)
            )");
    $self->register(main_db => $dbh);
}

return 1;
