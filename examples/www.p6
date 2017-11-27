use lib <lib>;
use WWW :extras;

say get 'https://httpbin.org/';
say jdelete 'https://httpbin.org/delete';
say jput    'https://httpbin.org/put';

say put 'https://httpbin.org/put?meow=moo', :72foo, :bar<♵>;
&CORE::put(put 'https://httpbin.org/put?meow=moo',
    %(Content-type => 'application/json'), :72foo, :bar<♵>);
