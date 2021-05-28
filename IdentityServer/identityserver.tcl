package provide identityserver 0.1
package require http
package require json

namespace eval ::identityserver {
    namespace export GetAccessToken GetIdentityResponse
}

proc ::identityserver::GetAccessToken {} {
    set results [::identityserver::GetIdentityResponse]
    return [dict get $results access_token]
}

proc ::identityserver::GetIdentityResponse {} {
    dict set postparams grant_type $::config::grant_type
    dict set postparams username $::config::username
    dict set postparams password $::config::password
    dict set postparams client_id $::config::client_id
    dict set postparams client_secret $::config::client_secret
    dict set postparams scope $::config::scope
    set url $::config::identityserverurl
    
    if {[string match "https*" $url]} {
        if {[catch {package require twapi_crypto}]} {
            package require tls 1.7
            http::register https 443 [list ::tls::socket -autoservername true]
        } else {
            http::register https 443 [list ::twapi::tls_socket]
        }
    }
    
    set accept "application/json"
    set headerl [list Accept $accept]
    
    set token [http::geturl $url -query [http::formatQuery {*}$postparams] -timeout 30000 -headers $headerl]
    set status [http::status $token]
    if {![string equal $status "ok"]} {
        #throw some sort of error.
    }
    set results [http::data $token]    
    http::cleanup $token    

    if {[string match "https*" $url]} {
        http::unregister https
    }

    return [::json::json2dict $results]
}