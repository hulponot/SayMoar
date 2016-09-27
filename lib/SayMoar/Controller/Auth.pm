package SayMoar::Controller::Auth;

use strict;
use warnings;
use Kelp::Base 'SayMoar::Controller';

use DBI qw/ :sql_types /;
use SayMoar::Constants;
use Data::Dumper;
use utf8;
use Encode qw/ encode decode /;
use Digest::SHA3 qw/ sha3_256_hex /;
use Crypt::Random qw( makerandom_octet ); 


sub auth {
    my $self = shift;
    my ($id,$token) = ($self->session->{user_id}, $self->session->{token});

    if (defined $id and defined $token){
        my $row = $self->main_db->selectrow_hashref("SELECT token FROM users WHERE id = ?",{},($id));
        if ($row->{token} eq $token) {
            return 1;
        }
    } 
    $self->res->redirect_to('/login',{},303);
    return 0;
}

sub login {
    my $self = shift;
    my ($war_id,$war_msg) = ($self->param('warning'), '');
    $war_msg = $NO_USER_MSG if $war_id == $NO_USER_ERROR;
    $war_msg = $USER_EXISTS_MSG if $war_id == $USER_EXISTS_ERROR;
    $war_msg = $PASSWORD_TOO_WEEK_MSG if $war_id == $PASSWORD_TOO_WEEK_ERROR;
    $war_msg = $NO_USER_EXISTS_MSG if $war_id == $NO_USER_EXISTS_ERROR;
    $war_msg = $WRONG_PASS_MSG if $war_id == $WRONG_PASS_ERROR;

    my $hash = $self->main_db->selectall_hashref("SELECT * FROM users", 'id');
    my $users;
    foreach (keys %$hash){
        push @$users, decode("UTF-8",$hash->{$_}->{name});
    }
    $self->template('login', { warning =>  $war_msg, users => $users});
}

sub check {
    my $self = shift;
    my ($user,$pass) = (decode("UTF-8",$self->param('user')), decode("UTF-8",$self->param('pass')) );
    $pass = __pass_handler($pass);

    if (not $user){
        $self->res->redirect_to('/login?warning='.$NO_USER_ERROR,{}, 303);#no user suplied
    } else {
        if ( my $row = $self->main_db->selectrow_hashref("SELECT * FROM users WHERE name = ?",{},$user) ){
            $self->res->redirect_to('/login?warning='.$WRONG_PASS_ERROR,{},303) unless $pass eq $row->{pass};

            my $token = __token_gen();
            $self->session->{token} = $token;
            $self->session->{user_id} = $row->{id};
            $self->session->{name} = $user;

            $self->main_db->do("UPDATE users SET token = ? WHERE id = ?",{}, $token, $row->{id});
            $self->res->redirect_to('/profile/'. $self->param('user'), {},303);
        } else {
            $self->res->redirect_to('/login?warning='.$NO_USER_EXISTS_ERROR,{},303);
        }
    }
}

sub registration {
    my $self = shift;
    my ($user,$pass) = (encode("UTF-8",decode("UTF-8",$self->param('user'))), decode("UTF-8",$self->param('pass')) );
    if (not $user){
        $self->res->redirect_to('/login?warning='.$NO_USER_ERROR,{}, 303);#no user suplied
    } else {
        my $sth = $self->main_db->prepare("SELECT * FROM users WHERE name = ?");
        $sth->bind_param(1, $user, SQL_VARCHAR);
        $sth->execute();
        my $row = $sth->fetchrow_arrayref();
        if (defined $row and @$row){
            $self->res->redirect_to('/login?warning='.$USER_EXISTS_ERROR, {}, 303);#user already exists
        } else {
            if (not $pass or length $pass < 8){
                $self->res->redirect_to('/login?warning='.$PASSWORD_TOO_WEEK_ERROR,{}, 303);#pass too week
            } else {
                $pass = __pass_handler($pass);
                my $token = __token_gen();
                my $sth_insert = $self->main_db->prepare("INSERT INTO users (name,pass,token)VALUES (?,?,?)");
                $sth_insert->bind_param(1, $user, SQL_VARCHAR);
                $sth_insert->bind_param(2, $pass, SQL_VARCHAR);
                $sth_insert->bind_param(3, $token, SQL_VARCHAR);
                $sth_insert->execute();


                my $row = $self->main_db->selectrow_hashref("SELECT id FROM users WHERE name = ?",{},($user));
                $self->session->{user_id} = $row->{id};
                $self->session->{token} = $token;
                $self->session->{name} = $user;
                $self->res->redirect_to('success?id=1' ,{}, 303);
            }
        }
        
    }
}

sub __pass_handler {
    my $pass = shift;
    return sha3_256_hex($pass);
}

sub __token_gen {
    return makerandom_octet(Size => 512, Strength => 1);
}
1;
