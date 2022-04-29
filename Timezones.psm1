#############################################################################################################
# Import the module using import-module Timezones.psm1 before using the function.
# Module name- Timezones.psm1.
#  ----Functions: Get-CommonTimeZone
#    ----Description: 1. Fetches all the timezones present in timezones.json and filers it out depending upon 
#                        paramter name or offset provided.
#                     2. Either of the parameters could only be provided i.e Name or offset  but not both together.
#    ----Examples:    1. Get-CommonTimeZone -Offset 4.5 | Format-Table
#                     2. Get-CommonTimeZone -name asia | Format-Table   
#                     3. Get-CommonTimeZone | Format-Table
#############################################################################################################

function  Get-CommonTimeZone{
    ##setting default parameterset to vairable Name
    [CmdletBinding(DefaultParameterSetName = 'Name')]

    param(
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Name')]
        [String] $Name,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'Offset')]
        [ValidateRange(-12, 12)] ##valid range for the offset variable would be -12 to 12
        [float] $Offset
    
    )

    try{
        ##instead of specifying the raw value of url, an xml file could be created from where the value could be extracted.

        $url="https://raw.githubusercontent.com/dmfilipenko/timezones.json/master/timezones.json"
        $urljson=Invoke-WebRequest -Uri $url -ErrorAction Stop        
    
    }
    catch{
        ##error action if the url is not active
        Write-Error ("Unable to reach url " + $url)
    
    }

    $json_obj=$urljson.content | ConvertFrom-Json
    
    if($Name -ne ''){
        $exp=" " + $Name + " "   ##regular expression to match the extact value of the name provided.
        return $json_obj | where {$_.value -match $exp}
    }
    elseif($Offset -ne ''){
        return $json_obj | where{$_.offset -eq $Offset}
    }
    else{
        
        return $json_obj
    }
    

}