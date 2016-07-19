Timebox
=======
Timebox is a timer script that may be used to practice timeboxing.

[![Download][SHIELD_WIN]][DOWNLOAD_WIN]
[![Download][SHIELD_LIN]][DOWNLOAD_LIN]
[![Build Status][BUILD_IMG]][BUILD_URL]
[![Coverage Status][COVERAGE_IMG]][COVERAGE_URL]

The Windows script has been tested on Windows 7 only. However, it should
work fine on other recent versions of Windows too.

The Linux/OS X script has been tested with [bash][bash], [ksh][ksh] and
[zsh][zsh] on Debian and OS X as well as with [dash][dash] and
[posh][posh] on Debian. It should work fine on any POSIX compliant
system with a POSIX compliant shell.

[SHIELD_WIN]: https://img.shields.io/badge/download-timebox%2ecmd%20for%20Windows-brightgreen.svg
[SHIELD_LIN]: https://img.shields.io/badge/download-timebox%20for%20Linux%2fOS%20X-brightgreen.svg
[DOWNLOAD_WIN]: https://github.com/susam/timebox/releases/download/0.2.0/timebox.cmd
[DOWNLOAD_LIN]: https://github.com/susam/timebox/releases/download/0.2.0/timebox

[BUILD_IMG]: https://travis-ci.org/susam/timebox.svg?branch=master
[BUILD_URL]: https://travis-ci.org/susam/timebox
[COVERAGE_IMG]: https://coveralls.io/repos/github/susam/timebox/badge.svg?branch=master
[COVERAGE_URL]: https://coveralls.io/github/susam/timebox?branch=master

[bash]: https://packages.debian.org/stable/bash
[ksh]: https://packages.debian.org/stable/ksh
[zsh]: https://packages.debian.org/stable/zsh
[dash]: https://packages.debian.org/stable/dash
[posh]: https://packages.debian.org/stable/posh


Contents
--------
* [Introduction](#introduction)
* [Getting Started](#getting-started)
* [License](#license)
* [Support](#support)


Introduction
------------
Timeboxing is a time management technique that is believed to boost
productivity by limiting the time during which a task is supposed to be
completed. A time box is a fixed period of time alloted for a task or
activity. The period of time to spend on the task is decided first. One
time box may last anywhere between 15 minutes to 45 minutes. The
duration of a time box may depend on the task or activity.
Alternatively, the task may be scoped in a manner that it can be
completed in a fixed size time box. Then a timer is started with the
decided time interval. Once the timer notifies that the time interval
has expired, any activity or work on the task is stopped, and a short
break is taken before beginning another time box.

This project offers scripts for Windows as well as Linux/OS X that may
be used to run a time box for a specified duration.


Getting Started
---------------
Timebox is a single-file executable script.

Download [`timebox.cmd`][DOWNLOAD_WIN] for Windows,
or [`timebox`][DOWNLOAD_LIN] for Linux or OS X.

Copy it to a directory specified in the PATH environment variable. On
Linux or OS X, make the script executable: `chmod u+x timebox`.

To run a 30 minute time box, run the script without any arguments.

    timebox

The script accepts one integer argument that specifies the duration of
the time box in minutes. For example, the following command also runs a
30 minute time box.

    timebox 30

The following command runs a 15 minute time box.

    timebox 15

To learn more about the usage of the script, run the following command.

    timebox --help

After the script starts, it displays a countdown starting with the
specified duration to 0. The countdown is displayed at the beginning of
a time box and whenever the number of minutes remaining in the time box
is a multiple of 5. On Windows, the time remaining is also displayed in
the title bar of the Command Prompt window; the title bar is updated
every minute.

Two beeps are played at the beginning of a time box. If the duration of
the time box is longer then 15 minutes, one beep is played when 15
minutes are remaining in the time box. If the duration of the time box
is longer than 5 minutes, two beeps are played when 5 minutes are
remaining in the time box. Four beeps are played at the end of a time
box. A dialog box with smileys is displayed for ten seconds at the end
of a time box.


License
-------
This is free and open source software. You can use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of it,
under the terms of the MIT License. See [LICENSE.md][L] for details.

This software is provided "AS IS", WITHOUT WARRANTY OF ANY KIND,
express or implied. See [LICENSE.md][L] for details.

[L]: LICENSE.md


Support
-------
To report bugs, suggest improvements, or ask questions, please create a
new issue at <http://github.com/susam/timebox/issues>.
