%% PR�CTICA 9
% Carlos Jaynor M�rquez Torres

% Daniel Tocino Estrada

% par�metros del clasificador
  clear all;
  close all;
  
 %definici�n de par�metros para las ventanas modales de di�logo
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
%%%%%%%%%         se pregunta que si la carga se har� desde fichero %%%%%%%
%%%%%%%%%         o por selecci�n de datos con el rat�n    %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 's';
prompt = {'s/n'};
dlg_title = '�nuevos datos?';
num_lines = 1;
def = {'s'};
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
n = answer{1};
if (strcmp(n,'s') ~= 0)

    n = 's';
    num_img = 0;
    while(strcmp(n,'s') ~= 0) % pregunta de m�s im�genes

      % numero de im�genes
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
      dlg_title = '�seleccionar muestras con el rat�n?';
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
  
      X = [X;XO]; %concatenaci�n
      Xo = X;     % datos originales
      clear XO;
      prompt = {'s/n'};
      dlg_title = '�M�s im�genes de entrenamiento?';
      num_lines = 1;
      def = {'s'};
      answer = inputdlg(prompt,dlg_title,num_lines,def,options);
      n = answer{1};

  end %while(strcmp(n,'s') ~= 0) % pregunta de m�s im�genes

  % quitamos la primera fila de X, que se a�adi� al crearla
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
%%%%%%%%  Paso 3: proceso de partici�n de los datos   %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dar la opci�n sobre si lo que se desea es realizar la partici�n con el algoritmo 
% Fuzzy d�ndo el n�mero de cl�steres o determinar el n�mero de cl�steres 
% de forma autom�tica mediante el algoritmo de cuantizaci�n vectorial    

NuevaParticion = true;

prompt = {'Peso exponencial','Criterio de terminaci�n'};
dlg_title = 'P�rametros para el algoritmo Fuzzy';
num_lines = 1;
def = {'2','1e-2'};
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
m = str2num(answer{1});
e = str2num(answer{2});

while NuevaParticion
  n = 's';
  prompt = {'s/n'};
  dlg_title = 's -> FC, n -> CV'; % s: fuzzy Clustering; n: Cuantizaci�n Vectorial 
  num_lines = 1;
  def = {'s'};
  answer = inputdlg(prompt,dlg_title,num_lines,def,options);
  n = answer{1};
  if (strcmp(n,'s') ~= 0)  % punto A
     % se ha elegido la opci�n de fijar el n�mero de cl�steres para d�rselo
     % al algoritmo de Fuzzy clustering para realizar la partici�n de los
     % datos
     prompt = {'N�mero de Cl�steres'};
     dlg_title = 'Numero de Cl�steres';
     num_lines = 1;
     def = {'4'};
     answer = inputdlg(prompt,dlg_title,num_lines,def,options);
     c = str2num(answer{1});

     % los datos est�n todav�a sin clasificar, por tanto los centros de las clases se
     % inicializar�n de forma aleatoria
     
     vEstimados = zeros (1,3);  % no se usar� realmente es s�lo para concordancia de par�metros con
                                % la funci�n posterior
     DatosClasificados = false; 
     [v,U, distancia, iteraciones, Jcost] = fuzzy_clustering (X,c,m,e,vEstimados,DatosClasificados);

     %desnormalizaci�n de v
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
     % se ha elegido la opci�n de determinar el n�mero de cl�steres de forma
     % autom�tica a trav�s del algoritmo de cuantizaci�n vectorial
     prompt = {'Umbral'};
     dlg_title = 'Umbral diferenciaci�n de Cl�steres';
     num_lines = 1;
     def = {'80'};
     answer = inputdlg(prompt,dlg_title,num_lines,def,options);
     T = str2num(answer{1});
     [N,n] = size(X);

     % inicializaci�n
     DATOS_CLASES(1).centroCVectorial = X1(1,:);  
     DATOS_CLASES(1).muestras(1,:)    = X1(1,:);   
     DATOS_CLASES(1).numero_muestras = 1; %numero de patrones
     c = 1; %numero de clases

     %clase(1).centro = X(1,:);
     %clase(1).patrones(1,:) = X(1,:);
     %clase(1).np = 1; %numero de patrones
     %nc = 1;  

     for j=2:1:N % punto B: n�mero de muestras
       % se computa la distancia del nuevo patron a los centros
       nueva_clase = false;
       for h=1:1:c
         d(h) = norm(X1(j,:)-DATOS_CLASES(h).centroCVectorial);
       end

       %calcular la distancia m�nima a los centros de cada clase, con indicaci�n de la clase (h) 
       dmin = min(d);
       h = find(d == dmin);

       % si esa distancia m�nima es inferior a un umbral determinado, a�adir el
       % patr�n a la clase, de otro modo crear una nueva clase
       if dmin < T
          DATOS_CLASES(h).numero_muestras = DATOS_CLASES(h).numero_muestras + 1;
          DATOS_CLASES(h).muestras(DATOS_CLASES(h).numero_muestras,:) = X1(j,:);   

          %clase(h).np = clase(h).np + 1;
          %clase(h).patrones(clase(h).np,:) = X(j,:);
       else % hay que crear una nueva clase 
          nueva_clase = true;
       end
  
       % creaci�n de la nueva clase
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
 %%%%%%%%  Paso 4: validaci�n de la partici�n   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
  % Generacion del vector X, de nuevo a partir de las clases
  % Se obtiene adem�s una estima (vEstimados, media para cada clase)
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
  % inicializar�n a las medias de la clasificaci�n obtenida
  DatosClasificados = true; 
  [v,U, distancia, iteraciones, Jcost] = fuzzy_clustering (X,c,m,e,vEstimados,DatosClasificados);
    
  coeficiente = 1;
  CvalidezFuzzy = validezFuzzy(X,v,U,distancia,coeficiente,m,c);
  
    %desnormalizaci�n de v
  v = (repmat(MA,size(v,1),1) - repmat(MI,size(v,1),1)).*v + ...
        repmat(MI,size(v,1),1);

  for i=1:1:c
    DATOS_CLASES(i).vFuzzy = v(i,:);
    DATOS_CLASES(i).UFuzzy = U(i,:);
  end

  % Clasificador Bayesiano 
  DATOS_CLASES = Bayesian(DATOS_CLASES, c);
  
  [Divergencia, Coseno_alpha, Jeffries_Matusita] = validezBayesian(DATOS_CLASES,c);
  
  % si el coeficiente CP (en el futuro ponemos m�s Fuzzy y los de Bayes)
  if CvalidezFuzzy.CP > 0.8
     % se requiere una nueva partici�n
     NuevaParticion = false;
  end
