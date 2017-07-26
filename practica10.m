% PRÁCTICA 10
% Esther Ávila Benito
% Laura Pérez Jambrina

%% 1 - GENERACIÓN, GRABACIÓN Y REPRODUCCIÓN DE SONIDO

% a) - Grabar la secuencia "Percepción Computacional" y guardarla en un
% fichero.
% Graba la voz durante t segundos
t = 5;
recObjeto = audiorecorder;
disp('Comienza grabación')
recordblocking(recObjeto, t);
disp('Finaliza grabación');

% Reproduce la grabación
play(recObjeto);

% Almacena la señal en un vector x
x = getaudiodata(recObjeto);

% Dibuja el sonido
figure; plot(1:size(x,1), x); title('Percepción computacional');

% Graba la señal en un fichero .wav
Fs = recObjeto.SampleRate; % frecuencia de muestreo
audiowrite('MiVoz.wav', x, Fs);

% b) - Grabar otros dos ficheros (PC11025.wav y PC22050.wav) a las 
% frecuencias 11025 y 22050 Hz.
clear all; close all
[y, Fs] = audioread('PC11025.wav');
grid on
figure; plot(1:size(y,1), y);
title('Percepción computacional - 11025 Hz');
% Reproduce la secuencia grabada
soundsc(y, Fs);
pause(5);
disp('Frecuencia: '); disp(Fs);

clear all; close all
[y, Fs] = audioread('PC22050.wav');
grid on
figure; plot(1:size(y,1), y);
title('Percepción computacional - 22050 Hz');
% Reproduce la secuencia grabada
soundsc(y, Fs);
pause(5);
disp('Frecuencia: '); disp(Fs);

% Se puede observar que mientras no se habla, la onda tiene un mínimo de
% amplitud por el ruido ambiental.

%% 2 - GENERACIÓN DE RUIDO Y FILTRADO

% a) - Leer el fichero PC11025.wav  y reproducirlo. Añadir a la señal 
% ruido aleatorio y representarlo en pantalla.
clear all; close all
[y, Fs] = audioread('PC11025.wav');
yruidosa = y + 0.005.*randn(size(y,1), 1);
soundsc(yruidosa, Fs);
figure; plot(1:size(yruidosa,1), yruidosa);
title('Percepción computacional con ruido');

% En la gráfica del sonido podemos ver que el ruido tiene una amplitud
% constante, aunque es menor que la de la secuencia del archivo.

% b) - Diseñar un filtro de Butterworth filtrándolo, 
% volviéndolo a reproducir y dibujar.
[b, a] = butter(8,0.1, 'low');
yfiltrada_butterworth = filtfilt(b, a, yruidosa);
soundsc(yfiltrada_butterworth, Fs);
figure; plot(1:size(yfiltrada_butterworth,1), yfiltrada_butterworth);
title('Filtro Butterworth');

% El filtro de Butterworth produce la respuesta más plana que sea posible 
% hasta la frecuencia de corte. La salida se mantiene constante casi hasta 
% la frecuencia de corte.

%% 3 - CARACTERÍSTICAS DE LA SEÑAL

% a) - Leer el fichero PC11025.wav a la frecuencia de 11025 kHz.
% Seleccionar las muestras comprendiads entre x(10000:1:10010), visualizar
% su contenido, calcular los pasos por cero y crear una variable indicando
% dónde se han producido esos tránsitos. Realizar el mismo proceso para la
% señal x(10000:1:10200).
clear all; close all
[x, Fs] = audioread('PC11025.wav');
y = x(10000:1:10050);

% Cálculo de los "zero-crossings"
[n, m] = size(y);
zcr = 0;
marcado_zcr = zeros(n, m);
for i = 2:1:n
    if abs(sign(y(i)) - sign(y(i-1))) ~= 0
        marcado_zcr(i) = 1;
    end
    zcr = zcr + 0.5 * abs(sign(y(i)) - sign(y(i-1)));
end

disp('Numero zero-crossings ='); disp(zcr);
figure(); plot(1:size(y,1), y); title('Pasos por cero - x(10000:1:10050)');
grid on

for i = 1:1:n
   if marcado_zcr(i) == 1
      hold on
      plot(i-1, 0, 'g*');
   end
end

[x, Fs] = audioread('PC11025.wav');
y = x(10000:1:10200);

% Cálculo de los "zero-crossings"
[n, m] = size(y);
zcr = 0;
marcado_zcr = zeros(n, m);
for i = 2:1:n
    if abs(sign(y(i)) - sign(y(i-1))) ~= 0
        marcado_zcr(i) = 1;
    end
    zcr = zcr + 0.5 * abs(sign(y(i)) - sign(y(i-1)));
