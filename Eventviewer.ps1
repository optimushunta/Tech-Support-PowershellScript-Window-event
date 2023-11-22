$Computername = 'SUPPORT', 'SUPPORT'
$StartTime = [datetime]::today
$EndTime = [datetime]::now

<# Event Log Levels
    1 = Critical
    2 = Error
    3 = Warning
    4 = Information
    5 = Verbose 
    #>  
$Levels = @('Placeholder-0','Critical','Error', 'Warning', 'Information', 'Verbose')

$EventFilter = @{
    Logname = 'System','Application'
    Level   = 2,3
    StartTime = $StartTime
    EndTime   = $EndTime
}

# Make sure you change the path to your path
$OutputPath = 'C:\Users\nurul\Documents\CEH'      

foreach($Computer in $Computername) {
    try {
        $Events = Get-WinEvent -ComputerName $Computer -Verbose:$false -ErrorAction Stop -FilterHashtable $EventFilter 
    
        foreach ($Event in $Events) {
            $Output = [PSCustomObject]@{
                Computer    = $Computer
                TimeCreated = $Event.TimeCreated
                LogName     = $Event.LogName
                Level       = $Levels[$Event.Level]
                Message     = $Event.Message
                Properties  = $Event.Properties
            }

            # Output to Screen
            $Output | Format-List | Out-Host

            # Export to File 
            $Output | Out-File (Join-Path $OutputPath "Window_event_log-$Computer.txt") -Append
        }

    } catch {
        Write-Warning "Error connecting to server: $Computer - $($Error[0])"
    }
} 
