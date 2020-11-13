#Creating Simulator
set ns [new Simulator]
set nf [open o.nam w]
$ns namtrace-all $nf

#Creating Colors
$ns color 1 Blue
$ns color 2 Orange
$ns color 3 Red
$ns color 4 Green

#Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$n3 shape box
$n4 shape box
$n5 shape box

$n0 label "TCP CBR"
$n1 label "UDP CBR"
$n2 label "UDP CBR"
$n3 label "Linker"
$n4 label "Linker"
$n5 label "Linker"
$n6 label "Receiver Node 0-1"
$n7 label "Receiver Node 2"

$n0 color blue
$n1 color orange
$n2 color red
$n6 color green
$n7 color green


#Creating links between nodes
$ns duplex-link $n0 $n3 20Mb 10ms DropTail
$ns duplex-link $n1 $n3 20Mb 10ms DropTail
$ns duplex-link $n2 $n4 20Mb 10ms DropTail
$ns duplex-link $n3 $n5 20Mb 10ms DropTail
$ns duplex-link $n4 $n5 20Mb 10ms DropTail
$ns duplex-link $n6 $n5 20Mb 10ms DropTail
$ns duplex-link $n7 $n5 20Mb 10ms DropTail

#Creation of Protocols
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n2 $udp1

#Generating Traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp0

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1

#Setting colors
$tcp0 set fid_ 1
$udp0 set fid_ 2
$udp1 set fid_ 3


#Setting Destination Point
set null1 [new Agent/TCPSink]
$ns attach-agent $n6 $null1

set null2 [new Agent/LossMonitor]
$ns attach-agent $n6 $null2

set null3 [new Agent/LossMonitor]
$ns attach-agent $n7 $null3

#Connection b/w Protocols and Destination
$ns connect $tcp0 $null1
$ns connect $udp0 $null2

$ns connect $udp1 $null3

#Finish Procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam o.nam &
	exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 19.0 "$cbr0 stop"

$ns at 0.1 "$cbr1 start"
$ns at 19.0 "$cbr1 stop"

$ns at 0.5 "$cbr2 start"
$ns at 19.0 "$cbr2 stop"

$ns at 20.0 "finish"
$ns run

