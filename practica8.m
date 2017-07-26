% Esther �vila Benito
% Laura P�rez Jambrina

%% APARTADO 1 - CONSTRUCCI�N DE UN ANAGLIFO
% Creaci�n de una imagen anaglifo a partir de las im�genes CorreodorI y 
% CorredorD 
izda = imread('CorredorI.tif');
dcha = imread('CorredorD.tif');

anaglifo(:,:,1) = izda; 
anaglifo(:,:,2) = dcha; 
anaglifo(:,:,3) = dcha; 

figure(); 
subplot(1,3,1); imshow(izda); title('CorredorI.tif');
subplot(1,3,2); imshow(dcha); title('CorredorD.tif');
subplot(1,3,3); imshow(anaglifo); title('Anaglifo');
% Visto con las gafas, se observa que cada ojo ve una imagen ligeramente
% diferente. El ojo cubierto por el filtro rojo ve las partes rojas de la
% imagen como "blancas" y las partes azules como "oscuras". El ojo 
% cubierto por el filtro azul percibe el efecto opuesto.

%% APARTADO 2 - CORRESPONDENCIA POR CORRELACI�N
im1 = imread('CMU-parkmeter-r.tif', 'tif');
im2 = imread('CMU-parkmeter-l.tif', 'tif');

paso = 1;
Dcha = im1(1:1:end, 1:1:end);
Izda = im2(1:1:end, 1:1:end);

figure(); imshow(Izda); impixelinfo; title('Imagen Izquierda')
figure(); imshow(Dcha); impixelinfo; title('Imagen Derecha')

[M,N,a] = size(Izda);

% ancho de la ventana
w = 2;

% m�xima disparidad
DispMax = 12;

% Mapa de disparidad resultante
MapaDisparidad = zeros(M,N);

tic
for i=1+w:1:M-w
    for j=1+w:N-w-DispMax
       VentanaDcha = Dcha(i-w:i+w,j-w:j+w);
       
       if i==91 && j== 94
         parar = 1;
       end
       
       disparidades = zeros(1,DispMax-1);
       k = 1;
       
       for h=0:1:DispMax
          VentanaIzda = Izda(i-w:i+w,j+h-w:j+h+w);
          c = corr2(VentanaDcha,VentanaIzda);
          if isnan(c)
            c = 0;
          end
          disparidades(k) = c;
          k = k + 1;
       end
       
       % encontrar la posici�n del m�ximo valor de disparidad
       disparidades = abs(disparidades);
       Max = max(disparidades);
       indice = find(disparidades == Max);
       
       % cuando haya varios m�ximos elegimos siempre el primero
       d = indice(1);
       MapaDisparidad(i,j) = d; 
    end
end

figure(); imagesc(MapaDisparidad); impixelinfo; colorbar; 
title('Mapa Disparidad')
toc
% El objetivo de un algoritmo est�reo de c�lculo de disparidad es obtener 
% la profundidad en todos los p�xeles de las im�genes del par est�reo. 

%% APARTADO 3 - CORRESPONDENCIA MEDIANTE HARRIS
StereoCorrelacionHarris

%% APARTADO 4 - PR�CTICA OPCIONAL: STEREO LANKTON
EstereoLankton