option explicit

Const ForReading = 1 
Const ForWriting = 2 
Const ForAppending = 8

dim AtLeastOneDeadRecord 

dim fso,strInputFile,tsInput,tsOutput, strFixedFileContents, objEnv, strTEMP, WshShell


if wscript.arguments.count = 0  then

	wscript.echo "Please provide a filename"

	wscript.quit
else
	
	strInputFile = wscript.arguments(0)

end if


set fso = createobject("scripting.FileSystemObject")

if not fso.fileExists(strInputFile) then 

	wscript.echo "File " & strInputFile & " does not exist"

	set fso = nothing

	wscript.quit

end if 

Set WshShell = CreateObject("WScript.Shell")

Set objEnv = WshShell.Environment("Process")

strTEMP = objEnv("TEMP")

set tsInput = fso.opentextfile(strInputFile,ForReading)

if tsInput.readline = "# mpv EDL v0" then 

	wscript.echo "mpv header found!"

	strFixedFileContents = strFixedFileContents & "# mpv EDL v0" & vbLf

else

	wscript.echo "mpv header NOT found, exiting"

	wscript.quit

end if

Do Until tsInput.AtEndOfStream

	dim record, fname

	record = tsInput.readline

	'wscript.echo "record " & record

	if mid(record,1,1) = "#" then
	
		'wscript.echo "Comment "
	else 

		fname = split(record,",")

		if ubound(fname) <> 2 then

			wscript.echo "something wrong with this record " & record

			AtLeastOneDeadRecord = true
		
		end if

		'wscript.echo "fname is " & fname(0)

		if not fso.fileExists(fname(0)) then
	
			wscript.echo "Missing file " & fname(0)

			AtLeastOneDeadRecord = true

		else
			
			strFixedFileContents = strFixedFileContents & record & vbLf

		end if
	

	end if
	

loop


tsInput.close()

if AtLeastOneDeadRecord then

	dim objFileTmp, strTmp, strOutPath, strTSOut,strBlankUnixFile


	set objFileTmp = fso.GetFile(strInputFile)

	strOutPath = strTEMP & "\" & fso.GetFileName(objFileTmp)

	strBlankUnixFile =strTEMP & "\UnixEmptyFile.txt"

	fso.CopyFile strBlankUnixFile, strOutPath

	set strTSOut = fso.opentextfile(strOutPath,ForAppending)

	strTSOut.write strFixedFileContents

	strTSOut.close

	wscript.quit(0)

	'wscript.echo strFixedFileContents 


else 
	wscript.quit(1)

end if