end % bucle while NuevaParticion  
  
 % una vez validada la partici�n se contin�a con el resto de algoritmos    
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 5: Aprendizaje Lloyd, Self-Organizing, Red neuronal %%%%%%%
 %%%%%%%%          Los m�todos de Fuzzy Clustering y Bayesian se    %%%%%%%
 %%%%%%%%          han relizado previamente                         %%%%%%%  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Algoritmo de Lloyd
 prompt = {'Raz�n de Aprendizaje','N�mero M�ximo Iteraciones','Tolerancia'};
 dlg_title = 'P�rametros para el algoritmo de Lloyd';
 num_lines = 1;
 def = {'0.1','1000','1e-10'};
 answer = inputdlg(prompt,dlg_title,num_lines,def,options);
 Razonaprendizaje = str2num(answer{1});
 iteraciones = str2num(answer{2});
 tolerancia = str2num(answer{3});
 [DATOS_CLASES, iteraciones] = Lloyd(DATOS_CLASES,c, Razonaprendizaje, iteraciones, tolerancia);
 
 % Algoritmo de SOM 
 prompt = {'Alpha_i','Alpha_f','N�mero M�ximo Iteraciones','Umbral','Tolerancia'};
 dlg_title = 'P�rametros para el algoritmo SOFM';
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
 
 prompt = {'Intervalo de muestra de resultados','Raz�n de aprendizaje','Max Num iteraciones','tolerancia'};
 dlg_title = 'Parametros de aprendizaje';
 num_lines = 1;
 def = {'500','0.2','10000','1e-1'};
 answer = inputdlg(prompt,dlg_title,num_lines,def,options); 
 parametros.IntervaloResultados = str2num(answer{1}); %mostrar resultados cada valor de ese intervalo de entrenamiento
 parametros.RazonAprendizaje = str2num(answer{2});    %raz�n de aprendizaje
 parametros.NumMaxIter = str2num(answer{3});          %n�mero m�ximo de iteraciones
 parametros.ToleranciaError = str2num(answer{4});     %error de tolerancia

 [red,tr] = RetroPropagacion (DATOS_CLASES,c,topologia,parametros);
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 6: alamacenar los datos en la BC       %%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 save ParamAprendizaje DATOS_CLASES red tr

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 7: verificaci�n del aprendizaje de la red %%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % verificaci�n de c�mo ha aprendido la red definir patrones objetivo
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
  
  % la Y deber�a ser igual al objetivo
  Y = sim(red,patrones);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%  Paso 8: representaci�n de los datos y centros Fuzzy      %%%%%%%
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
 q = 2; % proyecci�n a la dimensi�n q (en este caso bidimensional)
 [y,vp,V,D] = Componentes_principales(X1,v,q,c);
 grid on
 figure; plot(y(:,1),y(:,2),'k.','LineWidth',3)
 hold on; plot(vp(1,1),vp(1,2),'gd','LineWidth',5)
 hold on; plot(vp(2,1),vp(2,2),'rd','LineWidth',5)
 hold on; plot(vp(3,1),vp(3,2),'bd','LineWidth',5)
 hold on; plot(vp(4,1),vp(4,2),'bd','LineWidth',5)   

