# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Bump build version
- Rewrite modifier key handling (#110)
- Hide hint automatically
- Improve key-buffering workaround delay (#104)
- Move to MPL 2.0 license (#102)
- Update asset and build versions
- Remove deprecated locale changing (#106)
- Add CODEOWNERS file
- Add fonts
- Add minimal build script and static assets (#77)
- Remove UIA usage for caret
- Revert "fix caret position tracking"
- Prioritize MSAA over UIA & update GCP_UIA
- Check update over https (#64)
- Update about credits (#63)
- Remove obsolete urls/captions (#60)
- Update version-info (#57)
- Enable 64bit build
- Add english option at the end of suggestions
- Improve TEnglishToRegEx.Convert
- Replace $AD with $2212 for ANSI ro-fola
- Update gitignore
- Reformat project with delphi 12
- Update readme
- Update clsSkinLayoutConverter.pas
- Remove NativeXML, PCRE DW dependency from spellchecker
- Removed NativeXML from Skin Editor
- Removed NativeXML from Layout Editor
- Migrate to RegularExpressions & remove unused Units
- Remove JclAnsiStrings
- Migrate to FireDAC
- Migrate to TNetHTTPClient
- Use IXMLDocument
- Replace TJvBalloonHint

### Fixed

- Fix multi-monitor and dpi-scaling problems (#109)
- Fix cdata and encoding in xml handlers (#107)
- Fix hotkey dropdown style in options dialog (#105)
- Fix caret tracking
- Fix Topbar icon flickering
- Fix encoding problem in the spellchecker (#69)
- Hack: fix caret tracking in chrome/vscode etc
- Fix caret position tracking (#54)
- Fix building 64bit binary
- Fix some controls in the options window
- Fix process exit
- Fix dpi/scaling issues
- Fix conditional defines and add project group

### Added

- Add assets directory
- Add debug logging

## [5.6.0] - 2019-08-27

### Changed

- Bump version
- Turn locale changing off by default

### Fixed

- Fix build errors

### Removed

- Remove old tools that are not necessary anymore

## [5.5.0] - 2014-02-09

### Changed

- Updated resources with Windows 8.1 compatibility
- Replaced readme.txt with markdown
- Updated .gitignore
- Replaced outdated autodict.dct with the latest one
- Edited autodict.dct

### Fixed

- Added period to automatic decimal mark convertion (instead of dari) when the next character is a number.
- Fixed typo in readme.md
- Fixed NativeXML site
- Spell checker tools menu shortcut fix
- Spell checker popup shortcut fix

## [5.1.0] - 2010-12-30

### Changed

- Final update to 5.1.0

## [5.0.8] - 2010-10-23

### Changed

- Release ready. Updated to version 5.0.8!
- Finalizing to version 5.0.8
- Lots of changes in String type
- Updated spell checker backend
- Updated spell checker frontend
- Updated Layout Editor project
- Updated skin designer project
- Updated UnicodeToAnsi converter
- Updated PCRE
- Finalized spell checker GUI and library
- Better VBA compatibility.
- Separated Spell checker GUI and Core Library

### Fixed

- Fixed locale bug in ANSI mode and fixed some compiler warnings
- Fixed dll unload bug.

### Removed

- Removed Delphi fundamentals

## [5.0.7] - 2010-10-05

### Changed

- Release ready. Updated version to 5.0.7
- Added ANSI support in Avro Mouse and corrected a typo.
- Finalized ANSII support. Added options and warning.
- Bijoy support in phonetic.
- Added Phonetic quick options in tools menu
- Tools menu rearranged
- Enhanced faded label in option dialog box.
- Added apply button in option dialog with faded notification.
- Updated font fixer icon
- Added Data Directory textbox in About dialog box
- Updated systray icon again. The previous one sucks!
- Added hint in tray icon
- Changed systray icon
- Added options TabBrowsing, PipeToDot, EnableJoNukta in Phonetic.
- FAQ edit in Readme.txt

### Fixed

- Fixed a little bug in refresh setting during startup.
- Fixed Bijoy support bugs in phonetic and added bijoy support to fixed keyboard layouts!
- Fixed Photoshop layer drag issue
- Fixed bug: Not saving settings and candidate options during shutdown

## [5.0.0] - 2010-10-01

### Added

- Initial Commit
