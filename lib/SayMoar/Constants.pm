package SayMoar::Constants;

use strict;
use warnings;
use Const::Fast;
use Exporter 'import';

const our $NO_USER_ERROR => 1;
const our $NO_USER_MSG => 'No user supplied';

const our $USER_EXISTS_ERROR => 2;
const our $USER_EXISTS_MSG => 'User with same name already exists';

const our $PASSWORD_TOO_WEEK_ERROR => 3;
const our $PASSWORD_TOO_WEEK_MSG => 'Password too week, use imagination to create big one';

const our $NO_USER_EXISTS_ERROR => 4;
const our $NO_USER_EXISTS_MSG => 'There is no user with such name';

const our $WRONG_PASS_ERROR => 5;
const our $WRONG_PASS_MSG => 'Wrong password';

our @EXPORT = qw/ $NO_USER_ERROR $NO_USER_MSG $USER_EXISTS_ERROR $USER_EXISTS_MSG $PASSWORD_TOO_WEEK_ERROR $PASSWORD_TOO_WEEK_MSG 
                  $NO_USER_EXISTS_ERROR $NO_USER_EXISTS_MSG $WRONG_PASS_ERROR $WRONG_PASS_MSG /
