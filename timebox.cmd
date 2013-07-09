@echo off

goto :start
rem Timeboxing script

rem Copyright (c) 2013 Susam Pal
rem All rights reserved.
rem
rem Redistribution and use in source and binary forms, with or without
rem modification, are permitted provided that the following conditions
rem are met:
rem     1. Redistributions of source code must retain the above copyright
rem        notice, this list of conditions and the following disclaimer.
rem     2. Redistributions in binary form must reproduce the above
rem        copyright notice, this list of conditions and the following
rem        disclaimer in the documentation and/or other materials provided
rem        with the distribution.
rem
rem THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
rem "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
rem LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
rem A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
rem HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
rem SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
rem LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
rem DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
rem THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
rem (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
rem OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

:start
    setlocal

    rem Script data
    set VERSION=0.1
    set COPYRIGHT=Copyright (c) 2013 Susam Pal
    set LICENSE_URL=http://susam.in/licenses/bsd/

    rem Script settings
    set LOG=Yes
    set TIME_LOG=%~dp0\timeboxes.txt
    set DEFAULT_DURATION=30

    rem Determine how the script is executed and set global variables
    rem accordingly
    if /i "%COMSPEC%" == "%CMDCMDLINE%" (
        set MODE=Console
        set NAME=%0
    ) else (
        set MODE=Explorer
        set NAME=%~nx0
    )

    rem Handle command line arguments
    if %~1. == . (
        call :timer %DEFAULT_DURATION%
    ) else if %~1. == -w. (
        call :where_am_i
    ) else if %~1. == --where. (
        call :where_am_i
    ) else if %~1. == -h. (
        call :help
    ) else if %~1. == --help. (
        call :help
    ) else if %~1. == /?. (
        call :help
    ) else if %~1. == -v. (
        call :version
    ) else if %~1. == --version. (
        call :version
    ) else if %~1. == --qtpi. (
        call :qtpi
    ) else (
        call :timer %~1
    )

    endlocal
    goto :eof

:timer
    setlocal enabledelayedexpansion
    set /a duration = %~1

    rem Validate duration
    if %duration% EQU 0 (
        call :bad_duration_error
        goto :eof
    ) else if %duration% LSS 5 (
        call :less_duration_error
        goto :eof
    ) else if %duration% GTR 90 (
        call :more_duration_error
        goto :eof
    )

    rem Round down duration to a multiple of five
    set /a duration = (%duration% / 5) * 5

    rem Beep and start timer
    call :beep 2
    for /l %%i in (%duration%, -5, 5) do (
        rem Display time left
        set time_left=0%%i
        echo !time:~0,-3! - !time_left:~-2!

        call :pre_sleep %duration% %%i
        call :sleep 300
    )

    rem End timer
    echo %time:~0,-3% - 00
    if %LOG%. == Yes. (
        set duration=0%duration%
        echo %date% %time:~0,-3% - !duration:~-2!>>%TIME_LOG%
    )

    rem Beep and display smileys
    call :beep 4
    echo     
    msg %username% /w /time:10 ":-)    :-)    :-)    :-)    :-)"

    endlocal
    goto :eof

:pre_sleep
    setlocal

    rem Beep if fifteen minutes remain in a time box longer than
    rem fifteen minutes
    set duration=%~1
    set time_left=%~2
    if not %duration% == 15 (
        if %time_left% == 15 (
            call :beep 1
        )
    )

    endlocal
    goto :eof

:sleep
    setlocal
    set /a seconds = %~1 + 1
    ping -n %seconds% 127.0.0.1 > nul
    endlocal
    goto :eof

:beep
    setlocal
    if %~1. == . (
        set /a count = 1
    ) else (
        set /a count = %~1
    )
    for /l %%i in (1, 1, %count%) do (
        set /p a="" < nul
    )
    endlocal
    goto :eof

:string_length
    setlocal enabledelayedexpansion
    set str=%~1.
    set len=0
    for %%i in (256 128 64 32 16 8 4 2 1) do (
        if not "!str:~%%i,1!" == "" (
            set /a len += %%i
            set str=!str:~%%i!
        )
    )
    (
        endlocal
        set %~2=%len%
        goto :eof
    )

:echo_newlines
    for /l %%i in (1, 1, %~1) do (
        echo.
    )
    goto :eof

:echo_center
    setlocal enabledelayedexpansion
    set msg=%~1
    call :string_length "%msg%" len
    set /a horizontal_gap = (80 - %len%) / 2
    for /l %%i in (1, 1, %horizontal_gap%) do (
        set msg= !msg!
    )
    echo %msg%
    endlocal
    goto :eof

:where_am_i
    echo %~f0
    if %MODE% == Explorer (
        pause > NUL
    )
    goto :eof

:help
    setlocal
    set DD=%DEFAULT_DURATION%
    echo Usage: %NAME% [OPTION] [DURATION]
    echo.
    echo The timeboxing script runs for the number of minutes specified
    echo as the duration argument. If no duration argument is specified,
    echo it runs for %DD% minutes. If the duration argument is echo not
    echo a multiple of 5, it is rounded down to a multiple of 5.
    echo.
    echo Options:
    echo   -w, --where     display the path where this script is present
    echo   -h, --help, /?  display this help and exit
    echo   -v, --version   display version information and exit
    echo.
    echo Examples:
    echo   %NAME%         run a %DD% minute time box
    echo   %NAME% 15      run a 15 minute time box
    echo   %NAME% 10      run a 10 minute time box
    echo.
    echo Report bugs to ^<susam@susam.in^>.
    if %MODE% == Explorer (
        pause > NUL
    )
    endlocal
    goto :eof

:version
    echo %NAME% %VERSION%
    echo %COPYRIGHT%
    echo.
    echo This is free software. You are permitted to redistribute and use it in
    echo source and binary forms, with or without modification, under the terms
    echo of the Simplified BSD License. See ^<%LICENSE_URL%^> for
    echo the complete license.
    echo.
    echo Written by Susam Pal.
    if %MODE% == Explorer (
        pause > NUL
    )
    goto :eof

:qtpi
    setlocal enabledelayedexpansion
    set dedication=For Sunaina, for all time
    if %mode% == Console (
        echo.
        echo     %dedication%
    ) else (
        call :echo_newlines 11
        call :echo_center "%dedication%"
        call :echo_newlines 12
        pause > NUL
    )
    endlocal
    goto :eof

:bad_duration_error
    setlocal
    set error_msg=ERROR: Duration must be a positive integer
    echo %error_msg%
    if %MODE% == Explorer (
        pause > NUL
    )
    endlocal
    goto :eof

:less_duration_error
    setlocal
    set error_msg=ERROR: Duration must be at least 5 minutes
    echo %error_msg%
    if %MODE% == Explorer (
        pause > NUL
    )
    endlocal
    goto :eof

:more_duration_error
    setlocal
    set error_msg=ERROR: Duration must not exceed 90 minutes
    echo %error_msg%
    if %MODE% == Explorer (
        pause > NUL
    )
    endlocal
    goto :eof
