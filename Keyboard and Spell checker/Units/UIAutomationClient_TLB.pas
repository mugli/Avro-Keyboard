unit UIAutomationClient_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 98336 $
// File generated on 3/8/2025 9:52:39 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\SysWOW64\UIAutomationCore.dll (1)
// LIBID: {944DE083-8FB8-45CF-BCB7-C477ACB2F897}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Parameter 'unit' of IUIAutomationTextRange.Move changed to 'unit_'
//   Hint: Parameter 'unit' of IUIAutomationTextRange.MoveEndpointByUnit changed to 'unit_'
//   Hint: Symbol 'ClassName' renamed to '_className'
//   Hint: Parameter 'array' of IUIAutomation.IntNativeArrayToSafeArray changed to 'array_'
//   Hint: Parameter 'array' of IUIAutomation.IntSafeArrayToNativeArray changed to 'array_'
//   Hint: Parameter 'var' of IUIAutomation.RectToVariant changed to 'var_'
//   Hint: Parameter 'var' of IUIAutomation.VariantToRect changed to 'var_'
//   Hint: Parameter 'property' of IUIAutomation.GetPropertyProgrammaticName changed to 'property_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  UIAutomationClientMajorVersion = 1;
  UIAutomationClientMinorVersion = 0;

  LIBID_UIAutomationClient: TGUID = '{944DE083-8FB8-45CF-BCB7-C477ACB2F897}';

  IID_IUIAutomationElement: TGUID = '{D22108AA-8AC5-49A5-837B-37BBB3D7591E}';
  IID_IUIAutomationCondition: TGUID = '{352FFBA8-0973-437C-A61F-F64CAFD81DF9}';
  IID_IUIAutomationElementArray: TGUID = '{14314595-B4BC-4055-95F2-58F2E42C9855}';
  IID_IUIAutomationCacheRequest: TGUID = '{B32A92B5-BC25-4078-9C08-D7EE95C48E03}';
  IID_IUIAutomationBoolCondition: TGUID = '{1B4E1F2E-75EB-4D0B-8952-5A69988E2307}';
  IID_IUIAutomationPropertyCondition: TGUID = '{99EBF2CB-5578-4267-9AD4-AFD6EA77E94B}';
  IID_IUIAutomationAndCondition: TGUID = '{A7D0AF36-B912-45FE-9855-091DDC174AEC}';
  IID_IUIAutomationOrCondition: TGUID = '{8753F032-3DB1-47B5-A1FC-6E34A266C712}';
  IID_IUIAutomationNotCondition: TGUID = '{F528B657-847B-498C-8896-D52B565407A1}';
  IID_IUIAutomationTreeWalker: TGUID = '{4042C624-389C-4AFC-A630-9DF854A541FC}';
  IID_IUIAutomationEventHandler: TGUID = '{146C3C17-F12E-4E22-8C27-F894B9B79C69}';
  IID_IUIAutomationPropertyChangedEventHandler: TGUID = '{40CD37D4-C756-4B0C-8C6F-BDDFEEB13B50}';
  IID_IUIAutomationStructureChangedEventHandler: TGUID = '{E81D1B4E-11C5-42F8-9754-E7036C79F054}';
  IID_IUIAutomationFocusChangedEventHandler: TGUID = '{C270F6B5-5C69-4290-9745-7A7F97169468}';
  IID_IUIAutomationTextEditTextChangedEventHandler: TGUID = '{92FAA680-E704-4156-931A-E32D5BB38F3F}';
  IID_IUIAutomationChangesEventHandler: TGUID = '{58EDCA55-2C3E-4980-B1B9-56C17F27A2A0}';
  IID_IUIAutomationNotificationEventHandler: TGUID = '{C7CB2637-E6C2-4D0C-85DE-4948C02175C7}';
  IID_IUIAutomationInvokePattern: TGUID = '{FB377FBE-8EA6-46D5-9C73-6499642D3059}';
  IID_IUIAutomationDockPattern: TGUID = '{FDE5EF97-1464-48F6-90BF-43D0948E86EC}';
  IID_IUIAutomationExpandCollapsePattern: TGUID = '{619BE086-1F4E-4EE4-BAFA-210128738730}';
  IID_IUIAutomationGridPattern: TGUID = '{414C3CDC-856B-4F5B-8538-3131C6302550}';
  IID_IUIAutomationGridItemPattern: TGUID = '{78F8EF57-66C3-4E09-BD7C-E79B2004894D}';
  IID_IUIAutomationMultipleViewPattern: TGUID = '{8D253C91-1DC5-4BB5-B18F-ADE16FA495E8}';
  IID_IUIAutomationObjectModelPattern: TGUID = '{71C284B3-C14D-4D14-981E-19751B0D756D}';
  IID_IUIAutomationRangeValuePattern: TGUID = '{59213F4F-7346-49E5-B120-80555987A148}';
  IID_IUIAutomationScrollPattern: TGUID = '{88F4D42A-E881-459D-A77C-73BBBB7E02DC}';
  IID_IUIAutomationScrollItemPattern: TGUID = '{B488300F-D015-4F19-9C29-BB595E3645EF}';
  IID_IUIAutomationSelectionPattern: TGUID = '{5ED5202E-B2AC-47A6-B638-4B0BF140D78E}';
  IID_IUIAutomationSelectionPattern2: TGUID = '{0532BFAE-C011-4E32-A343-6D642D798555}';
  IID_IUIAutomationSelectionItemPattern: TGUID = '{A8EFA66A-0FDA-421A-9194-38021F3578EA}';
  IID_IUIAutomationSynchronizedInputPattern: TGUID = '{2233BE0B-AFB7-448B-9FDA-3B378AA5EAE1}';
  IID_IUIAutomationTablePattern: TGUID = '{620E691C-EA96-4710-A850-754B24CE2417}';
  IID_IUIAutomationTableItemPattern: TGUID = '{0B964EB3-EF2E-4464-9C79-61D61737A27E}';
  IID_IUIAutomationTogglePattern: TGUID = '{94CF8058-9B8D-4AB9-8BFD-4CD0A33C8C70}';
  IID_IUIAutomationTransformPattern: TGUID = '{A9B55844-A55D-4EF0-926D-569C16FF89BB}';
  IID_IUIAutomationValuePattern: TGUID = '{A94CD8B1-0844-4CD6-9D2D-640537AB39E9}';
  IID_IUIAutomationWindowPattern: TGUID = '{0FAEF453-9208-43EF-BBB2-3B485177864F}';
  IID_IUIAutomationTextRange: TGUID = '{A543CC6A-F4AE-494B-8239-C814481187A8}';
  IID_IUIAutomationTextRange2: TGUID = '{BB9B40E0-5E04-46BD-9BE0-4B601B9AFAD4}';
  IID_IUIAutomationTextRange3: TGUID = '{6A315D69-5512-4C2E-85F0-53FCE6DD4BC2}';
  IID_IUIAutomationTextRangeArray: TGUID = '{CE4AE76A-E717-4C98-81EA-47371D028EB6}';
  IID_IUIAutomationTextPattern: TGUID = '{32EBA289-3583-42C9-9C59-3B6D9A1E9B6A}';
  IID_IUIAutomationTextPattern2: TGUID = '{506A921A-FCC9-409F-B23B-37EB74106872}';
  IID_IUIAutomationTextEditPattern: TGUID = '{17E21576-996C-4870-99D9-BFF323380C06}';
  IID_IUIAutomationCustomNavigationPattern: TGUID = '{01EA217A-1766-47ED-A6CC-ACF492854B1F}';
  IID_IUIAutomationActiveTextPositionChangedEventHandler: TGUID = '{F97933B0-8DAE-4496-8997-5BA015FE0D82}';
  IID_IUIAutomationLegacyIAccessiblePattern: TGUID = '{828055AD-355B-4435-86D5-3B51C14A9B1B}';
  IID_IAccessible: TGUID = '{618736E0-3C3D-11CF-810C-00AA00389B71}';
  IID_IUIAutomationItemContainerPattern: TGUID = '{C690FDB2-27A8-423C-812D-429773C9084E}';
  IID_IUIAutomationVirtualizedItemPattern: TGUID = '{6BA3D7A6-04CF-4F11-8793-A8D1CDE9969F}';
  IID_IUIAutomationAnnotationPattern: TGUID = '{9A175B21-339E-41B1-8E8B-623F6B681098}';
  IID_IUIAutomationStylesPattern: TGUID = '{85B5F0A2-BD79-484A-AD2B-388C9838D5FB}';
  IID_IUIAutomationSpreadsheetPattern: TGUID = '{7517A7C8-FAAE-4DE9-9F08-29B91E8595C1}';
  IID_IUIAutomationSpreadsheetItemPattern: TGUID = '{7D4FB86C-8D34-40E1-8E83-62C15204E335}';
  IID_IUIAutomationTransformPattern2: TGUID = '{6D74D017-6ECB-4381-B38B-3C17A48FF1C2}';
  IID_IUIAutomationTextChildPattern: TGUID = '{6552B038-AE05-40C8-ABFD-AA08352AAB86}';
  IID_IUIAutomationDragPattern: TGUID = '{1DC7B570-1F54-4BAD-BCDA-D36A722FB7BD}';
  IID_IUIAutomationDropTargetPattern: TGUID = '{69A095F7-EEE4-430E-A46B-FB73B1AE39A5}';
  IID_IUIAutomationElement2: TGUID = '{6749C683-F70D-4487-A698-5F79D55290D6}';
  IID_IUIAutomationElement3: TGUID = '{8471DF34-AEE0-4A01-A7DE-7DB9AF12C296}';
  IID_IUIAutomationElement4: TGUID = '{3B6E233C-52FB-4063-A4C9-77C075C2A06B}';
  IID_IUIAutomationElement5: TGUID = '{98141C1D-0D0E-4175-BBE2-6BFF455842A7}';
  IID_IUIAutomationElement6: TGUID = '{4780D450-8BCA-4977-AFA5-A4A517F555E3}';
  IID_IUIAutomationElement7: TGUID = '{204E8572-CFC3-4C11-B0C8-7DA7420750B7}';
  IID_IUIAutomationElement8: TGUID = '{8C60217D-5411-4CDE-BCC0-1CEDA223830C}';
  IID_IUIAutomationElement9: TGUID = '{39325FAC-039D-440E-A3A3-5EB81A5CECC3}';
  IID_IUIAutomationProxyFactory: TGUID = '{85B94ECD-849D-42B6-B94D-D6DB23FDF5A4}';
  IID_IRawElementProviderSimple: TGUID = '{D6DD68D1-86FD-4332-8666-9ABEDEA2D24C}';
  IID_IUIAutomationProxyFactoryEntry: TGUID = '{D50E472E-B64B-490C-BCA1-D30696F9F289}';
  IID_IUIAutomationProxyFactoryMapping: TGUID = '{09E31E18-872D-4873-93D1-1E541EC133FD}';
  IID_IUIAutomationEventHandlerGroup: TGUID = '{C9EE12F2-C13B-4408-997C-639914377F4E}';
  IID_IUIAutomation: TGUID = '{30CBE57D-D9D0-452A-AB13-7AC5AC4825EE}';
  IID_IUIAutomation2: TGUID = '{34723AFF-0C9D-49D0-9896-7AB52DF8CD8A}';
  IID_IUIAutomation3: TGUID = '{73D768DA-9B51-4B89-936E-C209290973E7}';
  IID_IUIAutomation4: TGUID = '{1189C02A-05F8-4319-8E21-E817E3DB2860}';
  IID_IUIAutomation5: TGUID = '{25F700C8-D816-4057-A9DC-3CBDEE77E256}';
  IID_IUIAutomation6: TGUID = '{AAE072DA-29E3-413D-87A7-192DBF81ED10}';
  CLASS_CUIAutomation: TGUID = '{FF48DBA4-60EF-4201-AA87-54103EEF594E}';
  CLASS_CUIAutomation8: TGUID = '{E22AD333-B25F-460C-83D0-0581107395C9}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library
// *********************************************************************//
// Constants for enum TreeScope
type
  TreeScope = TOleEnum;
const
  TreeScope_None = $00000000;
  TreeScope_Element = $00000001;
  TreeScope_Children = $00000002;
  TreeScope_Descendants = $00000004;
  TreeScope_Parent = $00000008;
  TreeScope_Ancestors = $00000010;
  TreeScope_Subtree = $00000007;

// Constants for enum AutomationElementMode
type
  AutomationElementMode = TOleEnum;
