#!perl6

use lib 'lib';
use Test;
use Test::When <online>;
use WWW;

plan 4;

for <http  https> -> $prot {
    subtest 'get' => {
        plan 3;
        subtest "get fetched good content over $prot.uc()" => {
            with get($prot ~ '://httpbin.org/get?foo=42&bar=x') {
                plan 3;
                like $_, rx/'://httpbin.org/get'/, '(1)';
                like $_, rx/foo/, '(2)';
                like $_, rx/bar/, '(3)';
            }
        }

        is-deeply
            jget($prot ~ '://httpbin.org/get?foo=72&bar=x')<args><foo bar>,
            ('72', 'x'), "jget() can decode response over $prot.uc()";

        throws-like { get $prot ~ '://httpbin.org/status/404' }, Exception,
            :message(/404/), "can detect a 404 over $prot.uc()";
    }

    subtest 'post' => {
        plan 5;
        subtest "post fetched good content over $prot.uc()" => {
            with post($prot ~ '://httpbin.org/post', :72foo, :bar<♵>) {
                plan 3;
                like $_, rx/'://httpbin.org/post'/, '(1)';
                like $_, rx/foo/, '(2)';
                like $_, rx/bar/, '(3)';
            }
        }

        my $res = jpost $prot ~ '://httpbin.org/post?foo=42&bar=x',
            :72foo, :bar<♵>, %( :Foo<Bar> );

        is-deeply $res<form><foo bar>,
            ('72', '♵'), "jpost() can decode response over $prot.uc() [form]";
        is-deeply $res<args><foo bar>,
            ('42', 'x'), "jpost() can decode response over $prot.uc() [args]";
        is-deeply $res<headers><Foo>,
            'Bar', "jpost() can decode response over $prot.uc() [headers]";

        throws-like { post $prot ~ '://httpbin.org/status/404' }, Exception,
            :message(/404/), "can detect a POST 404 over $prot.uc()";
    }
}
