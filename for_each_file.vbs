option explicit

Const ForReading = 1 
Const ForWriting = 2 
Const ForAppending = 8

dim fso, objFolder, objFile, strInputDir, strFileType, strFile, cFiles, strCommand


strFileType = "edl"

strCommand = "cscript /nologo validate_edl.vbs "



if wscript.arguments.count = 0  then

	wscript.echo "Please provide a Directory name"

	wscript.quit
else
	
	strInputDir = wscript.arguments(0)

end if


set fso = createobject("scripting.FileSystemObject")

if not fso.folderExists(strInputDir) then 

	wscript.echo "Folder " & strInputDir & " does not exist"

	set fso = nothing

	wscript.quit

end if 

if wscript.arguments.count = 2 then

    strFileType = wscript.arguments(1)

end if

strFileType = ucase(strFileType)
strFileType = strFileType & " File"

if wscript.arguments.count = 3 then

    strCommand = wscript.arguments(2)

end if


set objFolder = fso.GetFolder(strInputDir)

set cFiles = objFolder.files

for each objFile in cFiles
    'wscript.echo objFile.type & " comparing to " & strFileType
    if strFileType = objFile.type then
        
        wscript.echo strCommand & ""  & objFile.path
        wscript.echo "echo %errorlevel%"
        'wscript.echo "pause"
        
    end if
    ' if objFile.Extension = strFileType then
    '     wscript.echo "Processing " & objFile.name
    ' end if
next