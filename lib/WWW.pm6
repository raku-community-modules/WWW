unit module WWW;
use JSON::Fast;
use HTTP::UserAgent;

sub jget  (|c) is export(:DEFAULT, :extras) {
    CATCH { .fail }; from-json get  |c
}
sub jpost (|c) is export(:DEFAULT, :extras) {
    CATCH { .fail }; from-json post |c
}
sub jput (|c) is export(:extras) { CATCH { .fail }; from-json put |c }
sub jdelete (|c) is export(:extras) { CATCH { .fail }; from-json delete |c }

sub get ($url, *%headers) is export(:DEFAULT, :extras) {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    with HTTP::UserAgent.new.get: $url, |%headers {
        .is-success or fail .&err;
        .decoded-content
    }
}

proto post (|) is export(:DEFAULT, :extras) {*}
multi post ($url, *%form) is export(:DEFAULT, :extras) {
    post $url, %, |%form
}
multi post ($url, %headers, *%form) is export(:DEFAULT, :extras) {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    with HTTP::UserAgent.new.post($url, %form, |%headers) {
        .is-success or fail .&err;
        .decoded-content
    }
}
multi post ($url, Str:D $json, *%headers) is export(:DEFAULT, :extras) {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    my $req = HTTP::Request.new: POST => $url, |%headers;
    $req.add-content: $json;

    with HTTP::UserAgent.new.request($req) {
        .is-success or fail .&err;
        .decoded-content;
    }
}

proto put (|) is export(:extras) {*}
multi put ($url,           *%form) is export(:extras) { put $url, %, |%form }
multi put ($url, %headers, *%form) is export(:extras) {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    with HTTP::UserAgent.new.put($url, %form, |%headers) {
        .is-success or fail .&err;
        .decoded-content
    }
}
multi put ($url, Str:D $json, *%headers) is export(:extras) {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    my $req = HTTP::Request.new: PUT => $url, |%headers;
    $req.add-content: $json;

    with HTTP::UserAgent.new.request($req) {
        .is-success or fail .&err;
        .decoded-content;
    }
}

sub delete ($url, *%headers) is export(:extras) {
    CATCH { .fail }
    %headers<User-Agent> //= 'Rakudo WWW';
    with HTTP::UserAgent.new.delete: $url, |%headers {
        .code == 204 and return ''; # "204 No Content"
        .is-success or fail .&err;
        .decoded-content
    }
}

sub err ($_) { "Error {.code}: {.status-line}" }
