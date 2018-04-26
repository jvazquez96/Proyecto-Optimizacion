function valuesO = DE(Fitness, ProblemDim, LowerBoundV,UpperBoundV,PopulationS,CrossoverRate,DiffWeight,StopCriteria)
    % La función recibe:
    % Fitness = un handle a una función fitness, 
    % ProblemDim = un entero que indica la cantidad de dimensiones, 
    % LowerBoundV = un vector del tamaño de las dimensiones que contiene el
    % minimo de cada dimensión
    % UpperBoundV = un vector del tamaño de las dimensiones que contiene el
    % maximo de cada dimensión
    % PopulationS = un entero que indica el tamaño de la población
    % CrossoverRate = un flotante que indica la probabilidad de cruza
    % DiffWeight = un flotante que indica el differential weight
    % StopCriteria = un entero que indicala cantidad maximas de
    % evaluaciones
    
    % Almacenar los datos de prueba
    m = csvread('creditcard.csv');
    
    % Vector de que contiene la mejor solución de cada dimensión
    best_sol = zeros(1,ProblemDim); 
    best_fitness = inf;
    % Definir la estructura de salida
    valuesO = struct;
    valuesO(1).Students = {'Jorge Vazquez','Andres Sosa','Hector Rincon'};
    valuesO(1).IDs = {'A01196160','A01176075','A01088760'};
    valuesO(1).Best_sol = best_sol;
    valuesO(1).Best_fitness = best_fitness;
    valuesO(1).Best_Fitness_Iter = [];
    valuesO(1).Mean_Fitness_Iter = [];
    valuesO(1).STD_Fitness_Iter = [];
    % Contadores para calcular la cantidad minima y maxima de veces
    % que no hubo un cambio en el fitness de la población.
    min_evaluations = 0;
    max_evaluations = 0;
    min_value = inf;
    % falta llenar la estructura y si un child sale de bound regresarlo y verificar que jale todo :v
    Population = [];
    FitPopulation = [];
    Populationaux = [];
    % Obtener una poblacion random
    for j = PopulationS
        Populationaux = [];
        for i = 1:ProblemDim
            Populationaux = [Populationaux LowerBoundV(i)+(UpperBoundV(i)-LowerBoundV(i))*rand(PopulationS,1)];
        end
        Population = [Population ; Populationaux];
    end
    % Calcular el fitness de cada población
    for i = 1:PopulationS
        FitPopulation = [FitPopulation ; Fitness(Population(i,:))];
    end
    Cont = 0;
    while Cont < StopCriteria
       auxPopulation = [];  
       for i = 1:PopulationS
           % Elige tres individuales de manera aleatoria
           grabIndividuals = ceil(rand(1,3)*PopulationS);
           % Hace formual de crossover (No estoy seguro como se une el padre con el trail vector solo los sume)
           auxIndividual = Population(grabIndividuals(1),:)+DiffWeight.*(Population(grabIndividuals(2),:)-Population(grabIndividuals(3),:));
           % Indice que vamos a cambiar sin importar el crossoverRate
           randomForzedIndex = ceil(rand()*PopulationS);
           for j = 1:ProblemDim
               % Agregar los valores que se van a quedar
               % En vez del if else solo hago un caso inverso de if para solo agregar los valores que se van a quedar
               if  rand()>CrossoverRate && i ~= randomForzedIndex
                    auxIndividual(1,j) = Population(i,j);                  
               end
           end
           fitnessEval = Fitness(auxIndividual);
           if fitnessEval < FitPopulation(i)
               Population(i,:) = auxIndividual;
               FitPopulation(i) =  fitnessEval;
               if fitnessEval < min_value
                   min_value = fitnessEval;
                   if min_evaluations > max_evaluations
                       max_evaluations = min_evaluations;
                   end
                   min_evaluations = 0;
               end
           end
           % Modifica toda la poblacion y deja a los de Fitness menor
           Cont = Cont+1;
       end
       min_evaluations = min_evaluations + 1;
       % Almacena el mejor, promedio y la desviación estandar de cada
       % dimensión
       valuesO(1).Best_Fitness_Iter = [valuesO(1).Best_Fitness_Iter ; min(FitPopulation)];
       valuesO(1).Mean_Fitness_Iter = [valuesO(1).Mean_Fitness_Iter ; mean(FitPopulation)];
       valuesO(1).STD_Fitness_Iter = [valuesO(1).STD_Fitness_Iter ; std(FitPopulation)];
       
    end
    valuesO(1).max_evaluations = max_evaluations;
    [valuesO(1).Best_fitness, Index]  = min(FitPopulation);
    valuesO(1).Best_sol = Population(Index,:);
    figure(1);
    plot(valuesO(1).Best_Fitness_Iter, 'o-','linewidth',3,'markersize',40,'markerfacecolor','g');
    title("Best fitness");
    xlabel("Iterations");
    ylabel("Fitness value");
    figure(2);
    plot(valuesO(1).Mean_Fitness_Iter, 'o-','linewidth',3,'markersize',40,'markerfacecolor','g');
    title("Mean fitness");
    xlabel("Iterations");
    ylabel("Fitness value");
    figure(3);
    plot(valuesO(1).STD_Fitness_Iter, 'o-','linewidth',3,'markersize',40,'markerfacecolor','g');
    title("STD fitness");
    xlabel("Iterations");
    ylabel("Fitness value");
end