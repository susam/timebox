Changelog
=========

0.4.0 (2019-08-25)
-----------------

### Fixed

- Use `osascript` and not `xmessage` to display messages on macOS even
  if `xmessage` is installed.


0.3.0 (2017-03-02)
------------------

### Added

- Display time remaining in the title bar of Windows Command Prompt.
- Tweak behaviour with configuration file at ~/.timebox.conf.
- Configuration option 'quiet': Do not beep in the middle of time box.
- Configuration option 'sober': Show "EOT" instead of smileys at the end.


0.2.0 (2016-06-05)
------------------

### Added

- Timebox script for Linux and OS/X.
- Beep twice when 5 minutes are left.


### Changed

- Minimum possible duration of a time box is 1 minute.
- Maximum possible duration of a time box is 999999999 minutes.
- Use integer duration as is; don't round it down to a multiple of 5.


0.1.0 (2013-07-14)
------------------

### Added

- Timebox script for Windows.
- Minimum possible duration of a time box is 5 minutes.
- Maximum possible duration of a time box is 90 minutes.
- Duration is rounded down to a multiple of 5 minutes.
- Beep twice at the beginning of a time box.
- Beep once when 15 minutes are left.
- Beep four times at the end of a time box.
- Display a dialog box with smileys at the end of a time box.
