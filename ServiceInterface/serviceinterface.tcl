package provide serviceinterface 0.1
package require http
package require rest
package require json

namespace eval ::serviceinterface {
    namespace export GetRequest PostRequest PutRequest DeleteRequest
}

#first argument is URL, second argument is a query parameter dictionary for the queryparameters
proc ::serviceinterface::GetRequest {args} {
    set params []
    if {[llength $args] == 1} {
        tailcall serviceinterface::ExecuteWebRequest 0 $args $params
    } else {
        tailcall serviceinterface::ExecuteWebRequest 0 {*}$args
    }
}

#first argument is URL, second argument is a query parameter dictionary for the form body
proc ::serviceinterface::PostRequest {args} {
    set params []
    if {[llength $args] == 1} {
        tailcall serviceinterface::ExecuteWebRequest 1 $args $params
    } else {
        tailcall serviceinterface::ExecuteWebRequest 1 {*}$args
    }
}

proc ::serviceinterface::PutRequest {url queryParams} {
    set auth "Bearer $::globals::bearerToken"
    set accept "application/json"

    dict set typeInfo method "put"
    dict set typeInfo headers [list Authorization $auth Accept $accept]

    if {[string match "https*" $url]} {
        if {[catch {package require twapi_crypto}]} {
            package require tls 1.7
            http::register https 443 [list ::tls::socket -autoservername true]
        } else {
            http::register https 443 [list ::twapi::tls_socket]
        }
    }

    set res [rest::simple $url $queryParams $typeInfo]

    if {[string match "https*" $url]} {
        http::unregister https
    }
    return $res
}

proc ::serviceinterface::DeleteRequest {url queryParams} {
    set auth "Bearer $::globals::bearerToken"
    set accept "application/json"

    dict set typeInfo method "delete"
    dict set typeInfo headers [list Authorization $auth Accept $accept]

    if {[string match "https*" $url]} {
        if {[catch {package require twapi_crypto}]} {
            package require tls 1.7
            http::register https 443 [list ::tls::socket -autoservername true]
        } else {
            http::register https 443 [list ::twapi::tls_socket]
        }
    }

    set res [rest::simple $url $queryParams $typeInfo]

    if {[string match "https*" $url]} {
        http::unregister https
    }
    return $res
}

proc ::serviceinterface::ExecuteWebRequest {isPost url queryParams} {
    
    if {[string match "https*" $url]} {
        if {[catch {package require twapi_crypto}]} {
            package require tls 1.7
            http::register https 443 [list ::tls::socket -autoservername true]
        } else {
            http::register https 443 [list ::twapi::tls_socket]
        }
    }
    
    set auth "Bearer $::globals::bearerToken"
    set accept "application/json"
    set headerl [list Authorization $auth Accept $accept]
    
    if {$isPost} {
        set token [http::geturl $url -query [http::formatQuery {*}$queryParams] -timeout 30000 -headers $headerl]
    } else {
        set token [http::geturl $url?[http::formatQuery {*}$queryParams] -timeout 30000 -headers $headerl]
    }
    
    set status [http::status $token]
    if {![string equal $status "ok"]} {
        #throw some sort of error.
    }
    set answer [http::data $token]    
    http::cleanup $token    

    if {[string match "https*" $url]} {
        http::unregister https
    }
 
    return $answer
}