unit uFormForm1;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, ActnList, Menus,
  StdCtrls, ComCtrls, LCLProc, LCLType, Buttons,
  sketchDocument, uFrameEditor, uFormDocument,
  glob, uFrameDocumetExplorer, uFormViewProp,
  sketchEditor,
  Dialogs;

const
  NUM_CUAD = 20;
  ZOOM_INI = 12;

type

  { TForm1 }
  TForm1 = class(TForm)
  published
    acToolbarPoint: TAction;
    acToolbarRot: TAction;
    acDocFileNew: TAction;
    acDocFileClose: TAction;
    acDocFileSave: TAction;
    acDocFileLeave: TAction;
    acDocInsPolyline: TAction;
    acDocProp: TAction;
    acDocInsRect: TAction;
    acDocInsRectan: TAction;
    acDocAddPage: TAction;
    acPageProp: TAction;
    acPageRemove: TAction;
    acPageAddLine: TAction;
    acViewProp: TAction;
    acVerViewSup: TAction;
    cmdInput: TEdit;
    cmdInputLabel: TLabel;
    cmdInputWrapper: TPanel;
    cmdMessages: TMemo;
    cmdRunBtn: TSpeedButton;
    frameDocumentExplorer: TFrameDocumentExplorer;
    mfileOpen: TMenuItem;
    mfileNew: TMenuItem;
    mfileExit: TMenuItem;
    mDoc: TMenuItem;
    mdocInsertPoly: TMenuItem;
    pdocInsert: TMenuItem;
    pdocinsertPoly: TMenuItem;
    pobjectsItem1: TMenuItem;
    pdocProperies: TMenuItem;
    mdocProperties: TMenuItem;
    mdocInsertRect: TMenuItem;
    pdocAddPage: TMenuItem;
    mdocAddPage: TMenuItem;
    mPage: TMenuItem;
    mpageRename: TMenuItem;
    mpageRemove: TMenuItem;
    mpageProperies: TMenuItem;
    ppageRename: TMenuItem;
    ppageRemove: TMenuItem;
    ppageProperties: TMenuItem;
    pviewProperties: TMenuItem;
    ppageAddline: TMenuItem;
    mviewItem: TMenuItem;
    MenuItem5: TMenuItem;
    acToolbarConfig: TAction;
    ActionList1: TActionList;
    acDocFileOpen: TAction;
    Images16: TImageList;
    Images32: TImageList;
    menuMain: TMainMenu;
    mFile: TMenuItem;
    mView: TMenuItem;
    mTools: TMenuItem;
    mtoolsConfig: TMenuItem;
    mfileClose: TMenuItem;
    mfileSave: TMenuItem;
    PageControl1: TPageControl;
    Splitter1: TSplitter;
    splitterVert1: TSplitter;
    StatusBar: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    WrapperBottom: TPanel;
    WrapperMiddle: TPanel;
    pmenuView: TPopupMenu;
    pmenuPage: TPopupMenu;
    pmenuDoc: TPopupMenu;
    pmenuObjects: TPopupMenu;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure acDocFileCloseExecute(Sender: TObject);
    procedure acDocNew_onExecute(Sender: TObject);
    procedure acDocFileLeaveExecute(Sender: TObject);
    procedure acPageAddLineExecute(Sender: TObject);
    procedure acPageRemoveExecute(Sender: TObject);
    procedure acDocAddPageExecute(Sender: TObject);
    procedure acDocInsRectanExecute(Sender: TObject);
    procedure acDocPropExecute(Sender: TObject);
    procedure acVerViewSupExecute(Sender: TObject);
    procedure acViewPropExecute(Sender: TObject);
    procedure cmdMessagesChange(Sender: TObject);
    procedure cmdRunBtnClick(Sender: TObject);
    procedure cmdInputKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure acToolbarConfigExecute(Sender: TObject);
    procedure SplitterHorCanOffset(Sender: TObject; var NewOffset: Integer;
      var Accept: Boolean);
    procedure WrapperBottomClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    priv_curDocument: TDocument;
    priv_ExploreDocPage: TDocPage;     //page selected in the document explorer
    priv_ExploreDocView: TFramePaintBox;  //View selected in the document explorer
    procedure priv_ConfigPropertiesChanged;
    procedure priv_curDocumentActivePageViewSendMessage(msg: string);
    procedure priv_curDocumentModified;
    procedure priv_curDocumentChangeState(ViewState: TViewState);
    procedure priv_curDocumentMouseMoveVirt(Shift: TShiftState; xp, yp: integer;
      xv, yv, zv: single);
    procedure priv_curDocumentChangeActivePage;
    procedure priv_frameExploreDocClickRightPage(Page: TDocPage);
    procedure priv_fraExploreDocClickRightDoc(Doc: TDocument);
    procedure priv_frameExploreDocClickRightView(View: TFramePaintBox);
    procedure priv_curDocumentChangeView(View: TFramePaintBox);
    function priv_MessageSaveChanges: integer;
    procedure priv_form1SetCaption;
    procedure priv_Refresh;
  public
    //frameDocumentExplorer: TFrameDocumentExplorer;  //Document Explorer
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
const
  BUT_CANCEL = 3;

