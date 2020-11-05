#Creating Simulator
set ns [new Simulator]
set nf [open o.nam w]
$ns namtrace-all $nf

#Creating Colors
$ns color 1 Blue
$ns color 2 Orange
$ns color 3 Red
$ns color 4 Green

#Creating files for xgraph
set f0 [open out0.tr w]
set f1 [open out1.tr w]
set f2 [open out2.tr w]
set f3 [open out3.tr w]


#Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n3 shape box

$n0 label "TCP Sender"
$n1 label "UDP Sender"
$n2 label "Linker"
$n3 label "Receiver"
$n4 label "TCP Sender"
$n5 label "UDP Sender"


$n0 color blue
$n1 color orange
$n2 color pink
$n4 color rRed
$n5 color green

#Creating links between nodes
$ns duplex-link $n0 $n2 20Mb 10ms DropTail
$ns duplex-link $n1 $n2 20Mb 10ms DropTail
$ns duplex-link $n2 $n3 20Mb 10ms DropTail
$ns duplex-link $n4 $n3 20Mb 10ms DropTail
$ns duplex-link $n4 $n5 20Mb 10ms DropTail

#Creation of Protocols
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCP]
$ns attach-agent $n4 $tcp1

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n5 $udp1


#Generating Traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp0
$cbr0 set packet_size_ 10000

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0
$cbr1 set packet_size_ 10000

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $tcp1
$cbr2 set packet_size_ 30000

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp1
$cbr3 set packet_size_ 30000

#Setting colors
$tcp0 set fid_ 1
$udp0 set fid_ 2
$tcp1 set fid_ 3
$udp1 set fid_ 4

#Setting Destination Point
set null1 [new Agent/TCPSink]
$ns attach-agent $n3 $null1

set null2 [new Agent/LossMonitor]
$ns attach-agent $n3 $null2

set null3 [new Agent/TCPSink]
$ns attach-agent $n3 $null3

set null4 [new Agent/LossMonitor]
$ns attach-agent $n3 $null4


#Connection b/w Protocols and Destination
$ns connect $tcp0 $null1
$ns connect $udp0 $null2

$ns connect $tcp1 $null3
$ns connect $udp1 $null4

#Graphing Procedure
proc traffic {} {
	global null1 null2 null3 null4 f0 f1 f2 f3
	set ns [Simulator instance]
	set time 1.0
	set bw0 [$null1 set bytes_]
	set bw1 [$null2 set bytes_]
    set bw2 [$null3 set bytes_]
    set bw3 [$null4 set bytes_]
	set now [$ns now]
	puts $f0 "$now [expr $bw0/$time*8/1000000]"
	puts $f1 "$now [expr $bw1/$time*8/1000000]"
    puts $f2 "$now [expr $bw2/$time*8/1000000]"
    puts $f3 "$now [expr $bw3/$time*8/1000000]"
	$null1 set bytes_ 0
	$null2 set bytes_ 0
    $null3 set bytes_ 0
    $null4 set bytes_ 0
	$ns at [expr $now+$time] "traffic"
}

#Finish Procedure
proc finish {} {
	global ns nf f0 f1 f2 f3
	$ns flush-trace
	close $nf
	close $f0
	close $f1
    close $f2
    close $f3
	exec nam o.nam &
	exec xgraph -color blue out0.tr -color orange out1.tr -color red out2.tr -color green out3.tr
	exit 0
}

$ns at 0.0 "traffic"

$ns at 0.1 "$cbr0 start"
$ns at 19.0 "$cbr0 stop"

$ns at 0.1 "$cbr1 start"
$ns at 19.0 "$cbr1 stop"

$ns at 0.5 "$cbr2 start"
$ns at 19.0 "$cbr2 stop"

$ns at 0.5 "$cbr3 start"
$ns at 19.0 "$cbr3 stop"

$ns at 20.0 "finish"
$ns run
