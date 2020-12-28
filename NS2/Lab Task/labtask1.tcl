#Creating Simulator
set ns [new Simulator]
set nf [open o.nam w]
$ns namtrace-all $nf

#Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]


#Creating links between nodes
$ns duplex-link $n0 $n3 20Mb 10ms DropTail
$ns duplex-link $n1 $n3 20Mb 10ms DropTail
$ns duplex-link $n2 $n4 20Mb 10ms DropTail
$ns duplex-link $n3 $n5 20Mb 10ms DropTail
$ns duplex-link $n4 $n5 20Mb 10ms DropTail
$ns duplex-link $n6 $n5 20Mb 10ms DropTail
$ns duplex-link $n7 $n5 20Mb 10ms DropTail
$ns duplex-link $n8 $n5 20Mb 10ms DropTail



#Finish Procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam o.nam
	exit 0
}

$ns at 20.0 "finish"
$ns run
