#!raku

use lib 'lib';
use Test;
use Test::When <online>;
use WWW :extras;


for <http  https> -> $prot {
    subtest 'head' => {
        subtest "head fetched good content over $prot.uc()" => {
            with head($prot ~ '://eu.httpbin.org/html') {
                like @_[0][0], rx/'text/html'/, 'Content is correct';
                like @_[4][0], rx/'gunicorn'/, 'Server is correct';
            }
        }

    }

}

done-testing;
