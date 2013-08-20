{********************************************************************
 COMPONENTE: TGrabadora

 DESC: Componente no visual que permite todo lo relacionado con
        la grabacion de sonido. Permite recibir los buffers con
        muestras del tamaño que se quiera.

 POR: Jose Luis Blanco Claraco © 20-ABR-2003

********************************************************************}
unit unTGrabadora;

interface

uses
  Windows, Messages, SysUtils, Classes, MMSystem;

type

  TBufferEvent = procedure (ptr : PChar ) of object;

  TGrabadora = class(TComponent)
  private

    { Private declarations }
    estoyGrabando       : Boolean;      // Indica si estoy grabando en este momento.

    // Caracteristicas del canal de grabacion:
    SelectedDevice      : Integer;
    SampleRate          : Integer;

    NumHeaders          : Integer;
    TamHeaders          : LongInt;


    // Handles:
    HandleIN            : HWAVEIN;
    hwnd                : HWND;

    DoOnBuffer          : TBufferEvent;

    procedure waveInProc( var msg: TMessage );

  protected
        procedure SetGrabando( aGrabando: Boolean );

        procedure SetSampleRate( aSample : Integer);

        procedure SetDevice( aDev : Integer );
        procedure SetNumHeaders( aNum : Integer );
        procedure SetTamHeaders( aTam : LongInt );


        procedure ProcesaErrores( err_code : Integer );

  public
    { Public declarations }
    buffers_procesados  : LongInt;

    cabeceras           : array of WAVEHDR;

        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;

    procedure IniciarGrabacion;
    procedure DetieneGrabacion;

    property Grabando: Boolean read estoyGrabando write SetGrabando default false;


  published
    { Properties de la clase }
    property Dispositivo: Integer read SelectedDevice write SetDevice default -1;
    property FrecMuestreo: Integer read SampleRate write SetSampleRate default 44100;
    property BuffersProcesados: LongInt read buffers_procesados default 0;

    property NumeroBuffers: Integer read NumHeaders write SetNumHeaders default 5;
    property SizeBuffers: LongInt read TamHeaders write SetTamHeaders default 10000;

    property OnBuffer: TBufferEvent read DoOnBuffer write DoOnBuffer;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JLBC', [TGrabadora]);
end;


