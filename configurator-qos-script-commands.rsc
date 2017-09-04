/queue type
add kind=sfq name=qos
add kind=pcq name=pcq-download-50000-1 pcq-classifier=dst-address pcq-rate=50000
add kind=pcq name=pcq-upload-10000-1 pcq-classifier=src-address pcq-rate=10000

/queue simple
add name=10000-1/50000-1 packet-marks="" queue=pcq-upload-10000-1/pcq-download-50000-1 target="192.168.88.0/24" comment="limit users"

/queue tree
add max-limit=10000000 name=All-Download parent=global queue=default
add max-limit=5000000 name=All-Upload parent=global queue=default
add limit-at=2000000M max-limit=10000000 name=P1-dn packet-mark=p1-dn parent=All-Download priority=1 queue=qos
add limit-at=2000000M max-limit=10000000 name=P2-dn packet-mark=p2-dn parent=All-Download priority=2 queue=qos
add limit-at=2000000M max-limit=10000000 name=P3-dn packet-mark=p3-dn parent=All-Download priority=3 queue=qos
add max-limit=10000000 name=P4-dn packet-mark=p4-dn parent=All-Download priority=4 queue=qos
add max-limit=10000000 name=P5-dn packet-mark=p5-dn parent=All-Download priority=5 queue=qos
add max-limit=10000000 name=P6-dn packet-mark=p6-dn parent=All-Download priority=6 queue=qos
add max-limit=10000000 name=P7-dn packet-mark=p7-dn parent=All-Download priority=7 queue=qos
add max-limit=10000000 name=P8-dn packet-mark=p8-dn parent=All-Download priority=8 queue=qos

add limit-at=1000000M max-limit=5000000 name=p1-up packet-mark=p1-up parent=All-Upload priority=1 queue=qos
add limit-at=1000000M max-limit=5000000 name=p2-up packet-mark=p2-up parent=All-Upload priority=2 queue=qos
add limit-at=1000000M max-limit=5000000 name=p3-up packet-mark=p3-up parent=All-Upload  priority=3 queue=qos
add max-limit=5000000 name=p4-up packet-mark=p4-up parent=All-Upload priority=4 queue=qos
add max-limit=5000000 name=p5-up packet-mark=p5-up parent=All-Upload priority=5 queue=qos
add max-limit=5000000 name=p6-up packet-mark=p6-up parent=All-Upload priority=6 queue=qos
add max-limit=5000000 name=p7-up packet-mark=p7-up parent=All-Upload priority=7 queue=qos
add max-limit=5000000 name=p8-up packet-mark=p8-up parent=All-Upload priority=8 queue=qos

