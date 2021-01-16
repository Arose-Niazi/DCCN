# Assignment 3
![Image](https://github.com/Arose-Niazi/DCCN/tree/New-Structure/Assignments/1/1.png?raw=true)
# Router 0 Commands
```
en
	conf t
		in se 2/0
			ip ad 192.168.1.1 255.255.255.0
			no sh
			ex
		in fa 0/0
			ip ad 192.168.2.1 255.255.255.0
			no sh
			ex
		in se 3/0
			ip ad 192.168.3.1 255.255.255.0
			no sh
			ex
		in fa 4/0
			ip ad 192.168.4.1 255.255.255.0
			no sh
			ex
		rou eigrp 1
			net 192.168.1.0
			net 192.168.2.0
			net 192.168.3.0
			net 192.168.4.0
			net 192.168.5.0
			net 192.168.6.0
			net 192.168.7.0
			ex
```
# Router 1 Commands
```
en
	conf t
		in se 2/0
			ip ad 192.168.1.2 255.255.255.0
			no sh
			ex
		in fa 0/0
			ip ad 192.168.5.1 255.255.255.0
			no sh
			ex
		ip dhcp pool FA18-BSE-010-1	
			net 192.168.5.0 255.255.255.0
			de 192.168.5.1
			dns 192.168.4.100
			ex
		rou eigrp 1
			net 192.168.1.0
			net 192.168.2.0
			net 192.168.3.0
			net 192.168.4.0
			net 192.168.5.0
			net 192.168.6.0
			net 192.168.7.0
			ex
```
# Router 2 Commands
```
en
	conf t
		in fa 0/0
			ip ad 192.168.2.2 255.255.255.0
			no sh
			ex
		in fa 1/0
			ip ad 192.168.6.1 255.255.255.0
			no sh
			ex
		ip dhcp pool FA18-BSE-010-2	
			net 192.168.6.0 255.255.255.0
			de 192.168.6.1
			dns 192.168.4.100
			ex
		rou eigrp 1
			net 192.168.1.0
			net 192.168.2.0
			net 192.168.3.0
			net 192.168.4.0
			net 192.168.5.0
			net 192.168.6.0
			net 192.168.7.0
			ex
```
# Router 3 Commands
```
en
	conf t
		in se 2/0
			ip ad 192.168.3.2 255.255.255.0
			no sh
			ex
		in fa 0/0
			ip ad 192.168.7.1 255.255.255.0
			no sh
			ex
		ip dhcp pool FA18-BSE-010-3	
			net 192.168.7.0 255.255.255.0
			de 192.168.7.1
			dns 192.168.4.100
			ex
		rou eigrp 1
			net 192.168.1.0
			net 192.168.2.0
			net 192.168.3.0
			net 192.168.4.0
			net 192.168.5.0
			net 192.168.6.0
			net 192.168.7.0
			ex
```