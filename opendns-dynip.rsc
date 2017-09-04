#--------------- Change Values in this section to match your setup ------------------
# User account info of OpenDNS
# Update-only password (obtained from OpenDNS Support). With two-factor authentication enabled, the use of an update only password is required. 

:local odnsuser "email@example.com"
:local odnspass "APIkey"

# Set the hostname or label of network to be updated. This is the name of your OpenDNS network on the Dashboard. 
# Hostnames with spaces are unsupported. Replace the value in the quotations below with your host name.
# Only one host is supported
# Use "all.dnsomatic.com" for the matichost to update all items in dnsomatic with this IP.

# Note, you must have admin or edit (Read/Write/Grant in the OpenDNS Dashboard) to update IP addresses. 

:local odnshost "Apartment"

# Change to the name of interface that gets the changing IP address

# May not be needed for your model number - commenting out this line may still work for single interface devices or if this is not supplied in the DNS-O-Matic script currently being used

:local inetinterface "ether1"

#------------------------------------------------------------------------------------

# No more changes needed, one optional change

:global previousIP;

:log info "Fetching current IP"

# Get the current public IP using DNS-O-Matic service.
/tool fetch url="http://myip.dnsomatic.com/" mode=http dst-path=mypublicip.txt

# Read the current public IP into the currentIP variable.
:local currentIP [/file get mypublicip.txt contents]

:log info "Fetched current IP as $currentIP"

# --------- Optional check to only run if the IP has changed (one line: :if)

# to disable, set line below to: ":if ($currentIP != 1) do={"

:if ($currentIP != $previousIP) do={
:log info "OpenDNS: Update needed"
:set previousIP $currentIP

# The update URL. Note the "\3F" is hex for question mark (?). Required since ? is a special character in commands.

# Some older editions of the MicroTik/WinBox OS require the following line instead (http) whereas newer versions require https.

# :local url "http://updates.opendns.com/nic/update\3Fhostname=$odnshost"


:local url "https://updates.opendns.com/nic/update?hostname=$odnshost"
:log info "OpenDNS: Sending update for $odnshost"

/tool fetch url=($url) user=$odnsuser password=$odnspass mode=http dst-path=("/net_odns.txt")

:delay 2;

:local odnsReply [/file get net_odns.txt contents];

:log info "OpenDNS update complete."

:log info "OpenDNS reply was $odnsReply";

} else={

:log info "OpenDNS: Previous IP $previousIP and current IP equal, no update need"
}