{ unit NativeXml

  This is a small-footprint implementation to read and write XML documents
  natively from Delpi code.

  You can use this code to read XML documents from files, streams or strings.
  The load routine generates events that can be used to display load progress
  on the fly.

  Note: any external encoding (ANSI, UTF16, etc) is converted to an internal
  encoding that is ANSI or UTF8. When the loaded document is ANSI based,
  the encoding will be ANSI, in other cases (UTF8, UTF16) the encoding
  will be UTF8.

  Original Author: Nils Haeck M.Sc. (n.haeck@simdesign.nl)
  Original Date: 01 Apr 2003
  Version: see below
  Copyright (c) 2003-2010 Simdesign BV
  Contributor(s): Stefan Glienke

  It is NOT allowed under ANY circumstances to publish or copy this code
  without accepting the license conditions in accompanying LICENSE.txt
  first!

  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied.

  Please visit http://www.simdesign.nl/xml.html for more information.
}

{$DEFINE USEGRAPHICS} // uncomment if you do not want to include the Graphics unit.

// Delphi and BCB versions

// Delphi 3
{$IFDEF VER110}
  {$DEFINE D3UP}
{$ENDIF}
// Delphi 4
{$IFDEF VER120}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
{$ENDIF}
// BCB 4
{$IFDEF VER125}
  {$DEFINE D4UP}
{$ENDIF}
// Delphi 5
{$IFDEF VER130}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
{$ENDIF}
//Delphi 6
{$IFDEF VER140}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
{$ENDIF}
//Delphi 7
{$IFDEF VER150}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
{$ENDIF}
//Delphi 8
{$IFDEF VER160}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
{$ENDIF}
// Delphi 2005
{$IFDEF VER170}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
{$ENDIF}
// Delphi 2006
{$IFDEF VER180}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
  {$DEFINE D10UP}
{$ENDIF}
// Delphi 2007 - NET
{$IFDEF VER190}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
  {$DEFINE D10UP}
{$ENDIF}

unit NativeXml;

interface

uses
  {$IFDEF D9UP}
  Windows,
  {$ENDIF}
  {$IFDEF CLR}
  System.Text,
  {$ENDIF}
  Classes,
  {$IFDEF USEGRAPHICS}
  {$IFDEF LINUX}
  QGraphics,
  {$ELSE}
  Graphics,
  {$ENDIF}
  {$ENDIF}
  SysUtils;

const

  // Current version of the NativeXml unit
  cNativeXmlVersion = '2.38';

// Delphi 3 and below stubs
{$IFNDEF D4UP}
type
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);
  int64 = integer;
function StringReplace(const S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags): string;
function StrToInt64Def(const AValue: string; ADefault: int64): int64;
function StrToInt64(const AValue: string): int64;
{$ENDIF}

// Delphi 4 stubs
{$IFNDEF D5UP}
type
  widestring = string;
function AnsiPos(const Substr, S: string): Integer;
function AnsiQuotedStr(const S: string; Quote: Char): string;
function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string;
procedure FreeAndNil(var Obj);
{$ENDIF}

// cross-platform pointer type
type
  {$IFDEF CLR}
  TPointer = TObject;
  {$ELSE}
  TPointer = Pointer;
  {$ENDIF}

// Delphi 5 stubs
{$IFNDEF D6UP}
type
  TSeekOrigin = Word;
const
  soBeginning = soFromBeginning;
  soCurrent = soFromCurrent;
  soEnd = soFromEnd;
{$ENDIF}

type

  // Note on TNativeXml.Format:
  // - xfReadable (default) to be able to read the xml file with a standard editor.
  // - xfCompact to save the xml fully compliant and at smallest size
  TXmlFormatType = (
    xfReadable,   // Save in readable format with CR-LF and indents
    xfCompact     // Save without any control chars except LF after declarations
  );

  // TXmlElementType enumerates the different kinds of elements that can be found
  // in the XML document.
  TXmlElementType = (
    xeNormal,      // Normal element <name {attr}>[value][sub-elements]</name>
    xeComment,     // Comment <!--{comment}-->
    xeCData,       // literal data <![CDATA[{data}]]>
    xeDeclaration, // XML declaration <?xml{declaration}?>
    xeStylesheet,  // Stylesheet <?xml-stylesheet{stylesheet}?>
    xeDoctype,     // DOCTYPE DTD declaration <!DOCTYPE{spec}>
    xeElement,     // <!ELEMENT >
    xeAttList,     // <!ATTLIST >
    xeEntity,      // <!ENTITY >
    xeNotation,    // <!NOTATION >
    xeExclam,      // Any <!data>
    xeQuestion,    // Any <?data?>
    xeCharData,    // Character data in a node
    xeUnknown      // Any <data>
  );

  // Choose what kind of binary encoding will be used when calling
  // TXmlNode BufferRead and BufferWrite.
  TBinaryEncodingType = (
    xbeBinHex,  { With this encoding, each byte is stored as a hexadecimal
                  number, e.g. 0 = 00 and 255 = FF.                        }
    xbeBase64   { With this encoding, each group of 3 bytes are stored as 4
                  characters, requiring 64 different characters.}
  );

  // Definition of different methods of string encoding.
  TStringEncodingType = (
    se8Bit,      // General 8 bit encoding, encoding must be determined from encoding declaration
    seUCS4BE,    // UCS-4 Big Endian
    seUCS4LE,    // UCS-4 Little Endian
    seUCS4_2143, // UCS-4 unusual octet order (2143)
    seUCS4_3412, // UCS-4 unusual octet order (3412)
    se16BitBE,   // General 16 bit Big Endian, encoding must be determined from encoding declaration
    se16BitLE,   // General 16 bit Little Endian, encoding must be determined from encoding declaration
    seUTF8,      // UTF-8
    seUTF16BE,   // UTF-16 Big Endian
    seUTF16LE,   // UTF-16 Little Endian
    seEBCDIC     // EBCDIC flavour
  );

  TXmlCompareOption = (
    xcNodeName,
    xcNodeType,
    xcNodeValue,
    xcAttribCount,
    xcAttribNames,
    xcAttribValues,
    xcChildCount,
    xcChildNames,
    xcChildValues,
    xcRecursive
  );

  TXmlCompareOptions = set of TXmlCompareOption;

const

  xcAll: TXmlCompareOptions = [xcNodeName, xcNodeType, xcNodeValue, xcAttribCount,
    xcAttribNames, xcAttribValues, xcChildCount, xcChildNames, xcChildValues,
    xcRecursive];

var

  // XML Defaults

  cDefaultEncodingString:          string              = 'windows-1252';
  cDefaultExternalEncoding:        TStringEncodingType = se8bit;
  cDefaultVersionString:           string              = '1.0';
  cDefaultXmlFormat:               TXmlFormatType      = xfCompact;
  cDefaultWriteOnDefault:          boolean             = True;
  cDefaultBinaryEncoding:          TBinaryEncodingType = xbeBase64;
  cDefaultUtf8Encoded:             boolean             = False;
  cDefaultIndentString:            string              = '  ';
  cDefaultDropCommentsOnParse:     boolean             = False;
  cDefaultUseFullNodes:            boolean             = False;
  cDefaultSortAttributes:          boolean             = False;
  cDefaultFloatAllowScientific:    boolean             = True;
  cDefaultFloatSignificantDigits:  integer             = 6;

