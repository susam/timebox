@echo off & goto :main

rem Timebox

rem The MIT License (MIT)
rem
rem Copyright (c) 2013-2020 Susam Pal
rem
rem Permission is hereby granted, free of charge, to any person obtaining
rem a copy of this software and associated documentation files (the
rem "Software"), to deal in the Software without restriction, including
rem without limitation the rights to use, copy, modify, merge, publish,
rem distribute, sublicense, and/or sell copies of the Software, and to
rem permit persons to whom the Software is furnished to do so, subject to
rem the following conditions:
rem
rem The above copyright notice and this permission notice shall be
rem included in all copies or substantial portions of the Software.
rem
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
rem EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
rem MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
rem IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
rem CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
rem TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
rem SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


rem Starting point of this script.
:main
    setlocal

    rem Script data.
    set VERSION=0.5.0
    set AUTHOR=Susam Pal
    set COPYRIGHT=Copyright (c) 2013-2020 %AUTHOR%
    set LICENSE_URL=https://susam.github.io/licenses/mit.html
    set SUPPORT_URL=https://github.com/susam/timebox/issues
    set NAME=%~n0

    rem Timer data.
    set DEFAULT_DURATION=30
    set LOG_FILE=%userprofile%\timebox.log
    set CONF_FILE=%userprofile%\.timeboxrc

    rem Parse arguments and start timer.
    set minute=60
    set duration_arg=
    set comment_arg=
    call :parse_arguments %*
    call :parse_configuration
    call :timer %duration_arg% "%comment_arg%"

    endlocal
    goto :eof


rem Parse command line arguments passed to this script.
rem
rem Arguments:
rem   arg...: All arguments this script was invoked with.
:parse_arguments
    set arg=%~1
    rem Handle command line arguments
    if "%arg%" == "-w" (
        call :where_am_i
        goto :eof
    ) else if "%arg%" == "--where" (
        call :where_am_i
        goto :eof
    ) else if "%arg%" == "-m" (
        if "%~2" == "" (
            call :err "%arg%" must be followed by an integer.
            goto :eof
        )
        set minute=%~2
        shift
        shift
        goto :parse_arguments
    ) else if "%arg%" == "--qtpi" (
        call :qtpi
        goto :eof
    ) else if "%arg%" == "-h" (
        call :show_help
        goto :eof
    ) else if "%arg%" == "--help" (
        call :show_help
        goto :eof
    ) else if "%arg%" == "/?" (
        call :show_help
    ) else if "%arg%" == "-v" (
        call :show_version
        goto :eof
    ) else if "%arg%" == "--version" (
        call :show_version
        goto :eof
    ) else if "%arg:~0,1%" == "-" (
        call :err Unknown option "%arg%".
        goto :eof
    )
    if not "%arg%" == "" (
        if "%duration_arg%" == "" (
            set duration_arg=%arg%
            shift
            goto :parse_arguments
        )
    )
:consume_comment
    if not "%~1" == "" (
        if "%comment_arg%" == "" (
            set comment_arg=%~1
        ) else (
            set comment_arg=%comment_arg% %~1
        )
        shift
        goto :consume_comment
    )
    if "%duration_arg%" == "" (
        set duration_arg=%DEFAULT_DURATION%
    )
    set arg=
    goto :eof


rem Parse configuration file.
:parse_configuration
    rem If configuration file does not exist, there is nothing to parse.
    if not exist %CONF_FILE% goto :eof

    rem quiet: Do not beep in the middle of timebox.
    findstr "\<quiet\>" %CONF_FILE% > nul
    if not errorlevel 1 set quiet=yes

    rem qtpi: Special message.
    findstr "\<qtpi\>" %CONF_FILE% > nul
    if not errorlevel 1 set qtpi=yes

    rem sober: "EOT" instead of smileys at the end of timebox.
    findstr "\<sober\>" %CONF_FILE% > nul
    if not errorlevel 1 set sober=yes

    goto :eof

