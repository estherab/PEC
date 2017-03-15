% Esther Ávila Benito
% Laura Pérez Jambrina
%% APARTADO 1 - PERFILES DE INTENSIDAD

% a) - Leer la imagen Tema05a.jpg. Mostrarla por pantalla y trazar varios 
% perfiles de intensidad mediante su representación gráfica. 
Imagen = imread('Tema05a.jpg','jpg');
figure(); imshow(Imagen(:,:,1)); impixelinfo
improfile;

% b) - Interpretar visualmente el perfil o perfiles obtenidos en función de 
% la línea o líneas trazadas sobre la imagen. Al trazar una línea que cruce 
% las ventanas del edificio central, se observa una gran diferencia cuando 
% pasa por una ventana y cuando no. Cuando pasa por la pared, que es 
% blanca, el valor tiende a 250, mientras que cuando pasa por la ventana, 
% es más oscuro y se acerca a 0; al pasar por los marcos de la ventana, 
% sube entre 100-150.

%% APARTADO 2 - EXTRACCIÓN DE BORDES
Imagen = Imagen(1:4:end,1:4:end,1);

% a) - Operador de Sobel: aplicar dos umbrales T1 = 0.1 y T2 = 0.2. 
T1 = 0.10; T2 = 0.20;

[Sobel_1, T, Sobel_H, Sobel_V] = edge(Imagen,'sobel',T1);

Sobel_2 = edge(Imagen,'sobel',T2);

figure(); imshow(Imagen); title('Original');
figure(); imshow(Sobel_1); title('Sobel T = 0.1');
figure(); imshow(Sobel_2); title('Sobel T = 0.2');
figure(); imshow(10*Sobel_V); title('Componentes Horizontales');
figure(); imshow(10*Sobel_H); title('Componentes Verticales');

% b) - Operador de Prewitt: umbral T1 = 0.1.
T1 = 0.10;

Prewitt = edge(Imagen,'prewitt',T1);
figure; imshow(Prewitt); title('Prewitt T = 0.1');

Prewitt = edge(Imagen,'prewitt',T1*3);
figure; imshow(Prewitt); title('Prewitt T = 0.3');

Prewitt = edge(Imagen,'prewitt',T1*5);
figure; imshow(Prewitt); title('Prewitt T = 0.5')

% Al aumentar el umbral aparecen menos bordes. Con T = 0.3 se eliminan los
% bordes del edificio y sólo aparecenen los de las ventanas y el del
% puente. Con T = 0.5 la imagen aparece en negro por completo porque no
% reconoce nada como borde.

% c) - Operador de Roberts: umbral T1 = 0.1.
Roberts = edge(Imagen,'roberts',T1);
figure; imshow(Roberts); title('Roberts T = 0.1');

% d) - Operador de Canny: umbrales T1 = 0.1 y T2 = 0.2 con un umbral de 
% ? = 5 para un suavizado previo.
T1 = 0.10; T2 = 0.50;
sigma = 5;

Canny = edge(Imagen,'canny',T1, T2,sigma);

figure; imshow(Canny); title('Cannny T1 = 0.10; T2 = 0.5 y sigma = 5');

% e) - Zerocrossing: obtener directamente el resultado con el parámetro 
% correspondiente. 
ZR = edge(Imagen,'zerocross');
figure; imshow(ZR); title('Zero-crossing');

% f) - Laplaciana de la Gaussiana: umbral T1 = 3 y ? = 2.  
sigma = 2;
T1 = 3;

LAP = edge(double(Imagen),'log',T1,sigma);
figure; imshow(LAP); title('Laplaciana de la Gaussiana');

% Representación gráfica del operador
rango = 10; 
step2D = 0.05;
step3D = 0.5;

%2D
x1 = -rango:step2D:rango;
a = (2-(x1.^2/sigma^2)) .* exp(-(x1.^2)/(2*sigma^2));

figure; plot(x1,a,'Linewidth',2); 
title('Representación operador laplaciana de la Gaussiana');

