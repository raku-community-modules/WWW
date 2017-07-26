unit module WWW;
use JSON::Fast;
use HTTP::UserAgent;

sub jget  (|c) is export { CATCH { .fail }; from-json get  |c }
sub jpost (|c) is export { CATCH { .fail }; from-json post |c }

sub get ($url) is export {
    CATCH { .fail }
    with HTTP::UserAgent.new.get: $url {
        .is-success or fail .&err;
        .decoded-content
    }
}

proto post (|) is export {*}
multi post ($url,           *%form) is export { post $url, %, |%form }
multi post ($url, %headers, *%form) is export {
    CATCH { .fail }
    with HTTP::UserAgent.new.post($url, %form, |%headers) {
        .is-success or fail .&err;
        .decoded-content
    }
}
multi post ($url, Str:D $json, *%headers) is export {
    CATCH { .fail }
    my $req = HTTP::Request.new: POST => $url, |%headers;
    $req.add-content: $json;

    with HTTP::UserAgent.new.request($req) {
        .is-success or fail .&err;
        .decoded-content;
    }
}

sub err ($_) { "Error {.code}: {.status-line}" }