rem Run a time box timer for the specified number of minutes.
rem
rem Arguments:
rem   duration: Number of minutes.
:timer
    setlocal
    set /a duration = %~1
    if errorlevel 1 (
        call :err Bad duration: "%~1".
        goto :eof
    )
    if %duration% equ 0 (
        call :err Bad duration: "%~1".
        goto :eof
    ) else if %duration% geq 1000000000 (
        call :err Bad duration: "%~1".
        goto :eof
    )
    set comment=%~2
    for /l %%i in (%duration%, -1, 0) do call :minute %%i
    endlocal
    goto :eof


rem If the time remaining in the time box is greater than zero, then
rem this subroutine sleeps for one minute before returning.
rem
rem Arguments:
rem   time_left: Time remaining in the time box.
:minute
    setlocal
    set time_left=%~1

    rem Display time remaining in the terminal window.
    title %time_left%

    rem Print current time and time remaining at the beginning of a
    rem time box and when the time remaining is a multiple of 5 minutes.
    set /a mod = %time_left% %% 5
    if %time_left% == %duration% (
        call :print_time %time_left%
    ) else if %mod% == 0 (
        call :print_time %time_left%
    )

    rem Beep at the beginning of the time box, 15 minutes from the end,
    rem 5 minutes from the end and at the end of the time box.
    if %time_left% == %duration% (
        call :beep 2
    ) else if %time_left% == 15 (
        if not %duration% == 15 (
            if not "%quiet%" == "yes" (
                call :beep 1
            )
        )
    ) else if %time_left% == 5 (
        if not %duration% == 5 (
            if not "%quiet%" == "yes" (
                call :beep 2
            )
        )
    ) else if %time_left% == 0 (
        call :beep 4
    )

    rem Determine smileys to use at the end of time box.
    if "%qtpi%" == "yes" (
        set console_msg=:-* :-* :-* :-* :-*
        set desktop_msg=":-*    :-*    :-*    :-*    :-*"
    ) else if "%sober%" == "yes" (
        set console_msg=EOT
        set desktop_msg=EOT
    ) else (
        set console_msg=:-^^^) :-^^^) :-^^^) :-^^^) :-^^^)
        set desktop_msg=":-)    :-)    :-)    :-)    :-)"
    )

    set log_msg=%date% %time:~0,-3% - %duration%
    if not "%comment%" == "" (
        set log_msg=%log_msg% - %comment%
    )

    if not %time_left% == 0 (
        rem Sleep for a minute.
        call :sleep %minute%
    ) else (
        rem Display smileys and write log at the end of the time box.
        echo %console_msg%
        msg %username% /w /time:10 %desktop_msg%
        >> "%LOG_FILE%" echo %log_msg%
    )

    endlocal
    goto :eof


rem Print the current time and the time remaining in the time box.
rem
rem Arguments:
rem   time_left: Time remaining in the time box.
:print_time
    setlocal enabledelayedexpansion
    rem Pad the time remaining with zeroes on the left side, so that we
    rem can select a substring of fixed size from the right side in
    rem order to display the time left values as a fixed width column.
    rem We do not allow a duration that exceeds nine digits. Therefore,
    rem padding with eight zeroes is sufficient.
    set time_left_padded=00000000%~1

    rem Determine the number of characters in the duration string. We
    rem will use these many characters to print the time left in order
    rem to display the time left values as a fixed width column.
    call :strlen %duration% len

    rem Replace any spaces with zeros so that the current time values
    rem are displayed as a fixed width column.
    set time_curr=%time: =0%

    rem Display time remaining in HH:MM:SS - N format where the string
    rem length of N equals the string length of specified duration.
    rem Note: The time_curr variable contains time in HH:MM:NN.DD
    rem format. That is why we remove the last three characters from it.
    echo %time_curr:~0,-3% - !time_left_padded:~-%len%!
    endlocal
    goto :eof


