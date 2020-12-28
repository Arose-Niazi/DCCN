#Creating Simulator
set ns [new Simulator]
set nf [open o.nam w]
$ns namtrace-all $nf

#Creating files for xgraph
set f0 [open out0.tr w]
set f1 [open out1.tr w]

#Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#Creating links between nodes
$ns duplex-link $n0 $n2 20Mb 10ms DropTail
$ns duplex-link $n1 $n2 20Mb 10ms DropTail
$ns duplex-link $n2 $n3 20Mb 10ms DropTail

#Creation of Protocols
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

#Generating Traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp
$cbr0 set packet_size_ 1000

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp
$cbr1 set packet_size_ 1000

#Setting Destination Point
set null1 [new Agent/TCPSink]
$ns attach-agent $n3 $null1

set null2 [new Agent/LossMonitor]
$ns attach-agent $n3 $null2

#Connection b/w Protocols and Destination
$ns connect $tcp $null1
$ns connect $udp $null2

#Graphing Procedure
proc traffic {} {
	global null1 null2 f0 f1
	set ns [Simulator instance]
	set time 1.0
	set bw0 [$null1 set bytes_]
	set bw1 [$null2 set bytes_]
	set now [$ns now]
	puts $f0 "$now [expr $bw0/$time*8/1000000]"
	puts $f1 "$now [expr $bw1/$time*8/1000000]"
	$null1 set bytes_ 0
	$null2 set bytes_ 0
	$ns at [expr $now+$time] "traffic"
}

#Finish Procedure
proc finish {} {
	global ns nf f0 f1
	$ns flush-trace
	close $nf
	close $f0
	close $f1
	exec nam o.nam
	exec xgraph -color blue out0.tr -color orange out1.tr
	exit 0
}

$ns at 0.0 "traffic"

$ns at 0.1 "$cbr0 start"
$ns at 19.0 "$cbr0 stop"

$ns at 0.1 "$cbr1 start"
$ns at 19.0 "$cbr1 stop"

$ns at 20.0 "finish"
$ns run