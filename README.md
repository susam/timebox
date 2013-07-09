Introduction
------------
Timeboxing is a time management technique that is believed to boost
productivity by limiting the time during which a task is supposed to be
completed. A time box is a fixed period of time alloted for a task or
activity. The period of time to spend on the task is decided first. One
time box may last anywhere between 15 minutes to 45 minutes. The
duration of a time box may depend on the task or activity.
Alternatively, the task may be scoped in a manner that it can be
completed in a time box. Then a timer is started with the decided time
interval. Once the timer notifies that the time interval has expired,
any activity or work on the task is stopped, and a short break is taken
before beginning another time box.

This project offers a script called timebox.cmd that runs on Microsoft
Windows systems. It can be used to run a time box for a specified
duration.


Installation
------------
Since this is just a one file script, installing it simply requires
downloading the timebox.cmd file and copying it to some directory
present in the Windows PATH variable. To download this script, visit
<https://github.com/susam/timeboxing> and click the 'ZIP' button. Then
unzip the downloaded file and copy the timebox.cmd file from it into a
directory specified in the Windows PATH variable.

There are various ways to check the Windows PATH variable.

  1. Open 'Command Prompt' and run the command: echo %PATH%.
  2. Hold down the 'Windows' key and press the 'Break' key to launch the
     'System Properties'. It can also be launched by right clicking
     'My Computer' and selecting 'Properties'. If you are on
     Windows Vista, Windows 7 or a later version of Windows, click
     'Advanced system settings'. Click 'Advanced' tab. Click
     'Environment variables' button. Look for the 'PATH' variable in
     'System variables' section.

Once timebox.cmd is placed in a directory specified in the Windows PATH
variable, it can be launched from command prompt by simply executing the
command:

    timebox

The above command runs a 30 minute time box.


Getting started
---------------
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


Usage
-----
    Usage: timebox [OPTION] [DURATION]

    The timeboxing script runs for the number of minutes specified
    as the duration argument. If no duration argument is specified,
    it runs for 30 minutes. If the duration argument is echo not
    a multiple of 5, it is rounded down to a multiple of 5.

    Options:
      -w, --where     display the path where this script is present
      -h, --help, /?  display this help and exit
      -v, --version   display version information and exit

    Examples:
      timebox         run a 30 minute time box
      timebox 15      run a 15 minute time box
      timebox 10      run a 10 minute time box

    Report bugs to <susam@susam.in>.


Version
-------
    timebox 0.1
    Copyright (c) 2013 Susam Pal


License
-------
This is free software. You are permitted to redistribute and use it in
source and binary forms, with or without modification, under the terms
of the Simplified BSD License. See the LICENSE.txt file for the complete
license.

This software is provided WITHOUT ANY WARRANTY; without even the implied
warranties of MERCHANTABILITY and FITNESS FOR A PARTICULAR PURPOSE. See
the LICENSE.txt file for the complete disclaimer.

If you do not have a copy of the LICENSE.txt file, please visit
<http://susam.in/licenses/bsd/> to obtain a copy of the license.
