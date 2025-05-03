# Avro Keyboard

Unicode compliant open source Bangla typing software (IME).
Visit: [https://www.omicronlab.com](https://www.omicronlab.com "OmicronLab") for latest version.

## Required Delphi Version

Was tested with **Delphi 12 community edition**

The community edition can be download from here:
https://www.embarcadero.com/products/delphi/starter/free-download

## Building Standard and Portable editions

Open `ProjectDefines.inc` file in the root folder of the source.

For building portable edition, add the following line in this file and compile:

    {$Define PortableOn}

For building standard edition, remove the above line from the
file or make it a comment like the following and then compile:

    {.$Define PortableOn}

or,

    //{$Define PortableOn}

## Notable contributions

- [@JayedAhsan](https://github.com/JayedAhsan) (PR [#32](https://github.com/mugli/Avro-Keyboard/pull/32)) - 3rd party dependencies are no longer necessary to compile the source, can be compiled with the latest free Community Edition of Delphi, and perf improvements.

## License

From version 5x, Avro Keyboard goes open source from freeware, licensed under **MOZILLA PUBLIC LICENSE Version 1.1**. You should receive a copy of the license in MPL-1.1.txt file with both binaries and source. An online version of the license can be found at: [https://www.mozilla.org/MPL/](https://www.mozilla.org/MPL/ "https://www.mozilla.org/MPL/")
