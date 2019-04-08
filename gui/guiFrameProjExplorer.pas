
unit guiFrameProjExplorer;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ComCtrls, StdCtrls, LCLType, ActnList,
  sketchDocument, guiFramePaintBox, sketchCore;

type
  TEvClickRightProj = procedure(Proj: TProject) of object;
  TEvClickRightPage = procedure(Page: TDocPage) of object;
  TEvClickRightObj = procedure(obj: TDrawObjetcs_list) of object;
  TEvClickRightView = procedure(View: TFrPaintBox) of object;

  { TFrProjectExplorer }

  TFrProjectExplorer = class(TFrame)
    treeNav: TTreeView;
    ImgActions16: TImageList;
    ImgActions32: TImageList;
    Label2: TLabel;
    procedure treeNavKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    curProject: TPtrProject;
    function NodeIsObject(node: TTreeNode): boolean;
    function NodeIsView(node: TTreeNode): boolean;
    function NodeObjectSelected: TTreeNode;
    function NodeGetSelected: TTreeNode;
    function NodeName(node: TTreeNode): string;
    function NodeSelectedGetName: string;
    procedure NodeSelectByName(argName: string);

    function NodeIsPage(node: TTreeNode): boolean;
    function NodeProjectSelected: TTreeNode;
    function NodePageSelected: TTreeNode;
    function NodeViewSelected: TTreeNode;

    procedure treeNavMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure treeNavSelectionChanged(Sender: TObject);
  public
    OnClickRightProject: TEvClickRightProj;
    OnClickRightPage: TEvClickRightPage;
    OnClickRightView: TEvClickRightView;
    OnClickRightObject: TEvClickRightObj;
    OnDeletePage: TNotifyEvent;
    procedure Refresh;
  public
    procedure Initiate(Proj: TPtrProject);
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}
const
  //  MSJE_SIN_ELEM = '<Sin elementos>';
  IMIND_PROJ = 0;
  IMIND_PAGE = 1;
  IMIND_VIEW = 2;
  IMIND_GRAOBJ = 3;

{ TFrProjectExplorer }
procedure TFrProjectExplorer.treeNavKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    if OnDeletePage <> nil then
      OnDeletePage(self);
end;

function TFrProjectExplorer.NodeGetSelected: TTreeNode;
  {Returns the currently selected node. }
begin
  if curProject^ = nil then
    exit(nil);
  Result := treeNav.Selected;
end;

function TFrProjectExplorer.NodeName(node: TTreeNode): string;
  {Returns the name of a node. }
begin
  Result := node.Text;
end;

function TFrProjectExplorer.NodeSelectedGetName: string;
  {Returns the name of the selected node.}
begin
  if treeNav.Selected = nil then
    exit('');
  Result := NodeName(treeNav.Selected);
end;

procedure TFrProjectExplorer.NodeSelectByName(argName: string);
{Select a node in the tree, using its name. It will work if the tree has or does not focus.}
var
  node: TTreeNode;
begin
  for node in treeNav.Items do
    if (NodeName(node) = argName) then
    begin
      node.Selected := True;
      exit;
    end;
end;
//Identification of selected nodes
function TFrProjectExplorer.NodeIsPage(node: TTreeNode): boolean;
begin
  if node = nil then
    exit(False);
  Result := (node.Level = 1) and (node.ImageIndex = IMIND_PAGE);
end;

function TFrProjectExplorer.NodeIsView(node: TTreeNode): boolean;
begin
  if node = nil then
    exit(False);
  Result := (node.Level = 2) and (node.ImageIndex = IMIND_VIEW);
end;

function TFrProjectExplorer.NodeIsObject(node: TTreeNode): boolean;
begin
  if node = nil then
    exit(False);
  Result := (node.Level = 2) and (node.ImageIndex = IMIND_GRAOBJ);
end;

function TFrProjectExplorer.NodeProjectSelected: TTreeNode;
begin
  if NodeGetSelected = nil then
    exit(nil);
  if NodeGetSelected.Level = 0 then
    exit(NodeGetSelected);
  exit(nil);
end;

function TFrProjectExplorer.NodePageSelected: TTreeNode;
begin
  if NodeGetSelected = nil then
    exit(nil);
  if NodeGetSelected.Visible = False then
    exit(nil);
  if NodeIsPage(NodeGetSelected) then
    exit(NodeGetSelected);
  exit(nil);
end;

function TFrProjectExplorer.NodeObjectSelected: TTreeNode;
begin
  if NodeGetSelected = nil then
    exit(nil);
  if NodeGetSelected.Visible = False then
    exit(nil);
  if NodeIsPage(NodeGetSelected) then
    exit(NodeGetSelected);
  exit(nil);
