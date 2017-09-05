# Script to ensure wireless lan radio is ON or OFF #
# between user selected times #
# The radio ON/OFF operation will not be performed if the system #
# clock is not in sync with local time, unless so required #
# Remember router is set back to default time after a reboot #
# Schedule this script at required intervals #

#####################################
## Set the Radio ON and OFF times here ##
:local RadioOnTime "05:30";
:local RadioOffTime "18:30";

# set to "no" if clock is being set manually after each reboot #
# set to "yes" if clock is being set using NTP client #
:local UseNTPClientStatus "yes";
#####################################

#debug :log info "RadioOnOff Script Starting";
# get the name of the wlan radio interface #
#:local RadioName [/interface get [find type=wlan] name];
:local RadioName "wlan2";
#debug :log info "Radio Name = $RadioName";

# First check if system clock has been syncronized with local time #
:local NTPSyncState [/system ntp client get active-server];
#debug :log info "NTP Client Status = $NTPSyncState";

# Don't perform radio On or Off operation, if current real time is unknown, unless required #
:if ([:len $NTPSyncState] > 0 ) do {

    :local CurrentTime [/system clock get time];
    #debug :log info "Current Time = $CurrentTime";
    
    # Check current ON or OFF status of radio #
    :local RadioDisabled [/interface get $RadioName disabled];
    #debug :log info "Radio Disabled = $RadioDisabled";
    
    
    # Where the ON time is set earlier than the OFF time #
    :if ($RadioOnTime < $RadioOffTime) do {
    
        # Radio should be ON between these times #
        :if (($CurrentTime > $RadioOnTime) and ($CurrentTime < $RadioOffTime)) do {
        
            if ($RadioDisabled=true) do {
                :log info "Radio was OFF, now switching ON";
                /interface enable $RadioName;
            }
        } else {
        
            if ($RadioDisabled=false) do {
                :log info "Radio was ON, now switching OFF";
                /interface disable $RadioName;
            }
        }
    }

    # Where the ON time is set later than the OFF time #
    :if ($RadioOnTime > $RadioOffTime) do {
    
        # Radio should be OFF between these times #
        :if (($CurrentTime < $RadioOnTime) and ($CurrentTime > $RadioOffTime)) do {
        
            if ($RadioDisabled=false) do {
                :log info "Radio was ON, now switching OFF";
                /interface disable $RadioName;
            }
        } else {
        
            if ($RadioDisabled=true) do {
                :log info "Radio was OFF, now switching ON";
                /interface enable $RadioName;
            }
        
        }
    
    }
    
} else {
    
    :log info "System clock may not be synchronized to local time, unable to perform operation";
    
}

#debug :log info "RadioOnOff Script completed";