const
  AutomationElementMode_None = $00000000;
  AutomationElementMode_Full = $00000001;

// Constants for enum OrientationType
type
  OrientationType = TOleEnum;
const
  OrientationType_None = $00000000;
  OrientationType_Horizontal = $00000001;
  OrientationType_Vertical = $00000002;

// Constants for enum PropertyConditionFlags
type
  PropertyConditionFlags = TOleEnum;
const
  PropertyConditionFlags_None = $00000000;
  PropertyConditionFlags_IgnoreCase = $00000001;
  PropertyConditionFlags_MatchSubstring = $00000002;

// Constants for enum StructureChangeType
type
  StructureChangeType = TOleEnum;
const
  StructureChangeType_ChildAdded = $00000000;
  StructureChangeType_ChildRemoved = $00000001;
  StructureChangeType_ChildrenInvalidated = $00000002;
  StructureChangeType_ChildrenBulkAdded = $00000003;
  StructureChangeType_ChildrenBulkRemoved = $00000004;
  StructureChangeType_ChildrenReordered = $00000005;

// Constants for enum TextEditChangeType
type
  TextEditChangeType = TOleEnum;
const
  TextEditChangeType_None = $00000000;
  TextEditChangeType_AutoCorrect = $00000001;
  TextEditChangeType_Composition = $00000002;
  TextEditChangeType_CompositionFinalized = $00000003;
  TextEditChangeType_AutoComplete = $00000004;

// Constants for enum NotificationKind
type
  NotificationKind = TOleEnum;
const
  NotificationKind_ItemAdded = $00000000;
  NotificationKind_ItemRemoved = $00000001;
  NotificationKind_ActionCompleted = $00000002;
  NotificationKind_ActionAborted = $00000003;
  NotificationKind_Other = $00000004;

// Constants for enum NotificationProcessing
type
  NotificationProcessing = TOleEnum;
const
  NotificationProcessing_ImportantAll = $00000000;
  NotificationProcessing_ImportantMostRecent = $00000001;
  NotificationProcessing_All = $00000002;
  NotificationProcessing_MostRecent = $00000003;
  NotificationProcessing_CurrentThenMostRecent = $00000004;

// Constants for enum DockPosition
type
  DockPosition = TOleEnum;
const
  DockPosition_Top = $00000000;
  DockPosition_Left = $00000001;
  DockPosition_Bottom = $00000002;
  DockPosition_Right = $00000003;
  DockPosition_Fill = $00000004;
  DockPosition_None = $00000005;

// Constants for enum ExpandCollapseState
type
  ExpandCollapseState = TOleEnum;
const
  ExpandCollapseState_Collapsed = $00000000;
  ExpandCollapseState_Expanded = $00000001;
  ExpandCollapseState_PartiallyExpanded = $00000002;
  ExpandCollapseState_LeafNode = $00000003;

// Constants for enum ScrollAmount
type
  ScrollAmount = TOleEnum;
const
  ScrollAmount_LargeDecrement = $00000000;
  ScrollAmount_SmallDecrement = $00000001;
  ScrollAmount_NoAmount = $00000002;
  ScrollAmount_LargeIncrement = $00000003;
  ScrollAmount_SmallIncrement = $00000004;

// Constants for enum SynchronizedInputType
type
  SynchronizedInputType = TOleEnum;
const
  SynchronizedInputType_KeyUp = $00000001;
  SynchronizedInputType_KeyDown = $00000002;
  SynchronizedInputType_LeftMouseUp = $00000004;
  SynchronizedInputType_LeftMouseDown = $00000008;
  SynchronizedInputType_RightMouseUp = $00000010;
  SynchronizedInputType_RightMouseDown = $00000020;

// Constants for enum RowOrColumnMajor
type
  RowOrColumnMajor = TOleEnum;
const
  RowOrColumnMajor_RowMajor = $00000000;
  RowOrColumnMajor_ColumnMajor = $00000001;
  RowOrColumnMajor_Indeterminate = $00000002;

// Constants for enum ToggleState
type
  ToggleState = TOleEnum;
const
  ToggleState_Off = $00000000;
  ToggleState_On = $00000001;
  ToggleState_Indeterminate = $00000002;

// Constants for enum WindowVisualState
type
  WindowVisualState = TOleEnum;
const
  WindowVisualState_Normal = $00000000;
  WindowVisualState_Maximized = $00000001;
  WindowVisualState_Minimized = $00000002;

// Constants for enum WindowInteractionState
type
  WindowInteractionState = TOleEnum;
const
  WindowInteractionState_Running = $00000000;
  WindowInteractionState_Closing = $00000001;
  WindowInteractionState_ReadyForUserInteraction = $00000002;
  WindowInteractionState_BlockedByModalWindow = $00000003;
  WindowInteractionState_NotResponding = $00000004;

// Constants for enum TextPatternRangeEndpoint
type
  TextPatternRangeEndpoint = TOleEnum;
const
  TextPatternRangeEndpoint_Start = $00000000;
  TextPatternRangeEndpoint_End = $00000001;

// Constants for enum TextUnit
type
  TextUnit = TOleEnum;
const
  TextUnit_Character = $00000000;
  TextUnit_Format = $00000001;
  TextUnit_Word = $00000002;
  TextUnit_Line = $00000003;
  TextUnit_Paragraph = $00000004;
  TextUnit_Page = $00000005;
  TextUnit_Document = $00000006;

// Constants for enum SupportedTextSelection
type
  SupportedTextSelection = TOleEnum;
const
  SupportedTextSelection_None = $00000000;
  SupportedTextSelection_Single = $00000001;
  SupportedTextSelection_Multiple = $00000002;

// Constants for enum NavigateDirection
type
  NavigateDirection = TOleEnum;
const
  NavigateDirection_Parent = $00000000;
  NavigateDirection_NextSibling = $00000001;
  NavigateDirection_PreviousSibling = $00000002;
  NavigateDirection_FirstChild = $00000003;
  NavigateDirection_LastChild = $00000004;

// Constants for enum ZoomUnit
type
  ZoomUnit = TOleEnum;
const
  ZoomUnit_NoAmount = $00000000;
  ZoomUnit_LargeDecrement = $00000001;
  ZoomUnit_SmallDecrement = $00000002;
  ZoomUnit_LargeIncrement = $00000003;
  ZoomUnit_SmallIncrement = $00000004;

// Constants for enum LiveSetting
type
  LiveSetting = TOleEnum;
const
  Off = $00000000;
  Polite = $00000001;
  Assertive = $00000002;

// Constants for enum TreeTraversalOptions
type
  TreeTraversalOptions = TOleEnum;
const
  TreeTraversalOptions_Default = $00000000;
  TreeTraversalOptions_PostOrder = $00000001;
  TreeTraversalOptions_LastToFirstOrder = $00000002;

// Constants for enum ProviderOptions
type
  ProviderOptions = TOleEnum;
const
  ProviderOptions_ClientSideProvider = $00000001;
  ProviderOptions_ServerSideProvider = $00000002;
  ProviderOptions_NonClientAreaProvider = $00000004;
  ProviderOptions_OverrideProvider = $00000008;
  ProviderOptions_ProviderOwnsSetFocus = $00000010;
  ProviderOptions_UseComThreading = $00000020;
  ProviderOptions_RefuseNonClientSupport = $00000040;
  ProviderOptions_HasNativeIAccessible = $00000080;
  ProviderOptions_UseClientCoordinates = $00000100;

// Constants for enum ConnectionRecoveryBehaviorOptions
type
  ConnectionRecoveryBehaviorOptions = TOleEnum;
const
  ConnectionRecoveryBehaviorOptions_Disabled = $00000000;
  ConnectionRecoveryBehaviorOptions_Enabled = $00000001;

// Constants for enum CoalesceEventsOptions
type
  CoalesceEventsOptions = TOleEnum;
const
  CoalesceEventsOptions_Disabled = $00000000;
  CoalesceEventsOptions_Enabled = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IUIAutomationElement = interface;
  IUIAutomationCondition = interface;
  IUIAutomationElementArray = interface;
  IUIAutomationCacheRequest = interface;
  IUIAutomationBoolCondition = interface;
  IUIAutomationPropertyCondition = interface;
  IUIAutomationAndCondition = interface;
  IUIAutomationOrCondition = interface;
  IUIAutomationNotCondition = interface;
  IUIAutomationTreeWalker = interface;
  IUIAutomationEventHandler = interface;
  IUIAutomationPropertyChangedEventHandler = interface;
  IUIAutomationStructureChangedEventHandler = interface;
  IUIAutomationFocusChangedEventHandler = interface;
  IUIAutomationTextEditTextChangedEventHandler = interface;
  IUIAutomationChangesEventHandler = interface;
  IUIAutomationNotificationEventHandler = interface;
  IUIAutomationInvokePattern = interface;
  IUIAutomationDockPattern = interface;
  IUIAutomationExpandCollapsePattern = interface;
  IUIAutomationGridPattern = interface;
  IUIAutomationGridItemPattern = interface;
  IUIAutomationMultipleViewPattern = interface;
  IUIAutomationObjectModelPattern = interface;
  IUIAutomationRangeValuePattern = interface;
  IUIAutomationScrollPattern = interface;
  IUIAutomationScrollItemPattern = interface;
  IUIAutomationSelectionPattern = interface;
  IUIAutomationSelectionPattern2 = interface;
  IUIAutomationSelectionItemPattern = interface;
  IUIAutomationSynchronizedInputPattern = interface;
  IUIAutomationTablePattern = interface;
  IUIAutomationTableItemPattern = interface;
  IUIAutomationTogglePattern = interface;
  IUIAutomationTransformPattern = interface;
  IUIAutomationValuePattern = interface;
  IUIAutomationWindowPattern = interface;
  IUIAutomationTextRange = interface;
  IUIAutomationTextRange2 = interface;
  IUIAutomationTextRange3 = interface;
  IUIAutomationTextRangeArray = interface;
  IUIAutomationTextPattern = interface;
  IUIAutomationTextPattern2 = interface;
  IUIAutomationTextEditPattern = interface;
  IUIAutomationCustomNavigationPattern = interface;
  IUIAutomationActiveTextPositionChangedEventHandler = interface;
  IUIAutomationLegacyIAccessiblePattern = interface;
  IAccessible = interface;
  IAccessibleDisp = dispinterface;
  IUIAutomationItemContainerPattern = interface;
  IUIAutomationVirtualizedItemPattern = interface;
  IUIAutomationAnnotationPattern = interface;
  IUIAutomationStylesPattern = interface;
  IUIAutomationSpreadsheetPattern = interface;
  IUIAutomationSpreadsheetItemPattern = interface;
  IUIAutomationTransformPattern2 = interface;
  IUIAutomationTextChildPattern = interface;
  IUIAutomationDragPattern = interface;
  IUIAutomationDropTargetPattern = interface;
  IUIAutomationElement2 = interface;
  IUIAutomationElement3 = interface;
  IUIAutomationElement4 = interface;
  IUIAutomationElement5 = interface;
  IUIAutomationElement6 = interface;
  IUIAutomationElement7 = interface;
  IUIAutomationElement8 = interface;
  IUIAutomationElement9 = interface;
  IUIAutomationProxyFactory = interface;
  IRawElementProviderSimple = interface;
  IUIAutomationProxyFactoryEntry = interface;
  IUIAutomationProxyFactoryMapping = interface;
  IUIAutomationEventHandlerGroup = interface;
  IUIAutomation = interface;
  IUIAutomation2 = interface;
  IUIAutomation3 = interface;
  IUIAutomation4 = interface;
  IUIAutomation5 = interface;
  IUIAutomation6 = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  CUIAutomation = IUIAutomation;
  CUIAutomation8 = IUIAutomation2;


// *********************************************************************//
// Declaration of structures, unions and aliases.
// *********************************************************************//
  PUserType1 = ^TGUID; {*}
  PPUserType1 = ^IUIAutomationCondition; {*}
  PUserType2 = ^UiaChangeInfo; {*}
  PSYSINT1 = ^SYSINT; {*}
  PUserType3 = ^ExtendedProperty; {*}
  PUserType4 = ^tagRECT; {*}

  tagRECT = record
    left: Integer;
    top: Integer;
    right: Integer;
    bottom: Integer;
  end;

  tagPOINT = record
    x: Integer;
    y: Integer;
  end;

{$ALIGN 8}
  UiaChangeInfo = record
    uiaId: SYSINT;
    payload: OleVariant;
    extraInfo: OleVariant;
  end;