% 3D
[x,y] = meshgrid(-rango:step3D:rango, -rango:step3D:rango);
a = (2-((x.^2 + y.^2)/sigma^2)) .* exp( -(x.^2 + y.^2)/(2*sigma^2));

z = a / sum(sum(a));
figure; surfc(x,y,z); colormap hsv; 
title('Representación operador laplaciana de la Gaussiana');

% Primero habría que valorar si es muy importante perder algún borde o
% tener algo de ruido en la imagen.
% En Sobel (umbral = 0.1) quedan todos los bordes bien definidos, 
% aunque aparece algo de ruido que a lo mejor es indeseable; 
% con el umbral 0.2 el ruido practicamente desaparece,
% a costa de que algunos bordes queden abiertos, o no definidos del todo.
% Con Roberts y Prewitt pasa algo parecido con Sobel (umbral 0.1).
% Aparecen todos los bordes, pero con algún "añadido". 
% En cuanto a Canny, la imagen queda bastante deformada y no aporta mucho 
% más que Sobel a 0.2.
% Zerocrossing y la Laplaciana de la gaussiana tienen resultados similares,
% teniendo el segundo un poco menos de ruido.
% En líneas generales, Sobel y la Laplaciana tienen, a nuestro parecer, los
% mejores resultados.

%% APARTADO 3 - PRÁCTICAS OPCIONALES
% a) - Implementar el método de Sobel con una función propia y
% umbral T = 100
[M,N] = size(Imagen);

% Método de Sobel
T = 100; 

ImTrans = zeros(M,N);
Angulos = zeros(M,N);

% Máscaras
gx = [ -1  0  1;
       -2  0  2; 
       -1  0  1 ]; 
gy = [ -1 -2 -1; 
        0  0  0; 
        1  2  1 ]; 

% Dimensión 2w+1
w = 1; % dimensión de la máscara 3x3
for i =1+w:1:M-w
    for j=1+w:1:N-w
      Ventana = double(Imagen(i-w:1:i+w,j-w:1:j+w));  
      Ax = sum(sum(gx.*Ventana));
      Ay = sum(sum(gy.*Ventana));
      Angulos(i,j) = atan2(Ax,Ay);      
      A = abs(Ax) + abs(Ay);
      if A > T
         ImTrans(i,j) = 255;         
      end
    end
end


figure(); imshow(mat2gray(ImTrans)); title('Bordes Sobel T = 100');
figure(); imshow(mat2gray(Angulos)); title('Ángulos Sobel');

% b) - Implementar el método basado en el operador Laplaciana con el núcleo 
% h = [-1 -1 -1; -1 8 -1; -1 -1 -1] y umbral t = 150.

Nucleo = [ -1 -1 -1 ;
           -1  8 -1 ; 
           -1 -1 -1 ];

L = conv2(Imagen, Nucleo, 'same');

B = zeros(M,N);

T = 150;
for i = 2:M-1
    for j = 2:N-1
      if (((L(i,j) < -T) && (...
              (L(i-1,j-1) > T) || (L(i-1,j) > T) || ...
              (L(i-1,j+1) > T) || (L(i,j-1) > T) || (L(i,j+1) > T) || ...
              (L(i+1,j-1) > T) || (L(i+1,j) > T) || (L(i+1,j+1) > T))) ...
          || ((L(i,j) > T)  && (...
              (L(i-1,j-1) < -T) || (L(i-1,j) < -T) || ...
              (L(i-1,j+1) < -T) || (L(i,j-1) < -T) || ...
              (L(i,j+1) < -T) || (L(i+1,j-1) < -T) || ...
              (L(i+1,j) < -T)   || (L(i+1,j+1) < -T))))
          B(i,j) = 255;
      end
    end
end

figure(); imshow(B); title('Bordes Laplaciana T = 150');

% c) - Aplicar el operador de Harris con K = 200
Imagen = imread('Tema05a.jpg','jpg');
Imagen = Imagen(1:4:end,1:4:end,1);

K = 200;
[H,B] = harris(Imagen, K);

figure(); imshow(mat2gray(H)); title('Puntos de interés');
figure(); imshow(B); title('Localizaciones');

