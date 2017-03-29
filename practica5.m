% Laura Pérez Jambrina
% Esther Ávila Benito

%% APARTADO 1 - BINARIZACIÓN DE REGIONES
% a) - Lectura de la imagen Tema05b.bmp. Visualización del canal rojo 
% y del histograma. Binarización de la imagen con el umbral 100 / 255. 
imagen = imread('Tema05b.bmp','bmp');
imagenR = imagen(:,:,1);

figure();

subplot(2,2,1); imshow(imagen); title('Imagen original');
subplot(2,2,2); imshow(imagenR); title('Imagen original (canal rojo)');
subplot(2,2,3); imhist(imagenR); title('Histograma (canal rojo)');

T = 100;
umbral = T / 255;
imagenBin = im2bw(imagenR, umbral);
subplot(2,2,4); imshow(imagenBin); title('Imagen binarizada, T = 100');

% b) - Umbral automático de binarización mediante el método Otsu.
% Binarización de la imagen con el umbral obtenido. Visualización
% del resultado y del umbral mediante la función disp.
T = graythresh(imagenR);

imagenBin = im2bw(imagenR, T);
figure();
subplot(1,2,1); imshow(imagenR); title('Imagen original (canal rojo)');
subplot(1,2,2); imshow(imagenBin); 
title('Imagen binarizada con umbral automático');
fprintf('Umbral: %f \n', double(T * 255));

% Se observa como se binariza la imagen: las tortugas quedan marcadas en
% negro, mientras que el resto de la imagen queda en blanco. Los dos
% umbrales utilizados son muy parejos, de ahí que las imágenes binarizadas
% sean prácticamente iguales

%% APARTADO 2 - ETIQUETADO DE COMPONENTES CONEXAS
% a) - Obtención de la imagen con las regiones identificadas 
% con un número.
% vecindad = 8
[Etiquetas, N] = bwlabel(~imagenBin, 8);
figure(); imshow(Etiquetas); title('Etiquetas'); impixelinfo();

% b) - Cambio de la etiqueta 1 por N+1.
[x, y] = size(imagenBin);
Etiquetas2 = Etiquetas;

for i= 1:x
    for j=1:y
        if (Etiquetas2(i,j) == 1)
            Etiquetas2(i,j) = N + 1;
        end
    end
end

figure(); imagesc(Etiquetas2); colorbar();
% Aquí se observa como cada tortuga, o a "ojos" del ordenador cada
% agrupación de puntos, las componentes conexas las clasifica con una
% etiqueta, quedando así diferenciadas cada una de las tortugas. Hay que
% tener en cuenta que el "ruido" también lo está agrupando (como las patas
% traseras de la tortuga derecha, que al estar tapadas parcialmente por la
% arena, hay una parte que las clasifica a parte).

%% APARTADO 3 - EXTRACCIÓN DE REGIONES POR COLOR
% a) - Lectura de la imagen Tema05.jpg y extracción de los canales R, G y B
% submuestreados x4. Extracción de píxeles con valores dominantes en rojo.
imagen = imread('Tema05b.jpg','jpg');

imagen = imagen(1:4:end, 1:4:end,:);
r = imagen(:,:,1);
g = imagen(:,:,2);
b = imagen(:,:,3);

[M, N] = size(r);

RR = zeros(M,N);
GR = zeros(M,N);
BR = zeros(M,N);

T = 70;

for i=1:M
    for j=1:N
        if (r(i,j) > T && (r(i,j) > g(i,j)) && (r(i,j) > b(i,j)))
            RR(i,j) = 255;
        end
        if (g(i,j) > T && (g(i,j) > r(i,j)) && (g(i,j) > b(i,j)))
            GR(i,j) = 255;
        end 
        if (b(i,j) > T && (b(i,j) > r(i,j)) && (b(i,j) > g(i,j)))
            BR(i,j) = 255;
        end 
    end
end

figure();
subplot(2,2,1); imshow(imagen); title('Imagen original');
subplot(2,2,2); imshow(RR); title('Rojo');
subplot(2,2,3); imshow(GR); title('Verde');
subplot(2,2,4); imshow(BR); title('Azul');

