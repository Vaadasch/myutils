# Modify the folder path HERE
$path = "<PATH OF FOLDER>"

# Specify the delai to add or remove
$diff = @{
    # To substract (-1) or to add( 1 ) at the subtitles times
    "diff" = -1
    "min" = 0
    "sec" = 1
    "msec" = 0
}

$dif = (Get-Date -Year 1 -Month 1 -Day 1 -Minute $diff.min -Second $diff.sec).addmilliseconds($diff.msec)

$files = Get-ChildItem $path | where { $_.Extension -eq ".srt" -and $_.CreationTime}

foreach ($file in $files) {
    $content = Get-Content $file.fullname
    $oldPathFile = $file.fullname
    $file.moveTo("$($file.fullname).back")
    
    
    foreach ($line in $content) {
        if ($line -match "^([0-9]{2}):([0-9]{2}):([0-9]{2}),([0-9]{3})(.*)([0-9]{2}):([0-9]{2}):([0-9]{2}),([0-9]{3})$") {
            $h1 = $Matches[1]
            $m1 = [int]($Matches[2]) + ($diff.min * $diff.diff)
            $s1 = [int]($Matches[3]) + ($diff.sec * $diff.diff)
            $ms1 = [int]($Matches[4]) + ($diff.msec * $diff.diff)
            
            if ($ms1 -lt 0) { 
                $ms1 += 1000
                $s1 -=1
            }
            if ($s1 -lt 0 ) {
                $s1 += 60
                $m1 -=1
            }
            if ($m1 -lt 0) {
                $m1 += 60
                $h1 -= 1
            }

            if ($ms1 -gt 1000) { 
                $ms1 -= 1000
                $s1 +=1
            }
            if ($s1 -gt 60 ) {
                $s1 -= 60
                $m1 +=1
            }
            if ($m1 -gt 60) {
                $m1 -= 60
                $h1 += 1
            }

            if ($h1 -lt 0)  { 
                $h1 = 0
                $m1 = 0
                $s1 = 0
                $ms1= 300
            }

            $separator = $Matches[5]
            $h2 = [int]($Matches[6])
            $m2 = [int]($Matches[7]) + ($diff.min * $diff.diff)
            $s2 = [int]($Matches[8]) + ($diff.sec * $diff.diff)
            $ms2 = [int]($Matches[9]) + ($diff.msec * $diff.diff)
            
            if ($ms2 -lt 0) { 
                $ms2 += 1000
                $s2 -=1
            }
            if ($s2 -lt 0 ) {
                $s2 += 60
                $m2 -=1
            }
            if ($m2 -lt 0) {
                $m2 += 60
                $h2 -= 1
            }

            if ($ms2 -gt 1000) { 
                $ms2 -= 1000
                $s2 +=1
            }
            if ($s2 -gt 60 ) {
                $s2 -= 60
                $m2 +=1
            }
            if ($m2 -gt 60) {
                $m2 -= 60
                $h2 += 1
            }
            
            
        
        
            $h1 = "{0:D2}" -f $h1
            $m1 = "{0:D2}" -f $m1
            $s1 = "{0:D2}" -f $s1
            $ms1 = "{0:D3}" -f $ms1
            $h2 = "{0:D2}" -f $h2
            $m2 = "{0:D2}" -f $m2
            $s2 = "{0:D2}" -f $s2
            $ms2 = "{0:D3}" -f $ms2
        
            $line = "$h1`:$m1`:$s1,$ms1$separator$h2`:$m2`:$s2,$ms2"
            
            
        }

        Out-File -FilePath $oldPathFile -InputObject $line -Append
    }
        
      


}
