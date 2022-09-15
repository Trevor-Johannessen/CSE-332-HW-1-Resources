$pairs = Import-Csv -Path "D:/Desktop/Song Titles and Artists.csv"
$objects = @()
$songsToRedo = @()
$iteration = 1

$pairs | ForEach-Object {
    $title = $_.Name
    $artist = $_.artist 
    $url = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=b0cbf77a0961cc6eaab4d50b6fd30c3d&artist=$artist&track=$title&format=json" 
    $info = curl -uri $url -UseBasicParsing
    Write-Output "`n`n`nURL : $url"
    Write-Output $info
    Write-Output "Iteration = $iteration"
    $iteration++
    $info = ($info.Content | ConvertFrom-Json).track
    if($info -NE $null){
        $objects += $info
    } else {
        $songsToRedo += $_
    }
}

$table = @(
	$objects | %{
		[PSCustomObject]@{
			'name' = $_.name
			'artist' = $_.artist
			'plays' = $_.playcount
		}
	}
)

$table | Export-Csv -Path "D:/downloads/songs.csv"


