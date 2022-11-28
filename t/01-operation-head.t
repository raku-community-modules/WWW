#!raku

use lib 'lib';
use Test;
use Test::When <online>;
use WWW :extras;


for <http  https> -> $prot {
    subtest 'head' => {
        my $url = $prot ~ '://eu.httpbin.org';
        subtest "head fetched good content over $prot.uc()" => {
            with head( "$url/html" ) {
                say $_;
                like @_[0][0], rx/'text/html'/, 'Content is correct';
                like @_[4][0], rx/'gunicorn'/, 'Server is correct';
            }
        }
    }

}

done-testing;