procedure TForm1.priv_fraExploreDocClickRightDoc(Doc: TDocument);
begin
  pmenuDoc.PopUp;
end;

procedure TForm1.priv_frameExploreDocClickRightPage(Page: TDocPage);
begin
  priv_ExploreDocPage := Page;
  pmenuPage.PopUp;
end;

procedure TForm1.priv_frameExploreDocClickRightView(View: TFramePaintBox);
begin
  priv_ExploreDocView := View;
  pmenuView.PopUp;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //Configure Document Explorer
  frameDocumentExplorer.Name := 'frameDocumentExplorer';
  frameDocumentExplorer.OnClickRightDocument := @priv_fraExploreDocClickRightDoc;
  frameDocumentExplorer.OnClickRightPage := @priv_frameExploreDocClickRightPage;
  frameDocumentExplorer.OnClickRightView := @priv_frameExploreDocClickRightView;
  frameDocumentExplorer.OnDeletePage := @acPageRemoveExecute;
  frameDocumentExplorer.Initiate(@priv_curDocument);

  //translating
  mFile.Caption :=msg.get('file');
  mfileNew.Caption :=msg.get('newDocument');
  mfileOpen.Caption :=msg.get('open');
  mfileSave.Caption :=msg.get('save');
  mfileClose.Caption :=msg.get('close');
  mfileExit.Caption :=msg.get('exit');
  //
  mView.Caption :=msg.get('view');
  mviewItem.Caption :=msg.get('newitem8');
  //
  mDoc.Caption :=msg.get('document');
  mdocAddPage.Caption:=msg.get('addPage');
  mdocInsertRect.Caption :=msg.get('insertRectangle');
  mdocInsertPoly.Caption :=msg.get('insertPolyline');
  mdocProperties.Caption :=msg.get('properties');
  //
  mPage.Caption :=msg.get('page');
  mpageRename.Caption :=msg.get('rename');
  mpageRemove.Caption :=msg.get('remove');
  mpageProperies.Caption :=msg.get('properties');
  //
  mTools.Caption :=msg.get('tools');
  mtoolsConfig.Caption :=msg.get('config');
  //
  pdocAddPage.Caption :=msg.get('addPage');
  pdocInsert.Caption :=msg.get('insert');
  pdocinsertPoly.Caption :=msg.get('insertPolyline');
  pdocProperies.Caption :=msg.get('properties');
  //
  pobjectsItem1.Caption :=msg.get('insertPolyline');
  //
  ppageAddline.Caption :=msg.get('addLine');
  ppageRename.Caption :=msg.get('rename');
  ppageRemove.Caption :=msg.get('remove');
  ppageProperties.Caption :=msg.get('properties');
  //
  pviewProperties.Caption :=msg.get('properties');
  // Toolbar1.
  ToolButton1.Caption :=msg.get('rotate'); 
  ToolButton2.Caption :=msg.get('rotate');
  ToolButton3.Caption :=msg.get('rotate');
  ToolButton4.Caption :=msg.get('ToolButton4');
  ToolButton6.Caption :=msg.get('newDocument');
  ToolButton7.Caption :=msg.get('save');
  ToolButton8.Caption :=msg.get('ToolButton8');
  ToolButton9.Caption :=msg.get('config');
  ToolButton10.Caption :=msg.get('open');
  ToolButton5.Caption :=msg.get('viewSuperior');
  ToolButton11.Caption :=msg.get('acDocInsRectan');
  ToolButton12.Caption :=msg.get('insertPolyline');
  ToolButton13.Caption :=msg.get('addLine');
  //
  TabSheet1.Caption :=msg.get('editor');
  TabSheet2.Caption :=msg.get('TabSheet2');
  //
  cmdInputLabel.Caption :=msg.get('commandPrompt');
  //btnRubtnRunCmd_oldion :=msg.get('');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  ToolButton13.Caption :=msg.get('addLine');
  //
  frameDocumentExplorer.Caption := msg.Get('DocumentExplorer');
  
  //assign actions to functions
  //acDocFileNew.OnExecute := @acDocNew_onExecute;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  priv_ConfigPropertiesChanged;
  priv_Refresh;
  //acDocNew_onExecute(self);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if priv_curDocument <> nil then
    priv_curDocument.Destroy;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
{Intercept the keyboard to manage it according to the chosen control}
begin
  if priv_curDocument = nil then
    exit;
  //Send all commands to the command box
  if TabSheet1.Focused then
    cmdInput.SetFocus//pass the focus
  else if PageControl1.Focused then
    cmdInput.SetFocus//pass the focus
  ;
