function Copy-File ($Session, $FilePath, $DestinationPath) {

    $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FilePath))
    Invoke-Command -Session $Session -ScriptBlock {
        [IO.File]::WriteAllBytes($Using:DestinationPath, [Convert]::FromBase64String($Using:base64string))
    }

}