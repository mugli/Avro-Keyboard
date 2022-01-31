
# Avro Keyboard #
Unicode compliant open source Bangla typing software (IME).
Visit: [http://www.omicronlab.com](http://www.omicronlab.com "OmicronLab") for latest version.


## How to compile: ##

This section describes briefly how to compile Avro Keyboard from source. 

1. If you need further help regarding codes from OmicronLab, 
you can contact us at: [http://forum.omicronlab.com/](http://forum.omicronlab.com/ "OmicronLab Forum")

2. If you need assistance regarding codes from 3rd party
libraries used in Avro Keyboard (see below for list), contact 
respective authors of that library.


## Required Delphi Version: ##

**Delphi 10.4**


## Required 3rd party libraries:  ##



**Before compiling, you have to install the following 3rd party
libraries in you Delphi environment:**


1. **ICS**.
Freeware with Source Code.
Site: http://www.overbyte.eu/

If you are ready with the above mentioned requirements,
the delphi project files (*.dpr) should be compiled without any problem.


## Building Standard and Portable editions ##
Open 
ProjectDefines.inc file in the root folder of the source.

For building portable edition, add the following line in this file and compile:

    {$Define PortableOn} 

For building standard edition, remove the above line from the
file or make it a comment like the following and then compile:

    {.$Define PortableOn} 
or,

    //{$Define PortableOn} 


## License ##

From version 5x, Avro Keyboard goes open source from freeware, licensed under **MOZILLA PUBLIC LICENSE Version 1.1**. You should
receive a copy of the license in MPL-1.1.txt file
with both binaries and source. An online version of the license can be found at: [http://www.mozilla.org/MPL/](http://www.mozilla.org/MPL/ "http://www.mozilla.org/MPL/")

**Copyright © OmicronLab. All Rights Reserved.**
