
function Copy-Function ($Session, $Name) {

    $FunctionString = Invoke-Expression "`${Function:$Name}"
    Invoke-Command -Session $Session -ScriptBlock {
        Invoke-Expression "function $Using:Name { $Using:FunctionString }"
    }

}