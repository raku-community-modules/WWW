#!perl6

use lib 'lib';
use Test;
use Test::When <online>;
use WWW;

plan 2;

for <http  https> -> $prot {
    subtest 'get' => {
        plan 3;
        subtest "get fetched good content over $prot.uc()" => {
            with get($prot ~ '://eu.httpbin.org/get?foo=42&bar=x') {
                plan 3;
                like $_, rx/'://eu.httpbin.org/get'/, '(1)';
                like $_, rx/foo/, '(2)';
                like $_, rx/bar/, '(3)';
            }
        }

        is-deeply
            jget($prot ~ '://eu.httpbin.org/get?foo=72&bar=x')<args><foo bar>,
            ('72', 'x'), "jget() can decode response over $prot.uc()";

        throws-like { get $prot ~ '://eu.httpbin.org/status/404' }, Exception,
            :message(/404/), "can detect a 404 over $prot.uc()";
    }

}


