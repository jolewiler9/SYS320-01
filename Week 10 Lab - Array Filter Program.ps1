# Storyline: Print a list of Services and allow filtering of them by Status
function service_check(){

    cls

    # List current services
    $Services = Get-Service | Select DisplayName
    $Services | Out-Host

    # Array for services
    $arrServices = @("all", "Stopped", "Running")

    $readServices = Read-Host -Prompt "Please enter a status you would like to filter for or q to quit the program"

    # Check for quit
    if ($readServices -match "^[qQ]$"){

        break

    } elseif ($arrServices -notcontains $readServices){

        Write-Host "Invalid choice. Filters are 'all', 'Stopped', 'Running'"

        sleep 5

        service_check

    } elseif ($readServices -ne "all"){

        Get-Service | Where-Object {$_.Status -eq $readServices} | Select-Object Status, DisplayName

    } else {

        Get-Service | Select-Object Status, DisplayName | Sort-Object Status

    }


}

service_check

