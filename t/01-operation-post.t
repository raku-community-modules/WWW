#!raku

use lib 'lib';
use Test;
use Test::When <online>;
use WWW;
use URI;

plan 4;

for <http  https> -> $prot {

    subtest 'post' => {
        plan 5;
        subtest "post fetched good content over $prot.uc()" => {
            with post($prot ~ '://eu.httpbin.org/post', :72foo, :bar<♵>) {
                plan 3;
                like $_, rx/'://eu.httpbin.org/post'/, '(1)';
                like $_, rx/foo/, '(2)';
                like $_, rx/bar/, '(3)';
            }
        }

	my $url =  $prot ~ '://eu.httpbin.org/post?foo=42&bar=x';
        my $res = jpost $prot ~ '://eu.httpbin.org/post?foo=42&bar=x',
            :72foo, :bar<♵>, %( :Foo<Bar> );
        is-deeply $res<form><foo bar>,
            ('72', '♵'), "jpost() can decode response over $prot.uc() [form]";
        is-deeply $res<args><foo bar>,
            ('42', 'x'), "jpost() can decode response over $prot.uc() [args]";
        is-deeply $res<headers><Foo>,
            'Bar', "jpost() can decode response over $prot.uc() [headers]";

        throws-like { post $prot ~ '://eu.httpbin.org/status/404' }, Exception,
            :message(/404/), "can detect a POST 404 over $prot.uc()";
    }

    subtest 'jpost body' => {
        plan 2;
        my $res = jpost "http://eu.httpbin.org/post",
            '{"a": 42, "foo": "meows"}',
            :Authorization<Zofmeister>;
        is-deeply $res.<json><foo>, 'meows', 'sent JSON in body matches';
        is-deeply $res.<headers><Authorization>, 'Zofmeister', 'headers got sent';
    }
}
