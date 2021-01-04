#!raku

use lib 'lib';
use Test;
use Test::When <online>;
use WWW;

plan 4;

for &get, &jget, &post, &jpost -> &s {
    CATCH {
        ok $_, "Fails OK";
    }
    my $res := s 'party';
    isa-ok $res, Failure,
        'failure to resolve host does not throw, but fails';
}
