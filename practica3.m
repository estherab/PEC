% ESTHER ÁVILA BENITO
% LAURA PÉREZ JAMBRINA

%% APARTADO 1 - SUAVIZADO
% a) - Corrupción por ruido blanco gaussiano de media cero y varianza 0.05
Imagen  = imread('Tema04a.jpg','jpg');
ImagenRuido = mat2gray(imnoise(Imagen,'gaussian',0,0.05));
ImagenRuido = ImagenRuido(:,:,1);

% b) - Suavizado mediante promediado
nucleo = (1/9)*[1 1 1; 1 1 1; 1 1 1];
ImagenSuavizada = mat2gray(conv2(ImagenRuido,nucleo,'same'));

% c) - Suavizado gaussiano
sigma = 5;
size = 5;
nucleo = fspecial('gaussian', size, sigma);
ImagenSuavizadaGaussiana = mat2gray(conv2(ImagenRuido, nucleo, 'same'));

figure();
subplot(2,2,1); imshow(Imagen); 
title('Imagen original');
subplot(2,2,2); imshow(ImagenRuido); 
title('Imagen con ruido');
subplot(2,2,3); imshow(ImagenSuavizada); 
title('Imagen suavizada - promedio');
subplot(2,2,4); imshow(ImagenSuavizadaGaussiana); 
title('Imagen suavizada - gaussiana');

%% APARTADO 2 - HISTOGRAMA DE LA IMAGEN - REALZADO
ImagenIzda  = imread('Tema04b-lzda.jpg','jpg');
ImagenDcha  = imread('Tema04b-Dcha.jpg','jpg');

ImagenIzda = ImagenIzda(:,:,1);
ImagenDcha = ImagenDcha(:,:,1);

% a) - Histogramas
figure();
subplot(2,2,1); imshow(ImagenIzda); 
title('Imagen Iquierda');
subplot(2,2,2); imshow(ImagenDcha); 
title('Imagen Derecha');
subplot(2,2,3); imhist(ImagenIzda); 
title('Histograma Izquierda');
subplot(2,2,4); imhist(ImagenDcha); 
title('Histograma Derecha');

% b) - Ecualización del histograma
Equalizada = histeq(ImagenIzda);

figure();
subplot(2,2,1); imshow(ImagenIzda); 
title('Imagen Izquierda');
subplot(2,2,2); imshow(Equalizada); 
title('Imagen Izquierda ecualizada');
subplot(2,2,3); imhist(ImagenIzda); 
title('Histograma imagen Izquierda');
subplot(2,2,4); imhist(Equalizada); 
title('Histograma imagen Izquierda ecualizada');

% c) - Expansión del histograma
Imagen = double(ImagenIzda);

MIN_IN = min(min(Imagen)); MAX_IN = max(max(Imagen));
MIN_OUT = 0; MAX_OUT = 255;

Ri = ((Imagen - MIN_IN)./(MAX_IN-MIN_IN)).*((MAX_OUT-MIN_OUT)+MIN_OUT);

Ri = mat2gray(Ri);

figure();
subplot(2,2,1); imshow(ImagenIzda); 
title('Imagen oscurecida');
subplot(2,2,2); imhist(ImagenIzda); 
title('Histograma');
subplot(2,2,3); imshow(Ri); 
title('Imagen histograma expandido');
subplot(2,2,4); imhist(Ri); 
title('Histograma');

%% APARTADO 3 - FILTRADO HOMOMÓRFICO
clear all;
Imagen = imread('Tema04b-lzda.jpg','jpeg');

figure();
subplot(2,1,1); imshow(Imagen); 
title('Imagen original');

Imagen = double(Imagen(:,:,1));

t = size(Imagen);
M = t(1);
N = t(2);

Imagen = log(Imagen + 1);
Imagen = fftshift(fft2(Imagen));

R = 100;

FiltroPB = ones(M,N);

for i = 1:1:M
    for j = 1:1:N
       d = sqrt((i - M / 2) ^2 + (j - N / 2) ^2);
       if d < R 
          FiltroPB(i,j) = 0; 
       end
    end
end
FiltroPA = 1 - FiltroPB;

ImagenFiltrada = Imagen.*FiltroPA;
ImagenRestaurada = abs(ifft2(ImagenFiltrada));

ImagenRestaurada = exp(ImagenRestaurada) - 1;
Imagen = mat2gray(ImagenRestaurada);

subplot(2,1,2); imshow(Imagen); 
title('Imagen tras el filtro homomórfico');

%% APARTADO 4 - OPERACIONES RADIOMÉTRICAS
clear all; close all;

% lectura de la imagen original
II = imread('Tema04b-lzda.jpg','jpeg');

Imagen = double(II(:,:,1));

t = size(Imagen);
M = t(1);
N = t(2);

m1 = 1 / 2;
m2 = 2;  

L = 255; 

for i = 1:1:M
    for j = 1:1:N
        Res1(i,j) = L^(1-m1)*Imagen(i,j)^m1;
        Res2(i,j) = L^(1-m2)*Imagen(i,j)^m2;
        Res3(i,j) = L*log(1+Imagen(i,j))/log(1+L);
    end
end

Im1 = mat2gray(Res1);
Im2 = mat2gray(Res2);
Im3 = mat2gray(Res3);

figure();
subplot(2,2,1); imshow(II);  
title('Imagen original');
subplot(2,2,2); imshow(Im1); 
title('Raíz cuadrada');
subplot(2,2,3); imshow(Im2); 
title('Cuadrada');
subplot(2,2,4); imshow(Im3); 
title('Logarítmica');
