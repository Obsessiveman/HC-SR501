function varargout = Hc_sr501_(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Hc_sr501__OpeningFcn, ...
                   'gui_OutputFcn',  @Hc_sr501__OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function Hc_sr501__OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);


function varargout = Hc_sr501__OutputFcn(~, ~, handles) 

varargout{1} = handles.output;


function start_Callback(~, ~, handles)

set(handles.stop,'UserData',0);  %Ölçümü durdur butonuna basili degil olarak baglaniyor.

clear SerPIC;
SerPIC = arduino('COM5','Mega2560');         %Arduinonun bagli oldugu port ve cinsi belirleniyor.

global x1; %x1 adinda bir degisken tanimlaniyor.
x1=0; %x1 degiskenine ilk degeri sifir olarak ataniyor.

global x2; %x2 adinda bir degisken tanimlaniyor.
x2=0; %x2 degiskenine ilk degeri sifir olarak ataniyor.

global x3; %x3 adinda bir degisken tanimlaniyor.
x3=0; %x3 degiskenine ilk degeri sifir olarak ataniyor.

global kisi;
kisi=0;

try
    
            while (1) 
                if get(handles.stop,'UserData')==1  %Eger ölçümü durdur butonuna basilirsa döngüden çikiliyor.
                    break 
                end
                b = readDigitalPin(SerPIC,'D2');
                c = readDigitalPin(SerPIC,'D3');
                d = readDigitalPin(SerPIC,'D4');
                %set(handles.sensor1,'string',[num2str(b)]); %a degiskenindeki veri gui ekranına yazdiriliyor.
                               
                x1=x1+1; %Zaman ekseninin sürekliligi için.Döngü çalistikça zaman ekseni 1 sn araliklarla artacak.
                x2=x2+1; %Zaman ekseninin sürekliligi için.Döngü çalistikça zaman ekseni 1 sn araliklarla artacak.
                x3=x3+1; %Zaman ekseninin sürekliligi için.Döngü çalistikça zaman ekseni 1 sn araliklarla artacak.

                y1(x1)= b; %Seri porttan okunan veriler zamana bagli bir fonk. tutuluyor.
                y2(x2)= c; %Seri porttan okunan veriler zamana bagli bir fonk. tutuluyor.
                y3(x3)= d; %Seri porttan okunan veriler zamana bagli bir fonk. tutuluyor.

                drawnow;  %Gerçek zamanli grafik çizdirmek için gerekli komut.
                axes(handles.tablo); %Grafigin çizilecegi bilesen seçiliyor.
                plot(y1,'r','linewidth',2) %Sürekli zamanli sinyal çizdiriliyor.
                title('Zaman-Değer Grafigi'); %Grafigin basligi ayarlaniyor.
                xlabel('Zaman (sn)'); %Grafigin x ekseninde yazacak yazi belirleniyor.
                ylabel('Değer'); %Grafigin y ekseninde yazacak yazi belirleniyor.
                ylim([0 2]) %y ekseninin araligi 0-2 arasi seçiliyor.


                axes(handles.tablo2); %Grafigin çizilecegi bilesen seçiliyor.
                plot(y2,'r','linewidth',2) %Sürekli zamanli sinyal çizdiriliyor.
                title('Zaman-Değer Grafigi'); %Grafigin basligi ayarlaniyor.
                xlabel('Zaman (sn)'); %Grafigin x ekseninde yazacak yazi belirleniyor.
                ylabel('Değer'); %Grafigin y ekseninde yazacak yazi belirleniyor.
                ylim([0 2]) %y ekseninin araligi 0-2 arasi seçiliyor.

                axes(handles.tablo3); %Grafigin çizilecegi bilesen seçiliyor.
                plot(y3,'r','linewidth',2) %Sürekli zamanli sinyal çizdiriliyor.
                title('Zaman-Değer Grafigi'); %Grafigin basligi ayarlaniyor.
                xlabel('Zaman (sn)'); %Grafigin x ekseninde yazacak yazi belirleniyor.
                ylabel('Değer'); %Grafigin y ekseninde yazacak yazi belirleniyor.
                ylim([0 2]) %y ekseninin araligi 0-2 arasi seçiliyor.

                if ((b==0) && (c==0) && (d==0)) %Sensorler cisim gormuyorsa
                        set(handles.sensor1,'string','yok')
                        set(handles.sensor2,'string','yok')
                        set(handles.sensor3,'string','yok')
                        set(handles.kisi,'string',[kisi])
                        %pause(1);
                
                elseif ((b==0) && (c==0) && (d==1)) %Sadece 3. sensör cisim görüyorsa
                        set(handles.sensor1,'string','yok')
                        set(handles.sensor2,'string','yok')
                        set(handles.sensor3,'string','var')
                        set(handles.kisi,'string',[kisi])
                        %pause(1);

                elseif ((b==0) && (c==1) && (d==0)) %Sadece 2. sensor cisim goruyorsa
                        set(handles.sensor1,'string','yok')
                        set(handles.sensor2,'string','var')
                        set(handles.sensor3,'string','yok')
                        set(handles.kisi,'string',[kisi])
                        %pause(1);

                elseif ((b==0) && (c==1) && (d==1)) %Cismi 1. ve 2. sensor goruyorsa.
                        set(handles.sensor1,'string','yok')
                        set(handles.sensor2,'string','var')
                        set(handles.sensor3,'string','var')
                        set(handles.kisi,'string',[kisi])
                        %pause(1);

                elseif ((b==1) && (c==0) && (d==0)) %Sadece 1. sensör cisim goruyorsa
                        set(handles.sensor1,'string','var')
                        set(handles.sensor2,'string','yok')
                        set(handles.sensor3,'string','yok')
                        kisi = kisi + 1;
                        set(handles.kisi,'string',[kisi])
                        pause(2); % Kişi sayısının art arda artmaması için bekletiyoruz.

                elseif ((b==1) && (c==0) && (d==1)) %Cismi 1. ve 3. sensor goruyorsa
                        set(handles.sensor1,'string','var')
                        set(handles.sensor2,'string','yok')
                        set(handles.sensor3,'string','var')
                        kisi = kisi + 1;
                        set(handles.kisi,'string',[kisi])
                        pause(2); % Kişi sayısının art arda artmaması için bekletiyoruz.

                elseif ((b==1) && (c==1) && (d==0)) %Cismi 1. ve 2. sensor goruyorsa
                        set(handles.sensor1,'string','var')
                        set(handles.sensor2,'string','var')
                        set(handles.sensor3,'string','yok')
                        kisi = kisi + 1;
                        set(handles.kisi,'string',[kisi])
                        pause(2); % Kişi sayısının art arda artmaması için bekletiyoruz.

                elseif ((b==1) && (c==1) && (d==1)) %Cismi tüm sensörler görüyorsa (3 sensör birden gördüğü için 1 den fazla cisim olmak zorunda)
                        set(handles.sensor1,'string','var')
                        set(handles.sensor2,'string','var')
                        set(handles.sensor3,'string','var')
                        set(handles.kisi,'string',[kisi]) 
                        %pause(1);
                end
                drawnow
            end

