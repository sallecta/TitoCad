{Formulario para controlar la vista de un objeto "frameGrafEditor"}
unit TypeFormPerspective;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, guiFramePaintBox;
type

  { TFormPerspective }

  TFormPerspective = class(TForm)
    btnFijar: TButton;
    btnLeer: TButton;
    btnLimpiar: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    spnYdesp: TSpinEdit;
    spnXdesp: TSpinEdit;
    spnAlfa: TFloatSpinEdit;
    spnXcam: TFloatSpinEdit;
    spnFi: TFloatSpinEdit;
    spnYcam: TFloatSpinEdit;
    spnZoom: TFloatSpinEdit;
    Timer1: TTimer;
    procedure btnFijarClick(Sender: TObject);
    procedure btnLeerClick(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure spnAlfaClick(Sender: TObject);
    procedure spnAlfaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
    fraEditor: TfraVisorGraf;
  public
    procedure Exec(fraEditor0: TfraVisorGraf);
  end;

var
  FormPerspective: TFormPerspective;

implementation
{$R *.lfm}

procedure TFormPerspective.btnLeerClick(Sender: TObject);
begin
  spnXdesp.Value:= fraEditor.xDes;
  spnYdesp.Value:= fraEditor.yDes;

  spnXcam.Value := fraEditor.xCam;
  spnYcam.Value := fraEditor.yCam;

  spnAlfa.Value := fraEditor.Alfa;
  spnFi.Value   := fraEditor.Fi;
  spnZoom.Value := fraEditor.Zoom;

end;
procedure TFormPerspective.btnLimpiarClick(Sender: TObject);
begin
  spnAlfa.Value := 0;
  spnFi.Value := 0;
  spnZoom.Value := 1;
  btnFijarClick(self);
  fraEditor.PaintBox1.Invalidate;
end;
procedure TFormPerspective.btnFijarClick(Sender: TObject);
begin
  fraEditor.xDes := spnXdesp.Value;
  fraEditor.yDes := spnYdesp.Value;

  fraEditor.xCam  := spnXcam.Value;
  fraEditor.yCam  := spnYcam.Value;

  fraEditor.Alfa:=spnAlfa.Value;
  fraEditor.Fi:=spnFi.Value;
  fraEditor.Zoom:=spnZoom.Value;
  fraEditor.PaintBox1.Invalidate;
end;

procedure TFormPerspective.spnAlfaClick(Sender: TObject);
begin
  btnFijarClick(self);
end;
procedure TFormPerspective.spnAlfaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  btnFijarClick(self);
end;

procedure TFormPerspective.Timer1Timer(Sender: TObject);
begin
//  btnLeerClick(self);  //actualiza
end;

procedure TFormPerspective.Exec(fraEditor0: TfraVisorGraf);
begin
  fraEditor:= fraEditor0;
  self.Show;
end;

end.