type

  TXmlNode = class;
  TNativeXml = class;
  TsdCodecStream = class;

  // An event that is based on the TXmlNode object Node.
  TXmlNodeEvent = procedure(Sender: TObject; Node: TXmlNode) of object;

  // An event that is used to indicate load or save progress.
  TXmlProgressEvent = procedure(Sender: TObject; Size: integer) of object;

  // This event is used in the TNativeXml.OnNodeCompare event, and should
  // return -1 if Node1 < Node2, 0 if Node1 = Node2 and 1 if Node1 > Node2.
  TXmlNodeCompareEvent = function(Sender: TObject; Node1, Node2: TXmlNode; Info: TPointer): integer of object;

  // Pass a function of this kind to TXmlNode.SortChildNodes. The function should
  // return -1 if Node1 < Node2, 0 if Node1 = Node2 and 1 if Node1 > Node2.
  TXMLNodeCompareFunction = function(Node1, Node2: TXmlNode; Info: TPointer): integer;

  // The TXmlNode represents an element in the XML file. Each TNativeXml holds
  // one Root element. Under ths root element, sub-elements can be nested (there
  // is no limit on how deep). Property ElementType defines what kind of element
  // this node is.
  TXmlNode = class(TPersistent)
  private
    FAttributes: TStringList;      // List with attributes
    FDocument: TNativeXml;         // Pointer to parent XmlDocument
    FElementType: TXmlElementType; // The type of element
    FName: string;                 // The element name
    FNodes: TList;                 // These are the child elements
    FParent: TXmlNode;             // Pointer to parent element
    FTag: integer;                 // A value the developer can use
    FValue: string;                // The *escaped* value
    function AbortParsing: boolean;
    function GetValueAsString: string;
    procedure SetAttributeName(Index: integer; const Value: string);
    procedure SetAttributeValue(Index: integer; const Value: string);
    procedure SetValueAsString(const AValue: string);
    function GetIndent: string;
    function GetLineFeed: string;
    function GetTreeDepth: integer;
    function GetAttributeCount: integer;
    function GetAttributePair(Index: integer): string;
    function GetAttributeName(Index: integer): string;
    function GetAttributeValue(Index: integer): string;
    function GetWriteOnDefault: boolean;
    function GetBinaryEncoding: TBinaryEncodingType;
    function GetCascadedName: string;
    function QualifyAsDirectNode: boolean;
    procedure SetName(const Value: string);
    function GetFullPath: string;
    procedure SetBinaryEncoding(const Value: TBinaryEncodingType);
    function GetBinaryString: string;
    procedure SetBinaryString(const Value: string);
    function UseFullNodes: boolean;
    function GetValueAsWidestring: widestring;
    procedure SetValueAsWidestring(const Value: widestring);
    function GetAttributeByName(const AName: string): string;
    procedure SetAttributeByName(const AName, Value: string);
    function GetValueAsInteger: integer;
    procedure SetValueAsInteger(const Value: integer);
    function GetValueAsFloat: double;
    procedure SetValueAsFloat(const Value: double);
    function GetValueAsDateTime: TDateTime;
    procedure SetValueAsDateTime(const Value: TDateTime);
    function GetValueAsBool: boolean;
    procedure SetValueAsBool(const Value: boolean);
    function GetValueAsInt64: int64;
    procedure SetValueAsInt64(const Value: int64);
    procedure CheckCreateAttributesList;
    function GetAttributeValueAsWidestring(Index: integer): widestring;
    procedure SetAttributeValueAsWidestring(Index: integer;
      const Value: widestring);
    function GetAttributeValueAsInteger(Index: integer): integer;
    procedure SetAttributeValueAsInteger(Index: integer;
      const Value: integer);
    function GetAttributeByNameWide(const AName: string): widestring;
    procedure SetAttributeByNameWide(const AName: string;
      const Value: widestring);
    function GetTotalNodeCount: integer;
    function FloatSignificantDigits: integer;
    function FloatAllowScientific: boolean;
    function GetAttributeValueDirect(Index: integer): string;
    procedure SetAttributeValueDirect(Index: integer; const Value: string);
  protected
    function CompareNodeName(const NodeName: string): integer;
    procedure DeleteEmptyAttributes;
    function GetNodes(Index: integer): TXmlNode; virtual;
    function GetNodeCount: integer; virtual;
    procedure ParseTag(const AValue: string; TagStart, TagClose: integer);
    procedure ReadFromStream(S: TStream); virtual;
    procedure ReadFromString(const AValue: string); virtual;
    procedure ResolveEntityReferences;
    function UnescapeString(const AValue: string): string; virtual;
    function Utf8Encoded: boolean;
    function WriteInnerTag: string; virtual;
    procedure WriteToStream(S: TStream); virtual;
    procedure ChangeDocument(ADocument: TNativeXml);
  public
    // Create a new TXmlNode object. ADocument must be the TNativeXml that is
    // going to hold this new node.
    constructor Create(ADocument: TNativeXml); virtual;
    // \Create a new TXmlNode with name AName. ADocument must be the TNativeXml
    // that is going to hold this new node.
    constructor CreateName(ADocument: TNativeXml; const AName: string); virtual;
    // \Create a new TXmlNode with name AName and string value AValue. ADocument
    // must be the TNativeXml that is going to hold this new node.
    constructor CreateNameValue(ADocument: TNativeXml; const AName, AValue: string); virtual;
    // \Create a new TXmlNode with XML element type AType. ADocument must be the
    // TNativeXml that is going to hold this new node.
    constructor CreateType(ADocument: TNativeXml; AType: TXmlElementType); virtual;
    // Use Assign to assign another TXmlNode to this node. This means that all
    // properties and subnodes from the Source TXmlNode are copied to the current
    // node. You can also Assign a TNativeXml document to the node, in that case
    // the RootNodeList property of the TNativeXml object will be copied.
    procedure Assign(Source: TPersistent); override;
    // Call Delete to delete this node completely from the parent node list. This
    // call only succeeds if the node has a parent. It has no effect when called for
    // the root node.
    procedure Delete; virtual;
    // \Delete all nodes that are empty (this means, which have no subnodes, no
    // attributes, and no value assigned). This procedure works recursively.
    procedure DeleteEmptyNodes;
    // Destroy a TXmlNode object. This will free the child node list automatically.
    // Never call this method directly. All TXmlNodes in the document will be
    // recursively freed when TNativeXml.Free is called.
    destructor Destroy; override;
    {$IFDEF D4UP}
    // Use this method to add an integer attribute to the node.
    procedure AttributeAdd(const AName: string; AValue: integer); overload;
    {$ENDIF}
    // Use this method to add a string attribute with value AValue to the node.
    procedure AttributeAdd(const AName, AValue: string); {$IFDEF D4UP}overload;{$ENDIF}
    // Use this method to delete the attribute at Index in the list. Index must be
    // equal or greater than 0, and smaller than AttributeCount. Using an index
    // outside of that range has no effect.
    procedure AttributeDelete(Index: integer);
    // Switch position of the attributes at Index1 and Index2.
    procedure AttributeExchange(Index1, Index2: integer);
    // Use this method to find the index of an attribute with name AName.
    function AttributeIndexByname(const AName: string): integer;
    // \Clear all attributes from the current node.
    procedure AttributesClear; virtual;
    // Use this method to read binary data from the node into Buffer with a length of Count.
    procedure BufferRead(var Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Count: Integer); virtual;
    // Use this method to write binary data in Buffer with a length of Count to the
    // current node. The data will appear as text using either BinHex or Base64
    // method) in the final XML document.
    // Notice that NativeXml does only support up to 2Gb bytes of data per file,
    // so do not use this option for huge files. The binary encoding method (converting
    // binary data into text) can be selected using property BinaryEncoding.
    // xbeBase64 is most efficient, but slightly slower. Always use identical methods
    // for reading and writing.
    procedure BufferWrite(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Count: Integer); virtual;
    // Returns the length of the data in the buffer, once it would be decoded by
    // method xbeBinHex or xbeBase64. If BinaryEncoding is xbeSixBits, this function
    // cannot be used. The length of the unencoded data is determined from the
    // length of the encoded data. For xbeBinHex this is trivial (just half the
    // length), for xbeBase64 this is more difficult (must use the padding characters)
    function BufferLength: integer; virtual;
    // Clear all child nodes and attributes, and the name and value of the current
    // XML node. However, the node is not deleted. Call Delete instead for that.
    procedure Clear; virtual;
    // Find the first node which has name NodeName. Contrary to the NodeByName
    // function, this function will search the whole subnode tree, using the
    // DepthFirst method. It is possible to search for a full path too, e.g.
    // FoundNode := MyNode.FindNode('/Root/SubNode1/SubNode2/ThisNode');
    function FindNode(const NodeName: string): TXmlNode;
    // Find all nodes which have name NodeName. Contrary to the NodesByName
    // function, this function will search the whole subnode tree. If you use
    // a TXmlNodeList for the AList parameter, you don't need to cast the list
    // items to TXmlNode.
    procedure FindNodes(const NodeName: string; const AList: TList);
    // Use FromAnsiString to convert a normal ANSI string to a string for the node
    // (name, value, attributes). If the TNativeXml property UtfEncoded is True,
    // the ANSI characters are encoded into UTF8. Use this function if you work
    // with special codebases (characters in the range $7F-$FF) and want to produce
    // unicode or UTF8 XML documents.
    function FromAnsiString(const s: string): string;
    // Use FromWidestring to convert widestring to a string for the node (name, value,
    // attributes). If the TNativeXml property UtfEncoded is True, all
    // character codes higher than $FF are preserved.
    function FromWidestring(const W: widestring): string;
    // Use HasAttribute to determine if the node has an attribute with name AName.
    function HasAttribute(const AName: string): boolean; virtual;
    // This function returns the index of this node in the parent's node list.
    // If Parent is not assigned, this function returns -1.
    function IndexInParent: integer;
    // This function returns True if the node has no subnodes and no attributes,
    // and if the node Name and value are empty.
    function IsClear: boolean; virtual;
    // This function returns True if the node has no subnodes and no attributes,
    // and if the node value is empty.
    function IsEmpty: boolean; virtual;
    function IsEqualTo(ANode: TXmlNode; Options: TXmlCompareOptions; MismatchNodes: TList {$IFDEF D4UP}= nil{$ENDIF}): boolean;
    // Add the node ANode as a new subelement in the nodelist. The node will be
    // added in position NodeCount (which will be returned).
    function NodeAdd(ANode: TXmlNode): integer; virtual;
    // This function returns a pointer to the first subnode that has an attribute with
    // name AttribName and value AttribValue. If ShouldRecurse = True (default), the
    // function works recursively, using the depthfirst method.
    function NodeByAttributeValue(const NodeName, AttribName, AttribValue: string;
      ShouldRecurse: boolean {$IFDEF D4UP}= True{$ENDIF}): TXmlNode;
    // Return a pointer to the first subnode with this Elementype, or return nil
    // if no subnode with that type is found.
    function NodeByElementType(ElementType: TXmlElementType): TXmlNode;
    // Return a pointer to the first subnode in the nodelist that has name AName.
    // If no subnodes with AName are found, the function returns nil.
    function NodeByName(const AName: string): TXmlNode; virtual;
    // \Delete the subnode at Index. The node will also be freed, so do not free the
    // node in the application.
    procedure NodeDelete(Index: integer); virtual;
    // Switch position of the nodes at Index1 and Index2.
    procedure NodeExchange(Index1, Index2: integer);
    // Extract the node ANode from the subnode list. The node will no longer appear
    // in the subnodes list, so the application is responsible for freeing ANode later.
    function NodeExtract(ANode: TXmlNode): TXmlNode; virtual;
    // This function returns a pointer to the first node with AName. If this node
    // is not found, then it creates a new node with AName and returns its pointer.
    function NodeFindOrCreate(const AName: string): TXmlNode; virtual;
    // Find the index of the first subnode with name AName.
    function NodeIndexByName(const AName: string): integer; virtual;
    // Find the index of the first subnode with name AName that appears after or on
    // the index AFrom. This function can be used in a loop to retrieve all nodes
    // with a certain name, without using a helper list. See also NodesByName.
    function NodeIndexByNameFrom(const AName: string; AFrom: integer): integer; virtual;
    // Call NodeIndexOf to get the index for ANode in the Nodes array. The first
    // node in the array has index 0, the second item has index 1, and so on. If
    // a node is not in the list, NodeIndexOf returns -1.
    function NodeIndexOf(ANode: TXmlNode): integer;
    // Insert the node ANode at location Index in the list.
    procedure NodeInsert(Index: integer; ANode: TXmlNode); virtual;
    // \Create a new node with AName, add it to the subnode list, and return a
    // pointer to it.
    function NodeNew(const AName: string): TXmlNode; virtual;
    // \Create a new node with AName, and insert it into the subnode list at location
    // Index, and return a pointer to it.
    function NodeNewAtIndex(Index: integer; const AName: string): TXmlNode; virtual;
    // Call NodeRemove to remove a specific node from the Nodes array when its index
    // is unknown. The value returned is the index of the item in the Nodes array
    // before it was removed. After an item is removed, all the items that follow
    // it are moved up in index position and the NodeCount is reduced by one.
    function NodeRemove(ANode: TxmlNode): integer;
    // \Clear (and free) the complete list of subnodes.
    procedure NodesClear; virtual;
    // Use this procedure to retrieve all nodes that have name AName. Pointers to
    // these nodes are added to the list in AList. AList must be initialized
    // before calling this procedure. If you use a TXmlNodeList you don't need
    // to cast the list items to TXmlNode.
    procedure NodesByName(const AName: string; const AList: TList);
    // Find the attribute with AName, and convert its value to a boolean. If the
    // attribute is not found, or cannot be converted, the default ADefault will
    // be returned.
    function ReadAttributeBool(const AName: string; ADefault: boolean {$IFDEF D4UP}= False{$ENDIF}): boolean; virtual;
    function ReadAttributeDateTime(const AName: string; ADefault: TDateTime {$IFDEF D4UP}= 0{$ENDIF}): TDateTime; virtual;
    // Find the attribute with AName, and convert its value to an integer. If the
    // attribute is not found, or cannot be converted, the default ADefault will
    // be returned.
    function ReadAttributeInteger(const AName: string; ADefault: integer {$IFDEF D4UP}= 0{$ENDIF}): integer; virtual;
    // Find the attribute with AName, and convert its value to an int64. If the
    // attribute is not found, or cannot be converted, the default ADefault will
    // be returned.
    function ReadAttributeInt64(const AName: string; ADefault: int64 {$IFDEF D4UP}= 0{$ENDIF}): int64; virtual;
    // Find the attribute with AName, and convert its value to a float. If the
    // attribute is not found, or cannot be converted, the default ADefault will
    // be returned.
    function ReadAttributeFloat(const AName: string; ADefault: double {$IFDEF D4UP}= 0{$ENDIF}): double;
    function ReadAttributeString(const AName: string; const ADefault: string {$IFDEF D4UP}= ''{$ENDIF}): string; virtual;
    // Read the subnode with AName and convert it to a boolean value. If the
    // subnode is not found, or cannot be converted, the boolean ADefault will
    // be returned.
    function ReadBool(const AName: string; ADefault: boolean {$IFDEF D4UP}= False{$ENDIF}): boolean; virtual;
    {$IFDEF USEGRAPHICS}
    // Read the properties Color and Style for the TBrush object ABrush from the
    // subnode with AName.
    procedure ReadBrush(const AName: string; ABrush: TBrush); virtual;
    // Read the subnode with AName and convert its value to TColor. If the
    // subnode is not found, or cannot be converted, ADefault will be returned.
    function ReadColor(const AName: string; ADefault: TColor {$IFDEF D4UP}= clBlack{$ENDIF}): TColor; virtual;
    // Read the properties \Name, Color, Size and Style for the TFont object AFont
    // from the subnode with AName.
    procedure ReadFont(const AName: string; AFont: TFont); virtual;
    // Read the properties Color, Mode, Style and Width for the TPen object APen
    // from the subnode with AName.
    procedure ReadPen(const AName: string; APen: TPen); virtual;
    {$ENDIF}
    // Read the subnode with AName and convert its value to TDateTime. If the
    // subnode is not found, or cannot be converted, ADefault will be returned.
    function ReadDateTime(const AName: string; ADefault: TDateTime {$IFDEF D4UP}= 0{$ENDIF}): TDateTime; virtual;
    // Read the subnode with AName and convert its value to a double. If the
    // subnode is not found, or cannot be converted, ADefault will be returned.
    function ReadFloat(const AName: string; ADefault: double {$IFDEF D4UP}= 0.0{$ENDIF}): double; virtual;
    // Read the subnode with AName and convert its value to an int64. If the
    // subnode is not found, or cannot be converted, ADefault will be returned.
    function ReadInt64(const AName: string; ADefault: int64 {$IFDEF D4UP}= 0{$ENDIF}): int64; virtual;
    // Read the subnode with AName and convert its value to an integer. If the
    // subnode is not found, or cannot be converted, ADefault will be returned.
    function ReadInteger(const AName: string; ADefault: integer {$IFDEF D4UP}= 0{$ENDIF}): integer; virtual;
    // Read the subnode with AName and return its string value. If the subnode is
    // not found, ADefault will be returned.
    function ReadString(const AName: string; const ADefault: string {$IFDEF D4UP}= ''{$ENDIF}): string; virtual;
    // Read the subnode with AName and return its widestring value. If the subnode is
    // not found, ADefault will be returned.
    function ReadWidestring(const AName: string; const ADefault: widestring {$IFDEF D4UP}= ''{$ENDIF}): widestring; virtual;
    // Sort the child nodes of this node. Provide a custom node compare function in Compare,
    // or attach an event handler to the parent documents' OnNodeCompare in order to
    // provide custom sorting. If no compare function is given (nil) and OnNodeCompare
    // is not implemented, SortChildNodes will simply sort the nodes by name (ascending,
    // case insensitive). The Info pointer parameter can be used to pass any custom
    // information to the compare function. Default value for Info is nil.
    procedure SortChildNodes(Compare: TXMLNodeCompareFunction {$IFDEF D4UP}= nil{$ENDIF}; Info: TPointer {$IFDEF D4UP}= nil{$ENDIF});
    // Use ToAnsiString to convert any string from the node (name, value, attributes)
    // to a normal ANSI string. If the TNativeXml property UtfEncoded is True,
    // you may loose characters with codes higher than $FF. To prevent this, use
    // widestrings in your application and use ToWidestring instead.
    function ToAnsiString(const s: string): string;
    // Use ToWidestring to convert any string from the node (name, value, attributes)
    // to a widestring. If the TNativeXml property UtfEncoded is True, all
    // character codes higher than $FF are preserved.
    function ToWidestring(const s: string): widestring;
    // Convert the node's value to boolean and return the result. If this conversion
    // fails, or no value is found, then the function returns ADefault.
    function ValueAsBoolDef(ADefault: boolean): boolean; virtual;
    // Convert the node's value to a TDateTime and return the result. If this conversion
    // fails, or no value is found, then the function returns ADefault.
    function ValueAsDateTimeDef(ADefault: TDateTime): TDateTime; virtual;
    // Convert the node's value to a double and return the result. If this conversion
    // fails, or no value is found, then the function returns ADefault.
    function ValueAsFloatDef(ADefault: double): double; virtual;
    // Convert the node's value to int64 and return the result. If this conversion
    // fails, or no value is found, then the function returns ADefault.
    function ValueAsInt64Def(ADefault: int64): int64; virtual;
    // Convert the node's value to integer and return the result. If this conversion
    // fails, or no value is found, then the function returns ADefault.
    function ValueAsIntegerDef(ADefault: integer): integer; virtual;
    // If the attribute with name AName exists, then set its value to the boolean
    // AValue. If it does not exist, then create a new attribute AName with the
    // boolean value converted to either "True" or "False". If ADefault = AValue, and
    // WriteOnDefault = False, no attribute will be added.
    procedure WriteAttributeBool(const AName: string; AValue: boolean; ADefault: boolean {$IFDEF D4UP}= False{$ENDIF}); virtual;
    procedure WriteAttributeDateTime(const AName:string; AValue: TDateTime; ADefault: TDateTime {$IFDEF D4UP}= 0{$ENDIF}); virtual;
    // If the attribute with name AName exists, then set its value to the integer
    // AValue. If it does not exist, then create a new attribute AName with the
    // integer value converted to a quoted string. If ADefault = AValue, and
    // WriteOnDefault = False, no attribute will be added.
    procedure WriteAttributeInteger(const AName: string; AValue: integer; ADefault: integer {$IFDEF D4UP}= 0{$ENDIF}); virtual;
    procedure WriteAttributeInt64(const AName: string; const AValue: int64; ADefault: int64 {$IFDEF D4UP}= 0{$ENDIF}); virtual;
    procedure WriteAttributeFloat(const AName: string; AValue: double; ADefault: double {$IFDEF D4UP} = 0{$ENDIF}); virtual;
    // If the attribute with name AName exists, then set its value to the string
    // AValue. If it does not exist, then create a new attribute AName with the
    // value AValue. If ADefault = AValue, and WriteOnDefault = False, no attribute
    // will be added.
    procedure WriteAttributeString(const AName: string; const AValue: string; const ADefault: string {$IFDEF D4UP}= ''{$ENDIF}); virtual;
    // Add or replace the subnode with AName and set its value to represent the boolean
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteBool(const AName: string; AValue: boolean; ADefault: boolean {$IFDEF D4UP}= False{$ENDIF}); virtual;
    {$IFDEF USEGRAPHICS}
    // Write properties Color and Style of the TBrush object ABrush to the subnode
    // with AName. If AName does not exist, it will be created.
    procedure WriteBrush(const AName: string; ABrush: TBrush); virtual;
    // Add or replace the subnode with AName and set its value to represent the TColor
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteColor(const AName: string; AValue: TColor; ADefault: TColor {$IFDEF D4UP}= clBlack{$ENDIF}); virtual;
    // Write properties \Name, Color, Size and Style of the TFont object AFont to
    // the subnode with AName. If AName does not exist, it will be created.
    procedure WriteFont(const AName: string; AFont: TFont); virtual;
    // Write properties Color, Mode, Style and Width of the TPen object APen to
    // the subnode with AName. If AName does not exist, it will be created.
    procedure WritePen(const AName: string; APen: TPen); virtual;
    {$ENDIF}
    // Add or replace the subnode with AName and set its value to represent the TDateTime
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    // The XML format used is compliant with W3C's specification of date and time.
    procedure WriteDateTime(const AName: string; AValue: TDateTime; ADefault: TDateTime {$IFDEF D4UP}= 0{$ENDIF}); virtual;
    // Add or replace the subnode with AName and set its value to represent the double
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteFloat(const AName: string; AValue: double; ADefault: double {$IFDEF D4UP}= 0.0{$ENDIF}); virtual;
    // Add or replace the subnode with AName and set its value to represent the hexadecimal representation of
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteHex(const AName: string; AValue: integer; Digits: integer; ADefault: integer {$IFDEF D4UP}= 0{$ENDIF}); virtual;
    // Add or replace the subnode with AName and set its value to represent the int64
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteInt64(const AName: string; AValue: int64; ADefault: int64 {$IFDEF D4UP}= 0{$ENDIF}); virtual;
    // Add or replace the subnode with AName and set its value to represent the integer
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteInteger(const AName: string; AValue: integer; ADefault: integer {$IFDEF D4UP}= 0{$ENDIF}); virtual;
    // Add or replace the subnode with AName and set its value to represent the string
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteString(const AName, AValue: string; const ADefault: string {$IFDEF D4UP}= ''{$ENDIF}); virtual;
    // Call WriteToString to save the XML node to a string. This method can be used to store
    // individual nodes instead of the complete XML document.
    function WriteToString: string; virtual;
    // Add or replace the subnode with AName and set its value to represent the widestring
    // AValue. If AValue = ADefault, and WriteOnDefault = False, no subnode will be added.
    procedure WriteWidestring(const AName: string; const AValue: widestring; const ADefault: widestring {$IFDEF D4UP}= ''{$ENDIF}); virtual;
    // AttributeByName returns the attribute value for the attribute that has name AName.
    // Set AttributeByName to add an attribute to the attribute list, or replace an
    // existing one.
    property AttributeByName[const AName: string]: string read GetAttributeByName write
      SetAttributeByName;
    // AttributeByNameWide returns the attribute value for the attribute that has name AName
    // as widestring. Set AttributeByNameWide to add an attribute to the attribute list, or replace an
    // existing one.
    property AttributeByNameWide[const AName: string]: widestring read GetAttributeByNameWide write
      SetAttributeByNameWide;
    // Returns the number of attributes in the current node.
    property AttributeCount: integer read GetAttributeCount;
    // Read this property to get the name of the attribute at Index. Note that Index
    // is zero-based: Index goes from 0 to AttributeCount - 1
    property AttributeName[Index: integer]: string read GetAttributeName write SetAttributeName;
    // Read this property to get the Attribute \Name and Value pair at index Index.
    // This is a string with \Name and Value separated by a TAB character (#9).
    property AttributePair[Index: integer]: string read GetAttributePair;
    // Read this property to get the string value of the attribute at index Index.
    // Write to it to set the string value.
    property AttributeValue[Index: integer]: string read GetAttributeValue write SetAttributeValue;
    // Read this property to get the widestring value of the attribute at index Index.
    // Write to it to set the widestring value.
    property AttributeValueAsWidestring[Index: integer]: widestring read GetAttributeValueAsWidestring write SetAttributeValueAsWidestring;
    // Read this property to get the integer value of the attribute at index Index.
    // If the value cannot be converted, 0 will be returned. Write to it to set the integer value.
    property AttributeValueAsInteger[Index: integer]: integer read GetAttributeValueAsInteger write SetAttributeValueAsInteger;
    // Set or get the raw attribute value, thus circumventing the escape function. Make sure that
    // the value you set does not contain the & and quote characters, or the produced
    // XML will be invalid.
    property AttributeValueDirect[Index: integer]: string read GetAttributeValueDirect write SetAttributeValueDirect;
    // BinaryEncoding reflects the same value as the BinaryEncoding setting of the parent
    // Document.
    property BinaryEncoding: TBinaryEncodingType read GetBinaryEncoding write SetBinaryEncoding;
    // Use BinaryString to add/extract binary data in an easy way to/from the node. Internally the
    // data gets stored as Base64-encoded data. Do not use this method for normal textual
    // information, it is better to use ValueAsString in that case (adds less overhead).
    property BinaryString: string read GetBinaryString write SetBinaryString;
    // This property returns the name and index and all predecessors with underscores
    // to separate, in order to get a unique reference that can be used in filenames.
    property CascadedName: string read GetCascadedName;
    // Pointer to parent NativeXml document, or Nil if none.
    property Document: TNativeXml read FDocument write FDocument;
    // ElementType contains the type of element that this node holds.
    property ElementType: TXmlElementType read FElementType write FElementType;
    // Fullpath will return the complete path of the node from the root, e.g.
    // /Root/SubNode1/SubNode2/ThisNode
    property FullPath: string read GetFullPath;
    // Read Name to get the name of the element, and write Name to set the name.
    // This is the full name and may include a namespace. (Namespace:Name)
    property Name: string read FName write SetName;
    // Parent points to the parent node of the current XML node.
    property Parent: TXmlNode read FParent write FParent;
    // NodeCount is the number of child nodes that this node holds. In order to
    // loop through all child nodes, use a construct like this:
    // <CODE>
    // with MyNode do
    //   for i := 0 to NodeCount - 1 do
    //     with Nodes[i] do
    //     ..processing here
    // </CODE>
    property NodeCount: integer read GetNodeCount;
    // Use Nodes to access the child nodes of the current XML node by index. Note
    // that the list is zero-based, so Index is valid from 0 to NodeCount - 1.
    property Nodes[Index: integer]: TXmlNode read GetNodes; default;
    // Tag is an integer value the developer can use in any way. Tag does not get
    // saved to the XML. Tag is often used to point to a GUI element (and is then
    // cast to a pointer).
    property Tag: integer read FTag write FTag;
    // TotalNodeCount represents the total number of child nodes, and child nodes
    // of child nodes etcetera of this particular node. Use the following to get
    // the total number of nodes in the XML document:
    // <CODE>
    // Total := MyDoc.RootNodes.TotalNodeCount;
    // </CODE>
    property TotalNodeCount: integer read GetTotalNodeCount;
    // Read TreeDepth to find out many nested levels there are for the current XML
    // node. Root has a TreeDepth of zero.
    property TreeDepth: integer read GetTreeDepth;
    // ValueAsBool returns the node's value as boolean, or raises an
    // exception if the value cannot be converted to boolean. Set ValueAsBool
    // to convert a boolean to a string in the node's value field. See also
    // function ValueAsBoolDef.
    property ValueAsBool: boolean read GetValueAsBool write SetValueAsBool;
    // ValueAsDateTime returns the node's value as TDateTime, or raises an
    // exception if the value cannot be converted to TDateTime. Set ValueAsDateTime
    // to convert a TDateTime to a string in the node's value field. See also
    // function ValueAsDateTimeDef.
    property ValueAsDateTime: TDateTime read GetValueAsDateTime write SetValueAsDateTime;
    // ValueAsIn64 returns the node's value as int64, or raises an
    // exception if the value cannot be converted to int64. Set ValueAsInt64
    // to convert an int64 to a string in the node's value field. See also
    // function ValueAsInt64Def.
    property ValueAsInt64: int64 read GetValueAsInt64 write SetValueAsInt64;
    // ValueAsInteger returns the node's value as integer, or raises an
    // exception if the value cannot be converted to integer. Set ValueAsInteger
    // to convert an integer to a string in the node's value field. See also
    // function ValueAsIntegerDef.
    property ValueAsInteger: integer read GetValueAsInteger write SetValueAsInteger;
    // ValueAsFloat returns the node's value as float, or raises an
    // exception if the value cannot be converted to float. Set ValueAsFloat
    // to convert a float to a string in the node's value field. See also
    // function ValueAsFloatDef.
    property ValueAsFloat: double read GetValueAsFloat write SetValueAsFloat;
    // ValueAsString returns the unescaped version of ValueDirect. All neccesary
    // characters in ValueDirect must be escaped (e.g. "&" becomes "&amp;") but
    // ValueAsString returns them in original format. Always use ValueAsString to
    // set the text value of a node, to make sure all neccesary charaters are
    // escaped.
    property ValueAsString: string read GetValueAsString write SetValueAsString;
    // ValueAsWidestring returns the unescaped version of ValueDirect as a widestring.
    // Always use ValueAsWidestring to set the text value of a node, to make sure all
    // neccesary charaters are escaped. Character codes bigger than $FF are preserved
    // if the document is set to Utf8Encoded.
    property ValueAsWidestring: widestring read GetValueAsWidestring write SetValueAsWidestring;
    // ValueDirect is the exact text value as was parsed from the stream. If multiple
    // text elements are encountered, they are added to ValueDirect with a CR to
    // separate them.
    property ValueDirect: string read FValue write FValue;
    // WriteOnDefault reflects the same value as the WriteOnDefault setting of the parent
    // Document.
    property WriteOnDefault: boolean read GetWriteOnDefault;
  end;

  // TXmlNodeList is a utility TList descendant that can be used to work with selection
  // lists. An example:
  // <code>
  // procedure FindAllZips(ANode: TXmlNode);
  // var
  //   i: integer;
  //   AList: TXmlNodeList;
  // begin
  //   AList := TXmlNodeList.Create;
  //   try
  //     // Get a list of all nodes named 'ZIP'
  //     ANode.NodesByName('ZIP', AList);
  //     for i := 0 to AList.Count - 1 do
  //       // Write the value of the node to output. Since AList[i] will be
  //       // of type TXmlNode, we can directly access the Value property.
  //       WriteLn(AList[i].Value);
  //   finally
  //     AList.Free;
  //   end;
  // end;
  // </code>
  TXmlNodeList = class(TList)
  private
    function GetItems(Index: Integer): TXmlNode;
    procedure SetItems(Index: Integer; const Value: TXmlNode);
  public
    // Return the first node in the list that has an attribute with AName, AValue
    function ByAttribute(const AName, AValue: string): TXmlNode;
    property Items[Index: Integer]: TXmlNode read GetItems write SetItems; default;
  end;

  // TNativeXml is the XML document holder. Create a TNativeXml and then use
  // methods LoadFromFile, LoadFromStream or ReadFromString to load an XML document
  // into memory. Or start from scratch and use Root.NodeNew to add nodes and
  // eventually SaveToFile and SaveToStream to save the results as an XML document.
  // Use property Xmlformat = xfReadable to ensure that indented (readable) output
  // is produced.
  TNativeXml = class(TPersistent)
  private
    FAbortParsing: boolean;         // Signal to abort the parsing process
    FBinaryEncoding: TBinaryEncodingType; // xbeBinHex or xbeBase64
    FCodecStream: TsdCodecStream;   // Temporary stream used to read encoded files
    FDropCommentsOnParse: boolean;  // If true, comments are dropped (deleted) when parsing
    FExternalEncoding: TStringEncodingType;
    FFloatAllowScientific: boolean;
    FFloatSignificantDigits: integer;
    FParserWarnings: boolean;       // Show parser warnings for non-critical errors
    FRootNodes: TXmlNode;           // Root nodes in the document (which contains one normal element that is the root)
    FIndentString: string;          // The indent string used to indent content (default is two spaces)
    FUseFullNodes: boolean;         // If true, nodes are never written in short notation.
    FUtf8Encoded: boolean;          // If true, all internal strings are UTF-8 encoded
    FWriteOnDefault: boolean;       // Set this option to "False" to only write values <> default value (default = true)
    FXmlFormat: TXmlFormatType;     // xfReadable, xfCompact
    FSortAttributes: boolean;       // If true, sort the String List that holds the parsed attributes.
    FOnNodeCompare: TXmlNodeCompareEvent; // Compare two nodes
    FOnNodeNew: TXmlNodeEvent;      // Called after a node is added
    FOnNodeLoaded: TXmlNodeEvent;   // Called after a node is loaded completely
    FOnProgress: TXmlProgressEvent; // Called after a node is loaded/saved, with the current position in the file
    FOnUnicodeLoss: TNotifyEvent;   // This event is called when there is a warning for unicode conversion loss when reading unicode
    procedure DoNodeNew(Node: TXmlNode);
    procedure DoNodeLoaded(Node: TXmlNode);
    procedure DoUnicodeLoss(Sender: TObject);
    function GetCommentString: string;
    procedure SetCommentString(const Value: string);
    function GetEntityByName(AName: string): string;
    function GetRoot: TXmlNode;
    function GetEncodingString: string;
    procedure SetEncodingString(const Value: string);
    function GetVersionString: string;
    procedure SetVersionString(const Value: string);
    function GetStyleSheetNode: TXmlNode;
  protected
    procedure CopyFrom(Source: TNativeXml); virtual;
    procedure DoProgress(Size: integer);
    function LineFeed: string; virtual;
    procedure ParseDTD(ANode: TXmlNode; S: TStream); virtual;
    procedure ReadFromStream(S: TStream); virtual;
    procedure WriteToStream(S: TStream); virtual;
    procedure SetDefaults; virtual;
  public
    // Create a new NativeXml document which can then be used to read or write XML files.
    // A document that is created with Create must later be freed using Free.
    // Example:
    // <Code>
    // var
    //   ADoc: TNativeXml;
    // begin
    //   ADoc := TNativeXml.Create;
    //   try
    //     ADoc.LoadFromFile('c:\\temp\\myxml.xml');
    //     {do something with the document here}
    //   finally
    //     ADoc.Free;
    //   end;
    // end;
    // </Code>
    constructor Create; virtual;
    // Use CreateName to Create a new Xml document that will automatically
    // contain a root element with name ARootName.
    constructor CreateName(const ARootName: string); virtual;
    // Destroy will free all data in the TNativeXml object. This includes the
    // root node and all subnodes under it. Do not call Destroy directly, call
    // Free instead.
    destructor Destroy; override;
    // When calling Assign with a Source object that is a TNativeXml, will cause
    // it to copy all data from Source.
    procedure Assign(Source: TPersistent); override;
    // Call Clear to remove all data from the object, and restore all defaults.
    procedure Clear; virtual;
    // Function IsEmpty returns true if the root is clear, or in other words, the
    // root contains no value, no name, no subnodes and no attributes.
    function IsEmpty: boolean; virtual;
    // Load an XML document from the TStream object in Stream. The LoadFromStream
    // procedure will raise an exception of type EFilerError when it encounters
    // non-wellformed XML. This method can be used with any TStream descendant.
    // See also LoadFromFile and ReadFromString.
    procedure LoadFromStream(Stream: TStream); virtual;
    // Call procedure LoadFromFile to load an XML document from the filename
    // specified. See Create for an example. The LoadFromFile procedure will raise
    // an exception of type EFilerError when it encounters non-wellformed XML.
    procedure LoadFromFile(const FileName: string); virtual;
    // Call procedure ReadFromString to load an XML document from the string AValue.
    // The ReadFromString procedure will raise an exception of type EFilerError
    // when it encounters non-wellformed XML.
    procedure ReadFromString(const AValue: string); virtual;
    // Call ResolveEntityReferences after the document has been loaded to resolve
    // any present entity references (&Entity;). When an entity is found in the
    // DTD, it will replace the entity reference. Whenever an entity contains
    // XML markup, it will be parsed and become part of the document tree. Since
    // calling ResolveEntityReferences is adding quite some extra overhead, it
    // is not done automatically. If you want to do the entity replacement, a good
    // moment to call ResolveEntityReferences is right after LoadFromFile.
    procedure ResolveEntityReferences;
    // Call SaveToStream to save the XML document to the Stream. Stream
    // can be any TStream descendant. Set XmlFormat to xfReadable if you want
    // the stream to contain indentations to make the XML more human-readable. This
    // is not the default and also not compliant with the XML specification. See
    // SaveToFile for information on how to save in special encoding.
    procedure SaveToStream(Stream: TStream); virtual;
    // Call SaveToFile to save the XML document to a file with FileName. If the
    // filename exists, it will be overwritten without warning. If the file cannot
    // be created, a standard I/O exception will be generated. Set XmlFormat to
    // xfReadable if you want the file to contain indentations to make the XML
    // more human-readable. This is not the default and also not compliant with
    // the XML specification.<p>
    // Saving to special encoding types can be achieved by setting two properties
    // before saving:
    // * ExternalEncoding
    // * EncodingString
    // ExternalEncoding can be se8bit (for plain ascii), seUtf8 (UTF-8), seUtf16LE
    // (for unicode) or seUtf16BE (unicode big endian).<p> Do not forget to also
    // set the EncodingString (e.g. "UTF-8" or "UTF-16") which matches with your
    // ExternalEncoding.
    procedure SaveToFile(const FileName: string); virtual;
    // Call WriteToString to save the XML document to a string. Set XmlFormat to
    // xfReadable if you want the string to contain indentations to make the XML
    // more human-readable. This is not the default and also not compliant with
    // the XML specification.
    function WriteToString: string; virtual;
    // Set AbortParsing to True if you use the OnNodeNew and OnNodeLoaded events in
    // a SAX-like manner, and you want to abort the parsing process halfway. Example:
    // <code>
    // procedure MyForm.NativeXmlNodeLoaded(Sender: TObject; Node: TXmlNode);
    // begin
    //   if (Node.Name = 'LastNode') and (Sender is TNativeXml) then
    //     TNativeXml(Sender).AbortParsing := True;
    // end;
    // </code>
    property AbortParsing: boolean read FAbortParsing write FAbortParsing;
    // Choose what kind of binary encoding will be used when calling TXmlNode.BufferRead
    // and TXmlNode.BufferWrite. Default value is xbeBase64.
    property BinaryEncoding: TBinaryEncodingType read FBinaryEncoding write FBinaryEncoding;
    // A comment string above the root element \<!--{comment}--\> can be accessed with
    // this property. \Assign a comment to this property to add it to the XML document.
    // Use property RootNodeList to add/insert/extract multiple comments.
    property CommentString: string read GetCommentString write SetCommentString;
    // Set DropCommentsOnParse if you're not interested in any comment nodes in your object
    // model data. All comments encountered during parsing will simply be skipped and
    // not added as a node with ElementType = xeComment (which is default). Note that
    // when you set this option, you cannot later reconstruct an XML file with the comments
    // back in place.
    property DropCommentsOnParse: boolean read FDropCommentsOnParse write FDropCommentsOnParse;
    // Encoding string (e.g. "UTF-8" or "UTF-16"). This encoding string is stored in
    // the header.
    // Example: In order to get this header:
    // <?xml version="1.0" encoding="UTF-16" ?>
    // enter this code:
    // <CODE>MyXmlDocument.EncodingString := 'UTF-16';</CODE>
    // When reading a file, EncodingString will contain the encoding used.
    property EncodingString: string read GetEncodingString write SetEncodingString;
    // Returns the value of the named entity in Name, where name should be stripped
    // of the leading & and trailing ;. These entity values are parsed from the
    // Doctype declaration (if any).
    property EntityByName[AName: string]: string read GetEntityByName;
    // ExternalEncoding defines in which format XML files are saved. Set ExternalEncoding
    // to se8bit to save as plain text files, to seUtf8 to save as UTF8 files (with
    // Byte Order Mark #EF BB FF) and to seUTF16LE to save as unicode (Byte Order
    // Mark #FF FE). When reading an XML file, the value of ExternalEncoding will
    // be set according to the byte order mark and/or encoding declaration found.
    property ExternalEncoding: TStringEncodingType read FExternalEncoding write FExternalEncoding;
    // When converting floating point values to strings (e.g. in WriteFloat),
    // NativeXml will allow to output scientific notation in some cases, if the
    // result is significantly shorter than normal output, but only if the value
    // of FloatAllowScientific is True (default).
    property FloatAllowScientific: boolean read FFloatAllowScientific write FFloatAllowScientific;
    // When converting floating point values to strings (e.g. in WriteFloat),
    // NativeXml will use this number of significant digits. The default is
    // cDefaultFloatSignificantDigits, and set to 6.
    property FloatSignificantDigits: integer read FFloatSignificantDigits write FFloatSignificantDigits;
    // IndentString is the string used for indentations. By default, it is two
    // spaces: '  '. Set IndentString to something else if you need to have
    // specific indentation, or set it to an empty string to avoid indentation.
    property IndentString: string read FIndentString write FIndentString;
    // Root is the topmost element in the XML document. Access Root to read any
    // child elements. When creating a new XML document, you can automatically
    // include a Root node, by creating using CreateName.
    property Root: TXmlNode read GetRoot;
    // RootNodeList can be used to directly access the nodes in the root of the
    // XML document. Usually this list consists of one declaration node followed
    // by a normal node which is the Root. You can use this property to add or
    // delete comments, stylesheets, dtd's etc.
    property RootNodeList: TXmlNode read FRootNodes;
    // Get the stylesheet node used for this XML document. If the node does not
    // exist yet, it will be created (thus if you use this property, and don't
    // set any of the attributes, an empty stylesheet node will be the result).
    property StyleSheetNode: TXmlNode read GetStyleSheetNode;
    // Set UseFullNodes to True before saving the XML document to ensure that all
    // nodes are represented by <Node>...</Node> instead of the short version
    // <Node/>. UseFullNodes is False by default.
    property UseFullNodes: boolean read FUseFullNodes write FUseFullNodes;
    // When Utf8Encoded is True, all strings inside the document represent
    // UTF-8 encoded strings. Use function ToWidestring to convert strings to
    // widestring (without loss) or ToAnsiString to convert to ANSI string
    // (with loss). When Utf8Encoded is False (default), all strings represent
    // normal ANSI strings. Set Utf8Encoded to True before adding info to the XML
    // file to ensure internal strings are all UTF-8. Use methods FromWidestring,
    // sdAnsiToUTF8 or sdUnicodeToUtf8 before setting any strings in that case.
    property Utf8Encoded: boolean read FUtf8Encoded write FUtf8Encoded;
    // After reading, this property contains the XML version (usually "1.0").
    property VersionString: string read GetVersionString write SetVersionString;
    // Set WriteOnDefault to False if you do not want to write default values to
    // the XML document. This option can avoid creating huge documents with
    // redundant info, and will speed up writing.
    property WriteOnDefault: boolean read FWriteOnDefault write FWriteOnDefault;
    // XmlFormat by default is set to xfCompact. This setting is compliant to the spec,
    // and NativeXml will only generate XML files with #$0A as control character.
    // By setting XmlFormat to xfReadable, you can generate easily readable XML
    // files that contain indentation and carriage returns after each element.
    property XmlFormat: TXmlFormatType read FXmlFormat write FXmlFormat;
    // ParserWarnings by default is True. If True, the parser will raise an
    // exception in cases where the XML document is not technically valid. If False,
    // the parser will try to ignore non-critical warnings. Set ParserWarnings
    // to False for some types of XML-based documents such as SOAP messages.
    property ParserWarnings: boolean read FParserWarnings write FParserWarnings;
    // SortAttributes by default is set to False.  Attributes will appear in the
    // String list in the same order that they appear in the XML Document.  Setting
    // this to true will cause the TStringList that holds the attributes to be sorted
    // This can help speed lookup and allow you to iterate the list looking for
    // specific attributes.
    property SortAttributes: boolean read FSortAttributes write FSortAttributes;
    // This event is called whenever a node's SortChildNodes method is called and
    // no direct compare method is provided. Implement this event if you want to
    // use object-event based methods for comparison of nodes.
    property OnNodeCompare: TXmlNodeCompareEvent read FOnNodeCompare write FOnNodeCompare;
    // This event is called whenever the parser has encountered a new node.
    property OnNodeNew: TXmlNodeEvent read FOnNodeNew write FOnNodeNew;
    // This event is called when the parser has finished parsing the node, and
    // has created its complete contents in memory.
    property OnNodeLoaded: TXmlNodeEvent read FOnNodeLoaded write FOnNodeLoaded;
    // OnProgress is called during loading and saving of the XML document. The
    // Size parameter contains the position in the stream. This event can be used
    // to implement a progress indicator during loading and saving. The event is
    // called after each node that is read or written.
    property OnProgress: TXmlProgressEvent read FOnProgress write FOnProgress;
    // This event is called if there is a warning for unicode conversion loss,
    // when reading from Unicode streams or files.
    property OnUnicodeLoss: TNotifyEvent read FOnUnicodeLoss write FOnUnicodeLoss;
  end;

  // This enumeration defines the conversion stream access mode.
  TsdStreamModeType = (
    umUnknown, // The stream access mode is not yet known
    umRead,    // UTF stream opened for reading
    umWrite    // UTF stream opened for writing
  );

  // TBigByteArray is an array of bytes like the standard TByteArray (windows
  // unit) but which can contain up to MaxInt bytes. This type helps avoiding
  // range check errors when working with buffers larger than 32768 bytes.
  TBigByteArray = array[0..MaxInt - 1] of byte;
  PBigByteArray = ^TBigByteArray;