catch 
     errordlg('Bir Hata Oldu !! ','Hata') %Hata durumunda try-catch döngüsünde catch yapan koda hata mesajı veriliyor.
end
        clear SerPIC; % Haberleşme siliniyor.

function stop_Callback(hObject, eventdata, handles)

set(handles.stop,'UserData',1) %Akış durduruluyor.
set(handles.sensor1,'string','yok'); %Bölgeyi gösteren kutucuğun akışı durduruluyor.
set(handles.sensor2,'string','yok'); %Bölgeyi gösteren kutucuğun akışı durduruluyor.
set(handles.sensor3,'string','yok'); %Bölgeyi gösteren kutucuğun akışı durduruluyor.
set(handles.kisi,'string',0); %Bölgeyi gösteren kutucuğun akışı durduruluyor.
cla(handles.tablo); %Tablo siliniyor. 1. sensor icin
cla(handles.tablo2); %Tablo2 siliniyor. 2. sensor icin
cla(handles.tablo3); %Tablo3 siliniyor. 3. sensor icin


function kisi_Callback(hObject, eventdata, handles)


function kisi_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bolge_Callback(hObject, eventdata, handles)


function bolge_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cisim_Callback(hObject, eventdata, handles)



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to sensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sensor2 as text
%        str2double(get(hObject,'String')) returns contents of sensor2 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to sensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sensor3 as text
%        str2double(get(hObject,'String')) returns contents of sensor3 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sensor1_Callback(hObject, eventdata, handles)
% hObject    handle to sensor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sensor1 as text
%        str2double(get(hObject,'String')) returns contents of sensor1 as a double


% --- Executes during object creation, after setting all properties.
function sensor1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sensor2_Callback(hObject, eventdata, handles)
% hObject    handle to sensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sensor2 as text
%        str2double(get(hObject,'String')) returns contents of sensor2 as a double


% --- Executes during object creation, after setting all properties.
function sensor2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sensor3_Callback(hObject, eventdata, handles)
% hObject    handle to sensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sensor3 as text
%        str2double(get(hObject,'String')) returns contents of sensor3 as a double


% --- Executes during object creation, after setting all properties.
function sensor3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
