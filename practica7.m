% Laura Pérez Jambrina
% Esther Ávila Benito

%% APARTADO 1 - DETECCIÓN DE CAMBIOS
% a) - Lectura de imágenes y transformación al formato HSI. Diferencia
% entre las dos imágenes de intensidad.
im1 = imread('Tema07-1.jpg', 'jpg');
im2 = imread('Tema07-2.jpg', 'jpg');

hsi1 = rgb2hsv(im1); 
hsi2 = rgb2hsv(im2);

hsi1B = hsi1(:,:,3);
hsi2B = hsi2(:,:,3);

dif = abs(hsi1B - hsi2B);

D = mat2gray(dif);

figure();
subplot(2,2,1); imshow(im1); impixelinfo; title('Tema07-1');
subplot(2,2,2); imshow(im2); impixelinfo; title('Tema07-2');
subplot(2,2,3); imshow(D); impixelinfo; title('Diferencia');
subplot(2,2,4); imshow(1-D); impixelinfo; title('Diferencia invertida');

% Se observa que en las imágenes de diferencia queda marcado donde las
% imágenes difieren, como por ejemplo el camión que aparece en la imagen 2
% pero no en la 1

%% APARTADO 2 - DIFERENCIA ACUMULADA
% a) - Acumulación de las diferencias sobre una imagen de ceros.
ref = double(imread('Pica30.jpg'));

[M,N,o] = size(ref);

acu = zeros(M, N, o);

N = 17;

for i = 31:57
    I = double(imread(strcat('Pica', num2str(i),'.jpg')));
    
    % Acumulador
    ak = (i-1) / (N-1);
    acu = acu + ak * abs(ref - I);
end

resultado = mat2gray(acu(:,:,1));

figure();
subplot(1,2,1); imshow(resultado); title('Diferencias');

% b) - Binarización y eliminación de píxeles superfluos. Erosión de la
% imagen
T = graythresh(resultado);

binaria = resultado > T;
binaria2 = imerode(binaria, ones(3));

subplot(1,2,2); imshow(binaria2); title('Diferencias binaria erosionada');

% Aquí podemos observar que queda marcado el recorrido del avión, además de
% las nubes y los coches de la carretera.
% En la imagen primera se ve muy borroso, pero tras binarizarla los
% movimientos aparecen muchos más marcados, pero con bastante ruido.

%% APARTADO 3 - FLUJO ÓPTICO MEDIANTE LUKAS-KANADE
% a) - Transformación al formato HSI. Cálculo de derivadas con operadores
% de Sobel
im1 = imread('Tema07-3.bmp', 'bmp');
im2 = imread('Tema07-4.bmp', 'bmp');

hsi1 = rgb2hsv(im1);
hsi2 = rgb2hsv(im2);

hsi1I = hsi1(:,:,3);
hsi2I = hsi2(:,:,3);

ho = [-1 0 1;
      -2 0 2;
      -1 0 1];
  
hv = [-1 -2 -1;
       0  0  0;
       1  2  1];
   
hu = ones(3);

fx = conv2(hsi1I, ho, 'same') + conv2(hsi2I, ho, 'same');
fy = conv2(hsi1I, hv, 'same') + conv2(hsi2I, hv, 'same');
ft = conv2(hsi1I, hu, 'same') - conv2(hsi2I, hu, 'same');

u = zeros(size(hsi1I));
v = zeros(size(hsi1I));

windowSize = 5;

halfWindow = floor(windowSize / 2);

for i = halfWindow+1:size(fx,1) - halfWindow
   for j = halfWindow+1:size(fx,2) - halfWindow
      curFx = fx(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      curFy = fy(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      curFt = ft(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      
      curFx = curFx';
      curFy = curFy';
      curFt = curFt';

      curFx = curFx(:);
      curFy = curFy(:);
      curFt = -curFt(:);
      
      A = [curFx curFy];
      
      U = pinv(A'*A)*A'*curFt;
      
      u(i,j)=U(1);
      v(i,j)=U(2);
   end;
end;

% 1) Cambiamos las filas de orden
u = flipud(u); v = flipud(v);

% 2) Aplicamos el filtro de la mediana en vecindades [5,5]
mu = medfilt2(u,[5 5]); mv = medfilt2(v,[5 5]);

% 3) Aplicamos dos descomposiciones piramidales gaussianas para reducir la
% dimensión de las matrices u y v
ru = reducir(reducir(mu)); rv = reducir(reducir(mv));
escala = 0; % valor por defecto (escalado de las flechas de vectores)

figure(); 
subplot(2,1,1); imshow(im1); title('Primera imagen');
subplot(2,1,2); imshow(im2); title('Segunda imagen');
figure(); quiver(ru, -rv, escala,'r','LineWidth',2); % axis equal
title('Movimientos');

% Se observa que las flechas indican el sentido del movimiento (de los
% objetos) entre las dos imágenes. También se observa que, si se reescala
% la imagen para que sea más pequeña, tienden a desaparecer las flechas que 
% no apuntan exactamente a la dirección de movimiento. Esto puede causar 
% pérdida de información.








