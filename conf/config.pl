# Common settings
{
    modules      => [qw/Template JSON Logger/],
    middleware      => [qw/Static Session/],
    modules_init => {

        # One log for errors and one for debug
        Logger => {
            outputs => [
                [
                    'File',
                    name      => 'debug',
                    filename  => 'log/debug.log',
                    min_level => 'debug',
                    mode      => '>>',
                    newline   => 1,
                    binmode   => ":encoding(UTF-8)"
                ], [
                    'File',
                    name      => 'error',
                    filename  => 'log/error.log',
                    min_level => 'error',
                    mode      => '>>',
                    newline   => 1,
                    binmode   => ":encoding(UTF-8)"
                ],
            ]
        },

        # JSON prints pretty
        JSON => {
            pretty => 1
        },

        # Enable UTF-8 in Template
        Template => {
            encoding => 'utf8'
        },

        Routes => {
            base => 'SayMoar::Controller',
            router => 'Controller'
        }
    },
    middleware_init => {
        Static => {
            path => qr{^/public/},
            root => '.',
        },
        Session => {
            store => 'File'
        }
    },
};
