# RouterOS 5.20
#
# Adjust default 'disk' action to to save up to 10 files of 2000 lines and 
# each change action for each of the default log rules from 'memory' or 'disk'.
#
# Enable BSD style remote syslog. A major benefit of BSD style (for me) is
# the ability to use the system's identify (host name) in the log entry instead
# of an IP address. The downside, by default, is the particular logging facility
# is lost (e.g., "system,info").  This script generates log rules with prefixes
# for most facilities.
#
# There may be a much better way to accomplish this same task...

/system logging action
set 0 memory-lines=200 memory-stop-on-full=no name=memory target=memory
set 1 disk-file-count=10 disk-file-name=log disk-lines-per-file=2000 \
    disk-stop-on-full=no name=disk target=disk
set 2 name=echo remember=yes target=echo
set 3 bsd-syslog=yes name=remote remote=X.X.X.X remote-port=514 src-address=\
    0.0.0.0 syslog-facility=syslog syslog-severity=auto target=remote

/system logging
set 0 action=disk disabled=no prefix="" topics=info
set 1 action=disk disabled=no prefix="" topics=error
set 2 action=disk disabled=no prefix="" topics=warning
set 3 action=echo disabled=no prefix="" topics=critical
add action=disk disabled=no prefix="" topics=critical

# LOG ALL THE THINGS!!!!
:global logTypes [:toarray "account,async,backup,bfd,bgp,calc,ddns,dhcp,e-mail,event,firewall,gsm,hotspot,igmp-proxy,interface,ipsec,iscsi,isdn,kvm,l2tp,ldp,manager,mme,mpls,ntp,ospf,ovpn,packet,pim,ppp,pppoe,pptp,radius,radvd,raw,read,rip,route,rsvp,script,sertcp,simulator,smb,snmp,ssh,sstp,state,store,system,telephony,tftp,timer,ups,vrrp,watchdog,web-proxy,wireless,write"]
:global logTypes2 [:toarray "critical,error,warning,info"]

#If you want DEBUG on everything, enable this one.
#:global logTypes2 [:toarray "critical,error,warning,info,debug"]

:foreach t1 in=$logTypes do={
	:foreach t2 in=$logTypes2 do={
		/system logging add \
		action=remote \
		disabled=no \
		prefix="$t1-$t2" \
		topics="$t1,$t2"
	}
}