/ip firewall address-list
/ip firewall mangle
add action=mark-connection chain=prerouting comment="Mark all management traffic to this router as priority 1" dst-address-type=local dst-port=21,22,23,80,443,8291,8728,8729 new-connection-mark=p1 protocol=tcp
add action=mark-connection chain=prerouting comment="VOIP to our VOIP gateways" connection-mark=no-mark new-connection-mark=p1 src-address-list=VOIP_Gateways
add action=mark-packet chain=prerouting comment="Mark P1" connection-mark=p1 in-interface=ether1 new-packet-mark=p1-dn
add action=mark-packet chain=prerouting comment="Mark P2" connection-mark=p2 in-interface=ether1 new-packet-mark=p2-dn
add action=mark-packet chain=prerouting comment="Mark P3" connection-mark=p3 in-interface=ether1 new-packet-mark=p3-dn
add action=mark-packet chain=prerouting comment="Mark P4" connection-mark=p4 in-interface=ether1 new-packet-mark=p4-dn
add action=mark-packet chain=prerouting comment="Mark P5" connection-mark=p5 in-interface=ether1 new-packet-mark=p5-dn
add action=mark-packet chain=prerouting comment="Mark P6" connection-mark=p6 in-interface=ether1 new-packet-mark=p6-dn
add action=mark-packet chain=prerouting comment="Mark P7" connection-mark=p7 in-interface=ether1 new-packet-mark=p7-dn
add action=mark-packet chain=prerouting comment="Mark P8" connection-mark=p8 in-interface=ether1 new-packet-mark=p8-dn
add action=mark-packet chain=prerouting comment="Mark P1" connection-mark=p1 in-interface=wlan1 new-packet-mark=p1-up
add action=mark-packet chain=prerouting comment="Mark P2" connection-mark=p2 in-interface=wlan1 new-packet-mark=p2-up
add action=mark-packet chain=prerouting comment="Mark P3" connection-mark=p3 in-interface=wlan1 new-packet-mark=p3-up
add action=mark-packet chain=prerouting comment="Mark P4" connection-mark=p4 in-interface=wlan1 new-packet-mark=p4-up
add action=mark-packet chain=prerouting comment="Mark P5" connection-mark=p5 in-interface=wlan1 new-packet-mark=p5-up
add action=mark-packet chain=prerouting comment="Mark P6" connection-mark=p6 in-interface=wlan1 new-packet-mark=p6-up
add action=mark-packet chain=prerouting comment="Mark P7" connection-mark=p7 in-interface=wlan1 new-packet-mark=p7-up
add action=mark-packet chain=prerouting comment="Mark P8" connection-mark=p8 in-interface=wlan1 new-packet-mark=p8-up
add action=mark-connection protocol=tcp port=20 chain=prerouting comment="FTP" packet-mark=no-mark new-connection-mark=p2
add action=mark-connection protocol=tcp port=21 chain=prerouting comment="FTP" packet-mark=no-mark new-connection-mark=p2
add action=mark-connection protocol=tcp port=22 chain=prerouting comment="SSH" packet-mark=no-mark new-connection-mark=p2
add action=mark-connection protocol=tcp port=23 chain=prerouting comment="Telnet" packet-mark=no-mark new-connection-mark=p2
add action=mark-connection protocol=tcp port=25 chain=prerouting comment="SMTP" packet-mark=no-mark new-connection-mark=p6
add action=mark-connection protocol=tcp port=37 chain=prerouting comment="Time Protocol" packet-mark=no-mark new-connection-mark=p7
add action=mark-connection protocol=udp port=37 chain=prerouting comment="Time Protocol" packet-mark=no-mark new-connection-mark=p7
add action=mark-connection protocol=tcp port=53 chain=prerouting comment="DNS" packet-mark=no-mark new-connection-mark=p3
add action=mark-connection protocol=udp port=53 chain=prerouting comment="DNS" packet-mark=no-mark new-connection-mark=p3
add action=mark-connection protocol=tcp port=80 chain=prerouting comment="HTTP" packet-mark=no-mark new-connection-mark=p5
add action=mark-connection protocol=udp port=110 chain=prerouting comment="POP3" packet-mark=no-mark new-connection-mark=p6
add action=mark-connection protocol=udp port=123 chain=prerouting comment="NTP" packet-mark=no-mark new-connection-mark=p7
add action=mark-connection protocol=udp port=161 chain=prerouting comment="SNMP" packet-mark=no-mark new-connection-mark=p5
add action=mark-connection protocol=tcp port=162 chain=prerouting comment="SNMP" packet-mark=no-mark new-connection-mark=p5
add action=mark-connection protocol=udp port=162 chain=prerouting comment="SNMP" packet-mark=no-mark new-connection-mark=p5
add action=mark-connection protocol=tcp port=179 chain=prerouting comment="BGP" packet-mark=no-mark new-connection-mark=p4
add action=mark-connection protocol=tcp port=443 chain=prerouting comment="HTTPS" packet-mark=no-mark new-connection-mark=p5
add action=mark-connection protocol=tcp port=465 chain=prerouting comment="SMTP" packet-mark=no-mark new-connection-mark=p6
add action=mark-connection protocol=udp port=514 chain=prerouting comment="Syslog" packet-mark=no-mark new-connection-mark=p7
add action=mark-connection protocol=tcp port=989 chain=prerouting comment="FTPS" packet-mark=no-mark new-connection-mark=p1
add action=mark-connection protocol=udp port=989 chain=prerouting comment="FTPS" packet-mark=no-mark new-connection-mark=p1
add action=mark-connection protocol=tcp port=990 chain=prerouting comment="FTPS" packet-mark=no-mark new-connection-mark=p1
add action=mark-connection protocol=udp port=990 chain=prerouting comment="FTPS" packet-mark=no-mark new-connection-mark=p1
add action=mark-connection protocol=tcp port=993 chain=prerouting comment="SPOP3" packet-mark=no-mark new-connection-mark=p7
add action=mark-connection protocol=tcp port=3389 chain=prerouting comment="Remote Desktop" packet-mark=no-mark new-connection-mark=p2
add action=mark-connection protocol=udp port=6667 chain=prerouting comment="IRC" packet-mark=no-mark new-connection-mark=p2
add action=mark-connection protocol=tcp port=8291 chain=prerouting comment="Winbox" packet-mark=no-mark new-connection-mark=p1