% En este apartado se ven claras diferencias al binarizar usando diferentes
% componentes de color de las imágenes u otras: binarizando por el verde se
% diferencia entre el césped o las hojas de los árboles, por azul el cielo
% del resto.

%% APARTADO 4 - OPERACIONES MORFOLÓGICAS
% a) - Dilatación, erosión, apertura, cierre, bordes

% Dilatación
BW = bwmorph(imagenBin,'dilate',1);
figure(); 
subplot(2,3,1); imshow(imagenBin); title('Imagen original');
subplot(2,3,2); imshow(BW); title('Dilatación');

% Erosión
BW = bwmorph(imagenBin,'erode',1);
subplot(2,3,3); imshow(BW); title('Erosión');

% Apertura
BW = bwmorph(imagenBin,'open',1);
subplot(2,3,4); imshow(BW); title('Apertura');

% Cierre
BW = bwmorph(imagenBin,'close',1);
subplot(2,3,5); imshow(BW); title('Cierre');

% Bordes
B = bwmorph(imagenBin,'open',1) - bwmorph(imagenBin,'erode',1);
subplot(2,3,6); imshow(B); title('Bordes');

%% APARTADO 5 - PRÁCTICAS OPCIONALES
% a) - Binarización de la componente roja de la imagen Tema05b.bmp
% con el umbral obtenido por Ridler-Calvard
% Segmentación de regiones método de Ridler-Calvard
imagen = imread('Tema05b.bmp','bmp');
imagenR = imagen(:,:,1);
imagenR = imagenR + 1; % para evitar índices de cero en los arrays
L = 256; % número de niveles de intensidad
[m,n] = size(imagenR);
e = eps; % desviación
P = zeros(1,L);

for i = 1:1:m
    for j = 1:1:n
        P(imagenR(i,j)) = P(imagenR(i,j)) + 1;
    end
end

% pi = P / (m * n);
T1 = mean2(imagenR);
% dividir los datos en dos clases: w1 y w2
h = 1;

for i = 1:1:m
    for j = 1:1:n
        if imagenR(i,j) <= T1
            w1(h) = imagenR(i,j);
            h = h + 1;
        end
    end
end

h = 1;

for i = 1:1:m
    for j = 1:1:n
        if imagenR(i,j) > T1
            w2(h) = imagenR(i,j);
            h = h + 1;
        end
    end
end

m1 = mean(w1);
m2 = mean(w2);
T2 = (m1 + m2) / 2;
iteracion = 0;

while abs(T1 - T2) > e
    T1 = T2;
    h = 1;
    for i = 1:1:m
        for j = 1:1:n
            if imagenR(i,j) <= T1
                w1(h) = imagenR(i,j);
                h = h + 1;
            end
        end
    end
    
    h = 1;
    
    for i = 1:1:m
        for j = 1:1:n
            if imagenR(i,j) > T1
                w2(h) = imagenR(i,j);
                h = h + 1;
            end
        end
    end

    m1 = mean(w1);
    m2 = mean(w2);
    T2 = (m1 + m2) / 2;
    iteracion = iteracion + 1;
end

fprintf('Umbral final: %f \n', double(T2));
subplot(1,2,1); imshow(imagenR-1); title('Imagen original')

T = (T2 - 1) / 255;
binaria = im2bw(imagenR - 1, T); 
% los signos - son para corregir la suma por 1 inicial
subplot(1,2,2); imshow(binaria); title('Imagen binarizada T = 101')

% b) Con la función bwmorph relaizar las operaciones bothat, skel, thin
% y shrink
imagen = imread('Tema05b.bmp','bmp');
imagenR = imagen(:,:,1);
T = graythresh(imagenR);
I = imagenR < 255*T;
N = inf;
figure(); imshow(imagenR); title('Imagen original');

% Bothat
BW = bwmorph(I,'bothat',N);
figure(); imshow(BW); title('Bothat');

% Skel
BW = bwmorph(I,'skel',N);
figure(); imshow(BW); title('Skel');

% Thin
BW = bwmorph(I,'thin',N);
figure(); imshow(BW); title('Thin');

% Shrink
BW = bwmorph(I,'shrink',N);
figure(); imshow(BW); title('Shrink');




