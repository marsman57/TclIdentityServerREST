package provide jsonparser 0.1
package require json
package require dicttool

# Create the namspace 
namespace eval ::jsonparser {
    # Export commands
    namespace export parse_file parse subparsepartialdict
    # namespace export parse_json parse_json_file

}

proc ::jsonparser::parse {json_text} {
    set tcl_dict [json::many-json2dict $json_text]

    foreach item $tcl_dict {
        if { [dict is_dict $item]} {
            foreach key [dict keys $item] value [dict values $item] {                
                set hasSubDictionaries 0
                if { [dict is_dict $value] } {
                    foreach key2 [dict keys $value] value2 [dict values $value] {
                        if { [dict is_dict $key2] || [dict is_dict $value2]} {
                            set hasSubDictionaries 1
                        }
                    }
                }
                if (!$hasSubDictionaries) {
                    puts "$key: $value"
                } else {
                    puts "$key \["                    
                    jsonparser::subparsepartialdict $value
                    puts "\]"
                }
            }
        } else {
            puts $item
        }
    }
}

proc ::jsonparser::subparsepartialdict {tcl_dict} {
    foreach item $tcl_dict {
        puts "{"
        if { [dict is_dict $item]} {
            foreach key [dict keys $item] value [dict values $item] {                
                set hasSubDictionaries 0
                if { [dict is_dict $value] } {
                    foreach key2 [dict keys $value] value2 [dict values $value] {
                        if { [dict is_dict $key2] || [dict is_dict $value2]} {
                            set hasSubDictionaries 1
                        }
                    }
                }
                if (!$hasSubDictionaries) {
                    puts "$key: $value"
                } else {
                    puts "$key \["
                    puts $value
                    jsonparser::subparsepartialdict $value
                    puts "\]"
                }
            }
        } else {
            puts $item
        }
        puts "}"
    }
}

proc ::jsonparser::parse_file {file_name} {
    set infile [open $file_name r]
    set text ""
    while { [gets $infile line] >= 0 } {
        set text $line
    }
    close $infile

    jsonparser::parse $text
}



proc ::jsonparser::? {} {lsort [info procs ::jsonparser::*]}

#------------------- Self-test code
if {[info ex argv0] && [file tail [info script]] == [file tail $argv0]} {
    puts "package jsonparser contains [jsonparser::?]"
    # set infile [open "sample.json" r]
    # set text ""
    # while { [gets $infile line] >= 0 } {
    #     set text $line
    # }
    # close $infile

    # jsonparser::parse $text

    jsonparser::parse_file "..\sample.json"
    puts "[file dirn [info scr]] [file tail [info scr]]"
    pkg_mkIndex -verbose [file dirn [info scr]] [file tail [info scr]]

} 