rem Play one or more beeps.
rem
rem Arguments:
rem   count (optional): Number of beeps to play, defaults to 1.
:beep
    setlocal
    if "%~1" == "" (
        set /a count = 1
    ) else (
        set /a count = %~1
    )
    for /l %%i in (1, 1, %count%) do (
        set /p a="" < nul
    )
    endlocal
    goto :eof


rem Sleep for specified number of seconds.
rem
rem Arguments:
rem   seconds: Number of seconds to sleep.
:sleep
    setlocal
    set /a count = %~1 + 1
    ping -n %count% 127.0.0.1 > nul
    endlocal
    goto :eof


rem Get the length of a string.
rem
rem Arguments:
rem   str: String.
rem   len_var_name: Name of variable that should be set with the length.
:strlen
    setlocal enabledelayedexpansion
    set str=%~1.
    set len_var_name=%~2
    set len=0

    if not "%str:~256,1%" == "" (
        call :err String too large.
        goto :eof
    )

    for %%i in (128 64 32 16 8 4 2 1) do (
        if not "!str:~%%i,1!" == "" (
            set /a len += %%i
            set str=!str:~%%i!
        )
    )
    endlocal & (
        set %len_var_name%=%len%
    )
    goto :eof


rem Show the path of this script.
:where_am_i
    echo %~f0
    call :pause
    goto :eof


rem Print dedication.
:qtpi
    setlocal enabledelayedexpansion

    set dedication=For Sunaina, for all time
    call :strlen "%dedication%" len
    set /a indentation = (80 - %len%) / 2

    echo %cmdcmdline% | findstr /i /c:"%~nx0" > nul && set mode=explorer
    if "%mode%" == "explorer" (
        for /l %%i in (1, 1, 11) do echo.
        for /l %%i in (1, 1, %indentation%) do (
            set dedication= !dedication!
        )
        echo !dedication!
        for /l %%i in (1, 1, 12) do echo.
        call :pause
    ) else (
        echo.
        echo     %dedication%
    )
    endlocal
    goto :eof


rem Print error message.
rem
rem Arguments:
rem   string...: String to print to standard error stream.
:err
    >&2 echo %NAME%: %*
    call :pause
    goto :eof


rem Pause if this script was invoked from command prompt.
:pause
    echo %cmdcmdline% | findstr /i /c:"%~nx0" > nul && pause > nul
    goto :eof


rem Show help.
:show_help
    setlocal
    echo Usage: %NAME% [-w] [-h] [-v] [DURATION [MESSAGE ...]]
    echo.
    echo The timeboxing script runs for the number of minutes specified
    echo as the duration argument. If no duration argument is specified,
    echo it runs for %DEFAULT_DURATION% minutes.
    echo.
    echo Options:
    echo   -w, --where     Display the path where this script is present.
    echo   -h, --help, /?  Display this help and exit.
    echo   -v, --version   Display version information and exit.
    echo.
    echo Examples:
    echo   %NAME%                 Run a %DEFAULT_DURATION% minute time box.
    echo   %NAME% 15              Run a 15 minute time box.
    echo   %NAME% 30 write essay  Specify a comment to be recorded in log.
    echo.
    echo Report bugs to ^<%SUPPORT_URL%^>.
    call :pause
    goto :eof


rem Show version and copyright.
:show_version
    echo Timebox %VERSION%
    echo %COPYRIGHT%
    echo.
    echo This is free and open source software. You can use, copy, modify,
    echo merge, publish, distribute, sublicense, and/or sell copies of it,
    echo under the terms of the MIT License. You can obtain a copy of the
    echo MIT License at <%LICENSE_URL%>.
    echo.
    echo This software is provided "AS IS", WITHOUT WARRANTY OF ANY KIND,
    echo express or implied. See the MIT License for details.
    call :pause
    goto :eof
