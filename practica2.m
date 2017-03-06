% Esther Ávila Benito
% Laura Pérez Jambrina

%% APARTADO 1 - FORMACIÓN DE IMÁGENES: COLOR
M = 9;
N = 9;
Ceros = zeros(M, N);
Unos = ones(M, N);
Gris = 0.5 * Unos;

Rojo(:,:,1) = Unos;      Rojo(:,:,2) = Ceros;     Rojo(:,:,3) = Ceros;
Verde(:,:,1) = Ceros;    Verde(:,:,2) = Unos;     Verde(:,:,3) = Ceros;
Azul(:,:,1) = Ceros;     Azul(:,:,2) = Ceros;     Azul(:,:,3) = Unos;

Amarillo(:,:,1) = Unos;  Amarillo(:,:,2) = Unos;  Amarillo(:,:,3) = Ceros;
Magenta(:,:,1) = Unos;   Magenta(:,:,2) = Ceros;  Magenta(:,:,3) = Unos;
Cyan(:,:,1) = Ceros;     Cyan(:,:,2) = Unos;      Cyan(:,:,3) = Unos;

Gris(:,:,1) = Gris;      Gris(:,:,1) = Gris;      Gris(:,:,1) = Gris;
Blanco(:,:,1) = Unos;    Blanco(:,:,1) = Unos;    Blanco(:,:,1) = Blanco;
Negro(:,:,1) = Ceros;    Negro(:,:,1) = Ceros;    Negro(:,:,1) = Ceros;

figure()
subplot(3,3,1); imshow(Rojo);      title('Rojo');
subplot(3,3,2); imshow(Verde);     title('Verde');
subplot(3,3,3); imshow(Azul);      title('Azul');
subplot(3,3,4); imshow(Amarillo);  title('Amarillo');
subplot(3,3,5); imshow(Magenta);   title('Magenta');
subplot(3,3,6); imshow(Cyan);      title('Cyan');
subplot(3,3,7); imshow(Gris);      title('Gris');
subplot(3,3,8); imshow(Blanco);    title('Blanco');
subplot(3,3,9); imshow(Negro);     title('Negro');

%% APARTADO 2 - TRANSFORMACIONES DE COLOR
original = imread('Tema03b.jpg', 'jpg');

R = original(1:4:end, 1:4:end, 1);
G = original(1:4:end, 1:4:end, 2);
B = original(1:4:end, 1:4:end, 3);

reducida(:,:,1) = R; reducida(:,:,2) = G; reducida(:,:,3) = B;

% 2 - Extraer las tres componentes y mostrarlas
Rreducida = reducida(:,:,1);
Greducida = reducida(:,:,2);
Breducida = reducida(:,:,3);

figure()
subplot(2,3,1); imshow(reducida);       title('Reducida');
subplot(2,3,2); imshow(255-Rreducida);  title('Canal rojo');
subplot(2,3,3); imshow(255-Greducida);  title('Canal verde');
subplot(2,3,4); imshow(255-Breducida);  title('Canal azul');

% 3 - Formato CMY
CMY(:,:,1) =  255-Rreducida;  CMY(:,:,2) =  255-Greducida;  CMY(:,:,3) =  255-Breducida;
figure()
subplot(2,3,1); imshow(reducida);    title('Reducida');
subplot(2,3,2); imshow(CMY(:,:,1));  title('CMY Canal rojo');
subplot(2,3,3); imshow(CMY(:,:,2));  title('CMY Canal verde');
subplot(2,3,4); imshow(CMY(:,:,3));  title('CMY Canal azul');
subplot(2,3,5); imshow(CMY);         title('CMY');

% 4 - Formato YIQ
T = [0.299 0.587 0.114; 0.596 -0.275 -0.321; 0.212 -0.523 0.311];
[M,N,s] = size(reducida);

for i=1:1:M
    for j=1:1:N
      YIQ(i,j,1) = T(1,1)*Rreducida(i,j) + T(1,2)*Greducida(i,j) + T(1,3)*Breducida(i,j); 
      YIQ(i,j,2) = T(2,1)*Rreducida(i,j) + T(2,2)*Greducida(i,j) + T(2,3)*Breducida(i,j); 
      YIQ(i,j,3) = T(3,1)*Rreducida(i,j) + T(3,2)*Greducida(i,j) + T(3,3)*Breducida(i,j); 
    end
end
 
