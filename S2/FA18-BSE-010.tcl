#
# Creating Simulator
#
set ns [new Simulator]

set nf [open 010.nam w]
$ns namtrace-all $nf


#Creating files for xgraph
set f0 [open out0.tr w]
set f1 [open out1.tr w]
set f2 [open out2.tr w]
set f3 [open out3.tr w]

#
#Applying routing protocol
#
$ns rtproto DV


#
# Creating colors
#
$ns color 1 Blue
$ns color 2 Pink
$ns color 3 Red
$ns color 4 Green

#
# Creating nodes
#
# Buldings
for { set a 0}  {$a < 30} {incr a} {
	set nComputers($a) [$ns node]
	$nComputers($a) shape box
	set x [expr $a + 1]
	$nComputers($a) label "Computer $x"
	$nComputers($a) color blue
}

# Departments
for { set a 0}  {$a < 3} {incr a} {
	set nDepartment($a) [$ns node]
	$nDepartment($a) shape hexagon
}

$nDepartment(0) label "Accounts"
$nDepartment(0) color darkgreen


$nDepartment(1) label "HR"
$nDepartment(1) color orange

$nDepartment(2) label "Finance"
$nDepartment(2) color red

for { set a 0}  {$a < 10} {incr a} {
	$ns duplex-link $nComputers($a) $nDepartment(0) 10Mb 10ms RED
	$ns duplex-link-op $nComputers($a) $nDepartment(0) color skyblue
}

for { set a 10}  {$a < 20} {incr a} {
	$ns duplex-link $nComputers($a) $nDepartment(1) 10Mb 10ms RED
	$ns duplex-link-op $nComputers($a) $nDepartment(1) color yellow
}

for { set a 20}  {$a < 30} {incr a} {
	$ns duplex-link $nComputers($a) $nDepartment(2) 10Mb 10ms RED
	$ns duplex-link-op $nComputers($a) $nDepartment(2) color pink
}

for { set a 0}  {$a < 3} {incr a} {
    set x [expr [expr $a + 1] % 3]
    $ns duplex-link $nDepartment($a) $nDepartment($x) 10Mb 10ms RED
}

#
# Creation of Protocols
#
# PCs
set udp(0) [new Agent/UDP]
$ns attach-agent $nComputers(0) $udp(0)
$udp(0) set fid_ 1

set udp(1) [new Agent/UDP]
$ns attach-agent $nComputers(10) $udp(1)
$udp(1) set fid_ 1

set udp(2) [new Agent/UDP]
$ns attach-agent $nComputers(20) $udp(2)
$udp(2) set fid_ 1

# Department
set tcp [new Agent/TCP]
$ns attach-agent $nDepartment(0) $tcp
$tcp set fid_ 2


# #
# # Generating Traffic
# #


foreach index [array names udp] {
 	set cbr($index) [new Application/Traffic/CBR]
 	$cbr($index) attach-agent $udp($index)
}

set cbrB [new Application/Traffic/CBR]
$cbrB attach-agent $tcp

# #
# # Setting Destination Point
# #
set tcpAgent [new Agent/TCPSink]
foreach index [array names udp] {
    set udpAgent($index) [new Agent/LossMonitor]
}


$ns attach-agent $nDepartment(2) $tcpAgent
foreach index [array names udpAgent] {
    $ns attach-agent $nDepartment($index) $udpAgent($index)
}

# #
# # Connection b/w Protocols and Destination
# #

foreach index [array names udp] {
	$ns connect $udp($index) $udpAgent($index)
}
$ns connect $tcp $tcpAgent


#Graphing Procedure
proc traffic {} {
	global udpAgent tcpAgent f0 f1 f2 f3
	set ns [Simulator instance]
	set time 1.0
	set bw0 [$tcpAgent set bytes_]
	set bw1 [$udpAgent(0) set bytes_]
    set bw2 [$udpAgent(1) set bytes_]
    set bw3 [$udpAgent(2) set bytes_]
	set now [$ns now]
	puts $f0 "$now [expr $bw0/$time*8/1000000]"
	puts $f1 "$now [expr $bw1/$time*8/1000000]"
    puts $f2 "$now [expr $bw2/$time*8/1000000]"
    puts $f3 "$now [expr $bw3/$time*8/1000000]"
	$tcpAgent set bytes_ 0
	$udpAgent(0) set bytes_ 0
    $udpAgent(1) set bytes_ 0
    $udpAgent(2) set bytes_ 0
	$ns at [expr $now+$time] "traffic"
}

#
# Finish Procedure
#
proc finish {} {
	global ns nf f0 f1 f2 f3
	$ns flush-trace
	close $nf
	close $f0
	close $f1
    close $f2
    close $f3
	exec nam 010.nam
	exec xgraph out0.tr out1.tr out2.tr out3.tr
	exit 0
}

#
# Simulators
#
foreach index [array names cbr] {
	$ns at 0.1 "$cbr($index) start"
	$ns at 9.0 "$cbr($index) stop"
}

$ns at 0.5 "$cbrB start"
$ns at 9.0 "$cbrB stop"

$ns rtmodel-at 1.5 down $nDepartment(2) $nDepartment(0)

$ns at 0.0 "traffic"
$ns at 10.0 "finish"
$ns run
