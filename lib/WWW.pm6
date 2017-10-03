unit module WWW:ver<1004001>;
use JSON::Fast;
use HTTP::UserAgent;

sub jget  (|c) is export { CATCH { .fail }; from-json get  |c }
sub jpost (|c) is export { CATCH { .fail }; from-json post |c }
sub jput (|c) is export { CATCH { .fail }; from-json put |c }

sub get ($url, *%headers) is export {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    with HTTP::UserAgent.new.get: $url, |%headers {
        .is-success or fail .&err;
        .decoded-content
    }
}

proto post (|) is export {*}
multi post ($url,           *%form) is export { post $url, %, |%form }
multi post ($url, %headers, *%form) is export {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    with HTTP::UserAgent.new.post($url, %form, |%headers) {
        .is-success or fail .&err;
        .decoded-content
    }
}
multi post ($url, Str:D $json, *%headers) is export {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    my $req = HTTP::Request.new: POST => $url, |%headers;
    $req.add-content: $json;

    with HTTP::UserAgent.new.request($req) {
        .is-success or fail .&err;
        .decoded-content;
    }
}

proto put (|) is export {*}
multi put ($url,           *%form) is export { put $url, %, |%form }
multi put ($url, %headers, *%form) is export {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    with HTTP::UserAgent.new.put($url, %form, |%headers) {
        .is-success or fail .&err;
        .decoded-content
    }
}
multi put ($url, Str:D $json, *%headers) is export {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    my $req = HTTP::Request.new: PUT => $url, |%headers;
    $req.add-content: $json;

    with HTTP::UserAgent.new.request($req) {
        .is-success or fail .&err;
        .decoded-content;
    }
}

sub err ($_) { "Error {.code}: {.status-line}" }