{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.waveInProc( var msg: TMessage );
var
        ptr     : PWaveHdr;
        i       : Integer;
        final   : Boolean;
begin
        case msg.Msg of
                // Buffer ha sido completado:
                MM_WIM_DATA:
                begin
                        ptr:= Pointer(msg.LParam);

                        // Son restos y hay que liberarlos?
                        if not EstoyGrabando then
                        begin
                                ProcesaErrores(
                                        waveInUnprepareHeader (
                                                HandleIN,
                                                ptr,
                                                sizeof( WAVEHDR ) ) );

                                FreeMemory( ptr.lpData );
                                ptr.lpData:=nil;

                                // Si era la ultima, cerrar el canal:
                                final:=true;
                                for i:=0 to length(cabeceras)-1 do
                                        if cabeceras[i].lpData<>nil then final:=false;

                                if final then
                                begin
                                	ProcesaErrores( waveInClose( HandleIN ) );
                                        SetLength( cabeceras, 0 );
                                        exit;
                                end;
                        end
                        else
                        begin
                                Inc( buffers_procesados );
                                      
                                // Son datos de grabacion validos:
                                // Avisar en el OnBuffer:
                                if Assigned(DoOnBuffer) then
                                        DoOnBuffer( ptr.lpData );

                                // Volver a meter en el buffer:
                                ProcesaErrores(
                                        waveInAddBuffer (
                                                HandleIN,
                                                ptr,
                                                sizeof( WAVEHDR ) ) );
                        end;

                end;



        end;



end;


{----------------------------------------------------------------

----------------------------------------------------------------}
constructor TGrabadora.Create(AOwner: TComponent); 
begin
        inherited Create(AOwner);

        SelectedDevice:=-1;
        SampleRate:= 44100;
        NumHeaders:= 10;
        TamHeaders:= 10000;

        hwnd:= AllocateHWnd( waveInProc );
end;

{----------------------------------------------------------------

----------------------------------------------------------------}
destructor TGrabadora.Destroy;
begin
        // Liberar cabeceras:


        DeallocateHWnd( hwnd );        
end;


{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.IniciarGrabacion;
var
        wf      :  tWAVEFORMATEX;
        i       : Integer;
begin
        if estoyGrabando then raise Exception.create('TGrabadora: Ya estoy grabando!');

	wf.wFormatTag:=WAVE_FORMAT_PCM;
	wf.nChannels:=1;
	wf.nSamplesPerSec:= SampleRate;
	wf.nBlockAlign:= 2;
	wf.nAvgBytesPerSec:=wf.nBlockAlign*wf.nSamplesPerSec;
	wf.wBitsPerSample:= 16;
	wf.cbSize:=0;

	// Abrir canal
	ProcesaErrores( waveInOpen(
		@HandleIN,		// HANDLE
		SelectedDevice, 		// Device ID
		@wf,		        // Formato WAVE
		DWORD(hwnd),	// Callback
		0,
		CALLBACK_WINDOW) );


        // Quitar posibles cabeceras si las hay:

        // ....
        SetLength( Cabeceras, 0 );

        // Preparar cabeceras:

        SetLength( Cabeceras, NumHeaders );

        for i:=0 to NumHeaders-1 do
        begin
                cabeceras[i].lpData:= GetMemory( TamHeaders * 2{!!!} );
                cabeceras[i].dwBufferLength:= TamHeaders * 2{!!!} ;
                cabeceras[i].dwUser:= i;
                ProcesaErrores(
                        waveInPrepareHeader (
                                HandleIN,
                                @cabeceras[i],
                                sizeof( WAVEHDR ) ) );

                ProcesaErrores(
                        waveInAddBuffer (
                                HandleIN,
                                @cabeceras[i],
                                sizeof( WAVEHDR ) ) );
        end;

        // Y empezar a grabar:
        ProcesaErrores( waveInStart( HandleIN ) );


        estoyGrabando:=true;
end;

{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.DetieneGrabacion;
begin
        if not estoyGrabando then raise Exception.create('TGrabadora: No estaba grabando!');

        // Parar grabacion:
        ProcesaErrores( waveInStop ( HandleIN ) );

        estoyGrabando:=false; // Con esto la rutina de msgs ya liberara las cabeceras

	ProcesaErrores( waveInReset( HandleIN ) );

end;

{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.SetGrabando( aGrabando: Boolean );
begin
        if estoyGrabando then
        begin
                if aGrabando=false then DetieneGrabacion;
        end
        else
                if aGrabando=true then IniciarGrabacion;
end;

{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.SetDevice( aDev : Integer );
begin
        if estoyGrabando then raise Exception.create('TGrabadora: No se puede cambiar dispositivo durante la grabacion!');

        SelectedDevice:= aDev;
end;


{----------------------------------------------------------------
        Procesa errores y los mues
----------------------------------------------------------------}
procedure TGrabadora.ProcesaErrores( err_code : Integer);
var
        texto : array [0..200] of char;
begin
        if err_code=MMSYSERR_NOERROR then exit;

	waveInGetErrorText( err_code,  texto,199);

        raise Exception.create('TGrabadora: Error de MMSYSTEM: '+texto );
        
end;

{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.SetSampleRate( aSample : Integer);
begin
        if estoyGrabando then raise Exception.create('TGrabadora: No se puede cambiar frec. muestreo durante la grabacion!');
        SampleRate:= aSample;
end;

{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.SetNumHeaders( aNum : Integer );
begin
        if estoyGrabando then raise Exception.create('TGrabadora: No se puede cambiar parametro durante la grabacion!');

        NumHeaders:= aNum;
end;

{----------------------------------------------------------------

----------------------------------------------------------------}
procedure TGrabadora.SetTamHeaders( aTam : LongInt );
begin
        if estoyGrabando then raise Exception.create('TGrabadora: No se puede cambiar parametro durante la grabacion!');

        TamHeaders:= aTam;
end;



end.
