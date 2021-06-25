function varargout = WeightedProduct(varargin)
% WEIGHTEDPRODUCT MATLAB code for WeightedProduct.fig
%      WEIGHTEDPRODUCT, by itself, creates a new WEIGHTEDPRODUCT or raises the existing
%      singleton*.
%
%      H = WEIGHTEDPRODUCT returns the handle to a new WEIGHTEDPRODUCT or the handle to
%      the existing singleton*.
%
%      WEIGHTEDPRODUCT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WEIGHTEDPRODUCT.M with the given input arguments.
%
%      WEIGHTEDPRODUCT('Property','Value',...) creates a new WEIGHTEDPRODUCT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WeightedProduct_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WeightedProduct_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WeightedProduct

% Last Modified by GUIDE v2.5 25-Jun-2021 16:52:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WeightedProduct_OpeningFcn, ...
                   'gui_OutputFcn',  @WeightedProduct_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before WeightedProduct is made visible.
function WeightedProduct_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WeightedProduct (see VARARGIN)

%import file xlsx & menampilkan pada tabel data
global data;
data.Mydata = xlsread('Real estate valuation data set');
data.Mydata = [data.Mydata(:,3) data.Mydata(:,4) data.Mydata(:,5) data.Mydata(:,8)];
data.Mydata = data.Mydata(1:50,:);
set(handles.data,'Data',data.Mydata);


% Choose default command line output for WeightedProduct
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WeightedProduct wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WeightedProduct_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in prosesbtn.
function prosesbtn_Callback(hObject, eventdata, handles)
% hObject    handle to prosesbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global data;

k = [0,0,0,1];%atribut tiap-tiap kriteria, dimana nilai 1=atrribut keuntungan, dan  0= atribut biaya
w = [3,5,4,1];%Nilai bobot tiap kriteria
 
%tahapan pertama, perbaikan bobot
[m n] = size(data.Mydata); %inisialisasi ukuran data
w  = w./sum(w); %membagi bobot per kriteria dengan jumlah total seluruh bobot

%normalisasi matrix 
S = zeros(m,1);%vektor s
V = zeros(m,1);%vektor v

%tahapan kedua, melakukan perhitungan vektor(S) per baris (alternatif)
for j=1:n,
    if k(j)==0, w(j)=-1*w(j);
    end;
end;
for i=1:m,
    S(i,:)=prod(data.Mydata(i,:).^w);
end;

%tahapan ketiga, perhitungan vektor (V)
for j=1:m,
    V(j,:) = S(j,:)/sum(sum(S));
end;

%proses memasukkan vektor s dan v ke dalam matriks
data.Mydata = [data.Mydata(:,1) data.Mydata(:,2) data.Mydata(:,3) data.Mydata(:,4) S(:,1) V(:,1)];
set(handles.hasilAsli,'Data',data.Mydata); %menampilkan ke tabel hasil belum urut

%pengurutan hasil dari terbesar ke terkecil
data.Mydata1 = data.Mydata;
for i=m:-1:1,
    for j=1:i-1,
       if data.Mydata1(j,6)<data.Mydata1(j+1,6),
           T = data.Mydata1(j,:);
           data.Mydata1(j,:) = data.Mydata1(j+1,:);
           data.Mydata1(j+1,:) = T; 
       end;
   end;
end;
set(handles.hasilUrut,'Data',data.Mydata1); %menampilkan ke tabel hasil sudah urut
