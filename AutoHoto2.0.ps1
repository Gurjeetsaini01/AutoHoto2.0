# Get the ID and security principal of the current user account
$myID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myPrincipal = New-Object Security.Principal.WindowsPrincipal($myID)

# Check if the current user has administrative privileges
if (!$myPrincipal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    # Relaunch the script with administrative privileges
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "--            ==========================================================================="  -ForegroundColor DarkGreen
Write-Host "--            =                                                                         ="  -ForegroundColor DarkGreen
Write-Host "--            =                               AutoHoto 2.0                              ="  -ForegroundColor DarkGreen
Write-Host "--            =                    Automate Windows Hotspot By Mr.Saini                 ="  -ForegroundColor DarkGreen
Write-Host "--            =                                                                         ="  -ForegroundColor DarkGreen
Write-Host "--            ==========================================================================="  -ForegroundColor DarkGreen

Write-Host "                                   ---------Made By Gurjeet Saini---------" -ForegroundColor DarkCyan
Write-Host "                                   -----------------PUNJAB----------------" -ForegroundColor DarkGreen
Write-Host
Write-Host
Write-Host "--Saving Needed Files AutoHoto2.0.bat and AutoHoto2.0.vbs To C:\AutoHoto2.0\"
Write-Host
# Define the folder path where the files will be saved. use a safe folder to protect it from tempring by others or unwanted delete. 
$folderPath = "C:\AutoHoto2.0"

# Check if the directory exists, and create it if it doesn't
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath -Force
}

# Define the content of the .bat file
$batContent = @"
@echo off
set result=
for /f "tokens=*" %%a in ('netsh wlan start hostednetwork') do set result=%%a
powershell.exe -Command "New-BurntToastNotification -Text '%result%'"
"@

# Define the content of the .vbs file
$vbsContent = @"
Dim folderPath, objShell
folderPath = "$folderPath"
Set objShell = CreateObject("WScript.Shell")
objShell.Run folderPath & "\AutoHoto2.0.bat", 0, True
"@

# Create the .bat file and save it to the folder path
Set-Content -Path "$folderPath\AutoHoto2.0.bat" -Value $batContent

# Create the .vbs file and save it to the folder path. i used VBS to avoid Flash of CMD window on execution
Set-Content -Path "$folderPath\AutoHoto2.0.vbs" -Value $vbsContent

# Add Hotspot Profile (it adds a new profile, you can modify ssid and password key as you want in bellow line
Write-Host "--Adding Hotspot Profile with Name - MyAutoHotspot Password - 123qwe123"
Write-Host
NETSH WLAN set hostednetwork mode=allow ssid=MyAutoHotspot key=123qwe123 | Out-Null

# Powershell Module "BurntToast" is needed to display windows Notification, and to verify Successfull turn on of Hotspot.
# its good to have it in case of hotspot failiure, and to know its on now, because hotspot icon in bottom right pannel will remain grey or show off status even its on.
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
Write-Host "--Adding Module 'BurntToast' to display windows Notifications When it Turns On"
Write-Host
$ModuleName = "BurntToast"

if (-not (Get-Module -Name $ModuleName -ListAvailable)) {
    Write-Host "--Module '$ModuleName' not found. Installing..."
    Install-Module -Name $ModuleName -Force -Scope CurrentUser -Confirm:$false
} else {
    Write-Host "--Module '$ModuleName' already installed."
}
Write-Host
#Task Scheduler - script below will add a task to automate the script when you sign in. later you can see and modify it by going in winndows task scheduler utitlity.
#To See that Go To - Control Panel>System and Security>Windows Tools>Task scheduler
Write-Host "--Adding Task in to Task scheduler for Automating it on sign in"
Write-Host
# Define the name and path of the program to run
$programName = "C:\AutoHoto2.0\AutoHoto2.0.vbs"

# Define the name of the scheduled task
$taskName = "Auto Start Hotspot on Sign In"

# Define the description of the scheduled task
$taskDescription = "Auto Start Hotspot on Sign In."

# Define the name of the trigger that will run the task on user sign-in
$triggerName = "At log on"

# Define the username and password of the user account to run the task as
$username = "$env:USERNAME"