end;

procedure TForm1.priv_ConfigPropertiesChanged;
//Configuration properties are changed
begin
  StatusBar.Visible := true;
  ToolBar1.Visible := true;
  ToolBar1.ButtonHeight := 38;
  ToolBar1.ButtonWidth := 38;
  ToolBar1.Height := 42;
  ToolBar1.Images := Images32;
end;

function TForm1.priv_MessageSaveChanges: integer;
{Displays a window to confirm whether changes are saved or not. If selected
cancel, the BUT_CANCEL value is returned.}
var
  answer: Integer;
begin
  if (priv_curDocument <> nil) and priv_curDocument.Modified then
  begin
    answer := Application.MessageBox(PChar(msg.Get('DocumentModifiedSaveChanges')), 'Question',
           (MB_ICONQUESTION + MB_YESNO));
    if answer = IDNO then
      exit(BUT_CANCEL);
    if answer = IDYES then
      priv_curDocument.SaveFile;
  end;
  Result := 0;   //Default value
end;

procedure TForm1.priv_form1SetCaption;
begin
  if priv_curDocument = nil then
    Caption := APP_NAME + ' ' + APP_VERSION
  else
    Caption := APP_NAME + ' ' + APP_VERSION + ' - ' +
      priv_curDocument.Name;
end;

procedure TForm1.priv_Refresh;
{Refresh the entire interface}
begin
  priv_form1SetCaption;
  frameDocumentExplorer.Refresh; 
end;

procedure TForm1.priv_curDocumentModified;
//Call when the document has been modified.
begin
  acDocFileSave.Enabled := True;
end;

procedure TForm1.priv_curDocumentChangeState(ViewState: TViewState);
begin
  StatusBar.Panels[0].Text := priv_curDocument.ActivePage.View.StateAsStr;
end;

procedure TForm1.priv_curDocumentMouseMoveVirt(Shift: TShiftState;
  xp, yp: integer; xv, yv, zv: single);
