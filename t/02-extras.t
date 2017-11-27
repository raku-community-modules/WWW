#!perl6

use lib 'lib';
use Test;
use Test::When <online>;
use WWW :extras;

plan 8;

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

    subtest 'put' => {
        plan 5;
        subtest "put fetched good content over $prot.uc()" => {
            with put($prot ~ '://httpbin.org/put', :72foo, :bar<♵>) {
                plan 3;
                like $_, rx/'://httpbin.org/put'/, '(1)';
                like $_, rx/foo/, '(2)';
                like $_, rx/bar/, '(3)';
            }
        }

        my $res = jput $prot ~ '://httpbin.org/put?foo=42&bar=x',
            :72foo, :bar<♵>, %( :Foo<Bar> );

        is-deeply $res<form><foo bar>,
            ('72', '♵'), "jput() can decode response over $prot.uc() [form]";
        is-deeply $res<args><foo bar>,
            ('42', 'x'), "jput() can decode response over $prot.uc() [args]";
        is-deeply $res<headers><Foo>,
            'Bar', "jput() can decode response over $prot.uc() [headers]";

        throws-like { put $prot ~ '://httpbin.org/status/404' }, Exception,
            :message(/404/), "can detect a PUT 404 over $prot.uc()";
    }

    subtest 'jput body' => {
        plan 2;
        my $res = jput "http://httpbin.org/put",
            '{"a": 42, "foo": "meows"}',
            :Authorization<Zofmeister>;
        is-deeply $res.<json><foo>, 'meows', 'sent JSON in body matches';
        is-deeply $res.<headers><Authorization>, 'Zofmeister', 'headers got sent';
    }

    subtest 'delete' => {
        plan 3;
        subtest "delete fetched good content over $prot.uc()" => {
            with get($prot ~ '://httpbin.org/delete?foo=42&bar=x') {
                plan 3;
                like $_, rx/'://httpbin.org/delete'/, '(1)';
                like $_, rx/foo/, '(2)';
                like $_, rx/bar/, '(3)';
            }
        }

        is-deeply
            jdelete(
                $prot ~ '://httpbin.org/delete?foo=72&bar=x'
            )<args><foo bar>,
            ('72', 'x'), "jdelete() can decode response over $prot.uc()";

        throws-like { get $prot ~ '://httpbin.org/status/404' }, Exception,
            :message(/404/), "can detect a 404 over $prot.uc()";
    }
}