# Create a new scheduled task with administrative privileges
$taskAction = New-ScheduledTaskAction -Execute $programName
$taskPrincipal = New-ScheduledTaskPrincipal -UserId $username -RunLevel Highest
$taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -RunOnlyIfNetworkAvailable -DontStopIfGoingOnBatteries
$taskTrigger = New-ScheduledTaskTrigger -AtLogOn -User $username
$task = Register-ScheduledTask -Action $taskAction -Principal $taskPrincipal -Settings $taskSettings -Trigger $taskTrigger -TaskName $taskName -Description $taskDescription -Force

# Set the password of the user account to run the task as -Password $password
Set-ScheduledTask -TaskName $taskName -User $username | Out-Null

# Enable the scheduled task
Enable-ScheduledTask -TaskName $taskName | Out-Null

if ($?) {
Write-Host
Write-Host
    Write-Host "
-----------------------------successfully Automated The Hotspot.------------------------------" -ForegroundColor DarkGreen
Write-Host
Write-Host "-----------------Your Hotspot Name is MyAutoHotspot and Password is 123qwe123 ---------------" -ForegroundColor DarkRed
Write-Host "
----------------------------------------Enjoy-------------------------------------------------" -ForegroundColor DarkGreen
}

$fileName = "BurntToast.png"

