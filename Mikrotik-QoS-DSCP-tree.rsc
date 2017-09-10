#Set interface here
:global outboundInterface "ether1"
#Set bandwidth of the interface (remember, this is for OUTGOING)
:global interfaceBandwidth 20M
#Set where in the chain the packets should be mangled
:global mangleChain postrouting

#Don't mess with these. They set the parameters for what is to follow
:global queueName ("qos_" . $outboundInterface . "_OUT")
:global qosClasses [:toarray "netcon,intercon,critical,flash_override,flash,immedate,priority,routine"]
:global qosIndex 64

#Set up mangle rules for all 64 DSCP marks
#This is different in that the highest priority packets are mangled first.
:for indexA from 63 to 0 do={
    /ip firewall mangle add \
    action=mark-packet \
    chain=$mangleChain \
    out-interface=$outboundInterface \
    comment=($outboundInterface . "_OUT_dscp_" . $indexA) \
    disabled=no \
    dscp=$indexA \
    new-packet-mark=($outboundInterface . "_OUT_dscp_" . $indexA) \
    passthrough=no
}


#Add a base queue to the queue tree for the outbound interface
/queue tree add \
    max-limit=$interfaceBandwidth \
    name=$queueName \
    parent=$outboundInterface \
    priority=1 \
    queue=ethernet-default

#Set up queues in queue tree for all 64 classes, subdivided by 8.
:for indexA from=0 to=7 do={
    :local subClass ([:pick $qosClasses $indexA] . "_" . $outboundInterface)
    /queue tree add \ 
        name=$subClass \
        parent=$queueName \
        priority=($indexA+1) \
        queue=ethernet-default
    :for indexB from=0 to=7 do={
        :set qosIndex ($qosIndex-1)
        /queue tree add \
        name=($subClass . "_" . $indexB) \
        parent=$subClass \
        priority=($indexB+1) \
        packet-mark=($outboundInterface . "_OUT_dscp_" . $qosIndex) \
        queue=ethernet-default
    }
}