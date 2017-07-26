%% PRÁCTICA 9
% Carlos Jaynor Márquez Torres

% Daniel Tocino Estrada

% parámetros del clasificador
  clear all;
  close all;
  
 %definición de parámetros para las ventanas modales de diálogo
 options.Resize='on';
 options.WindowStyle='modal';
 options.Interpreter='tex';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Paso 1: carga de datos desde la Base de Conocimiento %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%cargar los datos existentes en la Base de Conocimiento
if exist('MuestrasAprendizaje.mat') ~= 0 
  load MuestrasAprendizaje
else
  X = [0 0 0];  
end

[d1,d2] = size(X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  Paso 2: si se selecciona si (s, por defecto) %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%         se pregunta que si la carga se hará desde fichero %%%%%%%
%%%%%%%%%         o por selección de datos con el ratón    %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 's';
prompt = {'s/n'};
dlg_title = '¿nuevos datos?';
num_lines = 1;
def = {'s'};
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
n = answer{1};
if (strcmp(n,'s') ~= 0)

    n = 's';
    num_img = 0;
    while(strcmp(n,'s') ~= 0) % pregunta de más imágenes

      % numero de imágenes
      num_img = num_img + 1;
    
      if (num_img < 10) 
        IO = imread(strcat('IEntrenamiento_0',num2str(num_img),'.bmp')); 
      else
        IO = imread(strcat('IEntrenamiento_',num2str(num_img),'.bmp')); 
      end
      
      %leer los datos de la imagen original
      step = 1;
      [M,N,s] = size(IO);
      I = IO(1:step:M,1:step:N,:);
      figure; imshow(I);
  
      prompt = {'s/n'};
      dlg_title = '¿seleccionar muestras con el ratón?';
      num_lines = 1;
      def = {'s'};

      answer = inputdlg(prompt,dlg_title,num_lines,def,options);
      n = answer{1};
      if (strcmp(n,'s') ~= 0)
        [filas, columnas, XO] = impixel;
        [a,b] = size(filas);
        hold on
        for i=1:1:a
          plot(filas(i,:),columnas(i,:),'.b');
        end
      else 
        [m,n,s] = size(I);
        h = 0;
        for i=1:1:m
            for j=1:1:n
               h = h + 1;
               XO(h,:) = double(I(i,j,:)); 
            end
        end
      end
  
      X = [X;XO]; %concatenación
      Xo = X;     % datos originales
      clear XO;
      prompt = {'s/n'};
      dlg_title = '¿Más imágenes de entrenamiento?';
      num_lines = 1;
      def = {'s'};
      answer = inputdlg(prompt,dlg_title,num_lines,def,options);
      n = answer{1};

  end %while(strcmp(n,'s') ~= 0) % pregunta de más imágenes

  % quitamos la primera fila de X, que se añadió al crearla
  if d1 == 1
    [m,n] = size(X);
    X = X(2:1:m,:);
  end
  save MuestrasAprendizaje X
end %nuevos datos

% en X1 se mantienen los datos originales sin normalizar
X1 = X;

% %normalizacion de datos en el rango [0,1]
MI=min(X); %minimo
MA=max(X); %maximo
X=(X-repmat(min(X),size(X,1),1))./(repmat(max(X),...
     size(X,1),1)-repmat(min(X),size(X,1),1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  Paso 3: proceso de partición de los datos   %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dar la opción sobre si lo que se desea es realizar la partición con el algoritmo 
% Fuzzy dándo el número de clústeres o determinar el número de clústeres 
% de forma automática mediante el algoritmo de cuantización vectorial    

NuevaParticion = true;

prompt = {'Peso exponencial','Criterio de terminación'};
dlg_title = 'Párametros para el algoritmo Fuzzy';
num_lines = 1;
def = {'2','1e-2'};
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
m = str2num(answer{1});
e = str2num(answer{2});

while NuevaParticion
  n = 's';
  prompt = {'s/n'};
  dlg_title = 's -> FC, n -> CV'; % s: fuzzy Clustering; n: Cuantización Vectorial 
  num_lines = 1;
  def = {'s'};
  answer = inputdlg(prompt,dlg_title,num_lines,def,options);
  n = answer{1};
  if (strcmp(n,'s') ~= 0)  % punto A
     % se ha elegido la opción de fijar el número de clústeres para dárselo
     % al algoritmo de Fuzzy clustering para realizar la partición de los
     % datos
     prompt = {'Número de Clústeres'};
     dlg_title = 'Numero de Clústeres';
     num_lines = 1;
     def = {'4'};
     answer = inputdlg(prompt,dlg_title,num_lines,def,options);
     c = str2num(answer{1});

     % los datos están todavía sin clasificar, por tanto los centros de las clases se
     % inicializarán de forma aleatoria
     
     vEstimados = zeros (1,3);  % no se usará realmente es sólo para concordancia de parámetros con
                                % la función posterior
     DatosClasificados = false; 
     [v,U, distancia, iteraciones, Jcost] = fuzzy_clustering (X,c,m,e,vEstimados,DatosClasificados);

     %desnormalización de v
     v = (repmat(MA,size(v,1),1) - repmat(MI,size(v,1),1)).*v + ...
        repmat(MI,size(v,1),1);
    
     idx_clas = zeros(1,c);   
     [mx,nx] = size(X1);
     for hh=1:1:mx
       A = X1(hh,:);
       % calculo de los grados de pertenencia a cada una de las clases
       for i=1:1:c
          dd(i) = (1/sum((A - v(i,:)).^2))^(2/(m-1));
       end

       SUMA = sum(dd);
       for i=1:1:c
         mu(i) = dd(i)/SUMA;
       end

       [fila, columna, valor] = find(mu == max(mu));
        
       idx_clas (columna) = idx_clas(columna) + 1;
       j = idx_clas (columna);   
       DATOS_CLASES(columna).muestras(j,:) = A;   
       DATOS_CLASES(columna).numero_muestras = j; 
     end
  else %relativo al punto A
     % se ha elegido la opción de determinar el número de clústeres de forma
     % automática a través del algoritmo de cuantización vectorial
     prompt = {'Umbral'};
     dlg_title = 'Umbral diferenciación de Clústeres';
     num_lines = 1;
     def = {'80'};
     answer = inputdlg(prompt,dlg_title,num_lines,def,options);
     T = str2num(answer{1});
     [N,n] = size(X);

     % inicialización
     DATOS_CLASES(1).centroCVectorial = X1(1,:);  
     DATOS_CLASES(1).muestras(1,:)    = X1(1,:);   
     DATOS_CLASES(1).numero_muestras = 1; %numero de patrones
     c = 1; %numero de clases

     %clase(1).centro = X(1,:);
     %clase(1).patrones(1,:) = X(1,:);
     %clase(1).np = 1; %numero de patrones
     %nc = 1;  

     for j=2:1:N % punto B: número de muestras
       % se computa la distancia del nuevo patron a los centros
       nueva_clase = false;
       for h=1:1:c
         d(h) = norm(X1(j,:)-DATOS_CLASES(h).centroCVectorial);
       end

       %calcular la distancia mínima a los centros de cada clase, con indicación de la clase (h) 
       dmin = min(d);
       h = find(d == dmin);

       % si esa distancia mínima es inferior a un umbral determinado, añadir el
       % patrón a la clase, de otro modo crear una nueva clase
       if dmin < T
          DATOS_CLASES(h).numero_muestras = DATOS_CLASES(h).numero_muestras + 1;
          DATOS_CLASES(h).muestras(DATOS_CLASES(h).numero_muestras,:) = X1(j,:);   

          %clase(h).np = clase(h).np + 1;
          %clase(h).patrones(clase(h).np,:) = X(j,:);
       else % hay que crear una nueva clase 
          nueva_clase = true;
       end
  
       % creación de la nueva clase
       if nueva_clase
         c = c + 1;
         DATOS_CLASES(c).numero_muestras  = 1;
         DATOS_CLASES(c).muestras(1,:)    = X1(j,:);
         DATOS_CLASES(c).centroCVectorial = X1(j,:);
         
         %clase(nc).np = 1;
         %clase(nc).patrones(1,:) = X(j,:);
         %clase(nc).centro = X(j,:);
       end

     end % punto B
 end  %relativo al punto A if (strcmp(n,'s') ~= 0)
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 4: validación de la partición   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
  % Generacion del vector X, de nuevo a partir de las clases
  % Se obtiene además una estima (vEstimados, media para cada clase)
  hh = 0;
  for ii=1:1:c
     muestras_clase = DATOS_CLASES(ii).numero_muestras;
     for jj=1:muestras_clase
        hh = hh + 1;
        X(hh,:) = DATOS_CLASES(ii).muestras(jj,:);
     end
     vEstimados(ii,:) = mean(DATOS_CLASES(ii).muestras); 
  end

  % normalizacion al rango [0,1]
  MI=min(X); %minimo
  MA=max(X); %maximo
  X=(X-repmat(MI,size(X,1),1))./(repmat(MA,...
     size(X,1),1)-repmat(MI,size(X,1),1));

  vEstimados = (vEstimados-repmat(MI,size(vEstimados,1),1))./(repmat(MA,... %para usarlos posteriormente
                size(vEstimados,1),1)-repmat(MI,size(vEstimados,1),1));
  
  % los datos han sido ya clasificados, por tanto los centros de las clases se
  % inicializarán a las medias de la clasificación obtenida
  DatosClasificados = true; 
  [v,U, distancia, iteraciones, Jcost] = fuzzy_clustering (X,c,m,e,vEstimados,DatosClasificados);
    
  coeficiente = 1;
  CvalidezFuzzy = validezFuzzy(X,v,U,distancia,coeficiente,m,c);
  
    %desnormalización de v
  v = (repmat(MA,size(v,1),1) - repmat(MI,size(v,1),1)).*v + ...
        repmat(MI,size(v,1),1);

  for i=1:1:c
    DATOS_CLASES(i).vFuzzy = v(i,:);
    DATOS_CLASES(i).UFuzzy = U(i,:);
  end

  % Clasificador Bayesiano 
  DATOS_CLASES = Bayesian(DATOS_CLASES, c);
  
  [Divergencia, Coseno_alpha, Jeffries_Matusita] = validezBayesian(DATOS_CLASES,c);
  
  % si el coeficiente CP (en el futuro ponemos más Fuzzy y los de Bayes)
  if CvalidezFuzzy.CP > 0.8
     % se requiere una nueva partición
     NuevaParticion = false;
  end
end % bucle while NuevaParticion  
  
 % una vez validada la partición se continúa con el resto de algoritmos    
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 5: Aprendizaje Lloyd, Self-Organizing, Red neuronal %%%%%%%
 %%%%%%%%          Los métodos de Fuzzy Clustering y Bayesian se    %%%%%%%
 %%%%%%%%          han relizado previamente                         %%%%%%%  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Algoritmo de Lloyd
 prompt = {'Razón de Aprendizaje','Número Máximo Iteraciones','Tolerancia'};
 dlg_title = 'Párametros para el algoritmo de Lloyd';
 num_lines = 1;
 def = {'0.1','1000','1e-10'};
 answer = inputdlg(prompt,dlg_title,num_lines,def,options);
 Razonaprendizaje = str2num(answer{1});
 iteraciones = str2num(answer{2});
 tolerancia = str2num(answer{3});
 [DATOS_CLASES, iteraciones] = Lloyd(DATOS_CLASES,c, Razonaprendizaje, iteraciones, tolerancia);
 
 % Algoritmo de SOM 
 prompt = {'Alpha_i','Alpha_f','Número Máximo Iteraciones','Umbral','Tolerancia'};
 dlg_title = 'Párametros para el algoritmo SOFM';
 num_lines = 1;
 def = {'1e-1','1e-2','1000','1e-5','1e-6'};
 answer = inputdlg(prompt,dlg_title,num_lines,def,options);
 alphai = str2num(answer{1});
 alphaf = str2num(answer{2});
 iteraciones = str2num(answer{3});
 Umbral = str2num(answer{4});
 tolerancia = str2num(answer{5});
 [DATOS_CLASES, iteracionesReales] = SOFeatureMap (DATOS_CLASES,c, alphai,alphaf, iteraciones, Umbral, tolerancia);

 % Red neuronal Backpropagation
 topologia = TopologiaRedBC(c);
 
 prompt = {'Intervalo de muestra de resultados','Razón de aprendizaje','Max Num iteraciones','tolerancia'};
 dlg_title = 'Parametros de aprendizaje';
 num_lines = 1;
 def = {'500','0.2','10000','1e-1'};
 answer = inputdlg(prompt,dlg_title,num_lines,def,options); 
 parametros.IntervaloResultados = str2num(answer{1}); %mostrar resultados cada valor de ese intervalo de entrenamiento
 parametros.RazonAprendizaje = str2num(answer{2});    %razón de aprendizaje
 parametros.NumMaxIter = str2num(answer{3});          %número máximo de iteraciones
 parametros.ToleranciaError = str2num(answer{4});     %error de tolerancia

 [red,tr] = RetroPropagacion (DATOS_CLASES,c,topologia,parametros);
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 6: alamacenar los datos en la BC       %%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 save ParamAprendizaje DATOS_CLASES red tr

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 7: verificación del aprendizaje de la red %%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % verificación de cómo ha aprendido la red definir patrones objetivo
  patronObjetivo = GenerarPatronObjetivo(c);

 hh = 0;
  for ii=1:1:c
     muestras_clase = DATOS_CLASES(ii).numero_muestras;
     for jj=1:muestras_clase
        hh = hh + 1;
        patrones(hh,:) = DATOS_CLASES(ii).muestras(jj,:);
        objetivo(hh,:) = patronObjetivo(ii).patron;   
     end
  end

  MI=min(patrones); %minimo
  MA=max(patrones); %maximo
  patrones=(patrones-repmat(min(patrones),size(patrones,1),1))./(repmat(max(patrones),...
     size(patrones,1),1)-repmat(min(patrones),size(patrones,1),1));

  patrones = patrones'; objetivo = objetivo';
  
  % la Y debería ser igual al objetivo
  Y = sim(red,patrones);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 8: representación de los datos y centros Fuzzy      %%%%%%%
 %%%%%%%%          en 3 y 2 dimensiones                             %%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  figure;
%  plot3(X1(:,1),X1(:,2),X1(:,3),'k.',v(:,1),v(:,2),v(:,3),'kd','LineWidth',3);
%  hold on
%  plot3(v(1,1),v(1,2),v(1,3),'gd','LineWidth',5); 
%  plot3(v(2,1),v(2,2),v(2,3),'rd','LineWidth',5); 
%  plot3(v(3,1),v(3,2),v(3,3),'bd','LineWidth',5);
%  plot3(v(4,1),v(4,2),v(4,3),'yd','LineWidth',5);
%  grid on
 q = 2; % proyección a la dimensión q (en este caso bidimensional)
 [y,vp,V,D] = Componentes_principales(X1,v,q,c);
 grid on
 figure; plot(y(:,1),y(:,2),'k.','LineWidth',3)
 hold on; plot(vp(1,1),vp(1,2),'gd','LineWidth',5)
 hold on; plot(vp(2,1),vp(2,2),'rd','LineWidth',5)
 hold on; plot(vp(3,1),vp(3,2),'bd','LineWidth',5)
 hold on; plot(vp(4,1),vp(4,2),'bd','LineWidth',5)   

