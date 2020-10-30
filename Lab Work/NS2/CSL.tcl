#To understand usage of Color, Shape, and Label as the file name states CSL

#Creating Simulator
set ns [new Simulator]
set nf [open o.nam w]
$ns namtrace-all $nf

#Creating Colors
$ns color 1 Pink
$ns color 2 Yellow

#Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$n2 shape box

$n0 label "TCP Sender"
$n1 label "UDP Sender"
$n2 label "Linker"
$n3 label "Receiver"

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
set cbrT [new Application/Traffic/CBR]
$cbrT attach-agent $tcp
$cbrT set packet_size_ 10000

set cbrU [new Application/Traffic/CBR]
$cbrU attach-agent $udp
$cbrU set packet_size_ 10000

#Setting colors
$tcp set fid_ 1
$udp set fid_ 2

#Setting Destination Point
set null1 [new Agent/TCPSink]
$ns attach-agent $n3 $null1

set null2 [new Agent/LossMonitor]
$ns attach-agent $n3 $null2

#Connection b/w Protocols and Destination
$ns connect $tcp $null1
$ns connect $udp $null2

#Finish Procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam o.nam &
	exit 0
}

#Modifying the nodes at times
$ns at 0.0 "$n0 color green"
$ns at 0.0 "$n1 color green"
$ns at 0.0 "$n2 color blue"
$ns at 0.0 "$n3 color orange"

#Starting

$ns at 0.1 "$cbrT start"
$ns at 19.0 "$cbrT stop"

$ns at 0.1 "$cbrU start"
$ns at 19.0 "$cbrU stop"

$ns at 20.0 "finish"
$ns run