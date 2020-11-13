#
# Creating Simulator
#
set ns [new Simulator]

set nf [open 010.nam w]
$ns namtrace-all $nf

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
for { set a 0}  {$a < 15} {incr a} {
	set nBuilding($a) [$ns node]
	$nBuilding($a) shape box
	set x [expr $a + 1]
	$nBuilding($a) label "Building $x"
	$nBuilding($a) color blue
}

# Streets
set nStreet(ST1) [$ns node]
set nStreet(ST2) [$ns node]
set nStreet(ST3) [$ns node]
set nStreet(ST4) [$ns node]
set nStreet(ST5) [$ns node]
# Offices
set nComplaintOffice [$ns node]
set nSecurityOffice [$ns node]
set nMainOffice [$ns node]

# Counters
set c 0
set s 1

for { set a 0}  {$a < 15} {incr a} {
	incr c
	$ns simplex-link $nBuilding($a) $nStreet(ST$s) 0.5Mb 10ms DropTail
	$ns simplex-link-op $nBuilding($a) $nStreet(ST$s) color skyblue
	$ns simplex-link-op $nBuilding($a) $nStreet(ST$s) label "Simplex 50 MBPS"
	if { [expr $c % 6] == 0 } {
		set c 0
		set a [expr $a - 3]
		incr s
	}
}

foreach index [array names nStreet] {
	$nStreet($index) shape hexagon
    $nStreet($index) label "$index"
	$ns duplex-link $nStreet($index) $nComplaintOffice 5Mb 10ms DropTail
	$ns duplex-link $nStreet($index) $nSecurityOffice 5Mb 10ms DropTail
	$ns duplex-link-op $nStreet($index) $nComplaintOffice orient down
	$ns duplex-link-op $nStreet($index) $nComplaintOffice color hotpink
	$ns duplex-link-op $nStreet($index) $nComplaintOffice label "Duplex 500 MBPS"
	$ns duplex-link-op $nStreet($index) $nSecurityOffice orient down
	$ns duplex-link-op $nStreet($index) $nSecurityOffice color yellow
	$ns duplex-link-op $nStreet($index) $nSecurityOffice label "Duplex 500 MBPS"
	$nStreet($index) color orange
}

$nComplaintOffice label "Compalint Office"
$nComplaintOffice color pink

$nSecurityOffice label "Security Office"
$nSecurityOffice color red

$nMainOffice label "Main Office"
$nMainOffice color darkgreen

$ns duplex-link $nComplaintOffice $nMainOffice 10Mb 10ms RED
$ns duplex-link $nSecurityOffice $nMainOffice 10Mb 10ms RED

$ns duplex-link-op $nComplaintOffice $nMainOffice color green
$ns duplex-link-op $nComplaintOffice $nMainOffice label "Duplex 1,000 MBPS"

$ns duplex-link-op $nSecurityOffice $nMainOffice color green
$ns duplex-link-op $nSecurityOffice $nMainOffice label "Duplex 1,000 MBPS"


#
# Creation of Protocols
#
# Buildings
set udpC 0
foreach index [array names nBuilding] {
	set bUDP($index) [new Agent/UDP]
	$ns attach-agent $nBuilding($index) $bUDP($index)
	$bUDP($index) set fid_ 1
}

# Offices
set tcpCO [new Agent/TCP]
$ns attach-agent $nComplaintOffice $tcpCO
$tcpCO set fid_ 2

set tcpSO [new Agent/TCP]
$ns attach-agent $nSecurityOffice $tcpSO
$tcpSO set fid_ 3

set tcpM [new Agent/TCP]
$ns attach-agent $nMainOffice $tcpM
$tcpM set fid_ 4

set tcpM2 [new Agent/TCP]
$ns attach-agent $nMainOffice $tcpM2
$tcpM set fid_ 4

#
# Generating Traffic
#


foreach index [array names bUDP] {
	set cbr($index) [new Application/Traffic/CBR]
	$cbr($index) attach-agent $bUDP($index)
}

set cbrCO [new Application/Traffic/CBR]
$cbrCO attach-agent $tcpCO

set cbrSO [new Application/Traffic/CBR]
$cbrSO attach-agent $tcpSO

set cbrM [new Application/Traffic/CBR]
$cbrM attach-agent $tcpM

set cbrM2 [new Application/Traffic/CBR]
$cbrM2 attach-agent $tcpM2

#
# Setting Destination Point
#
set tcpAgentCO [new Agent/TCPSink]
set tcpAgentSO [new Agent/TCPSink]
set tcpAgentM [new Agent/TCPSink]
set tcpAgentM2 [new Agent/TCPSink]
set udpAgent [new Agent/LossMonitor]

$ns attach-agent $nComplaintOffice $tcpAgentCO
$ns attach-agent $nSecurityOffice $udpAgent
$ns attach-agent $nSecurityOffice $tcpAgentSO
$ns attach-agent $nMainOffice $tcpAgentM
$ns attach-agent $nMainOffice $tcpAgentM2

#
# Connection b/w Protocols and Destination
#

foreach index [array names bUDP] {
	$ns connect $bUDP($index) $udpAgent
}
$ns connect $tcpSO $tcpAgentM2
$ns connect $tcpCO $tcpAgentM
$ns connect $tcpM $tcpAgentCO
$ns connect $tcpM2 $tcpAgentSO

#
# Finish Procedure
#
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam 010.nam &
	exit 0
}

#
# Simulators
#
foreach index [array names cbr] {
	$ns at 0.1 "$cbr($index) start"
	$ns at 9.0 "$cbr($index) stop"
}

$ns at 0.5 "$cbrCO start"
$ns at 9.0 "$cbrCO stop"

$ns at 1.0 "$cbrSO start"
$ns at 9.0 "$cbrSO stop"

$ns rtmodel-at 1.5 down $nStreet(ST2) $nSecurityOffice
$ns rtmodel-at 2.0 down $nStreet(ST3) $nSecurityOffice

$ns at 2.0 "$cbrM start"
$ns at 9.0 "$cbrM stop"

$ns at 2.5 "$cbrM2 start"
$ns at 9.0 "$cbrM2 stop"

$ns at 10.0 "finish"
$ns run