{$IFDEF CLR}

  // not implemented
  TsdBufferedStream = class(TStream)
  private
    FStream: TStream;
    FOwned: Boolean;
  protected
    procedure SetSize(NewSize: Int64); override;
  public
    constructor Create(AStream: TStream; Owned: Boolean = False);
    destructor Destroy; override;
    function Read(var Buffer: array of Byte; Offset, Count: Longint): Longint; override;
    function Write(const Buffer: array of Byte; Offset, Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
  end;

  TsdBufferedReadStream = TsdBufferedStream;

  TsdBufferedWriteStream = TsdBufferedStream;

{$ELSE}

  // TsdBufferedReadStream is a buffered stream that takes another TStream
  // and reads only buffer-wise from it, and reads to the stream are first
  // done from the buffer. This stream type can only support reading.
  TsdBufferedReadStream = class(TStream)
  private
    FStream: TStream;
    FBuffer: PBigByteArray;
    FPage: integer;
    FBufPos: integer;
    FBufSize: integer;
    FPosition: longint;
    FOwned: boolean;
    FMustCheck: boolean;
  protected
    procedure CheckPosition;
  public
    // Create the buffered reader stream by passing the source stream in AStream,
    // this source stream must already be initialized. If Owned is set to True,
    // the source stream will be freed by TsdBufferedReadStream.
    constructor Create(AStream: TStream; Owned: boolean{$IFDEF D4UP} = False{$ENDIF});
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

  // TsdBufferedWriteStream is a buffered stream that takes another TStream
  // and writes only buffer-wise to it, and writes to the stream are first
  // done to the buffer. This stream type can only support writing.
  TsdBufferedWriteStream = class(TStream)
  private
    FStream: TStream;
    FBuffer: PBigByteArray;
    FBufPos: integer;
    FPosition: longint;
    FOwned: boolean;
  protected
    procedure Flush;
  public
    // Create the buffered writer stream by passing the destination stream in AStream,
    // this destination stream must already be initialized. If Owned is set to True,
    // the destination stream will be freed by TsdBufferedWriteStream.
    constructor Create(AStream: TStream; Owned: boolean{$IFDEF D4UP} = False{$ENDIF});
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

{$ENDIF}

  // TsdCodecStream is the base codec class for reading and writing encoded files.
  // See TsdAnsiStream and TsdUtf8Stream for more information.
  TsdCodecStream = class(TStream)
  private
    FBuffer: string;                // Buffer that holds temporary utf8 characters
    FBufferPos: integer;            // Current character in buffer
    FEncoding: TStringEncodingType; // Type of string encoding used for the external stream
    FMode: TsdStreamModeType;       // Access mode of this UTF stream, determined after first read/write
    FPosMin1: integer;              // Position for seek(-1)
    FPosMin2: integer;              // Position for seek(-2)
    FStream: TStream;               // Referenced stream
    FSwapByteOrder: boolean;
    FWarningUnicodeLoss: boolean;   // There was a warning for a unicode conversion loss
    FWriteBom: boolean;
    FOnUnicodeLoss: TNotifyEvent;   // This event is called if there is a warning for unicode conversion loss
  protected
    function ReadByte: byte; virtual;
    procedure StorePrevPositions; virtual;
    procedure WriteByte(const B: byte); virtual;
    procedure WriteBuf(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Offset, Count: longint); virtual;
    function InternalRead(var Buffer{$IFDEF CLR}: array of Byte{$ENDIF}; Offset, Count: Longint): Longint;
    function InternalSeek(Offset: Longint; Origin: TSeekOrigin): Longint;
    function InternalWrite(const Buffer{$IFDEF CLR}: array of Byte{$ENDIF}; Offset, Count: Longint): Longint;
    {$IFDEF CLR}
    procedure SetSize(NewSize: Int64); override;
    {$ENDIF}
  public
    // Call Create to create a new TsdCodectream based on an input or output stream
    // in AStream. After the first Read, the input streamtype will be determined,
    // and the Encoding property will be set accordingly. When using Write to
    // write data to the referenced stream, the Encoding property must be set prior
    // to this, indicating what kind of stream to produce.
    constructor Create(AStream: TStream); virtual;
    // Read Count bytes from the referenced stream, and put them in Buffer. The function
    // returns the actual number of bytes read. The codec stream can only read
    // one byte at the time!
    {$IFDEF CLR}
    function Read(var Buffer: array of Byte; Offset, Count: Longint): Longint; override;
    {$ELSE}
    function Read(var Buffer; Count: Longint): Longint; override;
    {$ENDIF}
    // Seek to a new position in the stream, with Origin as a reference. The codec
    // stream can not seek when writing, and when reading can only go back one
    // character, or return a position. Position returned is the position
    // in the referenced stream.
    {$IFDEF CLR}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    {$ELSE}
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    {$ENDIF}
    // Write Count bytes from Buffer to the referenced stream, The function
    // returns the actual number of bytes written.
    {$IFDEF CLR}
    function Write(const Buffer: array of Byte; Offset, Count: Longint): Longint; override;
    {$ELSE}
    function Write(const Buffer; Count: Longint): Longint; override;
    {$ENDIF}
    // Set Encoding when writing to the preferred encoding of the output stream,
    // or read Encoding after reading the output stream to determine encoding type.
    property Encoding: TstringEncodingType read FEncoding write FEncoding;
    // \Read this value after loading an XML file. It will be True if there was a
    // warning for a unicode conversion loss.
    property WarningUnicodeLoss: boolean read FWarningUnicodeLoss;
    // This event is called if there is a warning for unicode conversion loss.
    property OnUnicodeLoss: TNotifyEvent read FOnUnicodeLoss write FOnUnicodeLoss;
  end;

  // TsdAnsiStream is a conversion stream that will load ANSI, UTF8 or
  // Unicode files and convert them into ANSI only. The stream can
  // also save ANSI data as UTF8 or Unicode. When there is a conversion
  // problem, the conversion routine gives proper warnings through
  // WarningUnicodeLoss and OnUnicodeLoss.
  TsdAnsiStream = class(TsdCodecStream)
  protected
    function ReadByte: byte; override;
    procedure WriteByte(const B: byte); override;
    procedure WriteBuf(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Offset, Count: longint); override;
  end;

  // TsdUdf8tream is a conversion stream that will load ANSI, UTF8 or
  // Unicode files and convert them into UTF8 only. The stream can
  // also save UTF8 data as Ansi, UTF8 or Unicode.
  TsdUtf8Stream = class(TsdCodecStream)
  private
  protected
    function ReadByte: byte; override;
    procedure WriteByte(const B: byte); override;
    procedure WriteBuf(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Offset, Count: longint); override;
  end;

  // TsdSurplusReader is a simple class that can store a few surplus characters
  // and returns these first before reading from the underlying stream
  TsdSurplusReader = class
  private
    FStream: TStream;
    FSurplus: string;
  public
    constructor Create(AStream: TStream);
    property Surplus: string read FSurplus write FSurplus;
    function ReadChar(var Ch: char): integer;
    function ReadCharSkipBlanks(var Ch: char): boolean;
  end;

  // Simple string builder class that allocates string memory more effectively
  // to avoid repeated re-allocation
  TsdStringBuilder = class
  private
    FData: string;
    FCurrentIdx: integer;
    function GetData(Index: integer): Char;
    procedure Reallocate(RequiredLength: integer);
  public
    constructor Create;
    procedure Clear;
    procedure AddChar(Ch: Char);
    procedure AddString(var S: string);
    function StringCopy(AFirst, ALength: integer): string;
    function Value: string;
    property Length: integer read FCurrentIdx;
    property Data[Index: integer]: Char read GetData; default;
  end;

// string functions

// Escape all required characters in string AValue.
function EscapeString(const AValue: string): string;

// Replace all escaped characters in string AValue by their original. This includes
// character references using &#...; and &#x...;
function UnEscapeStringUTF8(const AValue: string): string;

// Replace all escaped characters in string AValue by their original. This includes
// character references using &#...; and &#x...;, however, character codes above
// 255 are not replaced.
function UnEscapeStringANSI(const AValue: string): string;

// Enclose the string AValue in quotes.
function QuoteString(const AValue: string): string;
// Remove the quotes from string AValue.
function UnQuoteString(const AValue: string): string;

// This function adds control characters Chars repeatedly after each Interval
// of characters to string Value.
function AddControlChars(const AValue: string; const Chars: string; Interval: integer): string;

// This function removes control characters from string AValue (Tab, CR, LF and Space)
function RemoveControlChars(const AValue: string): string;

// Convert the string ADate to a TDateTime according to the W3C date/time specification
// as found here: http://www.w3.org/TR/NOTE-datetime
// If there is a conversion error, an exception will be raised.
function sdDateTimeFromString(const ADate: string): TDateTime;

// Convert the string ADate to a TDateTime according to the W3C date/time specification
// as found here: http://www.w3.org/TR/NOTE-datetime
// If there is a conversion error, the default value ADefault is returned.
function sdDateTimeFromStringDefault(const ADate: string; ADefault: TDateTime): TDateTime;

// Convert the TDateTime ADate to a string according to the W3C date/time specification
// as found here: http://www.w3.org/TR/NOTE-datetime
function sdDateTimeToString(ADate: TDateTime): string;

// Convert a number to a string, using SignificantDigits to indicate the number of
// significant digits, and AllowScientific to allow for scientific notation if that
// results in much shorter notatoin.
function sdWriteNumber(Value: double; SignificantDigits: integer; AllowScientific: boolean): string;

// Conversion between Ansi, UTF8 and Unicode

// Convert a widestring to a UTF8 encoded string
function sdUnicodeToUtf8(const W: widestring): string;

// Convert a normal ansi string to a UTF8 encoded string
function sdAnsiToUtf8(const S: string): string;

// Convert a UTF8 encoded string to a widestring
function sdUtf8ToUnicode(const S: string): widestring;

// Convert a UTF8 encoded string to a normal ansi string
function sdUtf8ToAnsi(const S: string): string;


// parse functions

// Find SubString within string S, only process characters between Start and Close.
// First occurrance is reported in APos. If something is found, function returns True.
function FindString(const SubString: string; const S: string; Start, Close: integer; var APos: integer): boolean;

// Detect if the SubString matches the characters in S from position Start. S may be
// actually longer than SubString, only length(SubString) characters are checked.
function MatchString(const SubString: string; const S: string; Start: integer): boolean;

// Find all Name="Value" pairs in string AValue (from Start to Close - 1), and put
// the resulting attributes in stringlist Attributes. This stringlist must already
// be initialized when calling this function.
procedure ParseAttributes(const AValue: string; Start, Close: integer; Attributes: TStrings);

// Trim the string AValue between Start and Close - 1 (remove whitespaces at start
// and end), not by adapting the string but by adjusting the Start and Close indices.
// If the resulting string still has a length > 0, the function returns True.
function TrimPos(const AValue: string; var Start, Close: integer): boolean;

// Encoding/Decoding functions

// Encode binary data in Source as BASE64. The function returns the BASE64 encoded
// data as string, without any linebreaks.
function EncodeBase64(const Source: string): string;

// Decode BASE64 data in Source into binary data. The function returns the binary
// data as string. Use a TStringStream to convert this data to a stream. The Source
// string may contain linebreaks and control characters, these will be stripped.
function DecodeBase64(const Source: string): string;

// Encode binary data in Source as BINHEX. The function returns the BINHEX encoded
// data as string, without any linebreaks.
function EncodeBinHex(const Source: string): string;

// Decode BINHEX data in Source into binary data. The function returns the binary
// data as string. Use a TStringStream to convert this data to a stream. The Source
// string may contain linebreaks and control characters, these will be stripped.
function DecodeBinHex(const Source: string): string;

{$IFDEF D4UP}
resourcestring
{$ELSE}
const
{$ENDIF}

  sxeErrorCalcStreamLength       = 'Error while calculating streamlength';
  sxeMissingDataInBinaryStream   = 'Missing data in binary stream';
  sxeMissingElementName          = 'Missing element name';
  sxeMissingCloseTag             = 'Missing close tag in element %s';
  sxeMissingDataAfterGreaterThan = 'Missing data after "<" in element %s';
  sxeMissingLessThanInCloseTag   = 'Missing ">" in close tag of element %s';
  sxeIncorrectCloseTag           = 'Incorrect close tag in element %s';
  sxeIllegalCharInNodeName       = 'Illegal character in node name "%s"';
  sxeMoreThanOneRootElement      = 'More than one root element found in xml';
  sxeMoreThanOneDeclaration      = 'More than one xml declaration found in xml';
  sxeDeclarationMustBeFirstElem  = 'Xml declaration must be first element';
  sxeMoreThanOneDoctype          = 'More than one doctype declaration found in root';
  sxeDoctypeAfterRootElement     = 'Doctype declaration found after root element';
  sxeNoRootElement               = 'No root element found in xml';
  sxeIllegalElementType          = 'Illegal element type';
  sxeCDATAInRoot                 = 'No CDATA allowed in root';
  sxeRootElementNotDefined       = 'XML root element not defined.';
  sxeCodecStreamNotAssigned      = 'Encoding stream unassigned';
  sxeUnsupportedEncoding         = 'Unsupported string encoding';
  sxeCannotReadCodecForWriting   = 'Cannot read from a conversion stream opened for writing';
  sxeCannotWriteCodecForReading  = 'Cannot write to an UTF stream opened for reading';
  sxeCannotReadMultipeChar       = 'Cannot read multiple chars from conversion stream at once';
  sxeCannotPerformSeek           = 'Cannot perform seek on codec stream';
  sxeCannotSeekBeforeReadWrite   = 'Cannot seek before reading or writing in conversion stream';
  sxeCannotSeek                  = 'Cannot perform seek in conversion stream';
  sxeCannotWriteToOutputStream   = 'Cannot write to output stream';
  sxeXmlNodeNotAssigned          = 'XML Node is not assigned';
  sxeCannotConverToBool          = 'Cannot convert value to bool';
  sxeCannotConvertToFloat        = 'Cannot convert value to float';
  sxeSignificantDigitsOutOfRange = 'Significant digits out of range';

implementation

{$IFDEF TRIALXML}
uses
  Dialogs;
{$ENDIF}

type

  // Internal type
  TTagType = record
    FStart: string;
    FClose: string;
    FStyle: TXmlElementType;
  end;
  PByte = ^byte;

  TBomInfo = packed record
    BOM: array[0..3] of byte;
    Len: integer;
    Enc: TStringEncodingType;
    HasBOM: boolean;
  end;

const

  // Count of different escape characters
  cEscapeCount = 5;

  // These are characters that must be escaped. Note that "&" is first since
  // when another would be replaced first (eg ">" by "&lt;") this could
  // cause the new "&" in "&lt;" to be replaced by "&amp;";
  cEscapes: array[0..cEscapeCount - 1] of string =
    ('&', '<', '>', '''', '"');

  // These are the strings that replace the escape strings - in the same order
  cReplaces: array[0..cEscapeCount - 1] of string =
    ('&amp;', '&lt;', '&gt;', '&apos;', '&quot;');

  cQuoteChars: set of char = ['"', ''''];
  cControlChars: set of char = [#9, #10, #13, #32]; {Tab, LF, CR, Space}

  // Count of different XML tags
  cTagCount = 12;

  cTags: array[0..cTagCount - 1] of TTagType = (
    // The order is important here; the items are searched for in appearing order
    (FStart: '<![CDATA[';        FClose: ']]>'; FStyle: xeCData),
    (FStart: '<!DOCTYPE';        FClose: '>';   FStyle: xeDoctype),
    (FStart: '<!ELEMENT';        FClose: '>';   FStyle: xeElement),
    (FStart: '<!ATTLIST';        FClose: '>';   FStyle: xeAttList),
    (FStart: '<!ENTITY';         FClose: '>';   FStyle: xeEntity),
    (FStart: '<!NOTATION';       FClose: '>';   FStyle: xeNotation),
    (FStart: '<?xml-stylesheet'; FClose: '?>';  FStyle: xeStylesheet),
    (FStart: '<?xml';            FClose: '?>';  FStyle: xeDeclaration),
    (FStart: '<!--';             FClose: '-->'; FStyle: xeComment),
    (FStart: '<!';               FClose: '>';   FStyle: xeExclam),
    (FStart: '<?';               FClose: '?>';  FStyle: xeQuestion),
    (FStart: '<';                FClose: '>';   FStyle: xeNormal) );
    // direct tags are derived from Normal tags by checking for the />

  // These constant are used when generating hexchars from buffer data
  cHexChar:       array[0..15] of char = '0123456789ABCDEF';
  cHexCharLoCase: array[0..15] of char = '0123456789abcdef';

  // These characters are used when generating BASE64 chars from buffer data
  cBase64Char: array[0..63] of char =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  cBase64PadChar: char = '=';

  // The amount of bytes to allocate with each increase of the value buffer
  cNodeValueBuf = 2048;

  // byte order marks for strings
  // Unicode text files should contain $FFFE as first character to identify such a file clearly. Depending on the system
  // where the file was created on this appears either in big endian or little endian style.

  const cBomInfoCount = 15;
  const cBomInfo: array[0..cBomInfoCount - 1] of TBomInfo =
  ( (BOM: ($00,$00,$FE,$FF); Len: 4; Enc: seUCS4BE;    HasBOM: true),
    (BOM: ($FF,$FE,$00,$00); Len: 4; Enc: seUCS4LE;    HasBOM: true),
    (BOM: ($00,$00,$FF,$FE); Len: 4; Enc: seUCS4_2143; HasBOM: true),
    (BOM: ($FE,$FF,$00,$00); Len: 4; Enc: seUCS4_3412; HasBOM: true),
    (BOM: ($FE,$FF,$00,$00); Len: 2; Enc: seUTF16BE;   HasBOM: true),
    (BOM: ($FF,$FE,$00,$00); Len: 2; Enc: seUTF16LE;   HasBOM: true),
    (BOM: ($EF,$BB,$BF,$00); Len: 3; Enc: seUTF8;      HasBOM: true),
    (BOM: ($00,$00,$00,$3C); Len: 4; Enc: seUCS4BE;    HasBOM: false),
    (BOM: ($3C,$00,$00,$00); Len: 4; Enc: seUCS4LE;    HasBOM: false),
    (BOM: ($00,$00,$3C,$00); Len: 4; Enc: seUCS4_2143; HasBOM: false),
    (BOM: ($00,$3C,$00,$00); Len: 4; Enc: seUCS4_3412; HasBOM: false),
    (BOM: ($00,$3C,$00,$3F); Len: 4; Enc: seUTF16BE;   HasBOM: false),
    (BOM: ($3C,$00,$3F,$00); Len: 4; Enc: seUTF16LE;   HasBOM: false),
    (BOM: ($3C,$3F,$78,$6D); Len: 4; Enc: se8Bit;      HasBOM: false),
    (BOM: ($4C,$6F,$A7,$94); Len: 4; Enc: seEBCDIC;    HasBOM: false)
  );

// .NET compatible stub for TBytes (array of byte) type
{$IFNDEF CLR}
type
  TBytes = TBigByteArray;
{$ENDIF}

// Delphi 3 and below stubs
{$IFNDEF D4UP}
function StringReplace(const S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := UpperCase(S);
    Patt := UpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

function StrToInt64Def(const AValue: string; ADefault: int64): int64;
begin
  Result := StrToIntDef(AValue, ADefault);
end;

function StrToInt64(const AValue: string): int64;
begin
  Result := StrToInt(AValue);
end;
{$ENDIF}

// Delphi 4 stubs
{$IFNDEF D5UP}
function AnsiPos(const Substr, S: string): Integer;
begin
  Result := Pos(Substr, S);
end;

function AnsiQuotedStr(const S: string; Quote: Char): string;
var
  P, Src, Dest: PChar;
  AddCount: Integer;
begin
  AddCount := 0;
  P := StrScan(PChar(S), Quote);
  while P <> nil do
  begin
    Inc(P);
    Inc(AddCount);
    P := StrScan(P, Quote);
  end;
  if AddCount = 0 then
  begin
    Result := Quote + S + Quote;
    Exit;
  end;
  SetLength(Result, Length(S) + AddCount + 2);
  Dest := Pointer(Result);
  Dest^ := Quote;
  Inc(Dest);
  Src := Pointer(S);
  P := StrScan(Src, Quote);
  repeat
    Inc(P);
    Move(Src^, Dest^, P - Src);
    Inc(Dest, P - Src);
    Dest^ := Quote;
    Inc(Dest);
    Src := P;
    P := StrScan(Src, Quote);
  until P = nil;
  P := StrEnd(Src);
  Move(Src^, Dest^, P - Src);
  Inc(Dest, P - Src);
  Dest^ := Quote;
end;

function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string;
var
  P, Dest: PChar;
  DropCount: Integer;
begin
  Result := '';
  if (Src = nil) or (Src^ <> Quote) then
    Exit;
  Inc(Src);
  DropCount := 1;
  P := Src;
  Src := StrScan(Src, Quote);
  while Src <> nil do
  begin
    Inc(Src);
    if Src^ <> Quote then
      Break;
    Inc(Src);
    Inc(DropCount);
    Src := StrScan(Src, Quote);
  end;
  if Src = nil then
    Src := StrEnd(P);
  if ((Src - P) <= 1) then
    Exit;
  if DropCount = 1 then
    SetString(Result, P, Src - P - 1)
  else
  begin
    SetLength(Result, Src - P - DropCount);
    Dest := PChar(Result);
    Src := StrScan(P, Quote);
    while Src <> nil do
    begin
      Inc(Src);
      if Src^ <> Quote then
        Break;
      Move(P^, Dest^, Src - P);
      Inc(Dest, Src - P);
      Inc(Src);
      P := Src;
      Src := StrScan(Src, Quote);
    end;
    if Src = nil then
      Src := StrEnd(P);
    Move(P^, Dest^, Src - P - 1);
  end;
end;

procedure FreeAndNil(var Obj);
var
  P: TObject;
begin
  P := TObject(Obj);
  TObject(Obj) := nil;
  P.Free;
end;
{$ENDIF}

// .NET-compatible TStream.Write

function StreamWrite(Stream: TStream; const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Offset, Count: Longint): Longint;
begin
{$IFDEF CLR}
  Result := Stream.Write(Buffer, Offset, Count);
{$ELSE}
  Result := Stream.Write(TBytes(Buffer)[Offset], Count);
{$ENDIF}
end;

{$IFNDEF CLR}
// Delphi's implementation of TStringStream is severely flawed, it does a SetLength
// on each write, which slows down everything to a crawl. This implementation over-
// comes this issue.
type
  TsdStringStream = class(TMemoryStream)
  public
    constructor Create(const S: string);
    function DataString: string;
  end;

constructor TsdStringStream.Create(const S: string);
begin
  inherited Create;
  SetSize(length(S));
  if Size > 0 then
  begin
    Write(S[1], Size);
    Position := 0;
  end;
end;

function TsdStringStream.DataString: string;
begin
  SetLength(Result, Size);
  if Size > 0 then
  begin
    Position := 0;
    Read(Result[1], length(Result));
  end;
end;
{$ELSE}
// In .NET we use the standard TStringStream
type
  TsdStringStream = TStringStream;
{$ENDIF}

// Utility functions

function Min(A, B: integer): integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(A, B: integer): integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function EscapeString(const AValue: string): string;
var
  i: integer;
begin
  Result := AValue;
  for i := 0 to cEscapeCount - 1 do
    Result := StringReplace(Result, cEscapes[i], cReplaces[i], [rfReplaceAll]);
end;

function UnEscapeStringUTF8(const AValue: string): string;
var
  SearchStr, Reference, Replace: string;
  i, Offset, Code: Integer;
  W: word;
begin
  SearchStr := AValue;
  Result := '';
  while SearchStr <> '' do
  begin
    // find '&'
    Offset := AnsiPos('&', SearchStr);
    if Offset = 0 then
    begin
      // Nothing found
      Result := Result + SearchStr;
      Break;
    end;
    Result := Result + Copy(SearchStr, 1, Offset - 1);
    SearchStr := Copy(SearchStr, Offset, MaxInt);
    // find next ';'
    Offset := AnsiPos(';', SearchStr);
    if Offset = 0 then
    begin
      // Error: encountered a '&' but not a ';'.. we will ignore, just return
      // the unmodified value
      Result := Result + SearchStr;
      Break;
    end;
    // Reference
    Reference := copy(SearchStr, 1, Offset);
    SearchStr := Copy(SearchStr, Offset + 1, MaxInt);
    Replace := Reference;
    // See if it is a character reference
    if copy(Reference, 1, 2) = '&#' then
    begin
      Reference := copy(Reference, 3, length(Reference) - 3);
      if length(Reference) > 0 then
      begin
        if lowercase(Reference[1]) = 'x' then
          // Hex notation
          Reference[1] := '$';
        Code := StrToIntDef(Reference, -1);
        if (Code >= 0) and (Code < $FFFF) then
        begin
          W := Code;
          {$IFDEF D5UP}
          Replace := sdUnicodeToUtf8(WideChar(W));
          {$ELSE}
          Replace := char(W and $FF);
          {$ENDIF}
        end;
      end;
    end else
    begin
      // Look up default escapes
      for i := 0 to cEscapeCount - 1 do
        if Reference = cReplaces[i] then
        begin
          // Replace
          Replace := cEscapes[i];
          Break;
        end;
    end;
    // New result
    Result := Result + Replace;
  end;
end;

function UnEscapeStringANSI(const AValue: string): string;
var
  SearchStr, Reference, Replace: string;
  i, Offset, Code: Integer;
  B: byte;
begin
  SearchStr := AValue;
  Result := '';
  while SearchStr <> '' do
  begin
    // find '&'
    Offset := AnsiPos('&', SearchStr);
    if Offset = 0 then
    begin
      // Nothing found
      Result := Result + SearchStr;
      Break;
    end;
    Result := Result + Copy(SearchStr, 1, Offset - 1);
    SearchStr := Copy(SearchStr, Offset, MaxInt);
    // find next ';'
    Offset := AnsiPos(';', SearchStr);
    if Offset = 0 then
    begin
      // Error: encountered a '&' but not a ';'.. we will ignore, just return
      // the unmodified value
      Result := Result + SearchStr;
      Break;
    end;
    // Reference
    Reference := copy(SearchStr, 1, Offset);
    SearchStr := Copy(SearchStr, Offset + 1, MaxInt);
    Replace := Reference;
    // See if it is a character reference
    if copy(Reference, 1, 2) = '&#' then
    begin
      Reference := copy(Reference, 3, length(Reference) - 3);
      if length(Reference) > 0 then
      begin
        if lowercase(Reference[1]) = 'x' then
          // Hex notation
          Reference[1] := '$';
        Code := StrToIntDef(Reference, -1);
        if (Code >= 0) and (Code < $FF) then
        begin
          B := Code;
          Replace := char(B);
        end;
      end;
    end else
    begin
      // Look up default escapes
      for i := 0 to cEscapeCount - 1 do
        if Reference = cReplaces[i] then
        begin
          // Replace
          Replace := cEscapes[i];
          Break;
        end;
    end;
    // New result
    Result := Result + Replace;
  end;
end;

function QuoteString(const AValue: string): string;
var
  AQuoteChar: char;
begin
  AQuoteChar := '"';
  if Pos('"', AValue) > 0 then
    AQuoteChar := '''';
{$IFDEF CLR}
  Result := QuotedStr(AValue, AQuoteChar);
{$ELSE}
  Result := AnsiQuotedStr(AValue, AQuoteChar);
{$ENDIF}
end;

function UnQuoteString(const AValue: string): string;
{$IFNDEF CLR}
var
  P: PChar;
{$ENDIF}
begin
  if Length(AValue) < 2 then
  begin
    Result := AValue;
    exit;
  end;
  if AValue[1] in cQuoteChars then
  begin
    {$IFDEF CLR}
    Result := DequotedStr(AValue, AValue[1]);
    {$ELSE}
    P := PChar(AValue);
    Result := AnsiExtractQuotedStr(P, AValue[1]);
    {$ENDIF}
  end else
    Result := AValue;
end;

function AddControlChars(const AValue: string; const Chars: string; Interval: integer): string;
// Insert Chars in AValue at each Interval chars
var
  i, j, ALength: integer;
  // local
  procedure InsertControlChars;
  var
    k: integer;
  begin
    for k := 1 to Length(Chars) do
    begin
      Result[j] := Chars[k];
      inc(j);
    end;
  end;
// main
begin
  if (Length(Chars) = 0) or (Interval <= 0) then
  begin
    Result := AValue;
    exit;
  end;

  // Calculate length based on original length and total extra length for control chars
  ALength := Length(AValue) + ((Length(AValue) - 1) div Interval + 3) * Length(Chars);
  SetLength(Result, ALength);

  // Copy and insert
  j := 1;
  for i := 1 to Length(AValue) do
  begin
    if (i mod Interval) = 1 then
      // Insert control chars
      InsertControlChars;
    Result[j] := AValue[i];
    inc(j);
  end;
  InsertControlChars;

  // Adjust length
  dec(j);
  if ALength > j then
    SetLength(Result, j);
end;

function RemoveControlChars(const AValue: string): string;
// Remove control characters from string in AValue
var
  i, j: integer;
begin
  Setlength(Result, Length(AValue));
  i := 1;
  j := 1;
  while i <= Length(AValue) do
    if AValue[i] in cControlChars then
      inc(i)
    else
    begin
      Result[j] := AValue[i];
      inc(i);
      inc(j);
    end;
  // Adjust length
  if i <> j then
    SetLength(Result, j - 1);
end;

function FindString(const SubString: string; const S: string; Start, Close: integer; var APos: integer): boolean;
// Check if the Substring matches the string S in any position in interval Start to Close - 1
// and returns found positon in APos. Result = True if anything is found.
// Note: this funtion is case-insensitive
var
  CharIndex: integer;
begin
  Result := False;
  APos := 0;
  for CharIndex := Start to Close - Length(SubString) do
    if MatchString(SubString, S, CharIndex) then
    begin
      APos := CharIndex;
      Result := True;
      exit;
    end;
end;

function MatchString(const SubString: string; const S: string; Start: integer): boolean;
// Check if the Substring matches the string S at position Start.
// Note: this funtion is case-insensitive
var
  CharIndex: integer;
begin
  Result := False;
  // Check range just in case
  if (Length(S) - Start + 1) < Length(Substring) then
    exit;

  CharIndex := 0;
  while CharIndex < Length(SubString) do
    if Upcase(SubString[CharIndex + 1]) = Upcase(S[Start + CharIndex]) then
      inc(CharIndex)
    else
      exit;
  // All chars were the same, so we succeeded
  Result := True;
end;

procedure ParseAttributes(const AValue: string; Start, Close: integer; Attributes: TStrings);
// Convert the attributes string AValue in [Start, Close - 1] to the attributes stringlist
var
  i: integer;
  InQuotes: boolean;
  AQuoteChar: char;
begin
  InQuotes := False;
  AQuoteChar := '"';
  if not assigned(Attributes) then
    exit;
  if not TrimPos(AValue, Start, Close) then
    exit;

  // Clear first
  Attributes.Clear;

  // Loop through characters
  for i := Start to Close - 1 do
  begin

    // In quotes?
    if InQuotes then
    begin
      if AValue[i] = AQuoteChar then
        InQuotes := False;
    end else
    begin
      if AValue[i] in cQuoteChars then
      begin
        InQuotes   := True;
        AQuoteChar := AValue[i];
      end;
    end;

    // Add attribute strings on each controlchar break
    if not InQuotes then
      if AValue[i] in cControlChars then
      begin
        if i > Start then
          Attributes.Add(copy(AValue, Start, i - Start));
        Start := i + 1;
      end;
  end;
  // Add last attribute string
  if Start < Close then
    Attributes.Add(copy(AValue, Start, Close - Start));

  // First-char "=" signs should append to previous
  for i := Attributes.Count - 1 downto 1 do
    if Attributes[i][1] = '=' then
    begin
      Attributes[i - 1] := Attributes[i - 1] + Attributes[i];
      Attributes.Delete(i);
    end;

  // First-char quotes should append to previous
  for i := Attributes.Count - 1 downto 1 do
    if (Attributes[i][1] in cQuoteChars) and (Pos('=', Attributes[i - 1]) > 0) then
    begin
      Attributes[i - 1] := Attributes[i - 1] + Attributes[i];
      Attributes.Delete(i);
    end;
end;

function TrimPos(const AValue: string; var Start, Close: integer): boolean;
// Trim the string in AValue in [Start, Close - 1] by adjusting Start and Close variables
begin
  // Checks
  Start := Max(1, Start);
  Close := Min(Length(AValue) + 1, Close);
  if Close <= Start then
  begin
    Result := False;
    exit;
  end;

  // Trim left
  while
    (Start < Close) and
    (AValue[Start] in cControlChars) do
    inc(Start);

  // Trim right
  while
    (Start < Close) and
    (AValue[Close - 1] in cControlChars) do
    dec(Close);

  // Do we have a string left?
  Result := Close > Start;
end;

procedure WriteStringToStream(S: TStream; const AString: string);
begin
  if Length(AString) > 0 then
  begin
    {$IFDEF CLR}
    S.Write(BytesOf(AString), Length(AString));
    {$ELSE}
    S.Write(AString[1], Length(AString));
    {$ENDIF}
  end;  
end;

function ReadOpenTag(AReader: TsdSurplusReader): integer;
// Try to read the type of open tag from S
var
  AIndex, i: integer;
  Found: boolean;
  Ch: char;
  Candidates: array[0..cTagCount - 1] of boolean;
  Surplus: string;
begin
  Surplus := '';
  Result := cTagCount - 1;
  for i := 0 to cTagCount - 1 do Candidates[i] := True;
  AIndex := 1;
  repeat
    Found := False;
    inc(AIndex);
    if AReader.ReadChar(Ch) = 0 then
      exit;
    Surplus := Surplus + Ch;
    for i := cTagCount - 1 downto 0 do
      if Candidates[i] and (length(cTags[i].FStart) >= AIndex) then
      begin
        if cTags[i].FStart[AIndex] = Ch then
        begin
          Found := True;
          if length(cTags[i].FStart) = AIndex then
            Result := i;
        end else
          Candidates[i] := False;
      end;
  until Found = False;
  // The surplus string that we already read (everything after the tag)
  AReader.Surplus := copy(Surplus, length(cTags[Result].FStart), length(Surplus));
end;

function ReadStringFromStreamUntil(AReader: TsdSurplusReader; const ASearch: string;
  var AValue: string; SkipQuotes: boolean): boolean;
var
  AIndex, ValueIndex, SearchIndex: integer;
  LastSearchChar, Ch: char;
  InQuotes: boolean;
  QuoteChar: Char;
  SB: TsdStringBuilder;
begin
  Result := False;
  InQuotes := False;

  // Get last searchstring character
  AIndex := length(ASearch);
  if AIndex = 0 then exit;
  LastSearchChar := ASearch[AIndex];

  SB := TsdStringBuilder.Create;
  try
    QuoteChar := #0;

    repeat
      // Add characters to the value to be returned
      if AReader.ReadChar(Ch) = 0 then
        exit;
      SB.AddChar(Ch);

      // Do we skip quotes?
      if SkipQuotes then
      begin
        if InQuotes then
        begin
          if (Ch = QuoteChar) then
            InQuotes := false;
        end else
        begin
          if Ch in cQuoteChars then
          begin
            InQuotes := true;
            QuoteChar := Ch;
          end;
        end;
      end;

      // In quotes? If so, we don't check the end condition
      if not InQuotes then
      begin
        // Is the last char the same as the last char of the search string?
        if Ch = LastSearchChar then
        begin

          // Check to see if the whole search string is present
          ValueIndex  := SB.Length - 1;
          SearchIndex := length(ASearch) - 1;
          if ValueIndex < SearchIndex then continue;

          Result := True;
          while (SearchIndex > 0)and Result do
          begin
            Result := SB[ValueIndex] = ASearch[SearchIndex];
            dec(ValueIndex);
            dec(SearchIndex);
          end;
        end;
      end;
    until Result;

    // Use only the part before the search string
    AValue := SB.StringCopy(1, SB.Length - length(ASearch));
  finally
    SB.Free;
  end;
end;

function ReadStringFromStreamWithQuotes(S: TStream; const Terminator: string;
  var AValue: string): boolean;
var
  Ch, QuoteChar: char;
  InQuotes: boolean;
  SB: TsdStringBuilder;
begin
  SB := TsdStringBuilder.Create;
  try
    QuoteChar := #0;
    Result := False;
    InQuotes := False;
    repeat
      if S.Read(Ch, 1) = 0 then exit;
      if not InQuotes then
      begin
        if (Ch = '"') or (Ch = '''') then
        begin
          InQuotes := True;
          QuoteChar := Ch;
        end;
      end else
      begin
        if Ch = QuoteChar then
          InQuotes := False;
      end;
      if not InQuotes and (Ch = Terminator) then
        break;
      SB.AddChar(Ch);
    until False;
    AValue := SB.Value;
    Result := True;
  finally
    SB.Free;
  end;
end;

function sdDateTimeFromString(const ADate: string): TDateTime;
// Convert the string ADate to a TDateTime according to the W3C date/time specification
// as found here: http://www.w3.org/TR/NOTE-datetime
var
  AYear, AMonth, ADay, AHour, AMin, ASec, AMSec: word;
begin
  AYear  := StrToInt(copy(ADate, 1, 4));
  AMonth := StrToInt(copy(ADate, 6, 2));
  ADay   := StrToInt(copy(ADate, 9, 2));
  if Length(ADate) > 16 then
  begin
    AHour := StrToInt(copy(ADate, 12, 2));
    AMin  := StrToInt(copy(ADate, 15, 2));
    ASec  := StrToIntDef(copy(ADate, 18, 2), 0); // They might be omitted, so default to 0
    AMSec := StrToIntDef(copy(ADate, 21, 3), 0); // They might be omitted, so default to 0
  end else
  begin
    AHour := 0;
    AMin  := 0;
    ASec  := 0;
    AMSec := 0;
  end;
  Result :=
    EncodeDate(AYear, AMonth, ADay) +
    EncodeTime(AHour, AMin, ASec, AMSec);
end;

function sdDateTimeFromStringDefault(const ADate: string; ADefault: TDateTime): TDateTime;
// Convert the string ADate to a TDateTime according to the W3C date/time specification
// as found here: http://www.w3.org/TR/NOTE-datetime
// If there is a conversion error, the default value ADefault is returned.
begin
  try
    Result := sdDateTimeFromString(ADate);
  except
    Result := ADefault;
  end;
end;

function sdDateTimeToString(ADate: TDateTime): string;
// Convert the TDateTime ADate to a string according to the W3C date/time specification
// as found here: http://www.w3.org/TR/NOTE-datetime
var
  AYear, AMonth, ADay, AHour, AMin, ASec, AMSec: word;
begin
  DecodeDate(ADate, AYear, AMonth, ADay);
  DecodeTime(ADate, AHour, AMin, ASec, AMSec);
  if frac(ADate) = 0 then
    Result := Format('%.4d-%.2d-%.2d', [AYear, AMonth, ADay])
  else
    Result := Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.%.3dZ',
      [AYear, AMonth, ADay, AHour, AMin, ASec, AMSec]);
end;

function sdWriteNumber(Value: double; SignificantDigits: integer; AllowScientific: boolean): string;
const
  Limits: array[1..9] of integer =
    (10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000);
var
  Limit, Limitd, PointPos, IntVal, ScPower: integer;
  Body: string;
begin
  if (SignificantDigits < 1) or (SignificantDigits > 9) then
    raise Exception.Create(sxeSignificantDigitsOutOfRange);

  // Zero
  if Value = 0 then
  begin
    Result := '0';
    exit;
  end;

  // Sign
  if Value < 0 then
  begin
    Result := '-';
    Value := -Value;
  end else
    Result := '';

  // Determine point position
  Limit := Limits[SignificantDigits];
  Limitd := Limit div 10;
  PointPos := SignificantDigits;
  while Value < Limitd do
  begin
    Value := Value * 10;
    dec(PointPos);
  end;
  while Value >= Limit do
  begin
    Value := Value * 0.1;
    inc(PointPos);
  end;

  // Round
  IntVal := round(Value);

  // Exceptional case which happens when the value rounds up to the limit
  if Intval = Limit then
  begin
    IntVal := IntVal div 10;
    inc(PointPos);
  end;

  // Strip off any zeros, these reduce significance count
  while (IntVal mod 10 = 0) and (PointPos < SignificantDigits) do
  begin
    dec(SignificantDigits);
    IntVal := IntVal div 10;
  end;

  // Check for scientific notation
  ScPower := 0;
  if AllowScientific and ((PointPos < -1) or (PointPos > SignificantDigits + 2)) then
  begin
    ScPower := PointPos - 1;
    dec(PointPos, ScPower);
  end;

  // Body
  Body := IntToStr(IntVal);
  while PointPos > SignificantDigits do
  begin
    Body := Body + '0';
    inc(SignificantDigits);
  end;
  while PointPos < 0 do
  begin
    Body := '0' + Body;
    inc(PointPos);
  end;
  if PointPos = 0 then
    Body := '.' + Body
  else
    if PointPos < SignificantDigits then
      Body := copy(Body, 1, PointPos) + '.' + copy(Body, PointPos + 1, SignificantDigits);

  // Final result
  if ScPower = 0 then
    Result := Result + Body
  else
    Result := Result + Body + 'E' + IntToStr(ScPower);
end;

{$IFDEF CLR}

function sdUnicodeToUtf8(const W: widestring): string;
begin
  Result := Encoding.UTF8.GetBytes(W);
end;

function sdUtf8ToUnicode(const S: string): widestring;
begin
  Result := Encoding.UTF8.GetString(BytesOf(S));
end;

function EncodeBase64Buf(const Buffer: TBytes; Count: Integer): string;
begin
  Result := Convert.ToBase64String(Buffer, 0, Count);
end;

function EncodeBase64(const Source: string): string;
begin
  Result := Convert.ToBase64String(BytesOf(Source));
end;

procedure DecodeBase64Buf(const Source: string; var Buffer: TBytes; Count: Integer);
var
  ADecoded: TBytes;
begin
  ADecoded := Convert.FromBase64String(Source);
  if Count > Length(ADecoded) then
    raise EFilerError.Create(sxeMissingDataInBinaryStream);
  SetLength(ADecoded, Count);
  Buffer := ADecoded;
end;

function DecodeBase64(const Source: string): string;
begin
  Result := AnsiString(Convert.FromBase64String(Source));
end;

{$ELSE}

function PtrUnicodeToUtf8(Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Cardinal;
begin
  Result := 0;
  if not assigned(Source) or not assigned(Dest) then
    exit;

  count := 0;
  i := 0;

  while (i < SourceChars) and (count < MaxDestBytes) do
  begin
    c := Cardinal(Source[i]);
    Inc(i);
    if c <= $7F then
    begin
      Dest[count] := Char(c);
      Inc(count);
    end else
      if c > $7FF then
      begin
        if count + 3 > MaxDestBytes then
          break;
        Dest[count] := Char($E0 or (c shr 12));
        Dest[count+1] := Char($80 or ((c shr 6) and $3F));
        Dest[count+2] := Char($80 or (c and $3F));
        Inc(count,3);
      end else
      begin //  $7F < Source[i] <= $7FF
        if count + 2 > MaxDestBytes then
          break;
        Dest[count] := Char($C0 or (c shr 6));
        Dest[count+1] := Char($80 or (c and $3F));
        Inc(count,2);
      end;
  end;
  if count >= MaxDestBytes then
    count := MaxDestBytes-1;
  Dest[count] := #0;
  Result := count + 1;  // convert zero based index to byte count
end;

function PtrUtf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar;
  SourceBytes: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Byte;
  wc: Cardinal;
begin
  if not assigned(Dest) or not assigned(Source) then
  begin
    Result := 0;
    Exit;
  end;
  Result := Cardinal(-1);
  count := 0;
  i := 0;
  while (i < SourceBytes) and (count < MaxDestChars) do
  begin
    wc := Cardinal(Source[i]);
    Inc(i);
    if (wc and $80) <> 0 then
    begin
      if i >= SourceBytes then
        // incomplete multibyte char
        Exit;
      wc := wc and $3F;
      if (wc and $20) <> 0 then
      begin
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then
          // malformed trail byte or out of range char
          Exit;
        if i >= SourceBytes then
          // incomplete multibyte char
          Exit;
        wc := (wc shl 6) or (c and $3F);
      end;
      c := Byte(Source[i]);
      Inc(i);
      if (c and $C0) <> $80 then
        // malformed trail byte
        Exit;
      Dest[count] := WideChar((wc shl 6) or (c and $3F));
    end else
      Dest[count] := WideChar(wc);
    Inc(count);
  end;

  if count >= MaxDestChars then
    count := MaxDestChars-1;

  Dest[count] := #0;
  Result := count + 1;
end;

function sdUnicodeToUtf8(const W: widestring): string;
var
  L: integer;
  Temp: string;
begin
  Result := '';
  if W = '' then Exit;
  SetLength(Temp, Length(W) * 3); // SetLength includes space for null terminator

  L := PtrUnicodeToUtf8(PChar(Temp), Length(Temp) + 1, PWideChar(W), Length(W));
  if L > 0 then
    SetLength(Temp, L - 1)
  else
    Temp := '';
  Result := Temp;
end;

function sdUtf8ToUnicode(const S: string): widestring;
var
  L: Integer;
  Temp: WideString;
begin
  Result := '';
  if S = '' then Exit;
  SetLength(Temp, Length(S));

  L := PtrUtf8ToUnicode(PWideChar(Temp), Length(Temp)+1, PChar(S), Length(S));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

function EncodeBase64Buf(const Buffer; Count: Integer): string;
var
  i, j: integer;
  ACore: integer;
  ALong: cardinal;
  S: PByte;
begin
  // Make sure ASize is always a multiple of 3, and this multiple
  // gets saved as 4 characters
  ACore := (Count + 2) div 3;

  // Set the length of the string that stores encoded characters
  SetLength(Result, ACore * 4);
  S := @Buffer;
  // Do the loop ACore times
  for i := 0 to ACore - 1 do
  begin
    ALong := 0;
    for j := 0 to 2 do
    begin
      ALong := ALong shl 8 + S^;
      inc(S);
    end;
    for j := 0 to 3 do
    begin
      Result[i * 4 + 4 - j] := cBase64Char[ALong and $3F];
      ALong := ALong shr 6;
    end;
  end;
  // For comformity to Base64, we must pad the data instead of zero out
  // if the size is not an exact multiple of 3
  case ACore * 3 - Count of
  0:;// nothing to do
  1: // pad one byte
    Result[ACore * 4] := cBase64PadChar;
  2: // pad two bytes
    begin
      Result[ACore * 4    ] := cBase64PadChar;
      Result[ACore * 4 - 1] := cBase64PadChar;
    end;
  end;//case
end;

function EncodeBase64(const Source: string): string;
// Encode binary data in Source as BASE64. The function returns the BASE64 encoded
// data as string, without any linebreaks.
begin
  if length(Source) > 0 then
    Result := EncodeBase64Buf(Source[1], length(Source))
  else
    Result := '';
end;

procedure DecodeBase64Buf(var Source: string; var Buffer; Count: Integer);
var
  i, j: integer;
  BufPos, Core: integer;
  LongVal: cardinal;
  D: PByte;
  Map: array[Char] of byte;
begin
  // Core * 4 is the number of chars to read - check length
  Core := Length(Source) div 4;
  if Count > Core * 3 then
    raise EFilerError.Create(sxeMissingDataInBinaryStream);

  // Prepare map
  for i := 0 to 63 do
    Map[cBase64Char[i]] := i;
  D := @Buffer;

  // Check for final padding, and replace with "zeros". There can be
  // at max two pad chars ('=')
  BufPos := length(Source);
  if (BufPos > 0) and (Source[BufPos] = cBase64PadChar) then
  begin
    Source[BufPos] := cBase64Char[0];
    dec(BufPos);
    if (BufPos > 0) and (Source[BufPos] = cBase64PadChar) then
      Source[BufPos] := cBase64Char[0];
  end;

  // Do this Core times
  for i := 0 to Core - 1 do
  begin
    LongVal := 0;
    // Unroll the characters
    for j := 0 to 3 do
      LongVal := LongVal shl 6 + Map[Source[i * 4 + j + 1]];
    // and unroll the bytes
    for j := 2 downto 0 do
    begin
      // Check overshoot
      if integer(D) - integer(@Buffer) >= Count then
        exit;
      D^ := LongVal shr (j * 8) and $FF;
      inc(D);
    end;
  end;
end;

function DecodeBase64(const Source: string): string;
// Decode BASE64 data in Source into binary data. The function returns the binary
// data as string. Use a TStringStream to convert this data to a stream.
var
  BufData: string;
  BufSize, BufPos: integer;
begin
  BufData := RemoveControlChars(Source);

  // Determine length of data
  BufSize := length(BufData) div 4;
  if BufSize * 4 <> length(BufData) then
    raise EFilerError.Create(sxeErrorCalcStreamLength);
  BufSize := BufSize * 3;
  // Check padding chars
  BufPos := length(BufData);
  if (BufPos > 0) and (BufData[BufPos] = cBase64PadChar) then
  begin
    dec(BufPos);
    dec(BufSize);
    if (BufPos > 0) and (BufData[BufPos] = cBase64PadChar) then
      dec(BufSize);
  end;
  Setlength(Result, BufSize);

  // Decode
  if BufSize > 0 then
    DecodeBase64Buf(BufData, Result[1], BufSize);
end;

{$ENDIF}

function sdAnsiToUtf8(const S: string): string;
begin
  Result := sdUnicodeToUtf8(S);
end;

function sdUtf8ToAnsi(const S: string): string;
begin
  Result := sdUtf8ToUnicode(S);
end;

function EncodeBinHexBuf(const Source; Count: Integer): string;
// Encode binary data in Source as BINHEX. The function returns the BINHEX encoded
// data as string, without any linebreaks.
var
{$IFDEF CLR}
  Text: TBytes;
{$ELSE}
  Text: string;
{$ENDIF}
begin
  SetLength(Text, Count * 2);
{$IFDEF CLR}
  BinToHex(TBytes(Source), 0, Text, 0, Count);
{$ELSE}
{$IFDEF D4UP}
  BinToHex(PChar(@Source), PChar(Text), Count);
{$ELSE}
  raise Exception.Create(sxeUnsupportedEncoding);
{$ENDIF}
{$ENDIF}
  Result := Text;
end;

function EncodeBinHex(const Source: string): string;
// Encode binary data in Source as BINHEX. The function returns the BINHEX encoded
// data as string, without any linebreaks.
var
{$IFDEF CLR}
  Text: TBytes;
{$ELSE}
  Text: string;
{$ENDIF}
begin
  SetLength(Text, Length(Source) * 2);
{$IFDEF CLR}
  BinToHex(BytesOf(Source), 0, Text, 0, Length(Source));
{$ELSE}
{$IFDEF D4UP}
  BinToHex(PChar(Source), PChar(Text), Length(Source));
{$ELSE}
  raise Exception.Create(sxeUnsupportedEncoding);
{$ENDIF}
{$ENDIF}
  Result := Text;
end;

procedure DecodeBinHexBuf(const Source: string; var Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Count: Integer);
// Decode BINHEX data in Source into binary data.
begin
  if Length(Source) div 2 < Count then
    raise EFilerError.Create(sxeMissingDataInBinaryStream);

{$IFDEF CLR}
  HexToBin(BytesOf(Source), 0, Buffer, 0, Count);
{$ELSE}
{$IFDEF D4UP}
  HexToBin(PChar(Source), PChar(@Buffer), Count);
{$ELSE}
  raise Exception.Create(sxeUnsupportedEncoding);
{$ENDIF}
{$ENDIF}
end;

function DecodeBinHex(const Source: string): string;
// Decode BINHEX data in Source into binary data. The function returns the binary
// data as string. Use a TStringStream to convert this data to a stream.
var
  AData: string;
  ASize: integer;
{$IFDEF CLR}
  Buffer: TBytes;
{$ELSE}
  Buffer: string;
{$ENDIF}
begin
  AData := RemoveControlChars(Source);

  // Determine length of data
  ASize := length(AData) div 2;
  if ASize * 2 <> length(AData) then
    raise EFilerError.Create(sxeErrorCalcStreamLength);

  SetLength(Buffer, ASize);
{$IFDEF CLR}
  HexToBin(BytesOf(AData), 0, Buffer, 0, ASize);
{$ELSE}
{$IFDEF D4UP}
  HexToBin(PChar(AData), PChar(Buffer), ASize);
{$ELSE}
  raise Exception.Create(sxeUnsupportedEncoding);
{$ENDIF}
{$ENDIF}
  Result := Buffer;
end;

function sdStringToBool(const AValue: string): boolean;
var
  Ch: Char;
begin
  if Length(AValue) > 0 then
  begin
    Ch := UpCase(AValue[1]);
    if Ch in ['T', 'Y'] then
    begin
      Result := True;
      exit;
    end;
    if Ch in ['F', 'N'] then
    begin
      Result := False;
      exit;
    end;
  end;
  raise Exception.Create(sxeCannotConverToBool);
end;

function sdStringFromBool(ABool: boolean): string;
const
  cBoolValues: array[boolean] of string = ('False', 'True');
begin
  Result := cBoolValues[ABool];
end;

{ TXmlNode }

function TXmlNode.AbortParsing: boolean;
begin
  Result := assigned(Document) and Document.AbortParsing;
end;

procedure TXmlNode.Assign(Source: TPersistent);
var
  i: integer;
  Node: TXmlNode;
begin
  if Source is TXmlNode then
  begin
    // Clear first
    Clear;

    // Properties
    FElementType := TXmlNode(Source).FElementType;
    FName := TXmlNode(Source).FName;
    FTag := TXmlNode(Source).FTag;
    FValue := TXmlNode(Source).FValue;

    // Attributes
    if assigned(TXmlNode(Source).FAttributes) then
    begin
      CheckCreateAttributesList;
      FAttributes.Assign(TXmlNode(Source).FAttributes);
    end;

    // Nodes
    for i := 0 to TXmlNode(Source).NodeCount - 1 do
    begin
      Node := NodeNew('');
      Node.Assign(TXmlNode(Source).Nodes[i]);
    end;
  end else
    if Source is TNativeXml then
    begin
      Assign(TNativeXml(Source).FRootNodes);
    end else
      inherited;
end;

procedure TXmlNode.AttributeAdd(const AName, AValue: string);
var
  Attr: string;
begin
  Attr := Format('%s=%s', [AName, QuoteString(EscapeString(AValue))]);
  CheckCreateAttributesList;
  FAttributes.Add(Attr);
end;

{$IFDEF D4UP}
procedure TXmlNode.AttributeAdd(const AName: string; AValue: integer);
begin
  AttributeAdd(AName, IntToStr(AValue));
end;
{$ENDIF}

procedure TXmlNode.AttributeDelete(Index: integer);
begin
  if (Index >= 0) and (Index < AttributeCount) then
    FAttributes.Delete(Index);
end;

procedure TXmlNode.AttributeExchange(Index1, Index2: integer);
var
  Temp: string;
begin
  if (Index1 <> Index2) and
     (Index1 >= 0) and (Index1 < FAttributes.Count) and
     (Index2 >= 0) and (Index2 < FAttributes.Count) then
  begin
    Temp := FAttributes[Index1];
    FAttributes[Index1] := FAttributes[Index2];
    FAttributes[Index2] := Temp;
  end;
end;

function TXmlNode.AttributeIndexByname(const AName: string): integer;
// Return the index of the attribute with name AName, or -1 if not found
var
  i: integer;
begin
  Result := -1;
  for i := 0 to AttributeCount - 1 do
    if AnsiCompareText(AttributeName[i], AName) = 0 then
    begin
      Result := i;
      exit;
    end;
end;

procedure TXmlNode.AttributesClear;
begin
  FreeAndNil(FAttributes);
end;

function TXmlNode.BufferLength: integer;
var
  BufData: string;
  BufPos: integer;
begin
  BufData := RemoveControlChars(FValue);
  case BinaryEncoding of
  xbeBinHex:
    begin
      Result := length(BufData) div 2;
      if Result * 2 <> length(BufData) then
        raise EFilerError.Create(sxeErrorCalcStreamLength);
    end;
  xbeBase64:
    begin
      Result := length(BufData) div 4;
      if Result * 4 <> length(BufData) then
        raise EFilerError.Create(sxeErrorCalcStreamLength);
      Result := Result * 3;
      // Check padding chars
      BufPos := length(BufData);
      if (BufPos > 0) and (BufData[BufPos] = cBase64PadChar) then
      begin
        dec(BufPos);
        dec(Result);
        if (BufPos > 0) and (BufData[BufPos] = cBase64PadChar) then
          dec(Result);
      end;
    end;
  else
    Result := 0; // avoid compiler warning
  end;
end;

procedure TXmlNode.BufferRead(var Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Count: Integer);
// Read data from XML binhex to the buffer
var
  BufData: string;
begin
  BufData := RemoveControlChars(FValue);
  case BinaryEncoding of
  xbeBinHex:
    DecodeBinHexBuf(BufData, Buffer, Count);
  xbeBase64:
    DecodeBase64Buf(BufData, Buffer, Count);
  end;
end;

procedure TXmlNode.BufferWrite(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Count: Integer);
// Write data from the buffer to XML in binhex format
var
  BufData: string;
begin
  if Count > 0 then
    case BinaryEncoding of
    xbeBinHex:
      BufData := EncodeBinHexBuf(Buffer, Count);
    xbeBase64:
      BufData := EncodeBase64Buf(Buffer, Count);
    end;

  // For comformity with Base64, we must add linebreaks each 76 characters
  FValue := AddControlChars(BufData, GetLineFeed + GetIndent, 76);
end;

procedure TXmlNode.ChangeDocument(ADocument: TNativeXml);
var
  i: integer;
begin
  FDocument := ADocument;
  for i := 0 to NodeCount - 1 do
    Nodes[i].ChangeDocument(ADocument);
end;

procedure TXmlNode.CheckCreateAttributesList;
begin
  if not assigned(FAttributes) then
  begin
    FAttributes := TStringList.Create;
    if assigned(FDocument) then
      FAttributes.Sorted := FDocument.SortAttributes;
  end;
end;

procedure TXmlNode.Clear;
begin
  // Name + value
  FName  := '';
  FValue := '';
  // Clear attributes and nodes
  AttributesClear;
  NodesClear;
end;

function TXmlNode.CompareNodeName(const NodeName: string): integer;
begin
  // Compare with FullPath or local name based on NodeName's first character
  if length(NodeName) > 0 then
    if NodeName[1] = '/' then
    begin
      // FullPath
      Result := AnsiCompareText(FullPath, NodeName);
      exit;
    end;
  // local name
  Result := AnsiCompareText(Name, NodeName);
end;

constructor TXmlNode.Create(ADocument: TNativeXml);
begin
  inherited Create;
  FDocument := ADocument;
end;

constructor TXmlNode.CreateName(ADocument: TNativeXml;
  const AName: string);
begin
  Create(ADocument);
  Name := AName;
end;

constructor TXmlNode.CreateNameValue(ADocument: TNativeXml; const AName,
  AValue: string);
begin
  Create(ADocument);
  Name := AName;
  ValueAsString := AValue;
end;

constructor TXmlNode.CreateType(ADocument: TNativeXml;
  AType: TXmlElementType);
begin
  Create(ADocument);
  FElementType  := AType;
end;

procedure TXmlNode.Delete;
begin
  if assigned(Parent) then
    Parent.NodeRemove(Self);
end;

procedure TXmlNode.DeleteEmptyAttributes;
var
  i: integer;
  V: string;
begin
 for i := AttributeCount - 1 downto 0 do
 begin
   V := AttributeValue[i];
   if length(V) = 0 then
     FAttributes.Delete(i);
 end;
end;

procedure TXmlNode.DeleteEmptyNodes;
var
  i: integer;
  Node: TXmlNode;
begin
  for i := NodeCount - 1 downto 0 do
  begin
    Node := Nodes[i];
    // Recursive call
    Node.DeleteEmptyNodes;
    // Check if we should delete child node
    if Node.IsEmpty then
      NodeDelete(i);
  end;
end;

destructor TXmlNode.Destroy;
begin
  NodesClear;
  AttributesClear;
  inherited;
end;

function TXmlNode.FindNode(const NodeName: string): TXmlNode;
// Find the first node which has name NodeName. Contrary to the NodeByName
// function, this function will search the whole subnode tree, using the
// DepthFirst method.
var
  i: integer;
begin
  Result := nil;
  // Loop through all subnodes
  for i := 0 to NodeCount - 1 do
  begin
    Result := Nodes[i];
    // If the subnode has name NodeName then we have a result, exit
    if Result.CompareNodeName(NodeName) = 0 then
      exit;
    // If not, we will search the subtree of this node
    Result := Result.FindNode(NodeName);
    if assigned(Result) then
      exit;
  end;
end;

procedure TXmlNode.FindNodes(const NodeName: string; const AList: TList);
  // local
  procedure FindNodesRecursive(ANode: TXmlNode; AList: TList);
  var
    i: integer;
  begin
    with ANode do
      for i := 0 to NodeCount - 1 do
      begin
        if Nodes[i].CompareNodeName(NodeName) = 0 then
          AList.Add(Nodes[i]);
        FindNodesRecursive(Nodes[i], AList);
      end;
  end;
// main
begin
  AList.Clear;
  FindNodesRecursive(Self, AList);
end;

function TXmlNode.FloatAllowScientific: boolean;
begin
  if assigned(Document) then
    Result := Document.FloatAllowScientific
  else
    Result := cDefaultFloatAllowScientific;
end;

function TXmlNode.FloatSignificantDigits: integer;
begin
  if assigned(Document) then
    Result := Document.FloatSignificantDigits
  else
    Result := cDefaultFloatSignificantDigits;
end;

function TXmlNode.FromAnsiString(const s: string): string;
begin
  if Utf8Encoded then
    Result := sdAnsiToUtf8(s)
  else
    Result := s;
end;

function TXmlNode.FromWidestring(const W: widestring): string;
begin
  if Utf8Encoded then
    Result := sdUnicodeToUtf8(W)
  else
    Result := W;
end;

function TXmlNode.GetAttributeByName(const AName: string): string;
begin
  if assigned(FAttributes) then
    Result := UnEscapeString(UnQuoteString(FAttributes.Values[AName]))
  else
    Result := '';
end;

function TXmlNode.GetAttributeByNameWide(const AName: string): widestring;
begin
  Result := ToWidestring(GetAttributeByName(AName));
end;

function TXmlNode.GetAttributeCount: integer;
begin
  if assigned(FAttributes) then
    Result := FAttributes.Count
  else
    Result := 0;
end;

function TXmlNode.GetAttributeName(Index: integer): string;
begin
  if (Index >= 0) and (Index < AttributeCount) then
    Result := FAttributes.Names[Index];
end;

function TXmlNode.GetAttributePair(Index: integer): string;
begin
  if (Index >= 0) and (Index < AttributeCount) then
    Result := FAttributes[Index];
end;

function TXmlNode.GetAttributeValue(Index: integer): string;
var
  P: integer;
  S: string;
begin
  Result := '';
  if (Index >= 0) and (Index < AttributeCount) then
  begin
    S := FAttributes[Index];
    P := AnsiPos('=', S);
    if P > 0 then
      Result := UnEscapeString(UnQuoteString(Copy(S, P + 1, MaxInt)));
  end;
end;

function TXmlNode.GetAttributeValueAsInteger(Index: integer): integer;
begin
  Result := StrToIntDef(GetAttributeValue(Index), 0);
end;

function TXmlNode.GetAttributeValueAsWidestring(Index: integer): widestring;
begin
  Result := ToWidestring(GetAttributeValue(Index));
end;

function TXmlNode.GetAttributeValueDirect(Index: integer): string;
var
  P: integer;
  S: string;
begin
  Result := '';
  if (Index >= 0) and (Index < AttributeCount) then
  begin
    S := FAttributes[Index];
    P := AnsiPos('=', S);
    if P > 0 then
      Result := UnQuoteString(Copy(S, P + 1, MaxInt));
  end;
end;

function TXmlNode.GetBinaryEncoding: TBinaryEncodingType;
begin
  Result := xbeBinHex;
  if assigned(Document) then
    Result := Document.BinaryEncoding;
end;

function TXmlNode.GetBinaryString: string;
// Get the binary contents of this node as Base64 and return it as a string
var
  OldEncoding: TBinaryEncodingType;
{$IFDEF CLR}
  Buffer: TBytes;
{$ENDIF}
begin
  // Set to base64
  OldEncoding := BinaryEncoding;
  try
    BinaryEncoding := xbeBase64;
    {$IFDEF CLR}
    SetLength(Buffer, BufferLength);
    if length(Buffer) > 0 then
      BufferRead(Buffer, length(Buffer));
    Result := Buffer;
    {$ELSE}
    SetLength(Result, BufferLength);
    if length(Result) > 0 then
      BufferRead(Result[1], length(Result));
    {$ENDIF}
  finally
    BinaryEncoding := OldEncoding;
  end;
end;

function TXmlNode.GetCascadedName: string;
// Return the name+index and all predecessors with underscores to separate, in
// order to get a unique reference that can be used in filenames
var
  LName: string;
begin
  LName :=  Format('%s%.4d', [Name, StrToIntDef(AttributeByName['Index'], 0)]);
  if assigned(Parent) then
    Result := Format('%s_%s', [Parent.CascadedName, LName])
  else
    Result := LName;
end;

function TXmlNode.GetFullPath: string;
// GetFullpath will return the complete path of the node from the root, e.g.
// /Root/SubNode1/SubNode2/ThisNode
begin
  Result := '/' + Name;
  if Treedepth > 0 then
    // Recursive call
    Result := Parent.GetFullPath + Result;
end;

function TXmlNode.GetIndent: string;
var
  i: integer;
begin
  if assigned(Document) then
  begin
    case Document.XmlFormat of
    xfCompact: Result := '';
    xfReadable:
      for i := 0 to TreeDepth - 1 do
        Result := Result + Document.IndentString;
    end; //case
  end else
    Result := ''
end;

function TXmlNode.GetLineFeed: string;
begin
  if assigned(Document) then
  begin
    case Document.XmlFormat of
    xfCompact: Result := '';
    xfReadable: Result := #13#10;
    else
      Result := #10;
    end; //case
  end else
    Result := '';
end;

function TXmlNode.GetNodeCount: integer;
begin
  if Assigned(FNodes) then
    Result := FNodes.Count
  else
    Result := 0;
end;

function TXmlNode.GetNodes(Index: integer): TXmlNode;
begin
  if (Index >= 0) and (Index < NodeCount) then
    Result := TXmlNode(FNodes[Index])
  else
    Result := nil;
end;

function TXmlNode.GetTotalNodeCount: integer;
var
  i: integer;
begin
  Result := NodeCount;
  for i := 0 to NodeCount - 1 do
    inc(Result, Nodes[i].TotalNodeCount);
end;

function TXmlNode.GetTreeDepth: integer;
begin
  Result := -1;
  if assigned(Parent) then
    Result := Parent.TreeDepth + 1;
end;

function TXmlNode.GetValueAsBool: boolean;
begin
  Result := sdStringToBool(FValue);
end;

function TXmlNode.GetValueAsDateTime: TDateTime;
begin
  Result := sdDateTimeFromString(ValueAsString);
end;

function TXmlNode.GetValueAsFloat: double;
var
  Code: integer;
begin
  val(StringReplace(FValue, ',', '.', []), Result, Code);
  if Code > 0 then
    raise Exception.Create(sxeCannotConvertToFloat);
end;

function TXmlNode.GetValueAsInt64: int64;
begin
  Result := StrToInt64(FValue);
end;

function TXmlNode.GetValueAsInteger: integer;
begin
  Result := StrToInt(FValue);
end;

function TXmlNode.GetValueAsString: string;
begin
  Result := UnEscapeString(FValue);
end;

function TXmlNode.GetValueAsWidestring: widestring;
begin
  Result := ToWidestring(ValueAsString);
end;

function TXmlNode.GetWriteOnDefault: boolean;
begin
  Result := True;
  if assigned(Document) then
    Result := Document.WriteOnDefault;
end;

function TXmlNode.HasAttribute(const AName: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to AttributeCount - 1 do
    if AnsiCompareText(AName, AttributeName[i]) = 0 then
    begin
      Result := True;
      exit;
    end;
end;

function TXmlNode.IndexInParent: integer;
// Retrieve our index in the parent's nodelist
var
  i: integer;
begin
  Result := -1;
  if assigned(Parent) then
    for i := 0 to Parent.NodeCount - 1 do
      if Self = Parent.Nodes[i] then
      begin
        Result := i;
        exit;
      end;
end;

function TXmlNode.IsClear: boolean;
begin
  Result := (Length(FName) = 0) and IsEmpty;
end;

function TXmlNode.IsEmpty: boolean;
begin
  Result := (Length(FValue) = 0) and (NodeCount = 0) and (AttributeCount = 0);
end;

function TXmlNode.IsEqualTo(ANode: TXmlNode; Options: TXmlCompareOptions;
  MismatchNodes: TList): boolean;
var
  i, Index: integer;
  NodeResult, ChildResult: boolean;
begin
  // Start with a negative result
  Result := False;
  NodeResult := False;
  if not assigned(ANode) then
    exit;

  // Assume childs equals other node's childs
  ChildResult := True;

  // child node names and values - this comes first to assure the lists are filled
  if (xcChildNames in Options) or (xcChildValues in Options) or (xcRecursive in Options) then
    for i := 0 to NodeCount - 1 do
    begin
      // Do child name check
      Index := ANode.NodeIndexByName(Nodes[i].Name);
      // Do we have the childnode in the other?
      if Index < 0 then
      begin
        // No we dont have it
        if xcChildNames in Options then
        begin
          if assigned(MismatchNodes) then MismatchNodes.Add(Nodes[i]);
          ChildResult := False;
        end;
      end else
      begin
        // Do child value check
        if xcChildValues in Options then
          if AnsiCompareText(Nodes[i].ValueAsString, ANode.Nodes[Index].ValueAsString) <> 0 then
          begin
            if assigned(MismatchNodes) then
              MismatchNodes.Add(Nodes[i]);
            ChildResult := False;
          end;
        // Do recursive check
        if xcRecursive in Options then
          if not Nodes[i].IsEqualTo(ANode.Nodes[Index], Options, MismatchNodes) then
            ChildResult := False;
      end;
    end;

  try
    // We assume there are differences
    NodeResult := False;

    // Node name, type and value
    if xcNodeName in Options then
      if AnsiCompareText(Name, ANode.Name) <> 0 then
        exit;

    if xcNodeType in Options then
      if ElementType <> ANode.ElementType then
        exit;

    if xcNodeValue in Options then
      if AnsiCompareText(ValueAsString, ANode.ValueAsString) <> 0 then
        exit;

    // attribute count
    if xcAttribCount in Options then
      if AttributeCount <> ANode.AttributeCount then
        exit;

    // attribute names and values
    if (xcAttribNames in Options) or (xcAttribValues in Options) then
      for i := 0 to AttributeCount - 1 do
      begin
        Index := ANode.AttributeIndexByName(AttributeName[i]);
        if Index < 0 then
          if xcAttribNames in Options then
            exit
          else
            continue;
        if xcAttribValues in Options then
          if AnsiCompareText(AttributeValue[i], ANode.AttributeValue[Index]) <> 0 then
            exit;
      end;

    // child node count
    if xcChildCount in Options then
      if NodeCount <> ANode.NodeCount then
        exit;

    // If we arrive here, it means no differences were found, return True
    NodeResult := True;

  finally

    Result := ChildResult and NodeResult;
    if (not NodeResult) and assigned(MismatchNodes) then
      MismatchNodes.Insert(0, Self);

  end;
end;

function TXmlNode.NodeAdd(ANode: TXmlNode): integer;
begin
  if assigned(ANode) then
  begin
    ANode.Parent := Self;
    ANode.ChangeDocument(Document);
    if not assigned(FNodes) then
      FNodes := TList.Create;
    Result := FNodes.Add(ANode);
  end else
    Result := -1;
end;

function TXmlNode.NodeByAttributeValue(const NodeName, AttribName, AttribValue: string;
  ShouldRecurse: boolean): TXmlNode;
// This function returns a pointer to the first subnode that has an attribute with
// name AttribName and value AttribValue.
var
  i: integer;
  Node: TXmlNode;
begin
  Result := nil;
  // Find all nodes that are potential results
  for i := 0 to NodeCount - 1 do
  begin
    Node := Nodes[i];
    if (AnsiCompareText(Node.Name, NodeName) = 0) and
        Node.HasAttribute(AttribName) and
       (AnsiCompareText(Node.AttributeByName[AttribName], AttribValue) = 0) then
    begin
      Result := Node;
      exit;
    end;
    // Recursive call
    if ShouldRecurse then
      Result := Node.NodeByAttributeValue(NodeName, AttribName, AttribValue, True);
    if assigned(Result) then
      exit;
  end;
end;

function TXmlNode.NodeByElementType(ElementType: TXmlElementType): TXmlNode;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to NodeCount - 1 do
    if Nodes[i].ElementType = ElementType then
    begin
      Result := Nodes[i];
      exit;
    end;
end;

function TXmlNode.NodeByName(const AName: string): TXmlNode;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to NodeCount - 1 do
    if AnsiCompareText(Nodes[i].Name, AName) = 0 then
    begin
      Result := Nodes[i];
      exit;
    end;
end;

procedure TXmlNode.NodeDelete(Index: integer);
begin
  if (Index >= 0) and (Index < NodeCount) then
  begin
    TXmlNode(FNodes[Index]).Free;
    FNodes.Delete(Index);
  end;
end;

procedure TXmlNode.NodeExchange(Index1, Index2: integer);
begin
  if (Index1 >= 0) and (Index1 < Nodecount) and
     (Index2 >= 0) and (Index2 < Nodecount) then
    FNodes.Exchange(Index1, Index2);
end;

function TXmlNode.NodeExtract(ANode: TXmlNode): TXmlNode;
var
  Index: integer;
begin
  // Compatibility with Delphi4
  Result := nil;
  if assigned(FNodes) then
  begin
    Index := FNodes.IndexOf(ANode);
    if Index >= 0 then begin
      Result := ANode;
      FNodes.Delete(Index);
    end;
  end;
end;

function TXmlNode.NodeFindOrCreate(const AName: string): TXmlNode;
// Find the node with AName, and if not found, add new one
begin
  Result := NodeByName(AName);
  if not assigned(Result) then
    Result := NodeNew(AName);
end;

function TXmlNode.NodeIndexByName(const AName: string): integer;
begin
  Result := 0;
  while Result < NodeCount do
  begin
    if AnsiCompareText(Nodes[Result].Name, AName) = 0 then
      exit;
    inc(Result);
  end;
  if Result = NodeCount then
    Result := -1;
end;

function TXmlNode.NodeIndexByNameFrom(const AName: string; AFrom: integer): integer;
begin
  Result := AFrom;
  while Result < NodeCount do
  begin
    if AnsiCompareText(Nodes[Result].Name, AName) = 0 then
      exit;
    inc(Result);
  end;
  if Result = NodeCount then
    Result := -1;
end;

function TXmlNode.NodeIndexOf(ANode: TXmlNode): integer;
begin
  if assigned(ANode) and assigned(FNodes) then
    Result := FNodes.IndexOf(ANode)
  else
    Result := -1;
end;

procedure TXmlNode.NodeInsert(Index: integer; ANode: TXmlNode);
// Insert the node ANode at location Index in the list.
begin
  if not assigned(ANode) then
    exit;
  if (Index >=0) and (Index <= NodeCount) then
  begin
    if not assigned(FNodes) then
      FNodes := TList.Create;
    ANode.Parent := Self;
    FNodes.Insert(Index, ANode);
  end;
end;

function TXmlNode.NodeNew(const AName: string): TXmlNode;
// Add a new child node and return its pointer
begin
  Result := Nodes[NodeAdd(TXmlNode.CreateName(Document, AName))];
end;

function TXmlNode.NodeNewAtIndex(Index: integer; const AName: string): TXmlNode;
// Create a new node with AName, and insert it into the subnode list at location
// Index, and return a pointer to it.
begin
  if (Index >= 0) and (Index <= NodeCount) then
  begin
    Result := TXmlNode.CreateName(Document, AName);
    NodeInsert(Index, Result);
  end else
    Result := nil;
end;

function TXmlNode.NodeRemove(ANode: TxmlNode): integer;
begin
  Result := NodeIndexOf(ANode);
  if Result >= 0 then
    NodeDelete(Result);
end;

procedure TXmlNode.NodesByName(const AName: string; const AList: TList);
// Fill AList with nodes that have name AName
var
  i: integer;
begin
  if not assigned(AList) then
    exit;
  AList.Clear;
  for i := 0 to NodeCount - 1 do
    if AnsiCompareText(Nodes[i].Name, AName) = 0 then
      AList.Add(Nodes[i]);
end;

procedure TXmlNode.NodesClear;
var
  i: integer;
begin
  for i := 0 to NodeCount - 1 do
    TXmlNode(FNodes[i]).Free;
  FreeAndNil(FNodes);
end;

procedure TXmlNode.ParseTag(const AValue: string; TagStart, TagClose: integer);
var
  LItems: TStringList;
begin
  // Create a list to hold string items
  LItems := TStringList.Create;
  try
    ParseAttributes(AValue, TagStart, TagClose, LItems);

    // Determine name, attributes or value for each element type
    case ElementType of
    xeDeclaration:
      FName := 'xml';
    xeStyleSheet:
      begin
        FName := 'xml-stylesheet';
        // We also set this as the value for use in "StyleSheetString"
        ValueDirect := trim(copy(AValue, TagStart, TagClose - TagStart));
      end;
    else
      // First item is the name - is it there?
      if LItems.Count = 0 then
        raise EFilerError.Create(sxeMissingElementName);

      // Set the name - using the element instead of property for speed
      FName := LItems[0];
      LItems.Delete(0);
    end;//case

    // Any attributes?
    if LItems.Count > 0 then
    begin
      CheckCreateAttributesList;
      FAttributes.Assign(LItems);
    end;

  finally
    LItems.Free;
  end;
end;

function TXmlNode.QualifyAsDirectNode: boolean;
// If this node qualifies as a direct node when writing, we return True.
// A direct node may have attributes, but no value or subnodes. Furhtermore,
// the root node will never be displayed as a direct node.
begin
  Result :=
    (Length(FValue) = 0) and
    (NodeCount = 0) and
    (ElementType = xeNormal) and
    not UseFullNodes and
    (TreeDepth > 0);
end;

function TXmlNode.ReadAttributeBool(const AName: string; ADefault: boolean): boolean;
var
  V: string;
begin
  V := AttributeByName[AName];
  try
    Result := sdStringToBool(V);
  except
    Result := ADefault;
  end;
end;

function TXmlNode.ReadAttributeDateTime(const AName: string;
  ADefault: TDateTime): TDateTime;
var
  V: string;
begin
  V := AttributeByName[AName];
  try
    Result := sdDateTimeFromStringDefault(V, ADefault);
  except
    Result := ADefault;
  end;
end;

function TXmlNode.ReadAttributeFloat(const AName: string; ADefault: double): double;
var
  V: string;
  Code: integer;
begin
  V := AttributeByName[AName];
  val(StringReplace(V, ',', '.', []), Result, Code);
  if Code > 0 then
    Result := ADefault;
end;

function TXmlNode.ReadAttributeInteger(const AName: string; ADefault: integer): integer;
begin
  Result := StrToIntDef(AttributeByName[AName], ADefault);
end;

function TXmlNode.ReadAttributeInt64(const AName: string; ADefault: int64): int64;
begin
  Result := StrToInt64Def(AttributeByName[AName], ADefault);
end;

function TXmlNode.ReadAttributeString(const AName: string; const ADefault: string): string;
begin
  Result := AttributeByName[AName];
  if length(Result) = 0 then
    Result := ADefault;
end;

function TXmlNode.ReadBool(const AName: string; ADefault: boolean): boolean;
var
  Index: integer;
begin
  Result := ADefault;
  Index := NodeIndexByName(AName);
  if Index >= 0 then
    Result := Nodes[Index].ValueAsBoolDef(ADefault);
end;

{$IFDEF USEGRAPHICS}
procedure TXmlNode.ReadBrush(const AName: string; ABrush: TBrush);
var
  Child: TXmlNode;
begin
  Child := NodeByName(AName);
  if assigned(Child) then with Child do
  begin
    // Read values
    ABrush.Color  := ReadColor('Color', clWhite);
    ABrush.Style  := TBrushStyle(ReadInteger('Style', integer(bsSolid)));
  end else
  begin
    // Defaults
    ABrush.Bitmap := nil;
    ABrush.Color  := clWhite;
    ABrush.Style  := bsSolid;
  end;
end;

function TXmlNode.ReadColor(const AName: string; ADefault: TColor): TColor;
var
  Index: integer;
begin
  Result := ADefault;
  Index := NodeIndexByName(AName);
  if Index >= 0 then
    Result := StrToInt(Nodes[Index].ValueAsString);
end;
{$ENDIF}

function TXmlNode.ReadDateTime(const AName: string; ADefault: TDateTime): TDateTime;
// Date MUST always be written in this format:
// YYYY-MM-DD (if just date) or
// YYYY-MM-DDThh:mm:ss.sssZ (if date and time. The Z stands for universal time
// zone. Since Delphi's TDateTime does not give us a clue about the timezone,
// this is the easiest solution)
// This format SHOULD NOT be changed, to avoid all kinds of
// conversion errors in future.
// This format is compatible with the W3C date/time specification as found here:
// http://www.w3.org/TR/NOTE-datetime
begin
  Result := sdDateTimeFromStringDefault(ReadString(AName, ''), ADefault);
end;

function TXmlNode.ReadFloat(const AName: string; ADefault: double): double;
var
  Index: integer;
begin
  Result := ADefault;
  Index := NodeIndexByName(AName);
  if Index >= 0 then
    Result := Nodes[Index].ValueAsFloatDef(ADefault);
end;

{$IFDEF USEGRAPHICS}
procedure TXmlNode.ReadFont(const AName: string; AFont: TFont);
var
  Child: TXmlNode;
begin
  Child := NodeByName(AName);
  AFont.Style := [];
  if assigned(Child) then with Child do
  begin
    // Read values
    AFont.Name  := ReadString('Name', 'Arial');
    AFont.Color := ReadColor('Color', clBlack);
    AFont.Size  := ReadInteger('Size', 14);
    if ReadBool('Bold', False)      then AFont.Style := AFont.Style + [fsBold];
    if ReadBool('Italic', False)    then AFont.Style := AFont.Style + [fsItalic];
    if ReadBool('Underline', False) then AFont.Style := AFont.Style + [fsUnderline];
    if ReadBool('Strikeout', False) then AFont.Style := AFont.Style + [fsStrikeout];
  end else
  begin
    // Defaults
    AFont.Name  := 'Arial';
    AFont.Color := clBlack;
    AFont.Size  := 14;
  end;
end;
{$ENDIF}

procedure TXmlNode.ReadFromStream(S: TStream);
// Read the node from the starting "<" until the closing ">" from the stream in S.
// This procedure also calls OnNodeNew and OnNodeLoaded events
var
  Ch: Char;
  i: integer;
  TagIndex: integer;
  V: string;
  Len: integer;
  Node: TXmlNode;
  NodeValue: string;
  ValuePos, ValueLen: integer;
  ClosePos: integer;
  HasCR: boolean;
  HasSubtags: boolean;
  Words: TStringList;
  IsDirect: boolean;
  Reader: TsdSurplusReader;
  // local
  procedure AddCharDataNode;
  var
    V: string;
    Node: TXmlNode;
  begin
    // Add all text up till now as xeCharData
    if ValuePos > 0 then
    begin
      V := copy(NodeValue, 1, ValuePos);
      if length(trim(V)) > 0 then
      begin
        Node := TXmlNode.CreateType(Document, xeCharData);
        Node.ValueDirect := V;
        NodeAdd(Node);
      end;
      ValuePos := 0;
    end;
  end;
// Main
begin
  // Check if we aborted parsing
  if AbortParsing then
    exit;
  // Clear this node first
  Clear;
  // Initial reserve textual value: just 80 characters which is OK for most short values
  ValuePos := 0;
  ValueLen := 80;
  SetLength(NodeValue, ValueLen);
  HasCR := False;
  HasSubTags := False;
  Reader := TsdSurplusReader.Create(S);
  try
    // Trailing blanks/controls chars?
    if not Reader.ReadCharSkipBlanks(Ch) then
      exit;

    // What is it?
    if Ch = '<' then
    begin
      // A tag - which one?
      TagIndex := ReadOpenTag(Reader);
      if TagIndex >= 0 then
      begin
        try
          ElementType := cTags[TagIndex].FStyle;
          case ElementType of
          xeNormal, xeDeclaration, xeStyleSheet:
            begin
              // These tags we will process
              ReadStringFromStreamUntil(Reader, cTags[TagIndex].FClose, V, True);
              Len := length(V);

              // Is it a direct tag?
              IsDirect := False;
              if (ElementType = xeNormal) and (Len > 0) then
                if V[Len] = '/' then
                begin
                  dec(Len);
                  IsDirect := True;
                end;
              ParseTag(V, 1, Len + 1);

              // Here we know our name so good place to call OnNodeNew event
              if assigned(Document) then
              begin
                Document.DoNodeNew(Self);
                if AbortParsing then
                  exit;
              end;

              // Now the tag can be a direct close - in that case we're finished
              if IsDirect or (ElementType in [xeDeclaration, xeStyleSheet]) then
                exit;

              // Process rest of tag
              repeat

                // Read character from stream
                if S.Read(Ch, 1) <> 1 then
                  raise EFilerError.CreateFmt(sxeMissingCloseTag, [Name]);

                // Is there a subtag?
                if Ch = '<' then
                begin
                  if not Reader.ReadCharSkipBlanks(Ch) then
                    raise EFilerError.CreateFmt(sxeMissingDataAfterGreaterThan, [Name]);
                  if Ch = '/' then
                  begin

                    // This seems our closing tag
                    if not ReadStringFromStreamUntil(Reader, '>', V, True) then
                      raise EFilerError.CreateFmt(sxeMissingLessThanInCloseTag, [Name]);
                    if AnsiCompareText(trim(V), Name) <> 0 then
                      raise EFilerError.CreateFmt(sxeIncorrectCloseTag, [Name]);
                    V := '';
                    break;

                  end else
                  begin

                    // Add all text up till now as xeCharData
                    AddCharDataNode;

                    // Reset the HasCR flag if we add node, we only want to detect
                    // the CR after last subnode
                    HasCR := False;

                    // This is a subtag... so create it and let it process
                    HasSubTags := True;
                    S.Seek(-2, soCurrent);
                    Node := TXmlNode.Create(Document);
                    NodeAdd(Node);
                    Node.ReadFromStream(S);

                    // Check for dropping comments
                    if assigned(Document) and Document.DropCommentsOnParse and
                       (Node.ElementType = xeComment) then
                      NodeDelete(NodeIndexOf(Node));

                  end;
                end else
                begin

                  // If we detect a CR we will set the flag. This will signal the fact
                  // that this XML file was saved with xfReadable
                  if Ch = #13 then
                    HasCR := True;

                  // Add the character to the node value buffer.
                  inc(ValuePos);
                  if ValuePos > ValueLen then
                  begin
                    inc(ValueLen, cNodeValueBuf);
                    SetLength(NodeValue, ValueLen);
                  end;
                  NodeValue[ValuePos] := Ch;

                end;
              until False or AbortParsing;

              // Add all text up till now as xeText
              AddCharDataNode;

              // Check CharData nodes, remove trailing CRLF + indentation if we
              // were in xfReadable mode
              if HasSubtags and HasCR then
              begin
                for i := 0 to NodeCount - 1 do
                  if Nodes[i].ElementType = xeCharData then
                  begin
                    ClosePos := length(Nodes[i].FValue);
                    while (ClosePos > 0) and (Nodes[i].FValue[ClosePos] in [#10, #13, ' ']) do
                      dec(ClosePos);
                    Nodes[i].FValue := copy(Nodes[i].FValue, 1, ClosePos);
                  end;
              end;

              // If the first node is xeCharData we use it as ValueDirect
              if NodeCount > 0 then
                if Nodes[0].ElementType = xeCharData then
                begin
                  ValueDirect := Nodes[0].ValueDirect;
                  NodeDelete(0);
                end;

            end;
          xeDocType:
            begin
              Name := 'DTD';
              if assigned(Document) then
              begin
                Document.DoNodeNew(Self);
                if AbortParsing then
                  exit;
              end;
              // Parse DTD
              if assigned(Document) then
                Document.ParseDTD(Self, S);
            end;
          xeElement, xeAttList, xeEntity, xeNotation:
            begin
              // DTD elements
              ReadStringFromStreamWithQuotes(S, cTags[TagIndex].FClose, V);
              Len := length(V);
              Words := TStringList.Create;
              try
                ParseAttributes(V, 1, Len + 1, Words);
                if Words.Count > 0 then
                begin
                  Name := Words[0];
                  Words.Delete(0);
                end;
                ValueDirect := trim(Words.Text);
              finally
                Words.Free;
              end;
              if assigned(Document) then
              begin
                Document.DoNodeNew(Self);
                if AbortParsing then
                  exit;
              end;
            end;
          else
            case ElementType of
            xeComment:  Name := 'Comment';
            xeCData:    Name := 'CData';
            xeExclam:   Name := 'Special';
            xeQuestion: Name := 'Special';
            else
              Name := 'Unknown';
            end; //case

            // Here we know our name so good place to call OnNodeNew
            if assigned(Document) then
            begin
              Document.DoNodeNew(Self);
              if AbortParsing then
                exit;
            end;

            // In these cases just get all data up till the closing tag
            ReadStringFromStreamUntil(Reader, cTags[TagIndex].FClose, V, False);
            ValueDirect := V;
          end;//case
        finally
          // Call the OnNodeLoaded and OnProgress events
          if assigned(Document) and not AbortParsing then
          begin
            Document.DoProgress(S.Position);
            Document.DoNodeLoaded(Self);
          end;
        end;
      end;
    end;
  finally
    Reader.Free;
  end;
end;

procedure TXmlNode.ReadFromString(const AValue: string);
var
  S: TStream;
begin
  S := TsdStringStream.Create(AValue);
  try
    ReadFromStream(S);
  finally
    S.Free;
  end;
end;

function TXmlNode.ReadInt64(const AName: string; ADefault: int64): int64;
var
  Index: integer;
begin
  Result := ADefault;
  Index := NodeIndexByName(AName);
  if Index >= 0 then
    Result := Nodes[Index].ValueAsInt64Def(ADefault);
end;

function TXmlNode.ReadInteger(const AName: string; ADefault: integer): integer;
var
  Index: integer;
begin
  Result := ADefault;
  Index := NodeIndexByName(AName);
  if Index >= 0 then
    Result := Nodes[Index].ValueAsIntegerDef(ADefault);
end;

{$IFDEF USEGRAPHICS}
procedure TXmlNode.ReadPen(const AName: string; APen: TPen);
var
  Child: TXmlNode;
begin
  Child := NodeByName(AName);
  if assigned(Child) then with Child do
  begin
    // Read values
    APen.Color := ReadColor('Color', clBlack);
    APen.Mode  := TPenMode(ReadInteger('Mode', integer(pmCopy)));
    APen.Style := TPenStyle(ReadInteger('Style', integer(psSolid)));
    APen.Width := ReadInteger('Width', 1);
  end else
  begin
    // Defaults
    APen.Color := clBlack;
    APen.Mode := pmCopy;
    APen.Style := psSolid;
    APen.Width := 1;
  end;
end;
{$ENDIF}

function TXmlNode.ReadString(const AName: string; const ADefault: string): string;
var
  Index: integer;
begin
  Result := ADefault;
  Index := NodeIndexByName(AName);
  if Index >= 0 then
    Result := Nodes[Index].ValueAsString;
end;

function TXmlNode.ReadWidestring(const AName: string; const ADefault: widestring): widestring;
begin
  Result := ToWidestring(ReadString(AName, FromWidestring(ADefault)));
end;

procedure TXmlNode.ResolveEntityReferences;
// Replace any entity references by the entities, and parse the new content if any
  // local
  function SplitReference(const AValue: string; var Text1, Text2: string): string;
  var
    P: integer;
  begin
    Result := '';
    P := Pos('&', AValue);
    Text1 := '';
    Text2 := AValue;
    if P = 0 then
      exit;
    Text1 := copy(AValue, 1, P - 1);
    Text2 := copy(AValue, P + 1, length(AValue));
    P := Pos(';', Text2);
    if P = 0 then
      exit;
    Result := copy(Text2, 1, P - 1);
    Text2 := copy(Text2, P + 1, length(Text2));
  end;
  // local
  function ReplaceEntityReferenceByNodes(ARoot: TXmlNode; const AValue: string; var InsertPos: integer; var Text1, Text2: string): boolean;
  var
    Reference: string;
    Entity: string;
    Node: TXmlNode;
    S: TStream;
  begin
    Result := False;
    Reference := SplitReference(AValue, Text1, Text2);
    if (length(Reference) = 0) or not assigned(Document) then
      exit;

    // Lookup entity references
    Entity := Document.EntityByName[Reference];

    // Does the entity contain markup?
    if (length(Entity) > 0) and (Pos('<', Entity) > 0) then
    begin
      S := TsdStringStream.Create(Entity);
      try
        while S.Position < S.Size do
        begin
          Node := TXmlNode.Create(Document);
          Node.ReadFromStream(S);
          if Node.IsEmpty then
            Node.Free
          else
          begin
            ARoot.NodeInsert(InsertPos, Node);
            inc(InsertPos);
            Result := True;
          end;
        end;
      finally
        S.Free;
      end;
    end;
  end;
// main
var
  i: integer;
  InsertPos: integer;
  Text1, Text2: string;
  Node: TXmlNode;
  V, Reference, Replace, Entity, First, Last: string;
begin
  if length(FValue) > 0 then
  begin
    // Different behaviour for xeNormal and xeCharData
    if ElementType = xeNormal then
    begin
      InsertPos := 0;
      if ReplaceEntityReferenceByNodes(Self, FValue, InsertPos, Text1, Text2) then
      begin
        FValue := Text1;
        if length(trim(Text2)) > 0 then
        begin
          Node := TXmlNode.CreateType(Document, xeCharData);
          Node.ValueDirect := Text2;
          NodeInsert(InsertPos, Node);
        end;
      end;
    end else if (ElementType = xeCharData) and assigned(Parent) then
    begin
      InsertPos := Parent.NodeIndexOf(Self);
      if ReplaceEntityReferenceByNodes(Parent, FValue, InsertPos, Text1, Text2) then
      begin
        FValue := Text1;
        if length(trim(FValue)) = 0 then
          FValue := '';
        if length(trim(Text2)) > 0 then
        begin
          Node := TXmlNode.CreateType(Document, xeCharData);
          Node.ValueDirect := Text2;
          Parent.NodeInsert(InsertPos, Node);
        end;
      end;
    end;
  end;

  // Do attributes
  for i := 0 to AttributeCount - 1 do
  begin
    Last := AttributeValue[i];
    V := '';
    repeat
      Reference := SplitReference(Last, First, Last);
      Replace := '';
      if length(Reference) > 0 then
      begin
        Entity := Document.EntityByName[Reference];
        if length(Entity) > 0 then
           Replace := Entity
        else
          Replace := '&' + Reference + ';';
      end;
      V := V + First + Replace;
    until length(Reference) = 0;
    V := V + Last;
    AttributeValue[i] := V;
  end;

  // Do childnodes too
  i := 0;
  while i < NodeCount do
  begin
    Nodes[i].ResolveEntityReferences;
    inc(i);
  end;

  // Check for empty CharData nodes
  for i := NodeCount - 1 downto 0 do
    if (Nodes[i].ElementType = xeCharData) and (length(Nodes[i].ValueDirect) = 0) then
      NodeDelete(i);
end;

procedure TXmlNode.SetAttributeByName(const AName, Value: string);
begin
  CheckCreateAttributesList;
  FAttributes.Values[AName] := QuoteString(EscapeString(Value));
end;

procedure TXmlNode.SetAttributeByNameWide(const AName: string; const Value: widestring);
begin
  SetAttributeByName(AName, FromWidestring(Value));
end;

procedure TXmlNode.SetAttributeName(Index: integer; const Value: string);
var
  S: string;
  P: integer;
begin
  if (Index >= 0) and (Index < AttributeCount) then
  begin
    S := FAttributes[Index];
    P := AnsiPos('=', S);
    if P > 0 then
      FAttributes[Index] := Format('%s=%s', [Value, Copy(S, P + 1, MaxInt)]);
  end;
end;

procedure TXmlNode.SetAttributeValue(Index: integer; const Value: string);
begin
  if (Index >= 0) and (Index < AttributeCount) then
    FAttributes[Index] := Format('%s=%s', [AttributeName[Index],
      QuoteString(EscapeString(Value))]);
end;

procedure TXmlNode.SetAttributeValueAsInteger(Index: integer; const Value: integer);
begin
  SetAttributeValue(Index, IntToStr(Value));
end;

procedure TXmlNode.SetAttributeValueAsWidestring(Index: integer;
  const Value: widestring);
begin
  SetAttributeValue(Index, FromWidestring(Value));
end;

procedure TXmlNode.SetAttributeValueDirect(Index: integer;
  const Value: string);
begin
  if (Index >= 0) and (Index < AttributeCount) then
    FAttributes[Index] := Format('%s=%s', [AttributeName[Index],
      QuoteString(Value)]);
end;

procedure TXmlNode.SetBinaryEncoding(const Value: TBinaryEncodingType);
begin
  if assigned(Document) then
    Document.BinaryEncoding := Value;
end;

procedure TXmlNode.SetBinaryString(const Value: string);
var
  OldEncoding: TBinaryEncodingType;
begin
  // Set to base64
  OldEncoding := BinaryEncoding;
  try
    BinaryEncoding := xbeBase64;
    if length(Value) = 0 then
    begin
      ValueAsString := '';
      exit;
    end;
    // fill the buffer
    {$IFDEF CLR}
    BufferWrite(BytesOf(Value), length(Value));
    {$ELSE}
    BufferWrite(Value[1], length(Value));
    {$ENDIF}
  finally
    BinaryEncoding := OldEncoding;
  end;
end;

procedure TXmlNode.SetName(const Value: string);
var
  i: integer;
begin
  if FName <> Value then
  begin
    // Check if the name abides the rules. We will be very forgiving here and
    // just accept any name that at least does not contain control characters
    for i := 1 to length(Value) do
      if Value[i] in cControlChars then
        raise Exception.Create(Format(sxeIllegalCharInNodeName, [Value]));
    FName := Value;
  end;
end;

procedure TXmlNode.SetValueAsBool(const Value: boolean);
begin
  FValue := sdStringFromBool(Value);
end;

procedure TXmlNode.SetValueAsDateTime(const Value: TDateTime);
begin
  ValueAsString := sdDateTimeToString(Value);
end;

procedure TXmlNode.SetValueAsFloat(const Value: double);
begin
  FValue := sdWriteNumber(Value, FloatSignificantDigits, FloatAllowScientific);
end;

procedure TXmlNode.SetValueAsInt64(const Value: int64);
begin
  FValue := IntToStr(Value);
end;

procedure TXmlNode.SetValueAsInteger(const Value: integer);
begin
  FValue := IntToStr(Value);
end;

procedure TXmlNode.SetValueAsString(const AValue: string);
begin
  FValue := EscapeString(AValue);
end;

procedure TXmlNode.SetValueAsWidestring(const Value: widestring);
begin
  ValueAsString := FromWidestring(Value);
end;

procedure TXmlNode.SortChildNodes(Compare: TXMLNodeCompareFunction;
  Info: TPointer);
// Sort the child nodes using the quicksort algorithm
  //local
  function DoNodeCompare(Node1, Node2: TXmlNode): integer;
  begin
    if assigned(Compare) then
      Result := Compare(Node1, Node2, Info)
    else
      if assigned(Document) and assigned(Document.OnNodeCompare) then
        Result := Document.OnNodeCompare(Document, Node1, Node2, Info)
      else
        Result := AnsiCompareText(Node1.Name, Node2.Name);
  end;
  // local
  procedure QuickSort(iLo, iHi: Integer);
  var
    Lo, Hi, Mid: longint;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid:= (Lo + Hi) div 2;
    repeat
      while DoNodeCompare(Nodes[Lo], Nodes[Mid]) < 0 do
        Inc(Lo);
      while DoNodeCompare(Nodes[Hi], Nodes[Mid]) > 0 do
        Dec(Hi);
      if Lo <= Hi then
      begin
        // Swap pointers;
        NodeExchange(Lo, Hi);
        if Mid = Lo then
          Mid := Hi
        else
          if Mid = Hi then
            Mid := Lo;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(iLo, Hi);
    if Lo < iHi then QuickSort(Lo, iHi);
  end;
// main
begin
  if NodeCount > 1 then
    QuickSort(0, NodeCount - 1);
end;

function TXmlNode.ToAnsiString(const s: string): string;
begin
  if Utf8Encoded then
    Result := sdUtf8ToAnsi(s)
  else
    Result := s;
end;

function TXmlNode.ToWidestring(const s: string): widestring;
begin
  if Utf8Encoded then
    Result := sdUtf8ToUnicode(s)
  else
    Result := s;
end;

function TXmlNode.UnescapeString(const AValue: string): string;
begin
  if Utf8Encoded then
    Result := UnescapeStringUTF8(AValue)
  else
    Result := UnescapeStringAnsi(AValue);
end;

function TXmlNode.UseFullNodes: boolean;
begin
  Result := False;
  if assigned(Document) then
    Result := Document.UseFullNodes;
end;

function TXmlNode.Utf8Encoded: boolean;
begin
  Result := False;
  if assigned(Document) then
    Result := Document.Utf8Encoded;
end;

function TXmlNode.ValueAsBoolDef(ADefault: boolean): boolean;
var
  Ch: Char;
begin
  Result := ADefault;
  if Length(FValue) = 0 then
    exit;
  Ch := UpCase(FValue[1]);
  if Ch in ['T', 'Y'] then
  begin
    Result := True;
    exit;
  end;
  if Ch in ['F', 'N'] then
  begin
    Result := False;
    exit;
  end;
end;

function TXmlNode.ValueAsDateTimeDef(ADefault: TDateTime): TDateTime;
begin
  Result := sdDateTimeFromStringDefault(ValueAsString, ADefault);
end;

function TXmlNode.ValueAsFloatDef(ADefault: double): double;
var
  Code: integer;
begin
  try
    val(StringReplace(FValue, ',', '.', []), Result, Code);
    if Code > 0 then
      Result := ADefault;
  except
    Result := ADefault;
  end;
end;

function TXmlNode.ValueAsInt64Def(ADefault: int64): int64;
begin
  Result := StrToInt64Def(FValue, ADefault);
end;

function TXmlNode.ValueAsIntegerDef(ADefault: integer): integer;
begin
  Result := StrToIntDef(FValue, ADefault);
end;

procedure TXmlNode.WriteAttributeBool(const AName: string; AValue: boolean;
  ADefault: boolean);
var
  Index: integer;
begin
  if WriteOnDefault or (AValue <> ADefault) then
  begin
    Index := AttributeIndexByName(AName);
    if Index >= 0 then
      AttributeValue[Index] := sdStringFromBool(AValue)
    else
      AttributeAdd(AName, sdStringFromBool(AValue));
  end;
end;

procedure TXmlNode.WriteAttributeDateTime(const AName: string; AValue,
  ADefault: TDateTime);
var
  Index: integer;
begin
  if WriteOnDefault or (AValue <> ADefault) then
  begin
    Index := AttributeIndexByName(AName);
    if Index >= 0 then
      AttributeValue[Index] := sdDateTimeToString(AValue)
    else
      AttributeAdd(AName, sdDateTimeToString(AValue));
  end;
end;

procedure TXmlNode.WriteAttributeFloat(const AName: string; AValue, ADefault: double);
var
  Index: integer;
  S: string;
begin
  if WriteOnDefault or (AValue <> ADefault) then
  begin
    Index := AttributeIndexByName(AName);
    S := sdWriteNumber(AValue, FloatSignificantDigits, FloatAllowScientific);
    if Index >= 0 then
      AttributeValue[Index] := S
    else
      AttributeAdd(AName, S);
  end;
end;

procedure TXmlNode.WriteAttributeInteger(const AName: string; AValue: integer; ADefault: integer);
var
  Index: integer;
begin
  if WriteOnDefault or (AValue <> ADefault) then
  begin
    Index := AttributeIndexByName(AName);
    if Index >= 0 then
      AttributeValue[Index] := IntToStr(AValue)
    else
      AttributeAdd(AName, IntToStr(AValue));
  end;
end;

procedure TXmlNode.WriteAttributeInt64(const AName: string; const AValue: int64; ADefault: int64);
var
  Index: integer;
begin
  if WriteOnDefault or (AValue <> ADefault) then
  begin
    Index := AttributeIndexByName(AName);
    if Index >= 0 then
      AttributeValue[Index] := IntToStr(AValue)
    else
      AttributeAdd(AName, IntToStr(AValue));
  end;
end;

procedure TXmlNode.WriteAttributeString(const AName, AValue, ADefault: string);
var
  Index: integer;
begin
  if WriteOnDefault or (AValue <> ADefault) then
  begin
    Index := AttributeIndexByName(AName);
    if Index >= 0 then
      AttributeValue[Index] := AValue
    else
      AttributeAdd(AName, AValue);
  end;
end;

procedure TXmlNode.WriteBool(const AName: string; AValue: boolean; ADefault: boolean);
const
  cBoolValues: array[boolean] of string = ('False', 'True');
begin
  if WriteOnDefault or (AValue <> ADefault) then
    with NodeFindOrCreate(AName) do
      ValueAsString := cBoolValues[AValue];
end;

{$IFDEF USEGRAPHICS}
procedure TXmlNode.WriteBrush(const AName: string; ABrush: TBrush);
begin
  with NodeFindOrCreate(AName) do
  begin
    WriteColor('Color', ABrush.Color, clBlack);
    WriteInteger('Style', integer(ABrush.Style), 0);
  end;
end;

procedure TXmlNode.WriteColor(const AName: string; AValue, ADefault: TColor);
begin
  if WriteOnDefault or (AValue <> ADefault) then
    WriteHex(AName, ColorToRGB(AValue), 8, 0);
end;
{$ENDIF}

procedure TXmlNode.WriteDateTime(const AName: string; AValue, ADefault: TDateTime);
// Date MUST always be written in this format:
// YYYY-MM-DD (if just date) or
// YYYY-MM-DDThh:mm:ss.sssZ (if date and time. The Z stands for universal time
// zone. Since Delphi's TDateTime does not give us a clue about the timezone,
// this is the easiest solution)
// This format SHOULD NOT be changed, to avoid all kinds of
// conversion errors in future.
// This format is compatible with the W3C date/time specification as found here:
// http://www.w3.org/TR/NOTE-datetime
begin
  if WriteOnDefault or (AValue <> ADefault) then
    WriteString(AName, sdDateTimeToString(AValue), '');
end;

procedure TXmlNode.WriteFloat(const AName: string; AValue: double; ADefault: double);
begin
  if WriteOnDefault or (AValue <> ADefault) then
    with NodeFindOrCreate(AName) do
      ValueAsString := sdWriteNumber(AValue, FloatSignificantDigits, FloatAllowScientific);
end;

{$IFDEF USEGRAPHICS}
procedure TXmlNode.WriteFont(const AName: string; AFont: TFont);
begin
  with NodeFindOrCreate(AName) do
  begin
    WriteString('Name', AFont.Name, 'Arial');
    WriteColor('Color', AFont.Color, clBlack);
    WriteInteger('Size', AFont.Size, 14);
    WriteBool('Bold', fsBold in AFont.Style, False);
    WriteBool('Italic', fsItalic in AFont.Style, False);
    WriteBool('Underline', fsUnderline in AFont.Style, False);
    WriteBool('Strikeout', fsStrikeout in AFont.Style, False);
  end;
end;
{$ENDIF}

procedure TXmlNode.WriteHex(const AName: string; AValue, Digits: integer; ADefault: integer);
begin
  if WriteOnDefault or (AValue <> ADefault) then
    with NodeFindOrCreate(AName) do
      ValueAsString := '$' + IntToHex(AValue, Digits);
end;

function TXmlNode.WriteInnerTag: string;
// Write the inner part of the tag, the one that contains the attributes
var
  i: integer;
begin
  Result := '';
  // Attributes
  for i := 0 to AttributeCount - 1 do
    // Here we used to prevent empty attributes, but in fact, empty attributes
    // should be allowed because sometimes they're required
    Result := Result + ' ' + AttributePair[i];
  // End of tag - direct nodes get an extra "/"
  if QualifyAsDirectNode then
    Result := Result + '/';
end;

procedure TXmlNode.WriteInt64(const AName: string; AValue, ADefault: int64);
begin
  if WriteOnDefault or (AValue <> ADefault) then
    with NodeFindOrCreate(AName) do
      ValueAsString := IntToStr(AValue);
end;

procedure TXmlNode.WriteInteger(const AName: string; AValue: integer; ADefault: integer);
begin
  if WriteOnDefault or (AValue <> ADefault) then
    with NodeFindOrCreate(AName) do
      ValueAsString := IntToStr(AValue);
end;

{$IFDEF USEGRAPHICS}
procedure TXmlNode.WritePen(const AName: string; APen: TPen);
begin
  with NodeFindOrCreate(AName) do
  begin
    WriteColor('Color', APen.Color, clBlack);
    WriteInteger('Mode', integer(APen.Mode), 0);
    WriteInteger('Style', integer(APen.Style), 0);
    WriteInteger('Width', APen.Width, 0);
  end;
end;
{$ENDIF}

procedure TXmlNode.WriteString(const AName, AValue: string; const ADefault: string);
begin
  if WriteOnDefault or (AValue <> ADefault) then
    with NodeFindOrCreate(AName) do
      ValueAsString := AValue;
end;

procedure TXmlNode.WriteToStream(S: TStream);
var
  i: integer;
  Indent: string;
  LFeed: string;
  Line: string;
  ThisNode, NextNode: TXmlNode;
  AddLineFeed: boolean;
begin
  Indent := GetIndent;
  LFeed := GetLineFeed;

  // Write indent
  Line := Indent;

  // Write the node - distinguish node type
  case ElementType of
  xeDeclaration: // XML declaration <?xml{declaration}?>
    begin
      // Explicitly delete empty attributes in the declaration,
      // this is usually the encoding and we do not want encoding=""
      // to show up
      DeleteEmptyAttributes;
      Line := Indent + Format('<?xml%s?>', [WriteInnerTag]);
    end;
  xeStylesheet: // Stylesheet <?xml-stylesheet{stylesheet}?>
    Line := Indent + Format('<?xml-stylesheet%s?>', [WriteInnerTag]);
  xeDoctype:
    begin
      if NodeCount = 0 then
        Line := Indent + Format('<!DOCTYPE %s %s>', [Name, ValueDirect])
      else
      begin
        Line := Indent + Format('<!DOCTYPE %s %s [', [Name, ValueDirect]) + LFeed;
        WriteStringToStream(S, Line);
        for i := 0 to NodeCount - 1 do
        begin
          Nodes[i].WriteToStream(S);
          WriteStringToStream(S, LFeed);
        end;
        Line := ']>';
      end;
    end;
  xeElement:
    Line := Indent + Format('<!ELEMENT %s %s>', [Name, ValueDirect]);
  xeAttList:
    Line := Indent + Format('<!ATTLIST %s %s>', [Name, ValueDirect]);
  xeEntity:
    Line := Indent + Format('<!ENTITY %s %s>', [Name, ValueDirect]);
  xeNotation:
    Line := Indent + Format('<!NOTATION %s %s>', [Name, ValueDirect]);
  xeComment: // Comment <!--{comment}-->
    Line := Indent + Format('<!--%s-->', [ValueDirect]);
  xeCData: // literal data <![CDATA[{data}]]>
    Line := Indent + Format('<![CDATA[%s]]>', [ValueDirect]);
  xeExclam: // Any <!data>
    Line := Indent + Format('<!%s>', [ValueDirect]);
  xeQuestion: // Any <?data?>
    Line := Indent + Format('<?%s?>', [ValueDirect]);
  xeCharData:
    Line := FValue;
  xeUnknown: // Any <data>
    Line := Indent + Format('<%s>', [ValueDirect]);
  xeNormal: // normal nodes (xeNormal)
    begin
      // Write tag
      Line := Line + Format('<%s%s>', [FName, WriteInnerTag]);

      // Write value (if any)
      Line := Line + FValue;
      if (NodeCount > 0) then
        // ..and a linefeed
        Line := Line + LFeed;

      WriteStringToStream(S, Line);

      // Write child elements
      for i := 0 to NodeCount - 1 do
      begin
        ThisNode := Nodes[i];
        NextNode := Nodes[i + 1];
        ThisNode.WriteToStream(S);
        AddLineFeed := True;
        if ThisNode.ElementType = xeCharData then
          AddLineFeed := False;
        if assigned(NextNode) then
          if NextNode.ElementType = xeCharData then
            AddLineFeed := False;
        if AddLineFeed then
          WriteStringToStream(S, LFeed);
      end;

      // Write end tag
      Line := '';
      if not QualifyAsDirectNode then
      begin
        if NodeCount > 0 then
          Line := Indent;
        Line := Line + Format('</%s>', [FName]);
      end;
    end;
  else
    raise EFilerError.Create(sxeIllegalElementType);
  end;//case
  WriteStringToStream(S, Line);

  // Call the onprogress
  if assigned(Document) then
    Document.DoProgress(S.Position);
end;

function TXmlNode.WriteToString: string;
var
  S: TsdStringStream;
begin
  // We will simply call WriteToStream and collect the result as string using
  // a string stream
  S := TsdStringStream.Create('');
  try
    WriteToStream(S);
    Result := S.DataString;
  finally
    S.Free;
  end;
end;

procedure TXmlNode.WriteWidestring(const AName: string;
  const AValue: widestring; const ADefault: widestring);
begin
  WriteString(AName, FromWidestring(AValue), ADefault);
end;

{ TXmlNodeList }

function TXmlNodeList.ByAttribute(const AName, AValue: string): TXmlNode;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].AttributeByName[AName], AValue) = 0 then
    begin
      Result := Items[i];
      exit;
    end;
  Result := nil;
end;

function TXmlNodeList.GetItems(Index: Integer): TXmlNode;
begin
  Result := TXmlNode(Get(Index));
end;

procedure TXmlNodeList.SetItems(Index: Integer; const Value: TXmlNode);
begin
  Put(Index, TPointer(Value));
end;

{ TNativeXml }

procedure TNativeXml.Assign(Source: TPersistent);
  // local
  procedure SetDocumentRecursively(ANode: TXmlNode; ADocument: TNativeXml);
  var
    i: integer;
  begin
    ANode.Document := ADocument;
    for i := 0 to ANode.NodeCount - 1 do
      SetDocumentRecursively(ANode.Nodes[i], ADocument);
  end;
// main
begin
  if Source is TNativeXml then
  begin
    // Copy private members
    FBinaryEncoding := TNativeXml(Source).FBinaryEncoding;
    FDropCommentsOnParse := TNativeXml(Source).FDropCommentsOnParse;
    FExternalEncoding := TNativeXml(Source).FExternalEncoding;
    FParserWarnings := TNativeXml(Source).FParserWarnings;
    FIndentString := TNativeXml(Source).FIndentString;
    FUseFullNodes := TNativeXml(Source).FUseFullNodes;
    FUtf8Encoded := TNativeXml(Source).FUtf8Encoded;
    FWriteOnDefault := TNativeXml(Source).FWriteOnDefault;
    FXmlFormat := TNativeXml(Source).FXmlFormat;
    FSortAttributes := TNativeXml(Source).FSortAttributes;
    // Assign root
    FRootNodes.Assign(TNativeXml(Source).FRootNodes);
    // Set Document property recursively
    SetDocumentRecursively(FRootNodes, Self);
  end else
    if Source is TXmlNode then
    begin
      // Assign this node to the FRootNodes property
      FRootNodes.Assign(Source);
      // Set Document property recursively
      SetDocumentRecursively(FRootNodes, Self);
    end else
      inherited;
end;

procedure TNativeXml.Clear;
var
  Node: TXmlNode;
begin
  // Reset defaults
  SetDefaults;
  // Clear root
  FRootNodes.Clear;
  // Build default items in RootNodes
  // - first the declaration
  Node := TXmlNode.CreateType(Self, xeDeclaration);
  Node.Name := 'xml';
  Node.AttributeAdd('version', cDefaultVersionString);
  Node.AttributeAdd('encoding', cDefaultEncodingString);
  FRootNodes.NodeAdd(Node);
  // - then the root node
  FRootNodes.NodeNew('');
end;

procedure TNativeXml.CopyFrom(Source: TNativeXml);
begin
  if not assigned(Source) then
    exit;
  Assign(Source);
end;

constructor TNativeXml.Create;
begin
  inherited Create;
  FRootNodes := TXmlNode.Create(Self);
  Clear;
end;

constructor TNativeXml.CreateName(const ARootName: string);
begin
  Create;
  Root.Name := ARootName;
end;

destructor TNativeXml.Destroy;
begin
  FreeAndNil(FRootNodes);
  inherited;
end;

procedure TNativeXml.DoNodeLoaded(Node: TXmlNode);
begin
  if assigned(FOnNodeLoaded) then
    FOnNodeLoaded(Self, Node);
end;

procedure TNativeXml.DoNodeNew(Node: TXmlNode);
begin
  if assigned(FOnNodeNew) then
    FOnNodeNew(Self, Node);
end;

procedure TNativeXml.DoProgress(Size: integer);
begin
  if assigned(FOnProgress) then
    FOnProgress(Self, Size);
end;

procedure TNativeXml.DoUnicodeLoss(Sender: TObject);
begin
  if assigned(FOnUnicodeLoss) then
    FOnUnicodeLoss(Self);
end;

function TNativeXml.GetCommentString: string;
// Get the first comment node, and return its value
var
  Node: TXmlNode;
begin
  Result := '';
  Node := FRootNodes.NodeByElementType(xeComment);
  if assigned(Node) then
    Result := Node.ValueAsString;
end;

function TNativeXml.GetEncodingString: string;
begin
  Result := '';
  if FRootNodes.NodeCount > 0 then
    if FRootNodes[0].ElementType = xeDeclaration then
      Result := FRootNodes[0].AttributeByName['encoding'];
end;

function TNativeXml.GetEntityByName(AName: string): string;
var
  i, j: integer;
begin
  Result := '';
  for i := 0 to FRootNodes.NodeCount - 1 do
    if FRootNodes[i].ElementType = xeDoctype then with FRootNodes[i] do
    begin
      for j := 0 to NodeCount - 1 do
        if (Nodes[j].ElementType = xeEntity) and (Nodes[j].Name = AName) then
        begin
          Result := UnQuoteString(Trim(Nodes[j].ValueDirect));
          exit;
        end;
    end;
end;

function TNativeXml.GetRoot: TXmlNode;
begin
  Result := FRootNodes.NodeByElementType(xeNormal);
end;

function TNativeXml.GetStyleSheetNode: TXmlNode;
begin
  Result := FRootNodes.NodeByElementType(xeStylesheet);
  if not assigned(Result) then
  begin
    // Add a stylesheet node as second one if none present
    Result := TXmlNode.CreateType(Self, xeStyleSheet);
    FRootNodes.NodeInsert(1, Result);
  end;
end;

function TNativeXml.GetVersionString: string;
begin
  Result := '';
  if FRootNodes.NodeCount > 0 then
    if FRootNodes[0].ElementType = xeDeclaration then
      Result := FRootNodes[0].AttributeByName['version'];
end;

function TNativeXml.IsEmpty: boolean;
var
  R: TXmlNode;
begin
  Result := True;
  R := GetRoot;
  if assigned(R) then
    Result := R.IsClear;
end;

function TNativeXml.LineFeed: string;
begin
  case XmlFormat of
  xfReadable:
    Result := #13#10;
  xfCompact:
    Result := #10;
  else
    Result := #10;
  end;//case
end;

procedure TNativeXml.LoadFromFile(const FileName: string);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TNativeXml.LoadFromStream(Stream: TStream);
var
  B: TsdBufferedReadStream;
begin
  // Create buffer filter. Since we read from the original stream a buffer at a
  // time, this speeds up the reading process for disk-based files.
  B := TsdBufferedReadStream.Create(Stream, False);
  try
    // We will create a conversion stream as intermediate
    if Utf8Encoded then
      FCodecStream := TsdUtf8Stream.Create(B)
    else
      FCodecStream := TsdAnsiStream.Create(B);
    try
      // Connect events
      FCodecStream.OnUnicodeLoss := DoUnicodeLoss;
      // Read from stream
      ReadFromStream(FCodecStream);
      // Set our external encoding
      FExternalEncoding := FCodecStream.Encoding;
      // Set internal encoding
      if (ExternalEncoding = seUtf8) or (AnsiCompareText(EncodingString,'UTF-8') = 0) then
        FUtf8Encoded := True;
    finally
      FreeAndNil(FCodecStream);
    end;
  finally
    B.Free;
  end;
end;

procedure TNativeXml.ParseDTD(ANode: TXmlNode; S: TStream);
// DTD parsing is quite different from normal node parsing so it is brought
// under in the main NativeXml object
  // local
  procedure ParseMarkupDeclarations;
  var
    Ch: char;
  begin
    repeat
      ANode.NodeNew('').ReadFromStream(S);
      // Read character, exit if none available
      repeat
        if S.Read(Ch, 1) = 0 then
          exit;
      // Read until end markup declaration or end
      until not (Ch in cControlChars);
      if Ch = ']' then
        break;
      S.Seek(-1, soCurrent);
    until False;
  end;
// main
var
  Prework: string;
  Ch: char;
  Words: TStringList;
begin
  // Get the name and external ID
  Prework := '';
  repeat
    // Read character, exit if none available
    if S.Read(Ch, 1) = 0 then
      exit;
    // Read until markup declaration or end
    if Ch in ['[', '>'] then
      break;
    Prework := Prework + Ch;
  until False;
  Words := TStringList.Create;
  try
    ParseAttributes(Prework, 1, length(Prework) + 1, Words);
    // First word is name
    if Words.Count > 0 then
    begin
      ANode.Name := Words[0];
      Words.Delete(0);
      // Put the rest in the valuedirect
      ANode.ValueDirect := Trim(StringReplace(Words.Text, #13#10, ' ', [rfReplaceAll]));
    end;
  finally
    Words.Free;
  end;

  if Ch = '[' then
  begin

    // Parse any !ENTITY nodes and such
    ParseMarkupDeclarations;

    // read final tag
    repeat
      if S.Read(Ch, 1) = 0 then
        exit;
      if Ch = '>' then
        break;
    until False;

  end;
end;

procedure TNativeXml.ReadFromStream(S: TStream);
var
  i: integer;
  Node: TXmlNode;
  Enc: string;
  NormalCount, DeclarationCount,
  DoctypeCount, CDataCount: integer;
  NormalPos, DoctypePos: integer;
begin
  FAbortParsing := False;
  with FRootNodes do
  begin
    // Clear the old root nodes - we do not reset the defaults
    Clear;
    DoProgress(0);
    repeat
      Node := NodeNew('');
      Node.ReadFromStream(S);
      if AbortParsing then
        exit;

      // XML declaration
      if Node.ElementType = xeDeclaration then
      begin
        if Node.HasAttribute('encoding') then
          Enc := Node.AttributeByName['encoding'];
        // Check encoding
        if assigned(FCodecStream) and (Enc = 'UTF-8') then
          FCodecStream.Encoding := seUTF8;
      end;
      // Skip clear nodes
      if Node.IsClear then
        NodeDelete(NodeCount - 1);
    until S.Position >= S.Size;
    DoProgress(S.Size);

    // Do some checks
    NormalCount      := 0;
    DeclarationCount := 0;
    DoctypeCount     := 0;
    CDataCount       := 0;
    NormalPos        := -1;
    DoctypePos       := -1;
    for i := 0 to NodeCount - 1 do
    begin
      // Count normal elements - there may be only one
      case Nodes[i].ElementType of
      xeNormal:
        begin
          inc(NormalCount);
          NormalPos := i;
        end;
      xeDeclaration: inc(DeclarationCount);
      xeDoctype:
        begin
          inc(DoctypeCount);
          DoctypePos := i;
        end;
      xeCData: inc(CDataCount);
      end;//case
    end;

    // We *must* have a root node
    if NormalCount = 0 then
      raise EFilerError.Create(sxeNoRootElement);

    // Do some validation if we allow parser warnings
    if FParserWarnings then
    begin

      // Check for more than one root node
      if NormalCount > 1 then
        raise EFilerError.Create(sxeMoreThanOneRootElement);

      // Check for more than one xml declaration
      if DeclarationCount > 1 then
        raise EFilerError.Create(sxeMoreThanOneDeclaration);

      // Declaration must be first element if present
      if DeclarationCount = 1 then
        if Nodes[0].ElementType <> xeDeclaration then
          raise EFilerError.Create(sxeDeclarationMustBeFirstElem);

      // Check for more than one DTD
      if DoctypeCount > 1 then
        raise EFilerError.Create(sxeMoreThanOneDoctype);

      // Check if DTD is after root, this is not allowed
      if (DoctypeCount = 1) and (DoctypePos > NormalPos) then
        raise EFilerError.Create(sxeDoctypeAfterRootElement);

      // No CDATA in root allowed
      if CDataCount > 0 then
        raise EFilerError.Create(sxeCDataInRoot);
    end;
  end;//with
end;

procedure TNativeXml.ReadFromString(const AValue: string);
var
  S: TStream;
begin
  S := TsdStringStream.Create(AValue);
  try
    ReadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TNativeXml.ResolveEntityReferences;
begin
  if assigned(Root) then
    Root.ResolveEntityReferences;
end;

procedure TNativeXml.SaveToFile(const FileName: string);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TNativeXml.SaveToStream(Stream: TStream);
var
  B: TsdBufferedWriteStream;
begin
  // Create buffer filter. Since we write a buffer at a time to the destination
  // stream, this speeds up the writing process for disk-based files.
  B := TsdBufferedWriteStream.Create(Stream, False);
  try
    // Create conversion stream
    if Utf8Encoded then
      FCodecStream := TsdUtf8Stream.Create(B)
    else
      FCodecStream := TsdAnsiStream.Create(B);
    try
      // Set External encoding
      FCodecStream.Encoding := FExternalEncoding;
      WriteToStream(FCodecStream);
    finally
      FreeAndNil(FCodecStream);
    end;
  finally
    B.Free;
  end;
end;

procedure TNativeXml.SetCommentString(const Value: string);
// Find first comment node and set it's value, otherwise add new comment node
// right below the xml declaration
var
  Node: TXmlNode;
begin
  Node := FRootNodes.NodeByElementType(xeComment);
  if not assigned(Node) and (length(Value) > 0) then
  begin
    Node := TXmlNode.CreateType(Self, xeComment);
    FRootNodes.NodeInsert(1, Node);
  end;
  if assigned(Node) then
    Node.ValueAsString := Value;
end;

procedure TNativeXml.SetDefaults;
begin
  // Defaults
  FExternalEncoding       := cDefaultExternalEncoding;
  FXmlFormat              := cDefaultXmlFormat;
  FWriteOnDefault         := cDefaultWriteOnDefault;
  FBinaryEncoding         := cDefaultBinaryEncoding;
  FUtf8Encoded            := cDefaultUtf8Encoded;
  FIndentString           := cDefaultIndentString;
  FDropCommentsOnParse    := cDefaultDropCommentsOnParse;
  FUseFullNodes           := cDefaultUseFullNodes;
  FSortAttributes         := cDefaultSortAttributes;
  FFloatAllowScientific   := cDefaultFloatAllowScientific;
  FFloatSignificantDigits := cDefaultFloatSignificantDigits;
  FOnNodeNew              := nil;
  FOnNodeLoaded           := nil;
end;

procedure TNativeXml.SetEncodingString(const Value: string);
var
  Node: TXmlNode;
begin
  if Value = GetEncodingString then
    exit;
  Node := FRootNodes[0];
  if not assigned(Node) or (Node.ElementType <> xeDeclaration) then
  begin
    Node := TXmlNode.CreateType(Self, xeDeclaration);
    FRootNodes.NodeInsert(0, Node);
  end;
  if assigned(Node) then
    Node.AttributeByName['encoding'] := Value;
end;

procedure TNativeXml.SetVersionString(const Value: string);
var
  Node: TXmlNode;
begin
  if Value = GetVersionString then
    exit;
  Node := FRootNodes[0];
  if not assigned(Node) or (Node.ElementType <> xeDeclaration) then
  begin
    if length(Value) > 0 then
    begin
      Node := TXmlNode.CreateType(Self, xeDeclaration);
      FRootNodes.NodeInsert(0, Node);
    end;
  end;
  if assigned(Node) then
    Node.AttributeByName['version'] := Value;
end;

procedure TNativeXml.WriteToStream(S: TStream);
var
  i: integer;
begin
  if not assigned(Root) and FParserWarnings then
    raise EFilerError.Create(sxeRootElementNotDefined);

  DoProgress(0);

  // write the root nodes
  for i := 0 to FRootNodes.NodeCount - 1 do
  begin
    FRootNodes[i].WriteToStream(S);
    WriteStringToStream(S, LineFeed);
  end;

  DoProgress(S.Size);
end;

function TNativeXml.WriteToString: string;
var
  S: TsdStringStream;
begin
  S := TsdStringStream.Create('');
  try
    WriteToStream(S);
    Result := S.DataString;
  finally
    S.Free;
  end;
end;

{ TsdCodecStream }

constructor TsdCodecStream.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
end;

function TsdCodecStream.InternalRead(var Buffer{$IFDEF CLR}: array of Byte{$ENDIF}; Offset, Count: Longint): Longint;
// Read from FStream and pass back data
var
  i, j: integer;
  BOM: array[0..3] of byte;
  BytesRead: integer;
  Found: boolean;
begin
  Result := 0;
  if FMode = umUnknown then
  begin
    FMode := umRead;
    // Check FStream
    if not assigned(FStream) then
      raise EStreamError.Create(sxeCodecStreamNotAssigned);

    // Determine encoding
    FEncoding := se8Bit;
    BytesRead := FStream.Read(BOM, 4);
    for i := 0 to cBomInfoCount - 1 do
    begin
      Found := True;
      for j := 0 to Min(BytesRead, cBomInfo[i].Len) - 1 do
      begin
        if BOM[j] <> cBomInfo[i].BOM[j] then
        begin
          Found := False;
          break;
        end;
      end;
      if Found then
        break;
    end;
    if Found then
    begin
      FEncoding := cBomInfo[i].Enc;
      FWriteBom := cBomInfo[i].HasBOM;
    end else
    begin
      // Unknown.. default to this
      FEncoding := se8Bit;
      FWriteBom := False;
    end;

    // Some encodings are not supported (yet)
    if FEncoding in [seUCS4BE, seUCS4_2143, seUCS4_3412, seEBCDIC] then
      raise EStreamError.Create(sxeUnsupportedEncoding);

    // Correct stream to start position
    if FWriteBom then
      FStream.Seek(cBomInfo[i].Len - BytesRead, soCurrent)
    else
      FStream.Seek(-BytesRead, soCurrent);

    // Check if we must swap byte order
    if FEncoding in [se16BitBE, seUTF16BE] then
      FSwapByteOrder := True;

  end;

  // Check mode
  if FMode <> umRead then
    raise EStreamError.Create(sxeCannotReadCodecForWriting);

  // Check count
  if Count <> 1 then
    raise EStreamError.Create(sxeCannotReadMultipeChar);

  // Now finally read
  TBytes(Buffer)[Offset] := ReadByte;
  if TBytes(Buffer)[Offset] <> 0 then Result := 1;
end;

{$IFDEF CLR}

function TsdCodecStream.Read(var Buffer: array of Byte; Offset, Count: Longint): Longint;
begin
  Result := InternalRead(Buffer, Offset, Count);
end;

{$ELSE}

function TsdCodecStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := InternalRead(Buffer, 0, Count);
end;

{$ENDIF}

function TsdCodecStream.ReadByte: byte;
begin
  // default does nothing
  Result := 0;
end;

function TsdCodecStream.InternalSeek(Offset: Longint; Origin: TSeekOrigin): Longint;
begin
  Result := 0;
  if FMode = umUnknown then
    raise EStreamError.Create(sxeCannotSeekBeforeReadWrite);

  if Origin = soCurrent then
  begin
    if Offset = 0 then
    begin
      // Position
      Result := FStream.Position;
      exit;
    end;
    if (FMode = umRead) and ((Offset = -1) or (Offset = -2)) then
    begin
      FBuffer := '';
      case Offset of
      -1: FStream.Seek(FPosMin1, soBeginning);
      -2: FStream.Seek(FPosMin2, soBeginning);
      end;//case
      exit;
    end;
  end;
  if (Origin = soEnd) and (Offset = 0) then
  begin
    // Size
    Result := FStream.Size;
    exit;
  end;
  // Ignore set position from beginning (used in Size command)
  if Origin = soBeginning then
    exit;
  // Arriving here means we cannot do it
  raise EStreamError.Create(sxeCannotPerformSeek);
end;

{$IFDEF CLR}

function TsdCodecStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := InternalSeek(Offset, Origin);
end;

{$ELSE}

function TsdCodecStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := InternalSeek(Offset, TSeekOrigin(Origin));
end;

{$ENDIF}

procedure TsdCodecStream.StorePrevPositions;
begin
  FPosMin2 := FPosMin1;
  FPosMin1 := FStream.Position;
end;

function TsdCodecStream.InternalWrite(const Buffer{$IFDEF CLR}: array of Byte{$ENDIF}; Offset, Count: Longint): Longint;
var
  i: integer;
begin
  if FMode = umUnknown then
  begin
    FMode := umWrite;

    // Some encodings are not supported (yet)
    if FEncoding in [seUCS4BE, seUCS4_2143, seUCS4_3412, seEBCDIC] then
      raise EStreamError.Create(sxeUnsupportedEncoding);

    // Find correct encoding info
    for i := 0 to cBomInfoCount - 1 do
      if cBomInfo[i].Enc = FEncoding then
      begin
        FWriteBom := cBomInfo[i].HasBOM;
        break;
      end;

    // Write BOM
    if FWriteBom then
      FStream.WriteBuffer(cBomInfo[i].BOM, cBomInfo[i].Len);

    // Check if we must swap byte order
    if FEncoding in [se16BitBE, seUTF16BE] then
      FSwapByteOrder := True;
  end;

  if FMode <> umWrite then
    raise EStreamError.Create(sxeCannotWriteCodecForReading);
  WriteBuf(Buffer, Offset, Count);
  Result := Count;
end;

{$IFDEF CLR}

function TsdCodecStream.Write(const Buffer: array of Byte; Offset, Count: Longint): Longint;
begin
  Result := InternalWrite(Buffer, Offset, Count);
end;

{$ELSE}

function TsdCodecStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := InternalWrite(Byte(Buffer), 0, Count);
end;

{$ENDIF}

procedure TsdCodecStream.WriteBuf(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Offset, Count: longint);
var
  i: integer;
begin
  // Default just writes out bytes one by one. We override this in descendants
  // to provide faster writes for some modes
  for i := 0 to Count - 1 do
  {$IFDEF CLR}
    WriteByte(Buffer[Offset + i]);
  {$ELSE}
    WriteByte(TBytes(Buffer)[Offset + i]);
  {$ENDIF}
end;

procedure TsdCodecStream.WriteByte(const B: byte);
begin
// default does nothing
end;

{$IFDEF CLR}

procedure TsdCodecStream.SetSize(NewSize: Int64);
begin
// default does nothing
end;

{$ENDIF}

{ TsdAnsiStream }

function TsdAnsiStream.ReadByte: byte;
var
  B: byte;
  W: word;
begin
  StorePrevPositions;

  case FEncoding of
  se8Bit, seUTF8:
    begin
      // Just a flat read of one byte. UTF8 is not converted back, when UTF8
      // encoding is detected, the document will set Utf8Encoded to True.
      B := 0;
      FStream.Read(B, 1);
      Result := B;
    end;
  se16BitBE,se16BitLE,seUTF16BE,seUTF16LE:
    begin
      // Read two bytes
      W := 0;
      FStream.Read(W, 2);
      // Swap byte order
      if FSwapByteOrder then
        W := swap(W);
      // Unicode warning loss
      if ((W and $FF00) > 0) and not FWarningUnicodeLoss then
      begin
        FWarningUnicodeLoss := True;
        if assigned(FOnUnicodeLoss) then
          FOnUnicodeLoss(Self);
        // We cannot display unicode range characters
        Result := ord('?');
      end else
        Result := W and $FF;
    end;
  else
    raise EStreamError.Create(sxeUnsupportedEncoding);
  end;//case
end;

procedure TsdAnsiStream.WriteBuf(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Offset, Count: longint);
begin
  case FEncoding of
  se8Bit:
    begin
      // one on one
      if StreamWrite(FStream, Buffer, Offset, Count) <> Count then
        raise EStreamError.Create(sxeCannotWriteToOutputStream);
    end;
  else
    inherited;
  end;//case
end;

procedure TsdAnsiStream.WriteByte(const B: byte);
var
  SA, SU: string;
  W: word;
begin
  case FEncoding of
  se8Bit:
    begin
      // Just a flat write of one byte
      FStream.Write(B, 1);
    end;
  seUTF8:
    begin
      // Convert Ansi to UTF8
      SA := char(B);
      SU := sdAnsiToUTF8(SA);
      // write out
      if FStream.Write(SU[1], length(SU)) = 0 then
        raise EStreamError.Create(sxeCannotWriteToOutputStream);
    end;
  se16BitBE,se16BitLE,seUTF16BE,seUTF16LE:
    begin
      // Convert Ansi to Unicode
      W := B;
      // Swap byte order
      if FSwapByteOrder then
        W := swap(W);
      // write out
      if FStream.Write(W, 2) = 0 then
        raise EStreamError.Create(sxeCannotWriteToOutputStream);
    end;
  else
    raise EStreamError.Create(sxeUnsupportedEncoding);
  end;//case
end;

{ TsdUtf8Stream }

function TsdUtf8Stream.ReadByte: byte;
var
  B, B1, B2, B3: byte;
  W: word;
  SA: string;
begin
  Result := 0;

  // New character?
  if (Length(FBuffer) = 0) or (FBufferPos > length(FBuffer)) then
  begin
    StorePrevPositions;
    FBufferPos := 1;
    // Read another char and put in buffer
    case FEncoding of
    se8Bit:
      begin
        // read one byte
        B := 0;
        FStream.Read(B, 1);
        SA := char(B);
        // Convert to UTF8
        FBuffer := sdAnsiToUtf8(SA);
      end;
    seUTF8:
      begin
        // Read one, two or three bytes in the buffer
        B1 := 0;
        FStream.Read(B1, 1);
        FBuffer := char(B1);
        if (B1 and $80) > 0 then
        begin
          if (B1 and $20) <> 0 then
          begin
            B2 := 0;
            FStream.Read(B2, 1);
            FBuffer := FBuffer + char(B2);
          end;
          B3 := 0;
          FStream.Read(B3, 1);
          FBuffer := FBuffer + char(B3);
        end;
      end;
    se16BitBE,se16BitLE,seUTF16BE,seUTF16LE:
      begin
        // Read two bytes
        W := 0;
        FStream.Read(W, 2);
        // Swap byte order
        if FSwapByteOrder then
          W := swap(W);
        // Convert to UTF8 in buffer
        {$IFDEF D5UP}
        FBuffer := sdUnicodeToUtf8(widechar(W));
        {$ELSE}
        FBuffer := sdUnicodeToUtf8(char(W and $FF));
        {$ENDIF}
      end;
    else
      raise EStreamError.Create(sxeUnsupportedEncoding);
    end;//case
  end;

  // Now we have the buffer, so read
  if (FBufferPos > 0) and (FBufferPos <= length(FBuffer)) then
    Result := byte(FBuffer[FBufferPos]);
  inc(FBufferPos);
end;

procedure TsdUtf8Stream.WriteBuf(const Buffer{$IFDEF CLR}: TBytes{$ENDIF}; Offset, Count: longint);
begin
  case FEncoding of
  seUtf8:
    begin
      // one on one
      if StreamWrite(FStream, Buffer, Offset, Count) <> Count then
        raise EStreamError.Create(sxeCannotWriteToOutputStream);
    end
  else
    inherited;
  end;//case
end;

procedure TsdUtf8Stream.WriteByte(const B: byte);
var
  SA: string;
  SW: widestring;
  MustWrite: boolean;
begin
  case FEncoding of
  se8Bit,se16BitBE,se16BitLE,seUTF16BE,seUTF16LE:
    begin
      MustWrite := True;
      case Length(FBuffer) of
      0:
        begin
          FBuffer := char(B);
          if (B and $80) <> 0 then
            MustWrite := False;
        end;
      1:
        begin
          FBuffer := FBuffer + char(B);
          if (byte(FBuffer[1]) and $20) <> 0 then
            MustWrite := False;
        end;
      2: FBuffer := FBuffer + char(B);
      end;
      if MustWrite then
      begin
        if FEncoding = se8Bit then
        begin
          // Convert to ansi
          SA := sdUtf8ToAnsi(FBuffer);
          // write out
          if length(SA) = 1 then
            if FStream.Write(SA[1], 1) <> 1 then
              raise EStreamError.Create(sxeCannotWriteToOutputStream);
        end else
        begin
          // Convert to unicode
          SW := sdUtf8ToUnicode(FBuffer);
          // write out
          if length(SW) = 1 then
            if FStream.Write(SW[1], 2) <> 2 then
              raise EStreamError.Create(sxeCannotWriteToOutputStream);
        end;
        FBuffer := '';
      end;
    end;
  seUTF8:
    begin
      // Just a flat write of one byte
      if FStream.Write(B, 1) <> 1 then
        raise EStreamError.Create(sxeCannotWriteToOutputStream);
    end;
  else
    raise EStreamError.Create(sxeUnsupportedEncoding);
  end;//case
end;

{$IFDEF CLR}
{ TsdBufferedStream }

constructor TsdBufferedStream.Create(AStream: TStream; Owned: Boolean = False);
begin
  inherited Create;
  FStream := AStream;
  FOwned := Owned;
end;

destructor TsdBufferedStream.Destroy;
begin
  if FOwned then FreeAndNil(FStream);
  inherited Destroy;
end;

function TsdBufferedStream.Read(var Buffer: array of Byte; Offset, Count: Longint): Longint;
begin
  Result := FStream.Read(Buffer, Offset, Count);
end;

function TsdBufferedStream.Write(const Buffer: array of Byte; Offset, Count: Longint): Longint;
begin
  Result := FStream.Write(Buffer, Offset, Count);
end;

function TsdBufferedStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := FStream.Seek(Offset, Origin);
end;

procedure TsdBufferedStream.SetSize(NewSize: Int64);
begin
  FStream.Size := NewSize;
end;

{$ELSE}

{ TsdBufferedReadStream }

const
  cMaxBufferSize = $10000; // 65536 bytes in the buffer

procedure TsdBufferedReadStream.CheckPosition;
var
  NewPage: integer;
  FStartPos: longint;
begin
  // Page and buffer position
  NewPage := FPosition div cMaxBufferSize;
  FBufPos := FPosition mod cMaxBufferSize;

  // Read new page if required
  if (NewPage <> FPage) then
  begin
    // New page and buffer
    FPage := NewPage;

    // Start position in stream
    FStartPos := FPage * cMaxBufferSize;
    FBufSize  := Min(cMaxBufferSize, FStream.Size - FStartPos);

    FStream.Seek(FStartPos, soBeginning);
    if FBufSize > 0 then
      FStream.Read(FBuffer^, FBufSize);
  end;
  FMustCheck := False;
end;

constructor TsdBufferedReadStream.Create(AStream: TStream; Owned: boolean);
begin
  inherited Create;
  FStream := AStream;
  FOwned := Owned;
  FMustCheck := True;
  FPage := -1; // Set to invalid number to force an update on first read
  ReallocMem(FBuffer, cMaxBufferSize);
end;

destructor TsdBufferedReadStream.Destroy;
begin
  if FOwned then FreeAndNil(FStream);
  ReallocMem(FBuffer, 0);
  inherited;
end;

function TsdBufferedReadStream.Read(var Buffer; Count: longint): Longint;
var
  Packet: PByte;
  PacketCount: integer;
begin
  // Set the right page
  if FMustCheck then
    CheckPosition;

  // Special case - read one byte, most often
  if (Count = 1) and (FBufPos < FBufSize - 1) then
  begin
    byte(Buffer) := FBuffer^[FBufPos];
    inc(FBufPos);
    inc(FPosition);
    Result := 1;
    exit;
  end;

  // general case
  Packet := @Buffer;
  Result := 0;
  while Count > 0 do
  begin
    PacketCount := min(FBufSize - FBufPos, Count);
    if PacketCount <= 0 then
      exit;
    Move(FBuffer^[FBufPos], Packet^, PacketCount);
    dec(Count, PacketCount);
    inc(Packet, PacketCount);
    inc(Result, PacketCount);
    inc(FPosition, PacketCount);
    inc(FBufPos, PacketCount);
    if FBufPos >= FBufSize then
      CheckPosition;
  end;
end;

function TsdBufferedReadStream.Seek(Offset: longint; Origin: Word): Longint;
begin
  case Origin of
  soFromBeginning:
    FPosition := Offset;
  soFromCurrent:
    begin
      // no need to check in this case - it is the GetPosition command
      if Offset = 0 then
      begin
        Result := FPosition;
        exit;
      end;
      FPosition := FPosition + Offset;
    end;
  soFromEnd:
    FPosition := FStream.Size + Offset;
  end;//case
  Result := FPosition;
  FMustCheck := True;
end;

function TsdBufferedReadStream.Write(const Buffer; Count: longint): Longint;
begin
  raise EStreamError.Create(sxeCannotWriteCodecForReading);
end;

{ TsdBufferedWriteStream }

constructor TsdBufferedWriteStream.Create(AStream: TStream; Owned: boolean);
begin
  inherited Create;
  FStream := AStream;
  FOwned := Owned;
  ReallocMem(FBuffer, cMaxBufferSize);
end;

destructor TsdBufferedWriteStream.Destroy;
begin
  Flush;
  if FOwned then
    FreeAndNil(FStream);
  ReallocMem(FBuffer, 0);
  inherited;
end;

procedure TsdBufferedWriteStream.Flush;
begin
  // Write the buffer to the stream
  if FBufPos > 0 then
  begin
    FStream.Write(FBuffer^, FBufPos);
    FBufPos := 0;
  end;
end;

function TsdBufferedWriteStream.Read(var Buffer; Count: longint): Longint;
begin
  raise EStreamError.Create(sxeCannotReadCodecForWriting);
end;

function TsdBufferedWriteStream.Seek(Offset: longint; Origin: Word): Longint;
begin
  case Origin of
  soFromBeginning:
    if Offset = FPosition then
    begin
      Result := FPosition;
      exit;
    end;
  soFromCurrent:
    begin
      // GetPosition command
      if Offset = 0 then
      begin
        Result := FPosition;
        exit;
      end;
    end;
  soFromEnd:
    if Offset = 0 then
    begin
      Result := FPosition;
      exit;
    end;
  end;//case
  raise EStreamError.Create(sxeCannotPerformSeek);
end;

function TsdBufferedWriteStream.Write(const Buffer; Count: longint): Longint;
var
  Packet: PByte;
  PacketCount: integer;
begin
  // Special case - read less bytes than would fill buffersize
  if (FBufPos + Count < cMaxBufferSize) then
  begin
    Move(Buffer, FBuffer^[FBufPos], Count);
    inc(FBufPos, Count);
    inc(FPosition, Count);
    Result := Count;
    exit;
  end;

  // general case that wraps buffer
  Packet := @Buffer;
  Result := 0;
  while Count > 0 do
  begin
    PacketCount := min(cMaxBufferSize - FBufPos, Count);
    if PacketCount <= 0 then
      exit;
    Move(Packet^, FBuffer^[FBufPos], PacketCount);
    dec(Count,     PacketCount);
    inc(Result,    PacketCount);
    inc(FPosition, PacketCount);
    inc(Packet,    PacketCount);
    inc(FBufPos,   PacketCount);
    if FBufPos = cMaxBufferSize then
      Flush;
  end;
end;
{$ENDIF}

{ TsdSurplusReader }

constructor TsdSurplusReader.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
end;

function TsdSurplusReader.ReadChar(var Ch: char): integer;
begin
  if length(FSurplus) > 0 then
  begin
    Ch := FSurplus[1];
    FSurplus := copy(FSurplus, 2, length(FSurplus) - 1);
    Result := 1;
  end else
    Result := FStream.Read(Ch, 1);
end;

function TsdSurplusReader.ReadCharSkipBlanks(var Ch: char): boolean;
begin
  Result := False;
  repeat
    // Read character, exit if none available
    if ReadChar(Ch) = 0 then
      exit;
    // Skip if in controlchars
    if not (Ch in cControlchars) then
      break;
  until False;
  Result := True;
end;

{ TsdStringBuilder }

procedure TsdStringBuilder.AddChar(Ch: Char);
begin
  inc(FCurrentIdx);
  Reallocate(FCurrentIdx);
  FData[FCurrentIdx] := Ch;
end;

procedure TsdStringBuilder.AddString(var S: string);
var
  {$IFDEF CLR}
  i: integer;
  {$ENDIF}
  Count: integer;
begin
  {$IFDEF CLR}
  Count := S.Length;
  {$ELSE}
  Count := System.length(S);
  {$ENDIF}
  if Count = 0 then
    exit;
  Reallocate(FCurrentIdx + Count);
  {$IFDEF CLR}
  for i := 1 to S.Length do
    FData[FCurrentIdx + i] := S[i];
  {$ELSE}
  Move(S[1], FData[FCurrentIdx + 1], Count);
  {$ENDIF}
  inc(FCurrentIdx, Count);
end;

procedure TsdStringBuilder.Clear;
begin
  FCurrentIdx := 0;
end;

function TsdStringBuilder.StringCopy(AFirst, ALength: integer): string;
begin
  if ALength > FCurrentIdx - AFirst + 1 then
    ALength := FCurrentIdx - AFirst + 1;
  Result := Copy(FData, AFirst, ALength);
end;

constructor TsdStringBuilder.Create;
begin
  inherited Create;
  SetLength(FData, 64);
end;

function TsdStringBuilder.GetData(Index: integer): Char;
begin
  Result := FData[Index];
end;

procedure TsdStringBuilder.Reallocate(RequiredLength: integer);
begin
  {$IFDEF CLR}
  while FData.Length < RequiredLength do
    SetLength(FData, FData.Length * 2);
  {$ELSE}
  while System.Length(FData) < RequiredLength do
    SetLength(FData, System.Length(FData) * 2);
  {$ENDIF}
end;

function TsdStringBuilder.Value: string;
begin
  Result := Copy(FData, 1, FCurrentIdx);
end;

initialization

  {$IFDEF TRIALXML}
  ShowMessage(
    'This is the unregistered version of NativeXml.pas'#13#13 +
    'Please visit http://www.simdesign.nl/xml.html to buy the'#13 +
    'registered version for Eur 29.95 (source included).');
  {$ENDIF}

end.
