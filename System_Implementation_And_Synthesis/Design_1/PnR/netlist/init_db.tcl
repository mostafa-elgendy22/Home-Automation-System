if {[catch {$info}]} {
   set db_param [load_db [file dirname [file normalize [info script]]] -info $info]
} else {
   set db_param [load_db [file dirname [file normalize [info script]]]]
}
load_libs
load_design -db $db_param