begin
  StatusBar.Panels[3].Text :=
    'x=' + formatfloat('0.00', xv) + ' ' + 'y=' + formatfloat('0.00', yv) +
    ' ' + 'z=' + formatfloat('0.00', zv);
end;

procedure TForm1.priv_curDocumentChangeView(View: TFramePaintBox);
begin
  StatusBar.Panels[1].Text :=
    'Alfa=' + formatfloat('0.00', View.Alfa) + ' ' + 'Fi=' +
    formatfloat('0.00', View.Fi);
  //FloatToStr(fraMotEdicion.Alfa);
  StatusBar.Panels[2].Text :=
    'Zoom=' + formatfloat('0.00', View.Zoom);
end;

procedure TForm1.priv_curDocumentChangeActivePage;
{The active page of the current document was changed. Show it on the screen}
var
  ap: TDocPage;
begin
  if priv_curDocument = nil then
    exit;
  //Plug the viewer into PageControl1, to show it;
  priv_curDocument.HideAllPages; {Hide all the pages first because you may have
                                      already put your "Parent" in viewer.}
  ap := priv_curDocument.ActivePage;
  ap.View.Parent := TabSheet1;   //Place it here
  ap.View.Left := Random(200);
  ap.View.Top := Random(200);
  ap.View.Align := alClient;
  ap.View.Visible := True;  //it makes it visible
end;

function ComponentFromAction(Sender: TObject): TComponent;
  {Returns the component that triggered an action. If not object, returns NIL}
var
  compSource: TComponent;
begin
  if not (Sender is Taction) then
    exit(nil);
  compSource := TAction(Sender).ActionComponent;
  //We already have the source component
  if compSource is TMenuItem then
    exit(TMenuItem(compSource).GetParentComponent)//It's a menu item, but which one?
  else if compSource is TToolButton then
    exit(TToolButton(compSource).GetParentComponent)
    //It's a button on a toolbar, but which one?
  else
    exit(compSource)//It's another thing
  ;
end;

procedure TForm1.cmdInputKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  strCmd: string;
begin
  if priv_curDocument = nil then
    exit;
  if key = VK_RETURN then
  begin
    strCmd := trim(cmdInput.Text);
    if strCmd = '' then
      exit;
    strCmd := UpCase(strCmd);  //Convert upper case
    //Command entered.
    priv_curDocument.ActivePage.View.ExecuteCommand(strCmd);
  end
  else if key = VK_ESCAPE then
    priv_curDocument.ActivePage.View.ExecuteCommand('CANCEL')//Convert key to command
  ;
end;

procedure TForm1.priv_curDocumentActivePageViewSendMessage(msg: string);
{A message has arrived from the document}
begin
  cmdMessages.Lines.Add(cmdInput.Text);
  cmdInputLabel.Caption := msg;
  cmdInput.Text := '';
end;
///////////////////////////// Actions ///////////////////////////////
procedure TForm1.acDocNew_onExecute(Sender: TObject);
var
  tmpDoc: TDocument;
begin
  //check if changes must be saved
  if priv_MessageSaveChanges = BUT_CANCEL then
  begin
	//WriteLn('butcancel');
    exit;
  end;
  //Create temporary document
  tmpDoc := TDocument.Create;
  if not formDocument.ExecNew(tmpDoc) then
  begin
    //it was canceled
    tmpDoc.Destroy;  //It will not work
    exit;  //leaving the current document
  end;
  //Close current document and assign the temporary to the current one
  acDocFileCloseExecute(self);   //close current if it was open
  priv_curDocument := tmpDoc;  //points to the temporary
  priv_curDocument.OnModify := @priv_curDocumentModified;
  priv_curDocument.OnChangePersp := @priv_curDocumentChangeView;
  priv_curDocument.OnChangeActivePage := @priv_curDocumentChangeActivePage;
  priv_curDocument.OnMouseMoveVirt := @priv_curDocumentMouseMoveVirt;
  priv_curDocument.OnChangeState := @priv_curDocumentChangeState;
  priv_curDocument.ActivePage.View.OnSendMessage := @priv_curDocumentActivePageViewSendMessage;
  priv_curDocumentChangeActivePage;  //for priv_Refresh in your viewer
  priv_curDocument.ActivePage.View.InitView;  //start the axes
  priv_curDocument.SaveFile;
  priv_Refresh;
