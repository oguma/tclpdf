#!/usr/bin/env tclsh
global dir; set dir [file dirname $argv0]
proc path {file} { global dir; return [file join $dir $file] }

set pdf0 [lindex $argv 0]
set rootname [file rootname $pdf0]
set pdf1 [join [list $rootname "_L2_1.pdf"] ""]
set pdf2 [join [list $rootname "_L2_2.pdf"] ""]
puts $pdf0
puts $pdf1
puts $pdf2

set row [exec pdftk $pdf0 dump_data | grep NumberOfPages]
set num [regexp -inline {\d+} $row]
puts [concat $num "pages"]

set p1 {}
set p2 {}
for {set i 1} {$i <= $num} {incr i 4} {
  set p1e1 $i
  set i2 [expr $i+1]
  if {$i2 <= $num} {set p1e2 $i2} else {set p1e2 0}
  lappend p1 [list $p1e1 $p1e2]

  set j [expr $i+2]
  if {$j <= $num} { set p2e1 $j } else {set p2e1 0}
  set j2 [expr $j+1]
  if {$j2 <= $num} { set p2e2 $j2 } else {set p2e2 0}
  lappend p2 [list $p2e1 $p2e2]
}

set p1r [lreverse $p1]
set p1rf {}
foreach e $p1r { lappend p1rf {*}$e }

set p2r [lreverse $p2]
set p2rf {}
foreach e $p2r { lappend p2rf {*}$e }

puts "---"

puts $p1
puts $p1r
puts $p1rf

puts "---"

puts $p2
puts $p2r
puts $p2rf

puts "---"

set pa1 {}
set pa2 {}
foreach p $p1rf {
  if {$p == 0} {
    lappend pa1 "B1"
  } else {
    lappend pa1 [join [list "A" $p] ""]
  }
}
foreach p $p2rf {
  if {$p == 0} {
    lappend pa2 "B1"
  } else {
    lappend pa2 [join [list "A" $p] ""]
  }
}
puts $pa1
puts $pa2

#set cmd1 [list "pdftk" [join [list "A=" $pdf0] ""] "B=blank.pdf" "cat" {*}$pa1 "output" $pdf1]
#set cmd2 [list "pdftk" [join [list "A=" $pdf0] ""] "B=blank.pdf" "cat" {*}$pa2 "output" $pdf2]
set cmd1 [list "pdftk" [join [list "A=" $pdf0] ""] [join [list "B=" [path blank.pdf]] ""] "cat" {*}$pa1 "output" $pdf1]
set cmd2 [list "pdftk" [join [list "A=" $pdf0] ""] [join [list "B=" [path blank.pdf]] ""] "cat" {*}$pa2 "output" $pdf2]
puts $cmd1
puts $cmd2
exec {*}$cmd1
exec {*}$cmd2
