****************************************************************
Avro Keyboard :: Unicode compliant open source Bangla typing software
Copyright © OmicronLab. All Rights Reserved.
Visit: http://www.omicronlab.com for latest version
****************************************************************

From version 5x, Avro Keyboard goes open source from freeware. You should
receive a copy of MOZILLA PUBLIC LICENSE Version 1.1 in MPL-1.1.txt file
with both binaries and source. An online version of the license can be found
at: http://www.mozilla.org/MPL/

You should check the license file before proceeding, to know your rights as
well as OmicronLab's. Please read below for some helpful MPL FAQs.



------------------------------------------------------------------------------------------------
How to compile:
------------------------------------------------------------------------------------------------

This section describes briefly how to compile Avro Keyboard from source. 

1) If you need further help regarding codes from OmicronLab, 
you can contact us at: http://www.omicronlab.com/forum/

2) If you need assistance regarding codes from 3rd party
libraries used in Avro Keyboard (see below for list), contact 
respective authors of that library.



Required Delphi Version: 
------------------------------

Delphi 2007. 

Other versions of Delphi may or may not compile the source successfully. 
[Delphi has changed default string type from AnsiString to UnicodeString 
since Delphi 2009. So versions after 2007 are very likely to produce 
a lot of compiler errors!]




Required 3rd party libraries: 
--------------------------------

This source includes the following 3rd party libraries:

1) NativeXml. 
Open source. 
Site: http://www.simdesign.nl/xml.html

2) Portions of Delphi Fundamentals. 
Open source.
Site: http://sourceforge.net/projects/fundementals/

3) PCRE Delphi wrapper.
Open source.
Author: Renato Mancuso <mancuso@renatomancuso.com>

Before compiling, you have to install the following 3rd party
libraries in you Delphi environment:

1) DISQLite3
Freeware (Not open source)
Site: http://www.yunqa.de/

2) ICS
Freeware with Source Code.
Site: http://www.overbyte.be/

3) Delphi Jedi (JVCL and JCL)
Open source.
Site: http://www.delphi-jedi.org/

4) TNT Unicode Controls
Author: Troy Wolbrink
In late March 2007, the free TNT Unicode Controls turned 
commercial. They are no longer available for download 
from their old home, but it is still possible and legal to 
download them from: http://www.yunqa.de


If you are ready with the above mentions requirements,
the delphi project files (*.dpr) should be compiled without any problem.




------------------------------------------------------------------------------------------------
How to build Standard and Portable editions of Avro Keyboard
------------------------------------------------------------------------------------------------

It is easy. You should get a ProjectDefines.inc file in the root folder of the source.

For building portable edition, add the following line in this file and compile:
{$Define PortableOn} 

For building standard edition, remove the above line from the
file or make it a comment like the following and then compile:
{.$Define PortableOn} 
or,
//{$Define PortableOn} 




------------------------------------------------------------------------------------------------
MPL FAQ (Know your rights):
------------------------------------------------------------------------------------------------
Q: Does OmicronLab retain copyright once source is published under the MPL?
A: Absolutely. It is a common misconception that open source projects don't
have copyrights, but that's not true. There are certain distinctions between open
source and public domain softwares. As the initial developer, OmicronLab still retains 
all copyrights of the project. 

Q: Can OmicronLab  release the code under a different (possibly commercial type) license later?
A: Yes. Since OmicronLab has the original copyright, they can do it for their own code, 
and not for any contributions from others. But be informed that we don't have any intension
to go commercial. If we had, we wouldn't release our code!

Q: Can I use the MPL code in commercial software? If yes, am I obligated to credit the author?
A: Yes, you can use the MPL code in any commercial software. Since you have to include the MPL 
code, the credit is included in the license header. While not required, it is also customary to credit 
the author in "AboutBox". 

Also if you modify some portions of the project and release your work, make sure it is named
something new (like, don't name your project Avro Keyboard, Avro spell checker etc.).

Q: Must I release the source code of used codes?
A: Only of those covered by MPL, together with any modifications to them. 

Q: Must I publish my apps under MPL if I used MPL licensed code (the viral aspect) ?
A: No. That's the big advantage over GPL - you can use different code, mix MPL and commercial 
code, but you don't have to release either the application, nor the non-MPL code under MPL. 
Basically, what is MPL, will stay MPL, but it doesn't have any impact on the non-MPL code. 

Q: If a bug in MPL licensed code renders my clients machine unbootable, 
who can I hold responsible for that?
A: Nobody. You use MPL licensed code at your own risk. Since it is provided to 
you in a source code form, you can inspect it, test it, making sure that it does, 
what you want it to do. 

Q: Must I publish modifications to MPL licensed code?
A: Yes. This is one of the MPL requirements. You are getting a free source code, 
but you have to publish all modifications to the code, unless you have done the 
changes for your internal use. 

Q: Must I publish code based on MPL licensed code under MPL?
A: Yes. You cannot change the license terms. Only the Initial Developer can 
add an additional license.

I am considering using some protion of code that has being covered by the MPL v1.
in a commercial product. I will simply use the DLL libraries without modification, 
including the necessary header files in my own code. 
When I distribute (sell) my own product I would, of course, need to distribute 
the DLL libraries as well. My questions are:

Q1: Am I correct in assuming that simply including unmodified header files and 
linking with a library covered by the MPL does not place any legal restrictions or 
obligations on my commercial product and its source code?
A1: It places no obligations on the code YOU wrote, but there are still obligations 
for the code you included. These include source distribution 
(for included MPL code, not YOUR code), and some notification requirements.


Q2: Am I obligated to distribute the (unmodified) source code that produced 
the libraries with which I link?
A2: Yes. Since you are shipping the DLL libraries with your product, you have to 
make source available for the MPL code you ship.

Note that the license also allows you to meet the distribution requirement by 
making the source available via electronic means rather than having to physically 
ship them with your product (as long as you tell your users where to get it). 
If you are using unmodified source code you could probably just point at the 
code author's server. If you did that you'd have to specify how users could get 
the exact version of the source you used, such as a CVS date stamp or something.

This might be tricky -- you are responsible to make sure the source is available 
for 12 months after you ship, and there's no way of knowing how long the author 
will keep old versions around. The CVS repository is more of a sure bet. 
You could, of course, host the source on your own servers to be sure it'll stick around.

Q3: Am I obligated to make my use of the particular libraries known to users of my product?
A3: Yes, it's spelled out in the license. You need to credit the source of copyrighted code 
that is not yours in both the product and its documentation.
