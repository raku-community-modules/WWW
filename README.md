[![Build Status](https://travis-ci.org/zoffixznet/perl6-WWW.svg)](https://travis-ci.org/zoffixznet/perl6-WWW)

# NAME

WWW - No-nonsense, simple HTTPS client with JSON decoder

# SYNOPSIS

```perl6
    use WWW;

    # Just GET content (will return Failure on failure):
    say get 'https://httpbin.org/get?foo=42&bar=x', :SomeHeader<Value>;

    # GET and decode received data as JSON:
    say jget('https://httpbin.org/get?foo=42&bar=x')<args><foo>;

    # POST content (query args are OK; pass form as named args)
    say post 'https://httpbin.org/post?foo=42&bar=x', :some<form>, :42args;

    # And if you need headers, pass them inside a positional Hash:
    say post 'https://httpbin.org/post?foo=42&bar=x', %(:Some<Custom-Header>),
        :some<form>, :42args;

    # Same POST as above + decode response as JSON
    say jpost('https://httpbin.org/post', :some<form-arg>)<form><some>;

    # Also can post() or jpost() POST body directly as Str:D; headers passed as named args:
    say jpost(
        "http://httpbin.org/post",
        to-json({:42a, :foo<meows>}),
        :Authorization<Zofmeister>
    ).<json><foo>;
```

More HTTP methods:

```perl6
    use WWW :extras;

    say jdelete 'https://httpbin.org/delete';
    say jput    'https://httpbin.org/put';
```

# DESCRIPTION

Exports a handful of routines to fetch data from online resources and optionally
decode the responses as JSON.

The module will use `User-Agent` header set to `Rakudo WWW`, unless you specify
that header.

# INSTALLATION

On some operating systems you'll need `libssl` installed:

```bash
sudo apt-get install libssl-dev
```

Then just install the module with the module manager:

```bash
zef install WWW
```

# TESTING

To run the full test suite, set `ONLINE_TESTING` environmental variable to `1`

```bash
ONLINE_TESTING=1 zef install WWW
```

# EXPORTED ROUTINES

## `:DEFAULT` export tag

These routines get exported by default:

### `get`

```perl6
    sub get($url where URI:D|Str:D, *%headers --> Str:D);

    say get 'https://httpbin.org/get?foo=42&bar=x';
```

Takes either a `Str` or a [URI](https://modules.perl6.org/dist/URI).
Returns `Failure` if request fails or does not return a successful HTTP code.
Returns `Str` with the data on success. Takes headers as named arguments.

### `jget`

```perl6
    say jget 'https://httpbin.org/get?foo=42&bar=x';
```

Same as `get()` except will also decode the response as JSON and return
resultant data structure.

### `post`

```perl6
    multi post($url where URI:D|Str:D, *%form --> Str:D);
    multi post($url where URI:D|Str:D, %headers, *%form --> Str:D);
    multi post($url where URI:D|Str:D, Str:D $form-body, *%headers --> Str:D);

    say post 'https://httpbin.org/post?meow=moo', :72foo, :bar<♵>;
    say post 'https://httpbin.org/post?meow=moo',
        %(Content-type => 'application/json'), :72foo, :bar<♵>;
```

Takes either a `Str` or a [URI](https://modules.perl6.org/dist/URI), followed
by an optional `Hash` with HTTP headers to send. Form POST parameters can be
included as named arguments. It's fine to also include query arguments in the
URL itself. Returns `Failure` if request fails or does not return a successful
HTTP code. Returns `Str` with the data on success.

To send POST body directly, pass it as Str:D positional arg. In this calling
form, the headers are sent as named args.

### `jpost`

```perl6
    multi jpost($url where URI:D|Str:D, *%form);
    multi jpost($url where URI:D|Str:D, %headers, *%form);
    multi jpost($url where URI:D|Str:D, Str:D $form-body, *%headers);

    say jpost 'https://httpbin.org/post?meow=moo', :72foo, :bar<♵>;
    say jpost 'https://httpbin.org/post?meow=moo',
        %(Content-type => 'application/json'), :72foo, :bar<♵>;
```

Same as `post()` except will also decode the response as JSON and return
resultant data structure.

## `:extras` Export Tag

These routines get exported *in addition to* the `:DEFAULT` exports, when
`:extras` export tag is requested:

```perl6
use WWW :extras;
```

### `put`

```perl6
    multi put($url where URI:D|Str:D, *%form --> Str:D);
    multi put($url where URI:D|Str:D, %headers, *%form --> Str:D);
    multi put($url where URI:D|Str:D, Str:D $form-body, *%headers --> Str:D);

    say put 'https://httpbin.org/put?meow=moo', :72foo, :bar<♵>;
    say put 'https://httpbin.org/put?meow=moo',
        %(Content-type => 'application/json'), :72foo, :bar<♵>;
```

Takes either a `Str` or a [URI](https://modules.perl6.org/dist/URI), followed
by an optional `Hash` with HTTP headers to send. Form PUT parameters can be
included as named arguments. It's fine to also include query arguments in the
URL itself. Returns `Failure` if request fails or does not return a successful
HTTP code. Returns `Str` with the data on success.

To send PUT body directly, pass it as Str:D positional arg. In this calling
form, the headers are sent as named args.

### `jput`

```perl6
    multi jput($url where URI:D|Str:D, *%form --> Str:D);
    multi jput($url where URI:D|Str:D, %headers, *%form --> Str:D);
    multi jput($url where URI:D|Str:D, Str:D $form-body, *%headers --> Str:D);

    say jput 'https://httpbin.org/put?meow=moo', :72foo, :bar<♵>;
    say jput 'https://httpbin.org/put?meow=moo',
        %(Content-type => 'application/json'), :72foo, :bar<♵>;
```

Same as `put()` except will also decode the response as JSON and return
resultant data structure.

### `delete`

```perl6
    sub delete($url where URI:D|Str:D, *%headers --> Str:D);

    say delete 'https://httpbin.org/get?foo=42&bar=x';
```

Performs HTTP `DELETE` request.
Takes either a `Str` or a [URI](https://modules.perl6.org/dist/URI).
Returns `Failure` if request fails or does not return a successful HTTP code.
Returns `Str` with the data on success; if response for a `204 No Content`,
returns an empty string. Takes headers as named arguments.

### `jdelete`

```perl6
    say jdelete 'https://httpbin.org/get?foo=42&bar=x';
```

Same as `delete()` except will also decode the response as JSON and return
resultant data structure.

You probably want to use `delete()` instead, as `DELETE` requests can get
return no content, causing JSON parse failures.

# LIMITATIONS

Due to nuances of upstream code, currently any non-RFC-conformant URL will
be rejected; you have to ensure it's proper manually. Patches welcome.

# SEE ALSO

- [`LWP::Simple`](https://modules.perl6.org/repo/LWP::Simple)
- [`HTTP::UserAgent`](https://modules.perl6.org/repo/HTTP::UserAgent)

----

#### REPOSITORY

Fork this module on GitHub:
https://github.com/zoffixznet/perl6-WWW

#### BUGS

To report bugs or request features, please use
https://github.com/zoffixznet/perl6-WWW/issues

#### AUTHOR

Zoffix Znet (http://perl6.party/)

#### LICENSE

You can use and distribute this module under the terms of the
The Artistic License 2.0. See the `LICENSE` file included in this
distribution for complete details.

The `META6.json` file of this distribution may be distributed and modified
without restrictions or attribution.
