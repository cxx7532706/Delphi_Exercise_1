unit uWidgetForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uWidget, uWidgetReader;

type
  TWidgetForm = class(TForm)
    DisplayMemo: TMemo;
    OpenFileButton: TButton;
    procedure OpenFileButtonClick(Sender: TObject);
  private
    procedure DisplayResult(WidgetList : TWidgetList; DisplayMemo : TMemo);
  end;

var
  WidgetForm: TWidgetForm;

implementation

{$R *.dfm}

procedure TWidgetForm.OpenFileButtonClick(Sender: TObject);
var
  OpenFile : TOpenDialog;
  WidgetList : TWidgetList;
  WidgetReader : TWidgetReader;
begin
  OpenFile := TOpenDialog.Create(self);
  try
    OpenFile.InitialDir := GetCurrentDir;
    OpenFile.DefaultExt := 'txt';
    OpenFile.Filter := 'Text File(*.txt)|*.txt|all files(*.*)|*.*';
    OpenFile.FilterIndex := 1;
    OpenFile.Options := [ofFileMustExist];
    if OpenFile.Execute then
    begin
      WidgetList := TWidgetList.Create;
      try
        WidgetReader := TWidgetReader.Create;
        try
          WidgetReader.LoadFileToList(OpenFile.FileName,WidgetList);
          DisplayMemo.Text :='';
          DisplayResult(WidgetList, DisplayMemo);
        finally
          WidgetReader.Free;
        end;
      finally
        WidgetList.Free;
      end;
    end;
  finally
    OpenFile.Free;
  end;
end;

procedure TWidgetForm.DisplayResult(WidgetList : TWidgetList; DisplayMemo : TMemo);
var
  I : Integer;
  Widget : TWidget;
begin
  WidgetList.SortById;
  for I := 0 to WidgetList.Count - 1 do
  begin
    Widget := WidgetList.Items[I];
    DisplayMemo.Lines.Add(Widget.AsString);
  end;

end;

end.