end

disp('Numero zero-crossings ='); disp(zcr);
figure(); plot(1:size(y,1), y); title('Pasos por cero - x(10000:1:10200)');
grid on

for i = 1:1:n
   if marcado_zcr(i) == 1
      hold on
      plot(i-1, 0, 'g*');
   end
end

% Se puede observar que reconoce tres pasos por cero más de los que hay en
% la imagen. Además algunos los dibuja más a la izquierda de donde están.

% b) Programa de Matlab: Caracteristicas.m. Leer el fichero PC11025.wav a 
% la frecuencia de 11025 kHz. Definir una ventana de Hamming con L = 240; 
% definir el solapamiento para las ventanas como a = 60. 
% Procesar la señal por tramos calculando su magnitud, energía y entropía.
close all; clear all
[s, fs] = audioread('PC11025.wav');
figure; plot(s, 'k', 'LineWidth', 2); title('Señal original');

L = 240; a = 60;
v = hamming(L);
v = rot90(v);
n = (length(s) / 240);

ini = 0;
k = 0;
Magnitud = zeros(uint8(n), 1);
Energia = zeros(uint8(n), 1);
Entropia1 = zeros(uint8(n), 1);
Entropia2 = zeros(uint8(n), 1);

for j = ini:n
  for i = 1:L
    r(i) = s(i+k);
  end
  k = k+a;
  w = r.*v; % paso de los tramos de señal por la ventana de Hamming
  figure(2); 
  plot(r, 'k', 'LineWidth',2); 
  title('Muestra de la señal');
  figure(3); 
  plot(w, 'k', 'LineWidth',2); 
  title('Muestra de la señal pasada por la ventana de Hamming (240)');
  
  % Cálculo de las magnitudes de la señal para cada tramo
  Magnitud  (j+1)  = magnitud  (r,v);
  Energia   (j+1)  = energia   (r,v);
  Entropia1 (j+1)  = entropia1 (r,v);
  Entropia2 (j+1)  = entropia2 (r,v); 
end
figure; plot(Magnitud); title('Magnitud');
figure; plot(Energia); title('Energía');
figure; plot(Entropia1); title('Entropía 1');
figure; plot(Entropia2); title('Entropía 2');

% La energía sonora procede de la energía vibracional del foco sonoro y se
% propaga a las partículas del medio que atraviesan en forma de energía
% cinética y potencial. La energía se transmite a la celocidad de la onsa.
% A partir de la energía se puede calcular la densidad o el flujo de
% energía acústica.

%% 4 - CORRELACIÓN CRUZADA

% a) - Programa de Matlab: CorrelacionCruzada.m. Leer el fichero 
% PC11025.wav, a la frecuencia de 11025 kHz. Definir una ventana de Hamming 
% con L = 240 utilizando la función de Matlab w = hamming(L); definir el 
% solapamiento para las ventanas como a = 60. Calcular la correlación 
% cruzada mediante la función de Matlab: c = xcorr (w,s) donde s es la 
% señal en cada tramo.
close all; clear all;
s = audioread('PC11025.wav');
figure(1); plot(s, 'k', 'LineWidth', 2); title('Señal original')

L = 240; a = 60;
v = hamming(L); % ventana de Hamming
v = rot90(v);
n = (length(s) / 240);

ini = 0;
k = 0;
for j = ini:n,
  for i = 1:L,
    r(i) = s(i+k);
  end
  k = k + a;
  w = r.*v;
  c = xcorr(w);
  figure(2)
  plot(c, 'k', 'LineWidth', 2); 
  title('Correlación cruzada de la señal ventaneada')
end

% La correlación cruzada es una medida de similitud entre dos señales. Se
% suele usar para encontrar características relevantes en una señal
% desconocida por medio de la comparación con otra que sí se conoce. Es
% función del tiempo relativo entre las señales y también se llama producto
% escalar desplazado.

% b) - Programa de Matlab: Reconocimiento.m. Seleccionar uno de los 
% ficheros de sonido contenidos en la carpeta Reconocimiento y ejecutar el 
% programa.
close all; clear all;
disp ('Seleccionar fichero')
[fichero, path] = uigetfile({'*.*'}, 'Seleciona archivo a reconocer');           
if (fichero == 0)
    disp('Fichero no válido')
    return;
end
fichero = strcat(path, fichero);
speechrecognition(path, fichero);

%% 5 - BANCO DE FILTROS: ESPECTOGRAMA O SONOGRAMA

% Programa de Matlab: espectograma.m. Leer el fichero PC11025.wav. 
% Obtener su espectograma mediante el banco de filtros definidos por el 
% filtro Paso Banda Butterworth de orden 4.
close all; clear all
[x, fs] = audioread('PC11025.wav');

