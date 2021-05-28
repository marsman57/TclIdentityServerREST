lappend auto_path [pwd]

source globals.tcl
source config.tcl

package require jsonparser
package require identityserver
package require serviceinterface

#Test0 - Get Identity BearerToken. Necessary for any other tests that call a service
#set ::globals::bearerToken [identityserver::GetAccessToken]
#puts $::globals::bearerToken

#Test1 - Perform a simple GetRequest
#puts [serviceinterface::GetRequest "http://myserver/path/to/execute"]

#Test2 - Perform a simple PostRequest
#dict set postparams query "select ViewId from BatchStatsResults"
#dict set postparams type 0
#puts [::serviceinterface::PostRequest "http://myserver/path/to/execute" $postparams]

#Test3 - Perform a simple json parse.
#jsonparser::parse_file "sample.json"

#Test3 - Perform a simple PutRequest
#dict set postparams2 query "select ViewId from BatchStatsResults"
#dict set postparams2 type 0
#puts [::serviceinterface::PutRequest "http://myserver/path/to/execute" $postparams2]

#Test4 - Perform a simple DeleteRequest
#dict set postparams3 query "select ViewId from BatchStatsResults"
#dict set postparams3 type 0
#puts [::serviceinterface::DeleteRequest "http://myserver/path/to/execute" $postparams3]