# Set the Base64 encoded PNG image data
$imageData = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAEhlJREFUeJztXP1zFEUa7vwHluVP/jnUFWXVVd0PlFVCgZZl4fdpIcXOKigsH0YOCCkEAmcIblS4nMV3TIghgaOEEEngQkgIiUASYiDfhANUPLm+fnu6Z9/t9MzO7G52O6Ff6qnZnX62+/14+mMGlBBr1qxZs2bNmjVr1qxZs2bNmjVr1qxZs2bNmjVr1qxZs2ZtdoxSWkL/SxNwtbx5bBDwQrow8Qx9JkEocfGYg5LfGdw/CS3mOe9Z+mwCciNFwUUy1wUCAYw8GaEQmAg0/Q8kIT0Z+j9PG4+JZOGvC+ndJ3cTxa5hViaXuGVPlpmX3LnHm1urABR/+vF0sZOWH95j8f1/GlDEmW3eEzI3zgvgZP/jfun0TMD93xCeFt6vAnDvDw2eiPZfgnmwJRgrBG/mw+zR4Q8RoMQflqfl+eXvd7f90eNHtNi11hrs+WlLGAY4/5Dhgbj+nifew6eMB3l5xA7TJho78CXSlkWJx8JxCR1HAtrvI96vGvwmOBJPI8+0gyF/XHlE0pcyuZ+B09Pi+quGkwtPx5FQeY80kLx7c4z3EHZcg84C7Jk1kbaUPRSOMqdLJktc5x8p7SbyHvhwpwVvmqSWYhUF5vGcG2P32b6El6kHQrUT4voAtT3NPCm4CSS8IN54AO+eIWcBvhTdc9Uql1zu9BhyfloDy4vOu5f++cCjA4li199d/ieFcwCmWjIqrvLepALJG0E8lWN5wTwmkBfHXyy+AJ6ZfCbhOcacInfFVed4Jt6E8n1U8EY1vAnEh/Y7iDehwTzkPT/+fPEFwJxJcMdAtcPiOiEUrKLQvDH0+a7g3dVwxhAX2n9GvDENTOGNmnAOuMucANUOCfWOCYWqGBPtc5U3gj4PC96wpp8RxIX2QcQb0SAX3rAJAhhkTgwKVY4IZaoYEe2Wl8IdcR0SvCGfvjBvAPFcsSaKXX5CfhICuCOUqeKOCLBfXC0vf7xBEwRwSzjzs4IhcR0Qzg9oOJgHnFuIN6RBFJ467nzk9ZsggH6xAqgYQsXqJ6mlLlveoODcFFc/zqDg3BDXQZREFX0I+P6AQNRxC827aYIAYAuQCcOJ0xWhEDwoZq97dYYd6txx6PbR7TQ5kaQnpk7Q5qlmeIFCD08fprUPamnHdAfHj/d/5G21U7W0eqKalo+W0/idOCU9xEUvEqmKAUVMfoIbEDH0iWuuvJ9MEEAvc+KWSI5MkDqzbmmQL54UBmuLD8Vp5WglbZpsohMTE7745eEvHPB5cnLSw9TU1AzA/Vv3bnFxfDH6BXWGnFRhbiL/hOi0MUgA5zoS000NovC6TRBAD3PiBkoIdl4WR0U+eJBsNjMTwwlaP1lP7zy84xUtqPgqwggAoP6mbrKObhzeSEkX8+Oa8DEf8V534+JXHUcC2q+YIABQoZyd17gq3WtfAMLyegSnB80y9j1+O06Pjx7XFmw2BCC54+PjHPg349Pj9NjoMXdluIZWgqA4wsabiWeUANSi9mogeV2Cq+NIQHun4F53P8OM8yuUbtb6Idffj42NeWIAYDHxVaGTpM4N3Uq81zXIlnfVBAGACruUYvVocF20R+EJlA6V5rWAsykACS6Ey3yWpgRxTYOe9Fgj8YxYAdqYEzJIuQqouCbaw/I6CE+eM+jMSgEz/T7TthFGABJOv+PG3aVBt4i1Q+SmO4B3RcO7ZIIALjAnOmbOWg9dqYKG4rWzwv+kL3yhkE8BeEK46aQmgMRlBF1OMK9dw2szRQBydqvoFI5j54N4rYSOT4wXpMhBwMXVIRsBcGFNTrhx6orqlxfMU9uNEECbWAF0aOdOule5CqjoEJxzxDtp5zpDc/39bAlAAmIlF0PkJVP+LpggAHBCF0CbCLLNJ0AJNuvjfXEv8ZDcfArg0tQl/pi25/YeurF/I3VuONTpZehxAcXg3wFs69l4ayOtGKygR0eO0vbJ9lkRAN8S2Hje6qjisshdq7he9uEZIYDzzAnVsVYEvyDb3Vk/OZUqar4EsH9oPy80aSEuZCIvIv9aFP/aEEf6/gPDWUJjPTFaNVjFfZPIVQDeltAixpbQ+demQTv3LVHs8hOWpISXuDbh+DmSCuyiBm1uYiEBQUWF+7oXMroC7OrfRZ1rDu83reDquGH9a0GQomC/i12L0T2De3LagtKeWKbEliB9xv5hMWJIXrMJAgAVtqYSxGfNOR/HJc6kZn6uAoj1xnh/vPC6cWVCz7njktPuFcSCwX8v+zgb0J/sk8UJW0iuAvBEIPOmyx8WYyvy0QgBnGFOtKSWS35tCcBpt/jq83pUAcBM9Aqljit8gcImbiRo9e1q2jzaTDsnO+nQ9JDvzIX/srlhsoE23m6kyYEkXde3jsa6Yqn+z80cg4tJEUJUAXgiaA6RP5znM6YIQCSCX/GMU8E4m3s3a1/YhBUAP7idQbNAjnvWFRcUHQqezRlC/g0h3uslvh74msa6xWpzhqSvOj+kCyEbAQAgN57QdDirjGvECnCSOSGWVS8ZKuTy20B839hlEgA/MJ1KU7+7nMOsYfd33tgZ/vAV4kWPH65OXuVjkXpFfBKN6WebKAIA8HjUPmW8zeIqV4FTJgigTghAdRoD2pvY496VeFYCiHfHadoYp91ExzpiNDmYjHwKz0UAAMmrHqzmovYKcyYlAqfT/21mkADinfGZq4wQuScO2XbSFAFgh1U0uQnhAuiMLgA+006j/iARJwgdGx/L+jEsXwKQ8FaE0yhe8JPdiyyAK0Lsp1G8DeIqVz2JOlME0CzUiSFmKXe+UXyvD78FwCthnlTcH/vuXHFyfg7PtwAkwDfyHYq32fVZ3RICt4AGFDPOny7HtSYIAJxoEspvEkptEo5LyPvs82e9n2UsgFf8UwhH3b8nyKbQ6lu8bAscBtz3WsV3RQSBh8CGgPypMEIAx5kTjUKlaOnzcAq1NfJlyytkYPElHxJwhER6zCqmALyt65hSxLqUCHwfA+XqgfPXqPQjAfcPmyCAo8wJJVAPOscBLNC1V9fSC3cv0L4HfbT/fj89+fNJ6vzbcYOWPFjyL8982TIXBADg8dSlYmaThcfTMNxAB/4zQIfuD9HWkVa6rmsdP9d4PIkGRQwSkvdPEwQAKpSO1SLoHMe84+7M5jMFcEKIRnK+818pchXAjakbtGeqh7aPtHPA5ygCCDs+9wEeX2V8MkYZu4xf5usEQr0ymepQfiTnHyYIAFQog5KoU5QsEZbH4LTrX7NmI4C6/jq6rWsbjV2M0VhrLJV8jMPEbWco6yqj9f31eREAXwlYLLzQPrHK1cGbDN8pk0niO8Q5ZsoKACpkBzQPtYqSJWoRJxOvhuQ8A2HmwXJLviUuDoX0T4iBX791l2x1Jcrmn6Tx8XPNy1HkozErwAHmhEzY8QDIxB5W1I5x3C2Uc9F/9mcSAC/8j6Lwx9CYeFyZRImjQiA6/44KIbSmhJCNAJxLjtuXGq/OP11edLwDJgigmjlxCCVLxTGRXIlMPJZsWIKzEYBXeFlUOftrBA6yZb6FLfNtMbrp35votqvbOOBz7Ed2/1yMczhX9oPB2pwWx/vLrCgCKOsuc+M7ovHvW40ow/C+NkEAXzIn8OzGOKI4H4bHkr+hY0MkAfCD1kGlvxo+Q6hz3uH7/6mhU94hMNMhr+nnJl4wKDbv9xASkeg3SAQ6AaztWJvaig4r/R1WJsmhkLxqEwQATuAi4z0XO39Iw/HhQdHCCoAXqUbp8yt3psolW30KiHLK51vKBYf3mTYO+xxviYffAs6j88hBBF1OwvK+NEEAVcyJGqWIOudVThDvYPDLIu9gVaX0B0v0Ocd74eL3GJjNYx4XwnkntUVIVJGMAvBWqLB5EbHASjNjvPSxE8UuPyGVzAkcFDj2DUKNEnRY3v4AEUBC9yn85Mx37vkUQFox9ytj7/X/K2DOT+YxL5hXaaIAvkKQ9w5oAlB5BzRIujP6m2vf8Ofymt4ad8nfr/Aq9QWYDQF4Rd2rxLHPfVKo6auh9QP1NNmXdH1NRog3Km+3CQLYw5z4JlUwDwcUJUtkw6tCn79CnK/c2ZfpRVDeBSB4rAApv6Q/+xGkr0kNT0U2PCMEAE7oAvdDPnmV/sUvhAC4CCqEL0kNdHHkk2eMAKrELK3ycRzP5HzxWAJWt64uugBWX1jtFkP4NCOOfZo4cBGTgiOhtgfxdpoggHLmRKU7G7WOS1Qi5IPHZt6R3iMZiznbAB/4eWA24q3KwNthggDKhADwrN2ngLWX7C1xnVfbsuSRzwltvtWcU+Gqu6o5chHS9ze+d7cBvzh0+cgXr9wkAeigK6oPFzgSvv3JviDhOwl/KohSrC1tW6jT5HDxkF3uKsKvO1xAG3Ci9AlPKPwwqPgXNo6ceGWmCACWQA2407vF1YcTmlc5k+f8K/iNoXcGgH9ltI24hcJ9SgFUoHvA2Rr8IgrDOe14v+d+7QoZbz54W00QADhRIZKoYqfP/XzxdmQuFC/+DuV3e5X+9mrGCtt3ORISXln8EJW3O4DzNxME8BlzYrdwVIIltmSHq94ZbfnmbfMvlHPKSSVR6Y8XrtwtNP+uGxe2hUb9KrPz0k53VRHF8vyrCBGH33i7U4XnPCkUP3xqggDAiZ0iiSJACXxfRV55rJDOSYdvCaXnS93CbxEzSOWWMWwidMMPG2hVRxUHfCal7P72meNykbAtAfqEvuNn4y63vADx7vLhScGtN0UAnyN1lyP16rADzT45A/0Qlbc9A58VvuJihe+SDm1ecdV+wt7LRxxheUYIAJyQyZcoDwDmqUHj4Fl7SVlJxv6AIxE47vrgt4YYZB3J2F/YcWeVZ4wAYC+U2B6A2eSp4sJiLM38H2xi8MPdZuJuFzpsRfDjFIKXMEEAa5kTsN9uUQqiYgtCgXlOXbT/7Rw/QNY7M/sqi+jfZoGtAdicA2+tCQJYzZzYrCRGBXa+0DzY99sqIgvAOw/k6t9WH45a1Ez9lQrg33xsggA+FALwQ6mP84Xisf28trs2sgBqu2r5ucGYOHS81SYIAJwoVRyVzn6KoONIQPsmgSDepix4TAAnr5+MLID6nnr+26zHLQTPMUEA4AQutMQGBF27jlfqwynNsj9I3CeEJi8lIwsg2Z50BaD254di8IwQwCrmxAbF4fUIaluheCiJcKCLfAhkB0cugHUhxl2HUEjeShMEAE7gxGPn1wegkDwn/DsA711ALMS4umKt9/kN3PsEta3zwScIfhzJe98EAaxgTmTjfKF5KyK8CHqfwAnbjDh0v/lE+GeEAMAJ4VDJmpJU4nwAHIlC8shHDO9mFgF5z+UW2r+seKYIIM2pj4keuiDh/pqZXN7+EUnvb40GHyHo2nU8Nrs/PvkxfzRsH2jngM9wjxf/w4j9FZP3VxME8A5z4kOUOD98iJArb43CU5Oj9uco/cH3D1wxcKwk7p7vCAT55xjEe8cEAbzBnJAJ9gN23jSeLrlqH/hzzKc/3EcMwQlArrw3TBDAciEAP6xCeNp5MYW3MoAnsRIhpmC5KQJYpQS+CgW4EgVqeeF5uuKrnNdMEAA4sVJxFgB77Apx1bVLrECwvGi8V00RwAei0BLvI6htfryVmvYVIfuTicK8FQGYDzxoM+EM8Nzq5xLwfJ3m9HvKdz8Ui6f669fXuyH6LBbvbUJ57ottL+x+IUHeRI6/iwLww3zivZ2B967Cy4SwvOWELvr7ouILgFJawvYi1/G3QwRgefnhvQypZ7k3whaxvegtQkveKkkPRAG0S1he9jy+4i42YP+XtmDrggRfBd4KADj9ukAQ73WENwPwNPNYrvnWa4rxpWiR4mQhsDxE+/J5yPuLScu/NEpKyBLFWcBrCGrbXOUVE4sZINdG2itsX3oFOfsqQlBQTzMvCl4mhrz88TG+LLHliYsAIygoywvHg+IbufQrxh38M3N2iXBaFQPGywiW589bMkeKL407uowtVYuUYDCWIfhxAEsFZ6nyGxVLEeYTD3LIHvnmTPHTDA4rfxJB4MCWICwNQLY8P76OZyIWi5wtIAYf+EIaKHfhpwsTTAgJfj6AwF4SyJQEiWLzdL95Sdx/yee3i1H7S4jvB8gL5Ae2T5YryNncnPUBJsXw7KvPuoJYQNyrigUIunYTeEH++/ED2iAn87Lo1qxZs2bNmjVr1qxZs2bNmjVr1qxZs2bNmjVr1qxZs2bNmrWC2/8BRc7uKNJ5HDYAAAAASUVORK5CYII="

# Convert the Base64 encoded image data to bytes
$imageBytes = [System.Convert]::FromBase64String($imageData)

# Combine the folder path and file name to get the full path to the PNG file
$fullPath = Join-Path C:\Users\abcd\Documents\WindowsPowerShell\Modules\BurntToast\0.8.5\Images $fileName

# Overwrite the existing PNG file with the decoded image data
[System.IO.File]::WriteAllBytes($fullPath, $imageBytes)

# hide module for safety
$env_user = $env:USERNAME
$folder_path = "C:\Users\$env_user\Documents\WindowsPowerShell"
if (Test-Path $folder_path) {
    Set-ItemProperty -Path $folder_path -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) -Force
} else {
    Write-Host "Folder path not found: $folder_path"
}


Read-Host "All Done, Press Enter to exit..."