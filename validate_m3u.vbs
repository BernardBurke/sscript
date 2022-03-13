option explicit

Const ForReading = 1 
Const ForWriting = 2 
Const ForAppending = 8

dim AtLeastOneDeadRecord 

dim fso,strInputFile,tsInput,tsOutput,strFixedFileContents

wscript.echo "Good morning "

wscript.echo "Args " & wscript.arguments.count


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

set tsInput = fso.opentextfile(strInputFile,ForReading)


Do Until tsInput.AtEndOfStream

	dim record, fname

	record = tsInput.readline

	if not fso.fileExists(record) then

		wscript.echo "Missing file " & record

		AtLeastOneDeadRecord = true
	
	else

		strFixedFileContents = strFixedFileContents & record & vbCrLf

	end if
	

loop


tsInput.close()

if AtLeastOneDeadRecord then

	wscript.quit(0)

else 
	wscript.quit(1)

end if

