#!/usr/bin/env tclsh
global dir; set dir [file dirname $argv0]
proc path {file} { global dir; return [file join $dir $file] }

#puts "Choose a layout (1 or 2): "
#gets stdin layout
#puts "Layout: $layout"

set pdf0 [lindex $argv 0]
set rootname [file rootname $pdf0]
set pdf1 [join [list $rootname "_L1_1.pdf"] ""]
set pdf2 [join [list $rootname "_L1_2.pdf"] ""]
puts $pdf0
puts $pdf1
puts $pdf2
#set pdf11 "_L1_1.pdf"
#set pdf12 "_L1_2.pdf"
#set pdf21 "_L2_1.pdf"
#set pdf22 "_L2_2.pdf"

set row [exec pdftk $pdf0 dump_data | grep NumberOfPages]
set num [regexp -inline {\d+} $row]
puts [concat $num "pages"]

set p1 {}
set p2 {}
for {set i 1} {$i <= $num} {incr i 2} {lappend p1 $i}
for {set i 2} {$i <= $num} {incr i 2} {lappend p2 $i}
if {[llength $p1] != [llength $p2]} {lappend p2 0}

set pa1 {}
set pa2 {}
foreach p $p1 { lappend pa1 [join [list "A" $p] ""] }
foreach p $p2 {
  if {$p == 0} {
    lappend pa2 "B1"
  } else {
    lappend pa2 [join [list "A" $p] ""]
  }
}

set pa1r [lreverse $pa1]
set pa2r [lreverse $pa2]
puts $p1
puts $p2
puts $pa1
puts $pa2
puts $pa1r
puts $pa2r

#set cmd1 [list "pdftk" [join [list "A=" $pdf0] ""] "B=blank.pdf" "cat" {*}$pa1r "output" $pdf1]
#set cmd2 [list "pdftk" [join [list "A=" $pdf0] ""] "B=blank.pdf" "cat" {*}$pa2r "output" $pdf2]
set cmd1 [list "pdftk" [join [list "A=" $pdf0] ""] [join [list "B=" [path blank.pdf]] ""] "cat" {*}$pa1r "output" $pdf1]
set cmd2 [list "pdftk" [join [list "A=" $pdf0] ""] [join [list "B=" [path blank.pdf]] ""] "cat" {*}$pa2r "output" $pdf2]
#set cmd2 [list pdftk "--version"] 
puts $cmd1
puts $cmd2
exec {*}$cmd1
exec {*}$cmd2

#set result1 [exec {*}$cmd1]
#puts $result1
#set result2 [exec {*}$cmd2]
#puts $result2
