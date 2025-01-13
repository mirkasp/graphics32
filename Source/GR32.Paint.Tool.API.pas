unit GR32.Paint.Tool.API;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1 or LGPL 2.1 with linking exception
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * Alternatively, the contents of this file may be used under the terms of the
 * Free Pascal modified version of the GNU Lesser General Public License
 * Version 2.1 (the "FPC modified LGPL License"), in which case the provisions
 * of this license are applicable instead of those above.
 * Please see the file LICENSE.txt for additional information concerning this
 * license.
 *
 * The Original Code is Paint tools for Graphics32
 *
 * The Initial Developer of the Original Code is
 * Anders Melander, anders@melander.dk
 *
 * Portions created by the Initial Developer are Copyright (C) 2008-2025
 * the Initial Developer. All Rights Reserved.
 *
 * ***** END LICENSE BLOCK ***** *)

interface

{$INCLUDE GR32.inc}

uses
  Classes,
  Controls,
  GR32,
  GR32.Paint.API;


//------------------------------------------------------------------------------
//
//      IBitmap32PaintTool
//
//------------------------------------------------------------------------------
type
  // TBitmap32PaintToolFeatures:
  TBitmap32PaintToolFeature = (
    betfMouseCapture            // Tool captures the mouse during operation.
                                // If this flag is not set then the framework will reset
                                // mouse capture to the image control during operation.
  );
  TBitmap32PaintToolFeatures = set of TBitmap32PaintToolFeature;


  // TBitmap32PaintToolState:
  //
  // - tsContinue       Tool is performing the requested operation
  //
  // - tsAbort          Tool has rejected the requested operation
  //
  // - tsComplete       Tool has completed the requested operation
  //
  TBitmap32PaintToolState = (tsContinue, tsAbort, tsComplete);

type
  IBitmap32Viewport = interface;

  IBitmap32PaintTool = interface(IBitmap32PaintExtension)
    ['{712D1D8A-5C4B-43C7-A16A-8D8BBA9A6818}']
    /// <summary>Activate is called when the tool is selected.</summary>
    /// <comments>Set Continue to False to cancel the activation.</comments>
    procedure Activate(var Continue: boolean);
    /// <summary>Deactivate is called when tool is deselected.</summary>
    procedure Deactivate;

    /// <summary>BeginTool is called before BeginAction, just before IBitmap32PaintHost.BeginUpdate is called.</summary>
    /// <comments>Set Continue to False to abort the operation.</comments>
    procedure BeginTool(var Continue: boolean);
    /// <summary>EndTool is called after EndAction, just before IBitmap32PaintHost.EndUpdate is called.</summary>
    /// <comments>EndTool is called even if the operation is aborted prematurely.</comments>
    procedure EndTool;

    // BeginAction, ContinueAction and EndAction is called when the tool has
    // been selected and the user presses, moves and releases the mouse.
    // Set State to tsAbort to cancel the operation.
    procedure BeginAction(const Context: IBitmap32PaintToolContext; var ToolState: TBitmap32PaintToolState);
    procedure ContinueAction(const Context: IBitmap32PaintToolContext; var ToolState: TBitmap32PaintToolState);
    procedure EndAction(const Context: IBitmap32PaintToolContext; var ToolState: TBitmap32PaintToolState);
    procedure CallbackAction(Buffer: TBitmap32; Data: pointer; var Result: boolean);

    // MouseDown, MouseMove and MouseUp is called when the tool has been selected
    // and the user presses, moves and releases the mouse.
    procedure MouseDown(Button: TMouseButton; const Context: IBitmap32PaintToolContext);
    procedure MouseMove(const Context: IBitmap32PaintToolContext);
    procedure MouseUp(Button: TMouseButton; const Context: IBitmap32PaintToolContext);
    procedure MouseEnter;
    procedure MouseLeave;

    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure KeyUp(var Key: Word; Shift: TShiftState);

    /// <summary>GetCursor returns the cursor used by the tool.</summary>
    /// <comments>The tool should use IBitmap32PaintHost.RegisterCursor to register custom cursors.</comments>
    function GetCursor(out Cursor: TCursor): boolean;

    // SnapMouse specifies if bitmap coordinates should always be rounded (SnapMouse=True) or
    // truncated (SnapMouse=False) when converting mouse position from viewport to bitmap
    // coordinates.
    // If SnapMouse=True then the coordinates specified in Context.BitmapPos passed to BeginAction,
    // ContinueAction and EndAction will be snapped coordinates. I.e. the same value as Context.BitmapPosSnap.
    // Tools that operate on pixels usually need SnapMouse=False while tools that operate
    // on areas usually need SnapMouse=True.
    function GetSnapMouse: boolean;
    property SnapMouse: boolean read GetSnapMouse;

    function GetToolFeatures: TBitmap32PaintToolFeatures;
    property ToolFeatures: TBitmap32PaintToolFeatures read GetToolFeatures;

    procedure RenderLayer(const Viewport: IBitmap32Viewport; Buffer: TBitmap32);
  end;

//------------------------------------------------------------------------------
//
//      IBitmap32Viewport
//
//------------------------------------------------------------------------------
  IBitmap32Viewport = interface
    ['{77A63763-D9EA-4E50-BE8E-24C73B2F8654}']
    function BitmapToViewport(const Rect: TRect): TRect; overload;
    function BitmapToViewport(const Pos: TPoint): TPoint; overload;
    function ViewportToBitmap(const Rect: TRect): TRect; overload;
    function ViewportToBitmap(const Pos: TPoint): TPoint; overload;
    function GetViewportRect: TRect;
    property ViewportRect: TRect read GetViewportRect;
    function GetBitmapRect: TRect;
    property BitmapRect: TRect read GetBitmapRect;
    function GetVisible: boolean;
    procedure SetVisible(Value: boolean);
    property Visible: boolean read GetVisible write SetVisible;
  end;


//------------------------------------------------------------------------------
//
//      Global settings
//
//------------------------------------------------------------------------------
var
  // Snap to: rect, 45deg, etc.
  Bitmap32PaintToolKeyStateSnap: TShiftState = [ssShift]; // PhotoShop: [ssShift]
  // StartPos is center of: rect, circle, etc.
  Bitmap32PaintToolKeyStateCenter: TShiftState = [ssAlt]; // PhotoShop: [ssAlt]

  // Generic modifier (action depends on tool)
  Bitmap32PaintToolKeyStateAlternate: TShiftState = [ssCtrl]; // Must be different from the two above

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

//------------------------------------------------------------------------------

end.