{$ALIGN 4}
  ExtendedProperty = record
    PropertyName: WideString;
    PropertyValue: WideString;
  end;


// *********************************************************************//
// Interface: IUIAutomationElement
// Flags:     (0)
// GUID:      {D22108AA-8AC5-49A5-837B-37BBB3D7591E}
// *********************************************************************//
  IUIAutomationElement = interface(IUnknown)
    ['{D22108AA-8AC5-49A5-837B-37BBB3D7591E}']
    function SetFocus: HResult; stdcall;
    function GetRuntimeId(out runtimeId: PSafeArray): HResult; stdcall;
    function FindFirst(scope: TreeScope; const condition: IUIAutomationCondition;
                       out found: IUIAutomationElement): HResult; stdcall;
    function FindAll(scope: TreeScope; const condition: IUIAutomationCondition;
                     out found: IUIAutomationElementArray): HResult; stdcall;
    function FindFirstBuildCache(scope: TreeScope; const condition: IUIAutomationCondition;
                                 const cacheRequest: IUIAutomationCacheRequest;
                                 out found: IUIAutomationElement): HResult; stdcall;
    function FindAllBuildCache(scope: TreeScope; const condition: IUIAutomationCondition;
                               const cacheRequest: IUIAutomationCacheRequest;
                               out found: IUIAutomationElementArray): HResult; stdcall;
    function BuildUpdatedCache(const cacheRequest: IUIAutomationCacheRequest;
                               out updatedElement: IUIAutomationElement): HResult; stdcall;
    function GetCurrentPropertyValue(propertyId: SYSINT; out retVal: OleVariant): HResult; stdcall;
    function GetCurrentPropertyValueEx(propertyId: SYSINT; ignoreDefaultValue: Integer;
                                       out retVal: OleVariant): HResult; stdcall;
    function GetCachedPropertyValue(propertyId: SYSINT; out retVal: OleVariant): HResult; stdcall;
    function GetCachedPropertyValueEx(propertyId: SYSINT; ignoreDefaultValue: Integer;
                                      out retVal: OleVariant): HResult; stdcall;
    function GetCurrentPatternAs(patternId: SYSINT; var riid: TGUID; out patternObject: Pointer): HResult; stdcall;
    function GetCachedPatternAs(patternId: SYSINT; var riid: TGUID; out patternObject: Pointer): HResult; stdcall;
    function GetCurrentPattern(patternId: SYSINT; out patternObject: IUnknown): HResult; stdcall;
    function GetCachedPattern(patternId: SYSINT; out patternObject: IUnknown): HResult; stdcall;
    function GetCachedParent(out parent: IUIAutomationElement): HResult; stdcall;
    function GetCachedChildren(out children: IUIAutomationElementArray): HResult; stdcall;
    function Get_CurrentProcessId(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentControlType(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentLocalizedControlType(out retVal: WideString): HResult; stdcall;
    function Get_CurrentName(out retVal: WideString): HResult; stdcall;
    function Get_CurrentAcceleratorKey(out retVal: WideString): HResult; stdcall;
    function Get_CurrentAccessKey(out retVal: WideString): HResult; stdcall;
    function Get_CurrentHasKeyboardFocus(out retVal: Integer): HResult; stdcall;
    function Get_CurrentIsKeyboardFocusable(out retVal: Integer): HResult; stdcall;
    function Get_CurrentIsEnabled(out retVal: Integer): HResult; stdcall;
    function Get_CurrentAutomationId(out retVal: WideString): HResult; stdcall;
    function Get_CurrentClassName(out retVal: WideString): HResult; stdcall;
    function Get_CurrentHelpText(out retVal: WideString): HResult; stdcall;
    function Get_CurrentCulture(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentIsControlElement(out retVal: Integer): HResult; stdcall;
    function Get_CurrentIsContentElement(out retVal: Integer): HResult; stdcall;
    function Get_CurrentIsPassword(out retVal: Integer): HResult; stdcall;
    function Get_CurrentNativeWindowHandle(out retVal: Pointer): HResult; stdcall;
    function Get_CurrentItemType(out retVal: WideString): HResult; stdcall;
    function Get_CurrentIsOffscreen(out retVal: Integer): HResult; stdcall;
    function Get_CurrentOrientation(out retVal: OrientationType): HResult; stdcall;
    function Get_CurrentFrameworkId(out retVal: WideString): HResult; stdcall;
    function Get_CurrentIsRequiredForForm(out retVal: Integer): HResult; stdcall;
    function Get_CurrentItemStatus(out retVal: WideString): HResult; stdcall;
    function Get_CurrentBoundingRectangle(out retVal: tagRECT): HResult; stdcall;
    function Get_CurrentLabeledBy(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CurrentAriaRole(out retVal: WideString): HResult; stdcall;
    function Get_CurrentAriaProperties(out retVal: WideString): HResult; stdcall;
    function Get_CurrentIsDataValidForForm(out retVal: Integer): HResult; stdcall;
    function Get_CurrentControllerFor(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CurrentDescribedBy(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CurrentFlowsTo(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CurrentProviderDescription(out retVal: WideString): HResult; stdcall;
    function Get_CachedProcessId(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedControlType(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedLocalizedControlType(out retVal: WideString): HResult; stdcall;
    function Get_CachedName(out retVal: WideString): HResult; stdcall;
    function Get_CachedAcceleratorKey(out retVal: WideString): HResult; stdcall;
    function Get_CachedAccessKey(out retVal: WideString): HResult; stdcall;
    function Get_CachedHasKeyboardFocus(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsKeyboardFocusable(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsEnabled(out retVal: Integer): HResult; stdcall;
    function Get_CachedAutomationId(out retVal: WideString): HResult; stdcall;
    function Get_CachedClassName(out retVal: WideString): HResult; stdcall;
    function Get_CachedHelpText(out retVal: WideString): HResult; stdcall;
    function Get_CachedCulture(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedIsControlElement(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsContentElement(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsPassword(out retVal: Integer): HResult; stdcall;
    function Get_CachedNativeWindowHandle(out retVal: Pointer): HResult; stdcall;
    function Get_CachedItemType(out retVal: WideString): HResult; stdcall;
    function Get_CachedIsOffscreen(out retVal: Integer): HResult; stdcall;
    function Get_CachedOrientation(out retVal: OrientationType): HResult; stdcall;
    function Get_CachedFrameworkId(out retVal: WideString): HResult; stdcall;
    function Get_CachedIsRequiredForForm(out retVal: Integer): HResult; stdcall;
    function Get_CachedItemStatus(out retVal: WideString): HResult; stdcall;
    function Get_CachedBoundingRectangle(out retVal: tagRECT): HResult; stdcall;
    function Get_CachedLabeledBy(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CachedAriaRole(out retVal: WideString): HResult; stdcall;
    function Get_CachedAriaProperties(out retVal: WideString): HResult; stdcall;
    function Get_CachedIsDataValidForForm(out retVal: Integer): HResult; stdcall;
    function Get_CachedControllerFor(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedDescribedBy(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedFlowsTo(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedProviderDescription(out retVal: WideString): HResult; stdcall;
    function GetClickablePoint(out clickable: tagPOINT; out gotClickable: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationCondition
// Flags:     (0)
// GUID:      {352FFBA8-0973-437C-A61F-F64CAFD81DF9}
// *********************************************************************//
  IUIAutomationCondition = interface(IUnknown)
    ['{352FFBA8-0973-437C-A61F-F64CAFD81DF9}']
  end;

// *********************************************************************//
// Interface: IUIAutomationElementArray
// Flags:     (0)
// GUID:      {14314595-B4BC-4055-95F2-58F2E42C9855}
// *********************************************************************//
  IUIAutomationElementArray = interface(IUnknown)
    ['{14314595-B4BC-4055-95F2-58F2E42C9855}']
    function Get_Length(out Length: SYSINT): HResult; stdcall;
    function GetElement(index: SYSINT; out element: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationCacheRequest
// Flags:     (0)
// GUID:      {B32A92B5-BC25-4078-9C08-D7EE95C48E03}
// *********************************************************************//
  IUIAutomationCacheRequest = interface(IUnknown)
    ['{B32A92B5-BC25-4078-9C08-D7EE95C48E03}']
    function AddProperty(propertyId: SYSINT): HResult; stdcall;
    function AddPattern(patternId: SYSINT): HResult; stdcall;
    function Clone(out clonedRequest: IUIAutomationCacheRequest): HResult; stdcall;
    function Get_TreeScope(out scope: TreeScope): HResult; stdcall;
    function Set_TreeScope(scope: TreeScope): HResult; stdcall;
    function Get_TreeFilter(out filter: IUIAutomationCondition): HResult; stdcall;
    function Set_TreeFilter(const filter: IUIAutomationCondition): HResult; stdcall;
    function Get_AutomationElementMode(out mode: AutomationElementMode): HResult; stdcall;
    function Set_AutomationElementMode(mode: AutomationElementMode): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationBoolCondition
// Flags:     (0)
// GUID:      {1B4E1F2E-75EB-4D0B-8952-5A69988E2307}
// *********************************************************************//
  IUIAutomationBoolCondition = interface(IUIAutomationCondition)
    ['{1B4E1F2E-75EB-4D0B-8952-5A69988E2307}']
    function Get_BooleanValue(out boolVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationPropertyCondition
// Flags:     (0)
// GUID:      {99EBF2CB-5578-4267-9AD4-AFD6EA77E94B}
// *********************************************************************//
  IUIAutomationPropertyCondition = interface(IUIAutomationCondition)
    ['{99EBF2CB-5578-4267-9AD4-AFD6EA77E94B}']
    function Get_propertyId(out propertyId: SYSINT): HResult; stdcall;
    function Get_PropertyValue(out PropertyValue: OleVariant): HResult; stdcall;
    function Get_PropertyConditionFlags(out flags: PropertyConditionFlags): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationAndCondition
// Flags:     (0)
// GUID:      {A7D0AF36-B912-45FE-9855-091DDC174AEC}
// *********************************************************************//
  IUIAutomationAndCondition = interface(IUIAutomationCondition)
    ['{A7D0AF36-B912-45FE-9855-091DDC174AEC}']
    function Get_ChildCount(out ChildCount: SYSINT): HResult; stdcall;
    function GetChildrenAsNativeArray(out childArray: PPUserType1; out childArrayCount: SYSINT): HResult; stdcall;
    function GetChildren(out childArray: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationOrCondition
// Flags:     (0)
// GUID:      {8753F032-3DB1-47B5-A1FC-6E34A266C712}
// *********************************************************************//
  IUIAutomationOrCondition = interface(IUIAutomationCondition)
    ['{8753F032-3DB1-47B5-A1FC-6E34A266C712}']
    function Get_ChildCount(out ChildCount: SYSINT): HResult; stdcall;
    function GetChildrenAsNativeArray(out childArray: PPUserType1; out childArrayCount: SYSINT): HResult; stdcall;
    function GetChildren(out childArray: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationNotCondition
// Flags:     (0)
// GUID:      {F528B657-847B-498C-8896-D52B565407A1}
// *********************************************************************//
  IUIAutomationNotCondition = interface(IUIAutomationCondition)
    ['{F528B657-847B-498C-8896-D52B565407A1}']
    function GetChild(out condition: IUIAutomationCondition): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTreeWalker
// Flags:     (0)
// GUID:      {4042C624-389C-4AFC-A630-9DF854A541FC}
// *********************************************************************//
  IUIAutomationTreeWalker = interface(IUnknown)
    ['{4042C624-389C-4AFC-A630-9DF854A541FC}']
    function GetParentElement(const element: IUIAutomationElement; out parent: IUIAutomationElement): HResult; stdcall;
    function GetFirstChildElement(const element: IUIAutomationElement;
                                  out first: IUIAutomationElement): HResult; stdcall;
    function GetLastChildElement(const element: IUIAutomationElement; out last: IUIAutomationElement): HResult; stdcall;
    function GetNextSiblingElement(const element: IUIAutomationElement;
                                   out next: IUIAutomationElement): HResult; stdcall;
    function GetPreviousSiblingElement(const element: IUIAutomationElement;
                                       out previous: IUIAutomationElement): HResult; stdcall;
    function NormalizeElement(const element: IUIAutomationElement;
                              out normalized: IUIAutomationElement): HResult; stdcall;
    function GetParentElementBuildCache(const element: IUIAutomationElement;
                                        const cacheRequest: IUIAutomationCacheRequest;
                                        out parent: IUIAutomationElement): HResult; stdcall;
    function GetFirstChildElementBuildCache(const element: IUIAutomationElement;
                                            const cacheRequest: IUIAutomationCacheRequest;
                                            out first: IUIAutomationElement): HResult; stdcall;
    function GetLastChildElementBuildCache(const element: IUIAutomationElement;
                                           const cacheRequest: IUIAutomationCacheRequest;
                                           out last: IUIAutomationElement): HResult; stdcall;
    function GetNextSiblingElementBuildCache(const element: IUIAutomationElement;
                                             const cacheRequest: IUIAutomationCacheRequest;
                                             out next: IUIAutomationElement): HResult; stdcall;
    function GetPreviousSiblingElementBuildCache(const element: IUIAutomationElement;
                                                 const cacheRequest: IUIAutomationCacheRequest;
                                                 out previous: IUIAutomationElement): HResult; stdcall;
    function NormalizeElementBuildCache(const element: IUIAutomationElement;
                                        const cacheRequest: IUIAutomationCacheRequest;
                                        out normalized: IUIAutomationElement): HResult; stdcall;
    function Get_condition(out condition: IUIAutomationCondition): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationEventHandler
// Flags:     (256) OleAutomation
// GUID:      {146C3C17-F12E-4E22-8C27-F894B9B79C69}
// *********************************************************************//
  IUIAutomationEventHandler = interface(IUnknown)
    ['{146C3C17-F12E-4E22-8C27-F894B9B79C69}']
    function HandleAutomationEvent(const sender: IUIAutomationElement; eventId: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationPropertyChangedEventHandler
// Flags:     (256) OleAutomation
// GUID:      {40CD37D4-C756-4B0C-8C6F-BDDFEEB13B50}
// *********************************************************************//
  IUIAutomationPropertyChangedEventHandler = interface(IUnknown)
    ['{40CD37D4-C756-4B0C-8C6F-BDDFEEB13B50}']
    function HandlePropertyChangedEvent(const sender: IUIAutomationElement; propertyId: SYSINT;
                                        newValue: OleVariant): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationStructureChangedEventHandler
// Flags:     (256) OleAutomation
// GUID:      {E81D1B4E-11C5-42F8-9754-E7036C79F054}
// *********************************************************************//
  IUIAutomationStructureChangedEventHandler = interface(IUnknown)
    ['{E81D1B4E-11C5-42F8-9754-E7036C79F054}']
    function HandleStructureChangedEvent(const sender: IUIAutomationElement;
                                         changeType: StructureChangeType; runtimeId: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationFocusChangedEventHandler
// Flags:     (256) OleAutomation
// GUID:      {C270F6B5-5C69-4290-9745-7A7F97169468}
// *********************************************************************//
  IUIAutomationFocusChangedEventHandler = interface(IUnknown)
    ['{C270F6B5-5C69-4290-9745-7A7F97169468}']
    function HandleFocusChangedEvent(const sender: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextEditTextChangedEventHandler
// Flags:     (256) OleAutomation
// GUID:      {92FAA680-E704-4156-931A-E32D5BB38F3F}
// *********************************************************************//
  IUIAutomationTextEditTextChangedEventHandler = interface(IUnknown)
    ['{92FAA680-E704-4156-931A-E32D5BB38F3F}']
    function HandleTextEditTextChangedEvent(const sender: IUIAutomationElement;
                                            TextEditChangeType: TextEditChangeType;
                                            eventStrings: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationChangesEventHandler
// Flags:     (256) OleAutomation
// GUID:      {58EDCA55-2C3E-4980-B1B9-56C17F27A2A0}
// *********************************************************************//
  IUIAutomationChangesEventHandler = interface(IUnknown)
    ['{58EDCA55-2C3E-4980-B1B9-56C17F27A2A0}']
    function HandleChangesEvent(const sender: IUIAutomationElement; var uiaChanges: UiaChangeInfo;
                                changesCount: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationNotificationEventHandler
// Flags:     (256) OleAutomation
// GUID:      {C7CB2637-E6C2-4D0C-85DE-4948C02175C7}
// *********************************************************************//
  IUIAutomationNotificationEventHandler = interface(IUnknown)
    ['{C7CB2637-E6C2-4D0C-85DE-4948C02175C7}']
    function HandleNotificationEvent(const sender: IUIAutomationElement;
                                     NotificationKind: NotificationKind;
                                     NotificationProcessing: NotificationProcessing;
                                     const displayString: WideString; const activityId: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationInvokePattern
// Flags:     (0)
// GUID:      {FB377FBE-8EA6-46D5-9C73-6499642D3059}
// *********************************************************************//
  IUIAutomationInvokePattern = interface(IUnknown)
    ['{FB377FBE-8EA6-46D5-9C73-6499642D3059}']
    function Invoke: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationDockPattern
// Flags:     (0)
// GUID:      {FDE5EF97-1464-48F6-90BF-43D0948E86EC}
// *********************************************************************//
  IUIAutomationDockPattern = interface(IUnknown)
    ['{FDE5EF97-1464-48F6-90BF-43D0948E86EC}']
    function SetDockPosition(dockPos: DockPosition): HResult; stdcall;
    function Get_CurrentDockPosition(out retVal: DockPosition): HResult; stdcall;
    function Get_CachedDockPosition(out retVal: DockPosition): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationExpandCollapsePattern
// Flags:     (0)
// GUID:      {619BE086-1F4E-4EE4-BAFA-210128738730}
// *********************************************************************//
  IUIAutomationExpandCollapsePattern = interface(IUnknown)
    ['{619BE086-1F4E-4EE4-BAFA-210128738730}']
    function Expand: HResult; stdcall;
    function Collapse: HResult; stdcall;
    function Get_CurrentExpandCollapseState(out retVal: ExpandCollapseState): HResult; stdcall;
    function Get_CachedExpandCollapseState(out retVal: ExpandCollapseState): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationGridPattern
// Flags:     (0)
// GUID:      {414C3CDC-856B-4F5B-8538-3131C6302550}
// *********************************************************************//
  IUIAutomationGridPattern = interface(IUnknown)
    ['{414C3CDC-856B-4F5B-8538-3131C6302550}']
    function GetItem(row: SYSINT; column: SYSINT; out element: IUIAutomationElement): HResult; stdcall;
    function Get_CurrentRowCount(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentColumnCount(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedRowCount(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedColumnCount(out retVal: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationGridItemPattern
// Flags:     (0)
// GUID:      {78F8EF57-66C3-4E09-BD7C-E79B2004894D}
// *********************************************************************//
  IUIAutomationGridItemPattern = interface(IUnknown)
    ['{78F8EF57-66C3-4E09-BD7C-E79B2004894D}']
    function Get_CurrentContainingGrid(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CurrentRow(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentColumn(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentRowSpan(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentColumnSpan(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedContainingGrid(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CachedRow(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedColumn(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedRowSpan(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedColumnSpan(out retVal: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationMultipleViewPattern
// Flags:     (0)
// GUID:      {8D253C91-1DC5-4BB5-B18F-ADE16FA495E8}
// *********************************************************************//
  IUIAutomationMultipleViewPattern = interface(IUnknown)
    ['{8D253C91-1DC5-4BB5-B18F-ADE16FA495E8}']
    function GetViewName(view: SYSINT; out name: WideString): HResult; stdcall;
    function SetCurrentView(view: SYSINT): HResult; stdcall;
    function Get_CurrentCurrentView(out retVal: SYSINT): HResult; stdcall;
    function GetCurrentSupportedViews(out retVal: PSafeArray): HResult; stdcall;
    function Get_CachedCurrentView(out retVal: SYSINT): HResult; stdcall;
    function GetCachedSupportedViews(out retVal: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationObjectModelPattern
// Flags:     (0)
// GUID:      {71C284B3-C14D-4D14-981E-19751B0D756D}
// *********************************************************************//
  IUIAutomationObjectModelPattern = interface(IUnknown)
    ['{71C284B3-C14D-4D14-981E-19751B0D756D}']
    function GetUnderlyingObjectModel(out retVal: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationRangeValuePattern
// Flags:     (0)
// GUID:      {59213F4F-7346-49E5-B120-80555987A148}
// *********************************************************************//
  IUIAutomationRangeValuePattern = interface(IUnknown)
    ['{59213F4F-7346-49E5-B120-80555987A148}']
    function SetValue(val: Double): HResult; stdcall;
    function Get_CurrentValue(out retVal: Double): HResult; stdcall;
    function Get_CurrentIsReadOnly(out retVal: Integer): HResult; stdcall;
    function Get_CurrentMaximum(out retVal: Double): HResult; stdcall;
    function Get_CurrentMinimum(out retVal: Double): HResult; stdcall;
    function Get_CurrentLargeChange(out retVal: Double): HResult; stdcall;
    function Get_CurrentSmallChange(out retVal: Double): HResult; stdcall;
    function Get_CachedValue(out retVal: Double): HResult; stdcall;
    function Get_CachedIsReadOnly(out retVal: Integer): HResult; stdcall;
    function Get_CachedMaximum(out retVal: Double): HResult; stdcall;
    function Get_CachedMinimum(out retVal: Double): HResult; stdcall;
    function Get_CachedLargeChange(out retVal: Double): HResult; stdcall;
    function Get_CachedSmallChange(out retVal: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationScrollPattern
// Flags:     (0)
// GUID:      {88F4D42A-E881-459D-A77C-73BBBB7E02DC}
// *********************************************************************//
  IUIAutomationScrollPattern = interface(IUnknown)
    ['{88F4D42A-E881-459D-A77C-73BBBB7E02DC}']
    function Scroll(horizontalAmount: ScrollAmount; verticalAmount: ScrollAmount): HResult; stdcall;
    function SetScrollPercent(horizontalPercent: Double; verticalPercent: Double): HResult; stdcall;
    function Get_CurrentHorizontalScrollPercent(out retVal: Double): HResult; stdcall;
    function Get_CurrentVerticalScrollPercent(out retVal: Double): HResult; stdcall;
    function Get_CurrentHorizontalViewSize(out retVal: Double): HResult; stdcall;
    function Get_CurrentVerticalViewSize(out retVal: Double): HResult; stdcall;
    function Get_CurrentHorizontallyScrollable(out retVal: Integer): HResult; stdcall;
    function Get_CurrentVerticallyScrollable(out retVal: Integer): HResult; stdcall;
    function Get_CachedHorizontalScrollPercent(out retVal: Double): HResult; stdcall;
    function Get_CachedVerticalScrollPercent(out retVal: Double): HResult; stdcall;
    function Get_CachedHorizontalViewSize(out retVal: Double): HResult; stdcall;
    function Get_CachedVerticalViewSize(out retVal: Double): HResult; stdcall;
    function Get_CachedHorizontallyScrollable(out retVal: Integer): HResult; stdcall;
    function Get_CachedVerticallyScrollable(out retVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationScrollItemPattern
// Flags:     (0)
// GUID:      {B488300F-D015-4F19-9C29-BB595E3645EF}
// *********************************************************************//
  IUIAutomationScrollItemPattern = interface(IUnknown)
    ['{B488300F-D015-4F19-9C29-BB595E3645EF}']
    function ScrollIntoView: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationSelectionPattern
// Flags:     (0)
// GUID:      {5ED5202E-B2AC-47A6-B638-4B0BF140D78E}
// *********************************************************************//
  IUIAutomationSelectionPattern = interface(IUnknown)
    ['{5ED5202E-B2AC-47A6-B638-4B0BF140D78E}']
    function GetCurrentSelection(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CurrentCanSelectMultiple(out retVal: Integer): HResult; stdcall;
    function Get_CurrentIsSelectionRequired(out retVal: Integer): HResult; stdcall;
    function GetCachedSelection(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedCanSelectMultiple(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsSelectionRequired(out retVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationSelectionPattern2
// Flags:     (0)
// GUID:      {0532BFAE-C011-4E32-A343-6D642D798555}
// *********************************************************************//
  IUIAutomationSelectionPattern2 = interface(IUIAutomationSelectionPattern)
    ['{0532BFAE-C011-4E32-A343-6D642D798555}']
    function Get_CurrentFirstSelectedItem(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CurrentLastSelectedItem(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CurrentCurrentSelectedItem(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CurrentItemCount(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedFirstSelectedItem(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CachedLastSelectedItem(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CachedCurrentSelectedItem(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CachedItemCount(out retVal: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationSelectionItemPattern
// Flags:     (0)
// GUID:      {A8EFA66A-0FDA-421A-9194-38021F3578EA}
// *********************************************************************//
  IUIAutomationSelectionItemPattern = interface(IUnknown)
    ['{A8EFA66A-0FDA-421A-9194-38021F3578EA}']
    function Select: HResult; stdcall;
    function AddToSelection: HResult; stdcall;
    function RemoveFromSelection: HResult; stdcall;
    function Get_CurrentIsSelected(out retVal: Integer): HResult; stdcall;
    function Get_CurrentSelectionContainer(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CachedIsSelected(out retVal: Integer): HResult; stdcall;
    function Get_CachedSelectionContainer(out retVal: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationSynchronizedInputPattern
// Flags:     (0)
// GUID:      {2233BE0B-AFB7-448B-9FDA-3B378AA5EAE1}
// *********************************************************************//
  IUIAutomationSynchronizedInputPattern = interface(IUnknown)
    ['{2233BE0B-AFB7-448B-9FDA-3B378AA5EAE1}']
    function StartListening(inputType: SynchronizedInputType): HResult; stdcall;
    function Cancel: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTablePattern
// Flags:     (0)
// GUID:      {620E691C-EA96-4710-A850-754B24CE2417}
// *********************************************************************//
  IUIAutomationTablePattern = interface(IUnknown)
    ['{620E691C-EA96-4710-A850-754B24CE2417}']
    function GetCurrentRowHeaders(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCurrentColumnHeaders(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CurrentRowOrColumnMajor(out retVal: RowOrColumnMajor): HResult; stdcall;
    function GetCachedRowHeaders(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCachedColumnHeaders(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedRowOrColumnMajor(out retVal: RowOrColumnMajor): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTableItemPattern
// Flags:     (0)
// GUID:      {0B964EB3-EF2E-4464-9C79-61D61737A27E}
// *********************************************************************//
  IUIAutomationTableItemPattern = interface(IUnknown)
    ['{0B964EB3-EF2E-4464-9C79-61D61737A27E}']
    function GetCurrentRowHeaderItems(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCurrentColumnHeaderItems(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCachedRowHeaderItems(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCachedColumnHeaderItems(out retVal: IUIAutomationElementArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTogglePattern
// Flags:     (0)
// GUID:      {94CF8058-9B8D-4AB9-8BFD-4CD0A33C8C70}
// *********************************************************************//
  IUIAutomationTogglePattern = interface(IUnknown)
    ['{94CF8058-9B8D-4AB9-8BFD-4CD0A33C8C70}']
    function Toggle: HResult; stdcall;
    function Get_CurrentToggleState(out retVal: ToggleState): HResult; stdcall;
    function Get_CachedToggleState(out retVal: ToggleState): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTransformPattern
// Flags:     (0)
// GUID:      {A9B55844-A55D-4EF0-926D-569C16FF89BB}
// *********************************************************************//
  IUIAutomationTransformPattern = interface(IUnknown)
    ['{A9B55844-A55D-4EF0-926D-569C16FF89BB}']
    function Move(x: Double; y: Double): HResult; stdcall;
    function Resize(width: Double; height: Double): HResult; stdcall;
    function Rotate(degrees: Double): HResult; stdcall;
    function Get_CurrentCanMove(out retVal: Integer): HResult; stdcall;
    function Get_CurrentCanResize(out retVal: Integer): HResult; stdcall;
    function Get_CurrentCanRotate(out retVal: Integer): HResult; stdcall;
    function Get_CachedCanMove(out retVal: Integer): HResult; stdcall;
    function Get_CachedCanResize(out retVal: Integer): HResult; stdcall;
    function Get_CachedCanRotate(out retVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationValuePattern
// Flags:     (0)
// GUID:      {A94CD8B1-0844-4CD6-9D2D-640537AB39E9}
// *********************************************************************//
  IUIAutomationValuePattern = interface(IUnknown)
    ['{A94CD8B1-0844-4CD6-9D2D-640537AB39E9}']
    function SetValue(const val: WideString): HResult; stdcall;
    function Get_CurrentValue(out retVal: WideString): HResult; stdcall;
    function Get_CurrentIsReadOnly(out retVal: Integer): HResult; stdcall;
    function Get_CachedValue(out retVal: WideString): HResult; stdcall;
    function Get_CachedIsReadOnly(out retVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationWindowPattern
// Flags:     (0)
// GUID:      {0FAEF453-9208-43EF-BBB2-3B485177864F}
// *********************************************************************//
  IUIAutomationWindowPattern = interface(IUnknown)
    ['{0FAEF453-9208-43EF-BBB2-3B485177864F}']
    function Close: HResult; stdcall;
    function WaitForInputIdle(milliseconds: SYSINT; out success: Integer): HResult; stdcall;
    function SetWindowVisualState(state: WindowVisualState): HResult; stdcall;
    function Get_CurrentCanMaximize(out retVal: Integer): HResult; stdcall;
    function Get_CurrentCanMinimize(out retVal: Integer): HResult; stdcall;
    function Get_CurrentIsModal(out retVal: Integer): HResult; stdcall;
    function Get_CurrentIsTopmost(out retVal: Integer): HResult; stdcall;
    function Get_CurrentWindowVisualState(out retVal: WindowVisualState): HResult; stdcall;
    function Get_CurrentWindowInteractionState(out retVal: WindowInteractionState): HResult; stdcall;
    function Get_CachedCanMaximize(out retVal: Integer): HResult; stdcall;
    function Get_CachedCanMinimize(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsModal(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsTopmost(out retVal: Integer): HResult; stdcall;
    function Get_CachedWindowVisualState(out retVal: WindowVisualState): HResult; stdcall;
    function Get_CachedWindowInteractionState(out retVal: WindowInteractionState): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextRange
// Flags:     (0)
// GUID:      {A543CC6A-F4AE-494B-8239-C814481187A8}
// *********************************************************************//
  IUIAutomationTextRange = interface(IUnknown)
    ['{A543CC6A-F4AE-494B-8239-C814481187A8}']
    function Clone(out clonedRange: IUIAutomationTextRange): HResult; stdcall;
    function Compare(const range: IUIAutomationTextRange; out areSame: Integer): HResult; stdcall;
    function CompareEndpoints(srcEndPoint: TextPatternRangeEndpoint;
                              const range: IUIAutomationTextRange;
                              targetEndPoint: TextPatternRangeEndpoint; out compValue: SYSINT): HResult; stdcall;
    function ExpandToEnclosingUnit(TextUnit: TextUnit): HResult; stdcall;
    function FindAttribute(attr: SYSINT; val: OleVariant; backward: Integer;
                           out found: IUIAutomationTextRange): HResult; stdcall;
    function FindText(const text: WideString; backward: Integer; ignoreCase: Integer;
                      out found: IUIAutomationTextRange): HResult; stdcall;
    function GetAttributeValue(attr: SYSINT; out value: OleVariant): HResult; stdcall;
    function GetBoundingRectangles(out boundingRects: PSafeArray): HResult; stdcall;
    function GetEnclosingElement(out enclosingElement: IUIAutomationElement): HResult; stdcall;
    function GetText(maxLength: SYSINT; out text: WideString): HResult; stdcall;
    function Move(unit_: TextUnit; count: SYSINT; out moved: SYSINT): HResult; stdcall;
    function MoveEndpointByUnit(endpoint: TextPatternRangeEndpoint; unit_: TextUnit; count: SYSINT;
                                out moved: SYSINT): HResult; stdcall;
    function MoveEndpointByRange(srcEndPoint: TextPatternRangeEndpoint;
                                 const range: IUIAutomationTextRange;
                                 targetEndPoint: TextPatternRangeEndpoint): HResult; stdcall;
    function Select: HResult; stdcall;
    function AddToSelection: HResult; stdcall;
    function RemoveFromSelection: HResult; stdcall;
    function ScrollIntoView(alignToTop: Integer): HResult; stdcall;
    function GetChildren(out children: IUIAutomationElementArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextRange2
// Flags:     (0)
// GUID:      {BB9B40E0-5E04-46BD-9BE0-4B601B9AFAD4}
// *********************************************************************//
  IUIAutomationTextRange2 = interface(IUIAutomationTextRange)
    ['{BB9B40E0-5E04-46BD-9BE0-4B601B9AFAD4}']
    function ShowContextMenu: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextRange3
// Flags:     (0)
// GUID:      {6A315D69-5512-4C2E-85F0-53FCE6DD4BC2}
// *********************************************************************//
  IUIAutomationTextRange3 = interface(IUIAutomationTextRange2)
    ['{6A315D69-5512-4C2E-85F0-53FCE6DD4BC2}']
    function GetEnclosingElementBuildCache(const cacheRequest: IUIAutomationCacheRequest;
                                           out enclosingElement: IUIAutomationElement): HResult; stdcall;
    function GetChildrenBuildCache(const cacheRequest: IUIAutomationCacheRequest;
                                   out children: IUIAutomationElementArray): HResult; stdcall;
    function GetAttributeValues(var attributeIds: SYSINT; attributeIdCount: SYSINT;
                                out attributeValues: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextRangeArray
// Flags:     (0)
// GUID:      {CE4AE76A-E717-4C98-81EA-47371D028EB6}
// *********************************************************************//
  IUIAutomationTextRangeArray = interface(IUnknown)
    ['{CE4AE76A-E717-4C98-81EA-47371D028EB6}']
    function Get_Length(out Length: SYSINT): HResult; stdcall;
    function GetElement(index: SYSINT; out element: IUIAutomationTextRange): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextPattern
// Flags:     (0)
// GUID:      {32EBA289-3583-42C9-9C59-3B6D9A1E9B6A}
// *********************************************************************//
  IUIAutomationTextPattern = interface(IUnknown)
    ['{32EBA289-3583-42C9-9C59-3B6D9A1E9B6A}']
    function RangeFromPoint(pt: tagPOINT; out range: IUIAutomationTextRange): HResult; stdcall;
    function RangeFromChild(const child: IUIAutomationElement; out range: IUIAutomationTextRange): HResult; stdcall;
    function GetSelection(out ranges: IUIAutomationTextRangeArray): HResult; stdcall;
    function GetVisibleRanges(out ranges: IUIAutomationTextRangeArray): HResult; stdcall;
    function Get_DocumentRange(out range: IUIAutomationTextRange): HResult; stdcall;
    function Get_SupportedTextSelection(out SupportedTextSelection: SupportedTextSelection): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextPattern2
// Flags:     (0)
// GUID:      {506A921A-FCC9-409F-B23B-37EB74106872}
// *********************************************************************//
  IUIAutomationTextPattern2 = interface(IUIAutomationTextPattern)
    ['{506A921A-FCC9-409F-B23B-37EB74106872}']
    function RangeFromAnnotation(const annotation: IUIAutomationElement;
                                 out range: IUIAutomationTextRange): HResult; stdcall;
    function GetCaretRange(out isActive: Integer; out range: IUIAutomationTextRange): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextEditPattern
// Flags:     (0)
// GUID:      {17E21576-996C-4870-99D9-BFF323380C06}
// *********************************************************************//
  IUIAutomationTextEditPattern = interface(IUIAutomationTextPattern)
    ['{17E21576-996C-4870-99D9-BFF323380C06}']
    function GetActiveComposition(out range: IUIAutomationTextRange): HResult; stdcall;
    function GetConversionTarget(out range: IUIAutomationTextRange): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationCustomNavigationPattern
// Flags:     (0)
// GUID:      {01EA217A-1766-47ED-A6CC-ACF492854B1F}
// *********************************************************************//
  IUIAutomationCustomNavigationPattern = interface(IUnknown)
    ['{01EA217A-1766-47ED-A6CC-ACF492854B1F}']
    function Navigate(direction: NavigateDirection; out pRetVal: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationActiveTextPositionChangedEventHandler
// Flags:     (256) OleAutomation
// GUID:      {F97933B0-8DAE-4496-8997-5BA015FE0D82}
// *********************************************************************//
  IUIAutomationActiveTextPositionChangedEventHandler = interface(IUnknown)
    ['{F97933B0-8DAE-4496-8997-5BA015FE0D82}']
    function HandleActiveTextPositionChangedEvent(const sender: IUIAutomationElement;
                                                  const range: IUIAutomationTextRange): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationLegacyIAccessiblePattern
// Flags:     (0)
// GUID:      {828055AD-355B-4435-86D5-3B51C14A9B1B}
// *********************************************************************//
  IUIAutomationLegacyIAccessiblePattern = interface(IUnknown)
    ['{828055AD-355B-4435-86D5-3B51C14A9B1B}']
    function Select(flagsSelect: Integer): HResult; stdcall;
    function DoDefaultAction: HResult; stdcall;
    function SetValue(szValue: PWideChar): HResult; stdcall;
    function Get_CurrentChildId(out pRetVal: SYSINT): HResult; stdcall;
    function Get_CurrentName(out pszName: WideString): HResult; stdcall;
    function Get_CurrentValue(out pszValue: WideString): HResult; stdcall;
    function Get_CurrentDescription(out pszDescription: WideString): HResult; stdcall;
    function Get_CurrentRole(out pdwRole: LongWord): HResult; stdcall;
    function Get_CurrentState(out pdwState: LongWord): HResult; stdcall;
    function Get_CurrentHelp(out pszHelp: WideString): HResult; stdcall;
    function Get_CurrentKeyboardShortcut(out pszKeyboardShortcut: WideString): HResult; stdcall;
    function GetCurrentSelection(out pvarSelectedChildren: IUIAutomationElementArray): HResult; stdcall;
    function Get_CurrentDefaultAction(out pszDefaultAction: WideString): HResult; stdcall;
    function Get_CachedChildId(out pRetVal: SYSINT): HResult; stdcall;
    function Get_CachedName(out pszName: WideString): HResult; stdcall;
    function Get_CachedValue(out pszValue: WideString): HResult; stdcall;
    function Get_CachedDescription(out pszDescription: WideString): HResult; stdcall;
    function Get_CachedRole(out pdwRole: LongWord): HResult; stdcall;
    function Get_CachedState(out pdwState: LongWord): HResult; stdcall;
    function Get_CachedHelp(out pszHelp: WideString): HResult; stdcall;
    function Get_CachedKeyboardShortcut(out pszKeyboardShortcut: WideString): HResult; stdcall;
    function GetCachedSelection(out pvarSelectedChildren: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedDefaultAction(out pszDefaultAction: WideString): HResult; stdcall;
    function GetIAccessible(out ppAccessible: IAccessible): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IAccessible
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {618736E0-3C3D-11CF-810C-00AA00389B71}
// *********************************************************************//
  IAccessible = interface(IDispatch)
    ['{618736E0-3C3D-11CF-810C-00AA00389B71}']
    function Get_accParent: IDispatch; safecall;
    function Get_accChildCount: Integer; safecall;
    function Get_accChild(varChild: OleVariant): IDispatch; safecall;
    function Get_accName(varChild: OleVariant): WideString; safecall;
    function Get_accValue(varChild: OleVariant): WideString; safecall;
    function Get_accDescription(varChild: OleVariant): WideString; safecall;
    function Get_accRole(varChild: OleVariant): OleVariant; safecall;
    function Get_accState(varChild: OleVariant): OleVariant; safecall;
    function Get_accHelp(varChild: OleVariant): WideString; safecall;
    function Get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant): Integer; safecall;
    function Get_accKeyboardShortcut(varChild: OleVariant): WideString; safecall;
    function Get_accFocus: OleVariant; safecall;
    function Get_accSelection: OleVariant; safecall;
    function Get_accDefaultAction(varChild: OleVariant): WideString; safecall;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); safecall;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                          out pcyHeight: Integer; varChild: OleVariant); safecall;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; safecall;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; safecall;
    procedure accDoDefaultAction(varChild: OleVariant); safecall;
    procedure Set_accName(varChild: OleVariant; const pszName: WideString); safecall;
    procedure Set_accValue(varChild: OleVariant; const pszValue: WideString); safecall;
    property accParent: IDispatch read Get_accParent;
    property accChildCount: Integer read Get_accChildCount;
    property accChild[varChild: OleVariant]: IDispatch read Get_accChild;
    property accName[varChild: OleVariant]: WideString read Get_accName write Set_accName;
    property accValue[varChild: OleVariant]: WideString read Get_accValue write Set_accValue;
    property accDescription[varChild: OleVariant]: WideString read Get_accDescription;
    property accRole[varChild: OleVariant]: OleVariant read Get_accRole;
    property accState[varChild: OleVariant]: OleVariant read Get_accState;
    property accHelp[varChild: OleVariant]: WideString read Get_accHelp;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer read Get_accHelpTopic;
    property accKeyboardShortcut[varChild: OleVariant]: WideString read Get_accKeyboardShortcut;
    property accFocus: OleVariant read Get_accFocus;
    property accSelection: OleVariant read Get_accSelection;
    property accDefaultAction[varChild: OleVariant]: WideString read Get_accDefaultAction;
  end;

// *********************************************************************//
// DispIntf:  IAccessibleDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {618736E0-3C3D-11CF-810C-00AA00389B71}
// *********************************************************************//
  IAccessibleDisp = dispinterface
    ['{618736E0-3C3D-11CF-810C-00AA00389B71}']
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: IUIAutomationItemContainerPattern
// Flags:     (0)
// GUID:      {C690FDB2-27A8-423C-812D-429773C9084E}
// *********************************************************************//
  IUIAutomationItemContainerPattern = interface(IUnknown)
    ['{C690FDB2-27A8-423C-812D-429773C9084E}']
    function FindItemByProperty(const pStartAfter: IUIAutomationElement; propertyId: SYSINT;
                                value: OleVariant; out pFound: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationVirtualizedItemPattern
// Flags:     (0)
// GUID:      {6BA3D7A6-04CF-4F11-8793-A8D1CDE9969F}
// *********************************************************************//
  IUIAutomationVirtualizedItemPattern = interface(IUnknown)
    ['{6BA3D7A6-04CF-4F11-8793-A8D1CDE9969F}']
    function Realize: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationAnnotationPattern
// Flags:     (0)
// GUID:      {9A175B21-339E-41B1-8E8B-623F6B681098}
// *********************************************************************//
  IUIAutomationAnnotationPattern = interface(IUnknown)
    ['{9A175B21-339E-41B1-8E8B-623F6B681098}']
    function Get_CurrentAnnotationTypeId(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentAnnotationTypeName(out retVal: WideString): HResult; stdcall;
    function Get_CurrentAuthor(out retVal: WideString): HResult; stdcall;
    function Get_CurrentDateTime(out retVal: WideString): HResult; stdcall;
    function Get_CurrentTarget(out retVal: IUIAutomationElement): HResult; stdcall;
    function Get_CachedAnnotationTypeId(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedAnnotationTypeName(out retVal: WideString): HResult; stdcall;
    function Get_CachedAuthor(out retVal: WideString): HResult; stdcall;
    function Get_CachedDateTime(out retVal: WideString): HResult; stdcall;
    function Get_CachedTarget(out retVal: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationStylesPattern
// Flags:     (0)
// GUID:      {85B5F0A2-BD79-484A-AD2B-388C9838D5FB}
// *********************************************************************//
  IUIAutomationStylesPattern = interface(IUnknown)
    ['{85B5F0A2-BD79-484A-AD2B-388C9838D5FB}']
    function Get_CurrentStyleId(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentStyleName(out retVal: WideString): HResult; stdcall;
    function Get_CurrentFillColor(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentFillPatternStyle(out retVal: WideString): HResult; stdcall;
    function Get_CurrentShape(out retVal: WideString): HResult; stdcall;
    function Get_CurrentFillPatternColor(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentExtendedProperties(out retVal: WideString): HResult; stdcall;
    function GetCurrentExtendedPropertiesAsArray(out propertyArray: PUserType3;
                                                 out propertyCount: SYSINT): HResult; stdcall;
    function Get_CachedStyleId(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedStyleName(out retVal: WideString): HResult; stdcall;
    function Get_CachedFillColor(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedFillPatternStyle(out retVal: WideString): HResult; stdcall;
    function Get_CachedShape(out retVal: WideString): HResult; stdcall;
    function Get_CachedFillPatternColor(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedExtendedProperties(out retVal: WideString): HResult; stdcall;
    function GetCachedExtendedPropertiesAsArray(out propertyArray: PUserType3;
                                                out propertyCount: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationSpreadsheetPattern
// Flags:     (0)
// GUID:      {7517A7C8-FAAE-4DE9-9F08-29B91E8595C1}
// *********************************************************************//
  IUIAutomationSpreadsheetPattern = interface(IUnknown)
    ['{7517A7C8-FAAE-4DE9-9F08-29B91E8595C1}']
    function GetItemByName(const name: WideString; out element: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationSpreadsheetItemPattern
// Flags:     (0)
// GUID:      {7D4FB86C-8D34-40E1-8E83-62C15204E335}
// *********************************************************************//
  IUIAutomationSpreadsheetItemPattern = interface(IUnknown)
    ['{7D4FB86C-8D34-40E1-8E83-62C15204E335}']
    function Get_CurrentFormula(out retVal: WideString): HResult; stdcall;
    function GetCurrentAnnotationObjects(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCurrentAnnotationTypes(out retVal: PSafeArray): HResult; stdcall;
    function Get_CachedFormula(out retVal: WideString): HResult; stdcall;
    function GetCachedAnnotationObjects(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCachedAnnotationTypes(out retVal: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTransformPattern2
// Flags:     (0)
// GUID:      {6D74D017-6ECB-4381-B38B-3C17A48FF1C2}
// *********************************************************************//
  IUIAutomationTransformPattern2 = interface(IUIAutomationTransformPattern)
    ['{6D74D017-6ECB-4381-B38B-3C17A48FF1C2}']
    function Zoom(zoomValue: Double): HResult; stdcall;
    function ZoomByUnit(ZoomUnit: ZoomUnit): HResult; stdcall;
    function Get_CurrentCanZoom(out retVal: Integer): HResult; stdcall;
    function Get_CachedCanZoom(out retVal: Integer): HResult; stdcall;
    function Get_CurrentZoomLevel(out retVal: Double): HResult; stdcall;
    function Get_CachedZoomLevel(out retVal: Double): HResult; stdcall;
    function Get_CurrentZoomMinimum(out retVal: Double): HResult; stdcall;
    function Get_CachedZoomMinimum(out retVal: Double): HResult; stdcall;
    function Get_CurrentZoomMaximum(out retVal: Double): HResult; stdcall;
    function Get_CachedZoomMaximum(out retVal: Double): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationTextChildPattern
// Flags:     (0)
// GUID:      {6552B038-AE05-40C8-ABFD-AA08352AAB86}
// *********************************************************************//
  IUIAutomationTextChildPattern = interface(IUnknown)
    ['{6552B038-AE05-40C8-ABFD-AA08352AAB86}']
    function Get_TextContainer(out container: IUIAutomationElement): HResult; stdcall;
    function Get_TextRange(out range: IUIAutomationTextRange): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationDragPattern
// Flags:     (0)
// GUID:      {1DC7B570-1F54-4BAD-BCDA-D36A722FB7BD}
// *********************************************************************//
  IUIAutomationDragPattern = interface(IUnknown)
    ['{1DC7B570-1F54-4BAD-BCDA-D36A722FB7BD}']
    function Get_CurrentIsGrabbed(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsGrabbed(out retVal: Integer): HResult; stdcall;
    function Get_CurrentDropEffect(out retVal: WideString): HResult; stdcall;
    function Get_CachedDropEffect(out retVal: WideString): HResult; stdcall;
    function Get_CurrentDropEffects(out retVal: PSafeArray): HResult; stdcall;
    function Get_CachedDropEffects(out retVal: PSafeArray): HResult; stdcall;
    function GetCurrentGrabbedItems(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function GetCachedGrabbedItems(out retVal: IUIAutomationElementArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationDropTargetPattern
// Flags:     (0)
// GUID:      {69A095F7-EEE4-430E-A46B-FB73B1AE39A5}
// *********************************************************************//
  IUIAutomationDropTargetPattern = interface(IUnknown)
    ['{69A095F7-EEE4-430E-A46B-FB73B1AE39A5}']
    function Get_CurrentDropTargetEffect(out retVal: WideString): HResult; stdcall;
    function Get_CachedDropTargetEffect(out retVal: WideString): HResult; stdcall;
    function Get_CurrentDropTargetEffects(out retVal: PSafeArray): HResult; stdcall;
    function Get_CachedDropTargetEffects(out retVal: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement2
// Flags:     (0)
// GUID:      {6749C683-F70D-4487-A698-5F79D55290D6}
// *********************************************************************//
  IUIAutomationElement2 = interface(IUIAutomationElement)
    ['{6749C683-F70D-4487-A698-5F79D55290D6}']
    function Get_CurrentOptimizeForVisualContent(out retVal: Integer): HResult; stdcall;
    function Get_CachedOptimizeForVisualContent(out retVal: Integer): HResult; stdcall;
    function Get_CurrentLiveSetting(out retVal: LiveSetting): HResult; stdcall;
    function Get_CachedLiveSetting(out retVal: LiveSetting): HResult; stdcall;
    function Get_CurrentFlowsFrom(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedFlowsFrom(out retVal: IUIAutomationElementArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement3
// Flags:     (0)
// GUID:      {8471DF34-AEE0-4A01-A7DE-7DB9AF12C296}
// *********************************************************************//
  IUIAutomationElement3 = interface(IUIAutomationElement2)
    ['{8471DF34-AEE0-4A01-A7DE-7DB9AF12C296}']
    function ShowContextMenu: HResult; stdcall;
    function Get_CurrentIsPeripheral(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsPeripheral(out retVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement4
// Flags:     (0)
// GUID:      {3B6E233C-52FB-4063-A4C9-77C075C2A06B}
// *********************************************************************//
  IUIAutomationElement4 = interface(IUIAutomationElement3)
    ['{3B6E233C-52FB-4063-A4C9-77C075C2A06B}']
    function Get_CurrentPositionInSet(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentSizeOfSet(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentLevel(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentAnnotationTypes(out retVal: PSafeArray): HResult; stdcall;
    function Get_CurrentAnnotationObjects(out retVal: IUIAutomationElementArray): HResult; stdcall;
    function Get_CachedPositionInSet(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedSizeOfSet(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedLevel(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedAnnotationTypes(out retVal: PSafeArray): HResult; stdcall;
    function Get_CachedAnnotationObjects(out retVal: IUIAutomationElementArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement5
// Flags:     (0)
// GUID:      {98141C1D-0D0E-4175-BBE2-6BFF455842A7}
// *********************************************************************//
  IUIAutomationElement5 = interface(IUIAutomationElement4)
    ['{98141C1D-0D0E-4175-BBE2-6BFF455842A7}']
    function Get_CurrentLandmarkType(out retVal: SYSINT): HResult; stdcall;
    function Get_CurrentLocalizedLandmarkType(out retVal: WideString): HResult; stdcall;
    function Get_CachedLandmarkType(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedLocalizedLandmarkType(out retVal: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement6
// Flags:     (0)
// GUID:      {4780D450-8BCA-4977-AFA5-A4A517F555E3}
// *********************************************************************//
  IUIAutomationElement6 = interface(IUIAutomationElement5)
    ['{4780D450-8BCA-4977-AFA5-A4A517F555E3}']
    function Get_CurrentFullDescription(out retVal: WideString): HResult; stdcall;
    function Get_CachedFullDescription(out retVal: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement7
// Flags:     (0)
// GUID:      {204E8572-CFC3-4C11-B0C8-7DA7420750B7}
// *********************************************************************//
  IUIAutomationElement7 = interface(IUIAutomationElement6)
    ['{204E8572-CFC3-4C11-B0C8-7DA7420750B7}']
    function FindFirstWithOptions(scope: TreeScope; const condition: IUIAutomationCondition;
                                  traversalOptions: TreeTraversalOptions;
                                  const root: IUIAutomationElement; out found: IUIAutomationElement): HResult; stdcall;
    function FindAllWithOptions(scope: TreeScope; const condition: IUIAutomationCondition;
                                traversalOptions: TreeTraversalOptions;
                                const root: IUIAutomationElement;
                                out found: IUIAutomationElementArray): HResult; stdcall;
    function FindFirstWithOptionsBuildCache(scope: TreeScope;
                                            const condition: IUIAutomationCondition;
                                            const cacheRequest: IUIAutomationCacheRequest;
                                            traversalOptions: TreeTraversalOptions;
                                            const root: IUIAutomationElement;
                                            out found: IUIAutomationElement): HResult; stdcall;
    function FindAllWithOptionsBuildCache(scope: TreeScope;
                                          const condition: IUIAutomationCondition;
                                          const cacheRequest: IUIAutomationCacheRequest;
                                          traversalOptions: TreeTraversalOptions;
                                          const root: IUIAutomationElement;
                                          out found: IUIAutomationElementArray): HResult; stdcall;
    function GetCurrentMetadataValue(targetId: SYSINT; metadataId: SYSINT; out returnVal: OleVariant): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement8
// Flags:     (0)
// GUID:      {8C60217D-5411-4CDE-BCC0-1CEDA223830C}
// *********************************************************************//
  IUIAutomationElement8 = interface(IUIAutomationElement7)
    ['{8C60217D-5411-4CDE-BCC0-1CEDA223830C}']
    function Get_CurrentHeadingLevel(out retVal: SYSINT): HResult; stdcall;
    function Get_CachedHeadingLevel(out retVal: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationElement9
// Flags:     (0)
// GUID:      {39325FAC-039D-440E-A3A3-5EB81A5CECC3}
// *********************************************************************//
  IUIAutomationElement9 = interface(IUIAutomationElement8)
    ['{39325FAC-039D-440E-A3A3-5EB81A5CECC3}']
    function Get_CurrentIsDialog(out retVal: Integer): HResult; stdcall;
    function Get_CachedIsDialog(out retVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationProxyFactory
// Flags:     (0)
// GUID:      {85B94ECD-849D-42B6-B94D-D6DB23FDF5A4}
// *********************************************************************//
  IUIAutomationProxyFactory = interface(IUnknown)
    ['{85B94ECD-849D-42B6-B94D-D6DB23FDF5A4}']
    function CreateProvider(hwnd: Pointer; idObject: Integer; idChild: Integer;
                            out provider: IRawElementProviderSimple): HResult; stdcall;
    function Get_ProxyFactoryId(out factoryId: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IRawElementProviderSimple
// Flags:     (256) OleAutomation
// GUID:      {D6DD68D1-86FD-4332-8666-9ABEDEA2D24C}
// *********************************************************************//
  IRawElementProviderSimple = interface(IUnknown)
    ['{D6DD68D1-86FD-4332-8666-9ABEDEA2D24C}']
    function Get_ProviderOptions(out pRetVal: ProviderOptions): HResult; stdcall;
    function GetPatternProvider(patternId: SYSINT; out pRetVal: IUnknown): HResult; stdcall;
    function GetPropertyValue(propertyId: SYSINT; out pRetVal: OleVariant): HResult; stdcall;
    function Get_HostRawElementProvider(out pRetVal: IRawElementProviderSimple): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationProxyFactoryEntry
// Flags:     (0)
// GUID:      {D50E472E-B64B-490C-BCA1-D30696F9F289}
// *********************************************************************//
  IUIAutomationProxyFactoryEntry = interface(IUnknown)
    ['{D50E472E-B64B-490C-BCA1-D30696F9F289}']
    function Get_ProxyFactory(out factory: IUIAutomationProxyFactory): HResult; stdcall;
    function Get__className(out ClassName: WideString): HResult; stdcall;
    function Get_ImageName(out ImageName: WideString): HResult; stdcall;
    function Get_AllowSubstringMatch(out AllowSubstringMatch: Integer): HResult; stdcall;
    function Get_CanCheckBaseClass(out CanCheckBaseClass: Integer): HResult; stdcall;
    function Get_NeedsAdviseEvents(out adviseEvents: Integer): HResult; stdcall;
    function Set__className(ClassName: PWideChar): HResult; stdcall;
    function Set_ImageName(ImageName: PWideChar): HResult; stdcall;
    function Set_AllowSubstringMatch(AllowSubstringMatch: Integer): HResult; stdcall;
    function Set_CanCheckBaseClass(CanCheckBaseClass: Integer): HResult; stdcall;
    function Set_NeedsAdviseEvents(adviseEvents: Integer): HResult; stdcall;
    function SetWinEventsForAutomationEvent(eventId: SYSINT; propertyId: SYSINT;
                                            winEvents: PSafeArray): HResult; stdcall;
    function GetWinEventsForAutomationEvent(eventId: SYSINT; propertyId: SYSINT;
                                            out winEvents: PSafeArray): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationProxyFactoryMapping
// Flags:     (0)
// GUID:      {09E31E18-872D-4873-93D1-1E541EC133FD}
// *********************************************************************//
  IUIAutomationProxyFactoryMapping = interface(IUnknown)
    ['{09E31E18-872D-4873-93D1-1E541EC133FD}']
    function Get_count(out count: SYSUINT): HResult; stdcall;
    function GetTable(out table: PSafeArray): HResult; stdcall;
    function GetEntry(index: SYSUINT; out entry: IUIAutomationProxyFactoryEntry): HResult; stdcall;
    function SetTable(factoryList: PSafeArray): HResult; stdcall;
    function InsertEntries(before: SYSUINT; factoryList: PSafeArray): HResult; stdcall;
    function InsertEntry(before: SYSUINT; const factory: IUIAutomationProxyFactoryEntry): HResult; stdcall;
    function RemoveEntry(index: SYSUINT): HResult; stdcall;
    function ClearTable: HResult; stdcall;
    function RestoreDefaultTable: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomationEventHandlerGroup
// Flags:     (0)
// GUID:      {C9EE12F2-C13B-4408-997C-639914377F4E}
// *********************************************************************//
  IUIAutomationEventHandlerGroup = interface(IUnknown)
    ['{C9EE12F2-C13B-4408-997C-639914377F4E}']
    function AddActiveTextPositionChangedEventHandler(scope: TreeScope;
                                                      const cacheRequest: IUIAutomationCacheRequest;
                                                      const handler: IUIAutomationActiveTextPositionChangedEventHandler): HResult; stdcall;
    function AddAutomationEventHandler(eventId: SYSINT; scope: TreeScope;
                                       const cacheRequest: IUIAutomationCacheRequest;
                                       const handler: IUIAutomationEventHandler): HResult; stdcall;
    function AddChangesEventHandler(scope: TreeScope; var changeTypes: SYSINT;
                                    changesCount: SYSINT;
                                    const cacheRequest: IUIAutomationCacheRequest;
                                    const handler: IUIAutomationChangesEventHandler): HResult; stdcall;
    function AddNotificationEventHandler(scope: TreeScope;
                                         const cacheRequest: IUIAutomationCacheRequest;
                                         const handler: IUIAutomationNotificationEventHandler): HResult; stdcall;
    function AddPropertyChangedEventHandler(scope: TreeScope;
                                            const cacheRequest: IUIAutomationCacheRequest;
                                            const handler: IUIAutomationPropertyChangedEventHandler;
                                            var propertyArray: SYSINT; propertyCount: SYSINT): HResult; stdcall;
    function AddStructureChangedEventHandler(scope: TreeScope;
                                             const cacheRequest: IUIAutomationCacheRequest;
                                             const handler: IUIAutomationStructureChangedEventHandler): HResult; stdcall;
    function AddTextEditTextChangedEventHandler(scope: TreeScope;
                                                TextEditChangeType: TextEditChangeType;
                                                const cacheRequest: IUIAutomationCacheRequest;
                                                const handler: IUIAutomationTextEditTextChangedEventHandler): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomation
// Flags:     (0)
// GUID:      {30CBE57D-D9D0-452A-AB13-7AC5AC4825EE}
// *********************************************************************//
  IUIAutomation = interface(IUnknown)
    ['{30CBE57D-D9D0-452A-AB13-7AC5AC4825EE}']
    function CompareElements(const el1: IUIAutomationElement; const el2: IUIAutomationElement;
                             out areSame: Integer): HResult; stdcall;
    function CompareRuntimeIds(runtimeId1: PSafeArray; runtimeId2: PSafeArray; out areSame: Integer): HResult; stdcall;
    function GetRootElement(out root: IUIAutomationElement): HResult; stdcall;
    function ElementFromHandle(hwnd: Pointer; out element: IUIAutomationElement): HResult; stdcall;
    function ElementFromPoint(pt: tagPOINT; out element: IUIAutomationElement): HResult; stdcall;
    function GetFocusedElement(out element: IUIAutomationElement): HResult; stdcall;
    function GetRootElementBuildCache(const cacheRequest: IUIAutomationCacheRequest;
                                      out root: IUIAutomationElement): HResult; stdcall;
    function ElementFromHandleBuildCache(hwnd: Pointer;
                                         const cacheRequest: IUIAutomationCacheRequest;
                                         out element: IUIAutomationElement): HResult; stdcall;
    function ElementFromPointBuildCache(pt: tagPOINT;
                                        const cacheRequest: IUIAutomationCacheRequest;
                                        out element: IUIAutomationElement): HResult; stdcall;
    function GetFocusedElementBuildCache(const cacheRequest: IUIAutomationCacheRequest;
                                         out element: IUIAutomationElement): HResult; stdcall;
    function CreateTreeWalker(const pCondition: IUIAutomationCondition;
                              out walker: IUIAutomationTreeWalker): HResult; stdcall;
    function Get_ControlViewWalker(out walker: IUIAutomationTreeWalker): HResult; stdcall;
    function Get_ContentViewWalker(out walker: IUIAutomationTreeWalker): HResult; stdcall;
    function Get_RawViewWalker(out walker: IUIAutomationTreeWalker): HResult; stdcall;
    function Get_RawViewCondition(out condition: IUIAutomationCondition): HResult; stdcall;
    function Get_ControlViewCondition(out condition: IUIAutomationCondition): HResult; stdcall;
    function Get_ContentViewCondition(out condition: IUIAutomationCondition): HResult; stdcall;
    function CreateCacheRequest(out cacheRequest: IUIAutomationCacheRequest): HResult; stdcall;
    function CreateTrueCondition(out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateFalseCondition(out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreatePropertyCondition(propertyId: SYSINT; value: OleVariant;
                                     out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreatePropertyConditionEx(propertyId: SYSINT; value: OleVariant;
                                       flags: PropertyConditionFlags;
                                       out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateAndCondition(const condition1: IUIAutomationCondition;
                                const condition2: IUIAutomationCondition;
                                out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateAndConditionFromArray(conditions: PSafeArray;
                                         out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateAndConditionFromNativeArray(var conditions: IUIAutomationCondition;
                                               conditionCount: SYSINT;
                                               out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateOrCondition(const condition1: IUIAutomationCondition;
                               const condition2: IUIAutomationCondition;
                               out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateOrConditionFromArray(conditions: PSafeArray;
                                        out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateOrConditionFromNativeArray(var conditions: IUIAutomationCondition;
                                              conditionCount: SYSINT;
                                              out newCondition: IUIAutomationCondition): HResult; stdcall;
    function CreateNotCondition(const condition: IUIAutomationCondition;
                                out newCondition: IUIAutomationCondition): HResult; stdcall;
    function AddAutomationEventHandler(eventId: SYSINT; const element: IUIAutomationElement;
                                       scope: TreeScope;
                                       const cacheRequest: IUIAutomationCacheRequest;
                                       const handler: IUIAutomationEventHandler): HResult; stdcall;
    function RemoveAutomationEventHandler(eventId: SYSINT; const element: IUIAutomationElement;
                                          const handler: IUIAutomationEventHandler): HResult; stdcall;
    function AddPropertyChangedEventHandlerNativeArray(const element: IUIAutomationElement;
                                                       scope: TreeScope;
                                                       const cacheRequest: IUIAutomationCacheRequest;
                                                       const handler: IUIAutomationPropertyChangedEventHandler;
                                                       var propertyArray: SYSINT;
                                                       propertyCount: SYSINT): HResult; stdcall;
    function AddPropertyChangedEventHandler(const element: IUIAutomationElement; scope: TreeScope;
                                            const cacheRequest: IUIAutomationCacheRequest;
                                            const handler: IUIAutomationPropertyChangedEventHandler;
                                            propertyArray: PSafeArray): HResult; stdcall;
    function RemovePropertyChangedEventHandler(const element: IUIAutomationElement;
                                               const handler: IUIAutomationPropertyChangedEventHandler): HResult; stdcall;
    function AddStructureChangedEventHandler(const element: IUIAutomationElement; scope: TreeScope;
                                             const cacheRequest: IUIAutomationCacheRequest;
                                             const handler: IUIAutomationStructureChangedEventHandler): HResult; stdcall;
    function RemoveStructureChangedEventHandler(const element: IUIAutomationElement;
                                                const handler: IUIAutomationStructureChangedEventHandler): HResult; stdcall;
    function AddFocusChangedEventHandler(const cacheRequest: IUIAutomationCacheRequest;
                                         const handler: IUIAutomationFocusChangedEventHandler): HResult; stdcall;
    function RemoveFocusChangedEventHandler(const handler: IUIAutomationFocusChangedEventHandler): HResult; stdcall;
    function RemoveAllEventHandlers: HResult; stdcall;
    function IntNativeArrayToSafeArray(var array_: SYSINT; arrayCount: SYSINT;
                                       out safeArray: PSafeArray): HResult; stdcall;
    function IntSafeArrayToNativeArray(intArray: PSafeArray; out array_: PSYSINT1;
                                       out arrayCount: SYSINT): HResult; stdcall;
    function RectToVariant(rc: tagRECT; out var_: OleVariant): HResult; stdcall;
    function VariantToRect(var_: OleVariant; out rc: tagRECT): HResult; stdcall;
    function SafeArrayToRectNativeArray(rects: PSafeArray; out rectArray: PUserType4;
                                        out rectArrayCount: SYSINT): HResult; stdcall;
    function CreateProxyFactoryEntry(const factory: IUIAutomationProxyFactory;
                                     out factoryEntry: IUIAutomationProxyFactoryEntry): HResult; stdcall;
    function Get_ProxyFactoryMapping(out factoryMapping: IUIAutomationProxyFactoryMapping): HResult; stdcall;
    function GetPropertyProgrammaticName(property_: SYSINT; out name: WideString): HResult; stdcall;
    function GetPatternProgrammaticName(pattern: SYSINT; out name: WideString): HResult; stdcall;
    function PollForPotentialSupportedPatterns(const pElement: IUIAutomationElement;
                                               out patternIds: PSafeArray;
                                               out patternNames: PSafeArray): HResult; stdcall;
    function PollForPotentialSupportedProperties(const pElement: IUIAutomationElement;
                                                 out propertyIds: PSafeArray;
                                                 out propertyNames: PSafeArray): HResult; stdcall;
    function CheckNotSupported(value: OleVariant; out isNotSupported: Integer): HResult; stdcall;
    function Get_ReservedNotSupportedValue(out notSupportedValue: IUnknown): HResult; stdcall;
    function Get_ReservedMixedAttributeValue(out mixedAttributeValue: IUnknown): HResult; stdcall;
    function ElementFromIAccessible(const accessible: IAccessible; childId: SYSINT;
                                    out element: IUIAutomationElement): HResult; stdcall;
    function ElementFromIAccessibleBuildCache(const accessible: IAccessible; childId: SYSINT;
                                              const cacheRequest: IUIAutomationCacheRequest;
                                              out element: IUIAutomationElement): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomation2
// Flags:     (0)
// GUID:      {34723AFF-0C9D-49D0-9896-7AB52DF8CD8A}
// *********************************************************************//
  IUIAutomation2 = interface(IUIAutomation)
    ['{34723AFF-0C9D-49D0-9896-7AB52DF8CD8A}']
    function Get_AutoSetFocus(out AutoSetFocus: Integer): HResult; stdcall;
    function Set_AutoSetFocus(AutoSetFocus: Integer): HResult; stdcall;
    function Get_ConnectionTimeout(out timeout: LongWord): HResult; stdcall;
    function Set_ConnectionTimeout(timeout: LongWord): HResult; stdcall;
    function Get_TransactionTimeout(out timeout: LongWord): HResult; stdcall;
    function Set_TransactionTimeout(timeout: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomation3
// Flags:     (0)
// GUID:      {73D768DA-9B51-4B89-936E-C209290973E7}
// *********************************************************************//
  IUIAutomation3 = interface(IUIAutomation2)
    ['{73D768DA-9B51-4B89-936E-C209290973E7}']
    function AddTextEditTextChangedEventHandler(const element: IUIAutomationElement;
                                                scope: TreeScope;
                                                TextEditChangeType: TextEditChangeType;
                                                const cacheRequest: IUIAutomationCacheRequest;
                                                const handler: IUIAutomationTextEditTextChangedEventHandler): HResult; stdcall;
    function RemoveTextEditTextChangedEventHandler(const element: IUIAutomationElement;
                                                   const handler: IUIAutomationTextEditTextChangedEventHandler): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomation4
// Flags:     (0)
// GUID:      {1189C02A-05F8-4319-8E21-E817E3DB2860}
// *********************************************************************//
  IUIAutomation4 = interface(IUIAutomation3)
    ['{1189C02A-05F8-4319-8E21-E817E3DB2860}']
    function AddChangesEventHandler(const element: IUIAutomationElement; scope: TreeScope;
                                    var changeTypes: SYSINT; changesCount: SYSINT;
                                    const pCacheRequest: IUIAutomationCacheRequest;
                                    const handler: IUIAutomationChangesEventHandler): HResult; stdcall;
    function RemoveChangesEventHandler(const element: IUIAutomationElement;
                                       const handler: IUIAutomationChangesEventHandler): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomation5
// Flags:     (0)
// GUID:      {25F700C8-D816-4057-A9DC-3CBDEE77E256}
// *********************************************************************//
  IUIAutomation5 = interface(IUIAutomation4)
    ['{25F700C8-D816-4057-A9DC-3CBDEE77E256}']
    function AddNotificationEventHandler(const element: IUIAutomationElement; scope: TreeScope;
                                         const cacheRequest: IUIAutomationCacheRequest;
                                         const handler: IUIAutomationNotificationEventHandler): HResult; stdcall;
    function RemoveNotificationEventHandler(const element: IUIAutomationElement;
                                            const handler: IUIAutomationNotificationEventHandler): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IUIAutomation6
// Flags:     (0)
// GUID:      {AAE072DA-29E3-413D-87A7-192DBF81ED10}
// *********************************************************************//
  IUIAutomation6 = interface(IUIAutomation5)
    ['{AAE072DA-29E3-413D-87A7-192DBF81ED10}']
    function CreateEventHandlerGroup(out handlerGroup: IUIAutomationEventHandlerGroup): HResult; stdcall;
    function AddEventHandlerGroup(const element: IUIAutomationElement;
                                  const handlerGroup: IUIAutomationEventHandlerGroup): HResult; stdcall;
    function RemoveEventHandlerGroup(const element: IUIAutomationElement;
                                     const handlerGroup: IUIAutomationEventHandlerGroup): HResult; stdcall;
    function Get_ConnectionRecoveryBehavior(out ConnectionRecoveryBehaviorOptions: ConnectionRecoveryBehaviorOptions): HResult; stdcall;
    function Set_ConnectionRecoveryBehavior(ConnectionRecoveryBehaviorOptions: ConnectionRecoveryBehaviorOptions): HResult; stdcall;
    function Get_CoalesceEvents(out CoalesceEventsOptions: CoalesceEventsOptions): HResult; stdcall;
    function Set_CoalesceEvents(CoalesceEventsOptions: CoalesceEventsOptions): HResult; stdcall;
    function AddActiveTextPositionChangedEventHandler(const element: IUIAutomationElement;
                                                      scope: TreeScope;
                                                      const cacheRequest: IUIAutomationCacheRequest;
                                                      const handler: IUIAutomationActiveTextPositionChangedEventHandler): HResult; stdcall;
    function RemoveActiveTextPositionChangedEventHandler(const element: IUIAutomationElement;
                                                         const handler: IUIAutomationActiveTextPositionChangedEventHandler): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoCUIAutomation provides a Create and CreateRemote method to
// create instances of the default interface IUIAutomation exposed by
// the CoClass CUIAutomation. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoCUIAutomation = class
    class function Create: IUIAutomation;
    class function CreateRemote(const MachineName: string): IUIAutomation;
  end;

// *********************************************************************//
// The Class CoCUIAutomation8 provides a Create and CreateRemote method to
// create instances of the default interface IUIAutomation2 exposed by
// the CoClass CUIAutomation8. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoCUIAutomation8 = class
    class function Create: IUIAutomation2;
    class function CreateRemote(const MachineName: string): IUIAutomation2;
  end;

implementation

uses System.Win.ComObj;

class function CoCUIAutomation.Create: IUIAutomation;
begin
  Result := CreateComObject(CLASS_CUIAutomation) as IUIAutomation;
end;

class function CoCUIAutomation.CreateRemote(const MachineName: string): IUIAutomation;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CUIAutomation) as IUIAutomation;
end;

class function CoCUIAutomation8.Create: IUIAutomation2;
begin
  Result := CreateComObject(CLASS_CUIAutomation8) as IUIAutomation2;
end;

class function CoCUIAutomation8.CreateRemote(const MachineName: string): IUIAutomation2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CUIAutomation8) as IUIAutomation2;
end;

end.