end;

procedure TForm1.acDocFileCloseExecute(Sender: TObject);
begin
  if priv_curDocument = nil then
    exit;  //there is no open document
  //check if there is a modified document
  if priv_MessageSaveChanges = BUT_CANCEL then
    exit;
  priv_curDocument.Destroy;
  priv_curDocument := nil;   //marks it as closed
  priv_Refresh;
end;

procedure TForm1.acDocFileLeaveExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm1.acVerViewSupExecute(Sender: TObject);
begin
  if priv_curDocument = nil then
    exit;
  priv_curDocument.ActivePage.View.Alfa := 0;
  priv_curDocument.ActivePage.View.Fi := 0;
  priv_curDocument.ActivePage.View.Editor.Refresh;
end;

procedure TForm1.acViewPropExecute(Sender: TObject);
begin
  formViewProp.Exec(priv_ExploreDocView);
end;

procedure TForm1.cmdMessagesChange(Sender: TObject);
begin

end;

procedure TForm1.cmdRunBtnClick(Sender: TObject);
begin

end;

procedure TForm1.acDocAddPageExecute(Sender: TObject);
begin
  if priv_curDocument = nil then
    exit;  //there is no open document
  priv_curDocument.AddPage;
  priv_Refresh;
end;

procedure TForm1.acDocPropExecute(Sender: TObject);
begin
  if priv_curDocument = nil then
    exit;
  if formDocument.Exec(priv_curDocument) then
  begin
    priv_curDocument.Modified := True;
    frameDocumentExplorer.Refresh;
  end;
end;

procedure TForm1.acPageAddLineExecute(Sender: TObject);  //Add line
var
  Page: TDocPage;
begin
  if priv_curDocument = nil then
    exit;
  {It checks if the action comes from the document explorer, to give you the
    possibility to take actions, on non-active pages}
  if ComponentFromAction(Sender) = pmenuPage then
    Page := priv_ExploreDocPage
  else
    Page := priv_curDocument.ActivePage;
  Page.View.ExecuteCommand('LINE');
  priv_Refresh;
end;

procedure TForm1.acDocInsRectanExecute(Sender: TObject);
var
  Page: TDocPage;
begin
  if priv_curDocument = nil then
    exit;
  {It checks if the action comes from the document explorer, to give you the
    possibility to take actions, on non-active pages}
  if ComponentFromAction(Sender) = pmenuPage then
    Page := priv_ExploreDocPage
  else
    Page := priv_curDocument.ActivePage;
  Page.View.ExecuteCommand('RECTANGLE');
  priv_Refresh;
end;



procedure TForm1.acPageRemoveExecute(Sender: TObject);
begin
  if priv_curDocument = nil then
    exit;
  if Application.MessageBox(PChar(msg.Get('AskPageDelete')+priv_curDocument.ActivePage.Name), '', (MB_ICONQUESTION + MB_YESNO)) <> IDYES then
    exit;
  priv_curDocument.RemovePage(priv_curDocument.ActivePage);
  priv_Refresh;
end;

procedure TForm1.acToolbarConfigExecute(Sender: TObject);
begin

end;

procedure TForm1.SplitterHorCanOffset(Sender: TObject; var NewOffset: Integer;
  var Accept: Boolean);
begin

end;

procedure TForm1.WrapperBottomClick(Sender: TObject);
begin

end;

procedure TForm1.Label2Click(Sender: TObject);
begin

end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

end;

begin



end.
