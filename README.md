[![Build Status](https://travis-ci.org/zoffixznet/perl6-WWW.svg)](https://travis-ci.org/zoffixznet/perl6-WWW)

# NAME

WWW - No-nonsense, simple HTTPS client with JSON decoder

# SYNOPSIS

```perl6
    use WWW;

    # Just GET content (will return Failure on failure):
    say get 'https://httpbin.org/get?foo=42&bar=x';

    # GET and decode received data as JSON:
    say jget('https://httpbin.org/get?foo=42&bar=x')<args><foo>;

    # POST content (query args are OK; pass form as named args)
    say post 'https://httpbin.org/post?foo=42&bar=x', :some<form>, :42args;

    # And if you need headers, pass them inside a positional Hash:
    say post 'https://httpbin.org/post?foo=42&bar=x', %(:Some<Custom-Header>),
        :some<form>, :42args;

    # Same POST as above + decode response as JSON
    say jpost('https://httpbin.org/post', :some<form>)<args><some>;
```

# DESCRIPTION

Exports a handful of routines to fetch data from online resources and optionally
decode the responses as JSON.

# TESTING

To run the full test suite, set `ONLINE_TESTING` environmental variable to `1`

# EXPORTED ROUTINES

## `get`

```perl6
    sub get($url where URI:D|Str:D --> Str:D);

    say get 'https://httpbin.org/get?foo=42&bar=x';
```

Takes either a `Str` or a [URI](https://modules.perl6.org/dist/URI).
Returns `Failure` if request fails or does not return a successful HTTP code.
Returns `Str` with the data on success.

## `jget`

```perl6
    say jget 'https://httpbin.org/get?foo=42&bar=x';
```

Same as `get()` except will also decode the response as JSON and return
resultant data structure.

## `post`

```perl6
    multi post($url where URI:D|Str:D, *%form --> Str:D);
    multi post($url where URI:D|Str:D, %headers, *%form --> Str:D);

    say post 'https://httpbin.org/post?meow=moo', :72foo, :bar<♵>;
    say post 'https://httpbin.org/post?meow=moo',
        %(Content-type => 'application/json'), :72foo, :bar<♵>;
```

Takes either a `Str` or a [URI](https://modules.perl6.org/dist/URI), followed
by an optional `Hash` with HTTP headers to send. Form POST parameters can be
included as named arguments. It's fine to also include query arguments in the
URL itself. Returns `Failure` if request fails or does not return a successful
HTTP code. Returns `Str` with the data on success.


## `jpost`

```perl6
    multi jpost($url where URI:D|Str:D, *%form --> Str:D);
    multi jpost($url where URI:D|Str:D, %headers, *%form --> Str:D);

    say jpost 'https://httpbin.org/post?meow=moo', :72foo, :bar<♵>;
    say jpost 'https://httpbin.org/post?meow=moo',
        %(Content-type => 'application/json'), :72foo, :bar<♵>;
```

Same as `post()` except will also decode the response as JSON and return
resultant data structure.

# LIMITATIONS

Due to nuances of upstream code, currently any non-RFC-conformant URL will
be rejected; you have to ensure it's proper manually. Patches welcome.

# SEE ALSO

- [`LWP::Simple`](https://modules.perl6.org/repo/LWP::Simple)
- [`HTTP::UserAgent`](https://modules.perl6.org/repo/HTTP::UserAgent)

---

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
