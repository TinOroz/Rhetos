IF NOT EXIST Install\ MD Install
DEL /F /S /Q Install\* || GOTO Error0
IF EXIST Install\*.zip ECHO ERROR: Cannot delete old files in Install folder. Check if the files are locked. && GOTO Error0
RD /S /Q Install\Rhetos
IF EXIST Install\Rhetos ECHO ERROR: Cannot delete old files in Install folder. Check if the files are locked. && GOTO Error0

SET Config=%1%
IF [%1] == [] SET Config=Debug

CALL Source\Rhetos\GetServerFiles.bat %Config% /NOPAUSE || GOTO Error0

REM Packing the files with an older version of nuget.exe for backward compatibility (spaces in file names).
IF NOT EXIST Install\nuget.exe POWERSHELL (New-Object System.Net.WebClient).DownloadFile('https://dist.nuget.org/win-x86-commandline/v4.5.1/nuget.exe', 'Install\nuget.exe') || GOTO Error0

Install\NuGet.exe pack Rhetos.nuspec -OutputDirectory Install || GOTO Error0
Install\NuGet.exe pack CommonConcepts\Rhetos.CommonConcepts.nuspec -OutputDirectory Install || GOTO Error0

MD Install\Rhetos
MD Install\Rhetos\bin

XCOPY /Y/D/R Source\Rhetos\bin\*.dll Install\Rhetos\bin || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\bin\*.pdb Install\Rhetos\bin || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\bin\*.exe Install\Rhetos\bin || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\bin\*.config Install\Rhetos\bin || GOTO Error0
DEL /F /Q Install\Rhetos\bin\ConnectionStrings.config

XCOPY /Y/D/R Source\Rhetos\*.aspx Install\Rhetos\ || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\*.asax Install\Rhetos\ || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\Web.config Install\Rhetos\ || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\Template.RhetosPackages.config Install\Rhetos\ || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\Template.RhetosPackageSources.config Install\Rhetos\ || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\*.linq Install\Rhetos\ || GOTO Error0
XCOPY /Y/D/R Source\Rhetos\*.svc Install\Rhetos\ || GOTO Error0

XCOPY /Y/D/R ChangeLog.md Install\Rhetos\ || GOTO Error0
XCOPY /Y/D/R Readme.md Install\Rhetos\ || GOTO Error0

@REM ================================================

@ECHO.
@ECHO %~nx0 SUCCESSFULLY COMPLETED.
@EXIT /B 0

:Error0
@ECHO.
@ECHO %~nx0 FAILED.
@IF /I [%2] NEQ [/NOPAUSE] @PAUSE
@EXIT /B 1