figure()
subplot(2,3,1); imshow(reducida);    title('Reducida');
subplot(2,3,2); imshow(YIQ(:,:,1));  title('YIQ Canal rojo');
subplot(2,3,3); imshow(YIQ(:,:,2));  title('YIQ Canal verde');
subplot(2,3,4); imshow(YIQ(:,:,3));  title('YIQ Canal azul');
subplot(2,3,5); imshow(YIQ);         title('YIQ');

% 5 - Formato HSI
HSI = rgb2hsv(reducida);

figure()
subplot(2,3,1); imshow(reducida);   title('Reducida');
subplot(2,3,2); imshow(HSI(:,:,1)); title('HSI Canal rojo');
subplot(2,3,3); imshow(HSI(:,:,2)); title('HSI Canal verde');
subplot(2,3,4); imshow(HSI(:,:,3)); title('HSI Canal azul');
subplot(2,3,5) ; imshow(HSI);       title('HSI');

% 6 - Formato RGB
RGB = hsv2rgb(HSI);
subplot(2,3,6); imshow(RGB); title('RGB reconstruida');


%% APARTADO 3 - OPERACIONES ELEMENTALES PÍXEL A PÍXEL
original = imread('Tema03b.jpg', 'jpg');

R = original(1:4:end, 1:4:end, 1);
G = original(1:4:end, 1:4:end, 2);
B = original(1:4:end, 1:4:end, 3);

reducida(:,:,1) = R; reducida(:,:,2) = G; reducida(:,:,3) = B;
reducida = reducida(:,:,1);
[M,N,s] = size(reducida);

% 1 - Operador inverso
I1 = 255-reducida;
figure(); imshow(I1); title('Imagen inversa');

% 2 - Operador umbral (p1 = 90)
p1 = 90;
for i=1:1:M
    for j=1:1:N
      if reducida(i,j) < p1 
          I2(i,j) = 0;
      else
          I2(i,j) = 255;
      end
    end
end

figure(); imshow(I2); title('Operador umbral');

% 3 - Operador intervalo de umbral binario (p1 = 50 y p2 = 150)
p1 = 50; p2 = 150; 
for i=1:1:M
    for j=1:1:N
      if reducida(i,j) < p1 || reducida(i,j) > p2 
          I3(i,j) = 255;
      else
          I3(i,j) = 0;
      end
    end
end
figure(); imshow(I3); title('Operador intervalo umbral binario');

% 4 - Operador intervalo de umbral binario invertido (p1 = 50 y p2 = 150)
p1 = 50; p2 = 150; 
for i=1:1:M
    for j=1:1:N
      if reducida(i,j) < p1 || reducida(i,j) > p2 
          I4(i,j) = 0;
      else
          I4(i,j) = 255;
      end
    end
end
figure(); imshow(I4); title('Operador intervalo umbral binario invertido');

% 5 - Operador umbral escala de grises
p1 = 50; p2 = 150; 
I5 = reducida;
for i=1:1:M
    for j=1:1:N
      if reducida(i,j) < p1 || reducida(i,j) > p2 
          I5(i,j) = 255;
      end
    end
end
figure(); imshow(I5); title('Operador umbral escala de grises');

% 6 - Operador umbral escala de grises invertido (p1 = 50 y p2 = 150)
p1 = 50; p2 = 150; 
I6 = 255-reducida;
for i=1:1:M
    for j=1:1:N
      if reducida(i,j) < p1 || reducida(i,j) > p2 
          I6(i,j) = 255;
      end
    end
end
figure(); imshow(I6); title('Operador umbral escala de grises invertido');

% 7 - Operador extensión (p1 = 50 y p2 = 150)
p1 = 50; p2 = 150; 
I7 = (reducida-p1)*(255/(p2-p1));
for i=1:1:M
    for j=1:1:N
      if reducida(i,j) < p1 || reducida(i,j) > p2 
          I7(i,j) = 0;
      end
    end
end
figure(); imshow(I7); title('Operador extensión');

%% APARTADO 4 - OPERACIONES DE VECINDAD
original = imread('Tema03c.jpg', 'jpg');
original = original(1:4:end,1:4:end,1);

figure(); subplot(2,2,1); imshow(original); title('Imagen original en color');
[M,N,s] = size(original);

O = original(:,:,1);
subplot(2,2,2); imshow(O); title('Imagen original en gris');

h = [1 2 1; 0 0 0; -1 -2 -1];

I = conv2(double(O),h,'same');
subplot(2,2,3); imshow(I); title('Operador de vecindad (bordes)');

h = [1 2 1; 0 1.2 0; -1 -2 -1];

I = mat2gray(conv2(double(O),h,'same'));
subplot(2,2,4); imshow(I); title('Operador de vecindad (repujado)');