NF = 16; % número de filtros
BW = 300; % ancho de banda para los filtros Pasa Banda
NW = 100; % número de ventanas (divisiones de la señal)  
delta = 160;

% Redimensionar x
x = reshape(x, [length(x) 1]); % vector columna

nmw = floor(length(x) / NW); % número de muestras en cada ventana

% Calcular frecuencias de corte
cuts = linspace(100, delta*NF, NF);

% Inicializar la matriz del espectrograma
Energia = zeros(NW, NF);

% for each channel in turn
g = 0;
for j = 1:nmw:length(x)-nmw
    xs = x(j:j+nmw-1);
    g = g + 1;
    for i=1:NF
    % coeficientes del filtro Paso Banda Butterworth de orden 4
    [b, a] = butter(4, [2*cuts(i) / fs 2*(cuts(i)+BW)/ fs]);
    y = filter(b, a, xs);
    Energia(g, i) = sum(abs(y));
    end
end
% Calcular amplitud en decibelios
Energia = 10 * log10(Energia);
figure; imagesc(Energia'); colormap(jet), colorbar
title('Espectograma');
% colormap(1-gray)

axis xy;
xlabel('Número de ventanas');
ylabel('Número de filtros');

% El espectrograma es el resultado de calcular el espectro de tramas 
% enventanadas de una señal. Resulta una gráfica tridimensional que 
% representa la energía del contenido frecuencial de la señal según va 
% variando ésta a lo largo del tiempo.

%% 6 - TRANSFORMADA DE FOURIER: ESPECTOGRAMA O SONOGRAMA

% a) -  Leer el fichero PC11025.wav. Llamar a la función de Matlab 
% spectrogram y representar el espectrograma.
close all; clear all
[x, fs] = audioread('PC11025.wav');
figure; plot(x, 'k', 'LineWidth', 2); title('Señal original');

figure;
[y, f, t, p] = spectrogram(x);
surf(t, f, 10*log10(abs(p)), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0, 90);
xlabel('Tiempo'); ylabel('Frecuencia (Hz)');
title('Transformada de Fourier: espectograma');

% El espectrograma se puede interpretar como una proyección en dos 
% dimensiones de una sucesión de Transformadas de Fourier de tramas 
% consecutivas, donde la energía y el contenido frecuencial de la señal 
% va variando a lo largo del tiempo.

% b) - Programa de Matlab: Caracteristicas.m. Leer el fichero PC11025.wav 
% a la frecuencia de 11025 kHz. Definir una ventana de Hamming con L = 240 
% utilizando la función de Matlab w = hamming(L); definir el solapamiento 
% para las ventanas como a = 60. Procesar la señal por tramos calculando 
% su centroide, flujo espectral y RollOff.
L = 240; a = 60;
v = hamming(L);
v = rot90(v);
n = (length(x) / 240);

ini = 0;
k = 0;

Centroide = zeros(uint8(n), 1);
FlujoEspectral = zeros(uint8(n), 1);
RollOff = zeros(uint8(n), 1);

for j = ini:n,
  for i = 1:L,
    r(i) = x(i+k);
  end
  k = k + a;
  w = r.*v; % paso de los tramos de señal por la ventana de Hamming
  figure(2); 
  plot(r, 'k', 'LineWidth', 2); title('Muestra de la señal');
  figure(3); 
  plot(w, 'k', 'LineWidth', 2); 
  title('Muestra de la señal pasada por la ventana de Hamming (240)');
  
  % Cálculo del centroide
  Centroide(j+1) = centroide(r, fs);
  
  % Cálculo del flujo espectral
  L = length(r);
  FFT = (abs(fft(r, 2*L)));
  FFT = FFT(1:L);        
  FFT = FFT / max(FFT);
  if j == 0
      FlujoEspectral(j+1) = 0;
  else
      FlujoEspectral(j+1) = sum((FFT - FFTprev).^2);
  end
  FFTprev = FFT;
  
  c = 0.5; % significa que cuando se alcance el 50% del valor acumulado 
  % de la señal se detiene el proceso. Si no se alcanza nunca, se detiene
  % el proceso tambié
  RollOff(j+1) = SpectralRollOff(r, c, fs);
end

figure; plot(Centroide); title('Centroide')
figure; plot(FlujoEspectral); title('Flujo espectral')
figure; plot(RollOff); title('RollOff')

% El RollOff de un sonido es cuando el sonido se atenúa en las bajas 
% frecuencias, o en otras palabras, van sonando más despacio a medida que 
% disminuye la frecuencia.