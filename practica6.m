% Laura P�rez Jambrina
% Esther �vila Benito

%% APARTADO 1 - DESCRIPCI�N DE BORDES
% a) - Ajuste entre una l�nea recta y otra curva
imagen = imread('Tema06a.bmp', 'bmp');
imagenR = imagen(:,:,1);

[M,N] = size(imagenR);

for i=1:M
    for j=1:N
        if (imagenR(i,j) == 0)
            y(i,1) = 1;
            y(i,2) = j;
            b(i) = i;
        end
    end
end

a= pinv(y) * b';
x1 = 0;
x2 = N;
y1 = a(1) + a(2) * x1;
y2 = a(1) + a(2) * x2;

figure(); imshow(imagenR); line([x1, x2], [y1, y2], 'LineWidth', 4);

% Se observa como el programa ajusta la l�nea curva de la imagen a la mejor
% recta que ha encontrado

%b) - 
% x = imread('lineas1.bmp','bmp');
% xy = detectar_lineas(x);
% plot(xy(:,2),xy(:,1), 'LineWidth', 3, 'Color','r');
% 
% x = imread('lineas2.bmp','bmp');
% xy = detectar_lineas(x);
% plot(xy(:,2),xy(:,1), 'LineWidth', 3, 'Color','r');
% 
% x = imread('lineas3.bmp','bmp');
% xy = detectar_lineas(x);
% plot(xy(:,2),xy(:,1), 'LineWidth', 3, 'Color','r');
% 
% x = imread('lineas4.bmp','bmp');
% xy = detectar_lineas(x);
% plot(xy(:,2),xy(:,1), 'LineWidth', 3, 'Color','r');
% 
% x = imread('Tema06b.bmp','bmp');
% detectar_lineas(x);
% plot(xy(:,2),xy(:,1), 'LineWidth', 3, 'Color','r');
%
% Se observa que los cuadrados azules caracterizan a las rectas: la
% posici�n en el eje y (ro) est� relacionado por la posici�n de la recta;
% mientras que el valor del eje x determina el �ngulo de la misma.

%% APARTADO 2 - DESCRIPCI�N DE REGIONES
% a) - Binarizar la imagen Tema06c.bmp, etiquetar las regiones y mostrar 
% por pantalla las propiedades de las regiones.
imagen = imread('Tema06c.bmp', 'bmp');
imagenR = imagen(:,:,1);

figure(); imshow(imagenR); impixelinfo; title('Original');

% Binarizar
T = graythresh(imagenR);
A = imagenR < 255*T;

% N = n�mero de etiquetas y valor de las etiquetas de la imagen izquierda
[Etiquetas, N]=bwlabel(A,8);

figure(); imshow(Etiquetas); impixelinfo; title('Etiquetas');
figure(); imagesc(Etiquetas); colorbar;

prop = regionprops(Etiquetas,'all');

for i=1:1:N
 disp(prop(i));
end

% Se observa que el programa clasifica cada elemento con una etiqueta
% distinta, y que aporta una serie de propiedades para cada uno de ellos
% que lo definen.

% b) - C�lculo de los siete momentos invariantes de Hu.
% primer 0
F0a = imread('Cero_a.bmp','bmp');
phi = invmoments(F0a);
% escalado
phi = abs(log10(abs(phi)));
disp('phi primer cero ='); disp(phi);

% segundo 0
F0b = imread('Cero_b.bmp','bmp');
phi = invmoments(F0b);
% escalado
phi = abs(log10(abs(phi)));
disp('phi segundo cero ='); disp(phi);

% tercer 0
F0c = imread('Cero_c.bmp','bmp');
phi = invmoments(F0c);
% escalado
phi = abs(log10(abs(phi)));
disp('phi tercer cero ='); disp(phi);

% cuarto 0
F0d = imread('Cero_d.bmp','bmp');
phi = invmoments(F0d);
% escalado
phi = abs(log10(abs(phi)));
disp('phi cuarto cero ='); disp(phi);

% primer 7
F7a = imread('Siete_a.bmp','bmp');
phi = invmoments(F7a);
% escalado
phi = abs(log10(abs(phi)));
disp('phi primer siete ='); disp(phi);

% segundo 7
F7b = imread('Siete_b.bmp','bmp');
phi = invmoments(F7b);
% escalado
phi = abs(log10(abs(phi)));
disp('phi segundo siete ='); disp(phi);

% tercer 7
F7c = imread('Siete_c.bmp','bmp');
phi = invmoments(F7c);
%escalado
phi = abs(log10(abs(phi)));
disp('phi tercer siete ='); disp(phi);

% cuarto 7
F7d = imread('Siete_d.bmp','bmp');
phi = invmoments(F7d);
% escalado
phi = abs(log10(abs(phi)));
disp('phi cuarto siete ='); disp(phi);

subplot(4,2,1); imshow(F0a)
subplot(4,2,2); imshow(F0b)
subplot(4,2,3); imshow(F0c)
subplot(4,2,4); imshow(F0d)
subplot(4,2,5); imshow(F7a)
subplot(4,2,6); imshow(F7b)
subplot(4,2,7); imshow(F7c)
subplot(4,2,8); imshow(F7d)

% Se observa que, para el mismo n�mero, los valores de los invariantes de
% Hu var�an levemente de una imagen a otra; siendo m�s distantes para
% n�meros difrentes.
% Dentro del mismo n�mero, rotar la imagen no provoca pr�cticamente ning�n
% cambio (parejas 1 y 2, 3 y 4 de cada n�mero), mientras que al cambiar el
% tama�o (1 y 3) si se observan leves cambios.

%% APARTADO 3 - PR�CTICA OPCIONALES
% a) - Ejecuci�n del programa Demo1
% Demo1
% Se observa como, partiendo de un rect�ngulo rojo que no delimita nada, se
% va cerrando en torno a las c�lulas, hasta un momento que se forman dos
% zonas y no s�lo una, cada una cerr�ndose poco a poco en torno a cada una
% de las c�lulas.

% b) - Aplicaci�n de la transformada de Fourier
I1 = imread('Tema06d1.bmp','bmp');
I2 = imread('Tema06d2.bmp','bmp');

Ia1 = double(I1);
Ia2 = double(I2);

X1 = log(abs(fftshift(fft2(Ia1(:,:,1))))); 
X2 = log(abs(fftshift(fft2(Ia2(:,:,1))))); 

figure;  imshow(I1);
figure;  imagesc(X1); colorbar;
figure;  imshow(I2);
figure;  imagesc(X2); colorbar;

% Se observan unas l�neas perpendiculares a los lados de la figura. 
% La se gunda imagen al estar girada hace que rote tambi�n el espectro de
% frecuencias en el mismo angulo que la figura.