end;

function TFrProjectExplorer.NodeViewSelected: TTreeNode;
begin
  if NodeGetSelected = nil then
    exit(nil);
  if NodeGetSelected.Visible = False then
    exit(nil);
  if NodeIsView(NodeGetSelected) then
    exit(NodeGetSelected);
  exit(nil);
end;
//Tree events
procedure TFrProjectExplorer.treeNavMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  node: TTreeNode;
  Page: TDocPage;
begin
  node := treeNav.GetNodeAt(x, y);
  if node = nil then
    treeNav.Selected := nil;
  //Generate events according to the selected node
  if Button = mbRight then
  begin
    if treeNav.GetNodeAt(X, Y) <> nil then
      treeNav.GetNodeAt(X, Y).Selected := True;
    if NodeProjectSelected <> nil then
    begin //selected project
      if OnClickRightProject <> nil then
        OnClickRightProject(curProject^);
    end
    else if NodePageSelected <> nil then
    begin  //selected page
      Page := curProject^.PageByName(NodeSelectedGetName);
      if OnClickRightPage <> nil then
        OnClickRightPage(Page);
    end
    else if NodeViewSelected <> nil then
    begin
      Page := curProject^.PageByName(NodeGetSelected.Parent.Text);
      if OnClickRightView <> nil then
        OnClickRightView(Page.View);
    end
    else if NodeObjectSelected <> nil then
    begin
      Page := curProject^.PageByName(NodeGetSelected.Parent.Text);
      if OnClickRightObject <> nil then
        OnClickRightObject(Page.docPageObjList);
    end;
  end;
end;

procedure TFrProjectExplorer.treeNavSelectionChanged(Sender: TObject);
{The selected item has changed. Take the corresponding actions.}
begin
  if NodePageSelected <> nil then
    curProject^.SetActivePageByName(NodePageSelected.Text) ;
    //A page has been selected, the active page changes

end;

procedure TFrProjectExplorer.Refresh;
{Refreshes the appearance of the frame, according to the current project.}
var
  Page: TDocPage;
  nodePage: TTreeNode;
  nodeProj: TTreeNode;
  nodeGeom, nodeView, nodeGraphicObj: TTreeNode;
  argGraphicObject: TGraphicObj;
begin
  //show your title
  Label2.Caption := self.Caption;

  //  ns := NodeSelectedGetName;  //guarda elemento ObjSelected
  treeNav.Items.Clear;  //clean items
  if curProject^ = nil then
  begin
    //There is no current project
    nodeProj := treeNav.items.AddChild(nil, '<<Sin Proyectos>>');
    exit;
  end;
  //There is an open project
  //Add project node
  nodeProj := treeNav.items.AddChild(nil, curProject^.Name);  //add current project
  nodeProj.ImageIndex := IMIND_PROJ;
  nodeProj.SelectedIndex := IMIND_PROJ;
  //Add page nodes
  treeNav.BeginUpdate;
  for Page in curProject^.pages do
  begin
    nodePage := treeNav.Items.AddChild(nodeProj, Page.Name);
    nodePage.ImageIndex := IMIND_PAGE;
    nodePage.SelectedIndex := IMIND_PAGE;
    //Add graphic objects fields
    nodeGeom := treeNav.items.AddChild(nodePage, 'objects Gráficos');
    nodeGeom.ImageIndex := IMIND_GRAOBJ;
    nodeGeom.SelectedIndex := IMIND_GRAOBJ;

    for argGraphicObject in Page.View.objects do
      nodeGraphicObj := treeNav.items.AddChild(nodeGeom, 'Objeto');
    //Add field View
    nodeView := treeNav.items.AddChild(nodePage, 'View');
    nodeView.ImageIndex := IMIND_VIEW;
    nodeView.SelectedIndex := IMIND_VIEW;

    nodePage.Expanded := True;
  end;
  treeNav.EndUpdate;
  nodeProj.Expanded := True;
  //  NodeSelectByName(ns);  //restaura la selección
  NodeSelectByName(curProject^.ActivePage.Name);
end;

procedure TFrProjectExplorer.Initiate(Proj: TPtrProject);
{Start the frame, passing the address of the current project that is being managed.
At the moment, it is assumed that he can only manage zero or one project.
Note that you are given the address of the referendum, as it may change.}
begin
  curProject := Proj;   //saves reference
  Refresh;
end;

constructor TFrProjectExplorer.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  treeNav.OnMouseUp := @treeNavMouseUp;
  treeNav.OnSelectionChanged := @treeNavSelectionChanged;
end;

destructor TFrProjectExplorer.Destroy;
begin
  inherited Destroy;
end;


end.
