classdef TarjetasDeCalculo < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        AplicacindeTarjetasdeClculoUIFigure  matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        TabGroup                        matlab.ui.container.TabGroup
        ConfiguracinTab                 matlab.ui.container.Tab
        GridLayout12                    matlab.ui.container.GridLayout
        GridLayout22                    matlab.ui.container.GridLayout
        SettingsMessage                 matlab.ui.control.Label
        GridLayout18                    matlab.ui.container.GridLayout
        OpcionesdeVariablesButtonGroup  matlab.ui.container.ButtonGroup
        xortButton                      matlab.ui.control.RadioButton
        VariosButton                    matlab.ui.control.RadioButton
        ShowsolutionsButtonGroup        matlab.ui.container.ButtonGroup
        NoButton                        matlab.ui.control.RadioButton
        SButton                         matlab.ui.control.RadioButton
        TiposdeProblemasPanel           matlab.ui.container.Panel
        GridLayout13                    matlab.ui.container.GridLayout
        GridLayout14                    matlab.ui.container.GridLayout
        TiposdeFuncionesPanel           matlab.ui.container.Panel
        TrigFunctions                   matlab.ui.control.CheckBox
        ExpLnFunctions                  matlab.ui.control.CheckBox
        PolynomialFunctions             matlab.ui.control.CheckBox
        AleatorizarPanel                matlab.ui.container.Panel
        allTypesCheckBox                matlab.ui.control.CheckBox
        IntegralesPanel                 matlab.ui.container.Panel
        definiteIntCheckBox             matlab.ui.control.CheckBox
        substitutionIntCheckBox         matlab.ui.control.CheckBox
        simpleintegralCheckBox          matlab.ui.control.CheckBox
        bypartsIntCheckBox              matlab.ui.control.CheckBox
        allintegralsCheckBox            matlab.ui.control.CheckBox
        DerivadasPanel                  matlab.ui.container.Panel
        powerrulelinearityDerCheckBox   matlab.ui.control.CheckBox
        chainruleDerCheckBox            matlab.ui.control.CheckBox
        simplederivativesCheckBox       matlab.ui.control.CheckBox
        productruleDerCheckBox          matlab.ui.control.CheckBox
        allderivativesCheckBox          matlab.ui.control.CheckBox
        ProblemasdePrcticaTab           matlab.ui.container.Tab
        GridLayout2                     matlab.ui.container.GridLayout
        GridLayout3                     matlab.ui.container.GridLayout
        GridLayout16                    matlab.ui.container.GridLayout
        FeedbackStatement               matlab.ui.control.Label
        GridLayout17                    matlab.ui.container.GridLayout
        ProposedSoln                    matlab.ui.control.Label
        ProposedSolnLabel               matlab.ui.control.Label
        GridLayout15                    matlab.ui.container.GridLayout
        GridLayout7                     matlab.ui.container.GridLayout
        VistaPreviadelaSolucinButton    matlab.ui.control.Button
        EnviarSolucinButton             matlab.ui.control.Button
        GridLayout6                     matlab.ui.container.GridLayout
        SolPrompt                       matlab.ui.control.Label
        SolutionEditField               matlab.ui.control.EditField
        GridLayout5                     matlab.ui.container.GridLayout
        Warning                         matlab.ui.control.Label
        ProbStatement                   matlab.ui.control.Label
        GridLayout4                     matlab.ui.container.GridLayout
        GenerarProblemaButton           matlab.ui.control.Button
        AnlisisTab                      matlab.ui.container.Tab
        GridLayout19                    matlab.ui.container.GridLayout
        GridLayout20                    matlab.ui.container.GridLayout
        GridLayout24                    matlab.ui.container.GridLayout
        AnalysisFeedback                matlab.ui.control.Label
        GridLayout23                    matlab.ui.container.GridLayout
        BorarHistoriaButton             matlab.ui.control.Button
        UITable                         matlab.ui.control.Table
        UIAxes                          matlab.ui.control.UIAxes
    end


    properties (Access = private)
        myFun           % a symbolic function used in this problem
        mySol           % a symbolic solution used in this problem
        varChoice       % the variable to use in myFun
        probOpts        % tracks the possible problem types considered
        probType        % tracks the type of problem
        funcOpts        % tracks the types of functions allowed
        aTob            % a vector of the endpoints of a definite integral
        varOpts         % a vector of potential variables
        bds             % a vector of limits on the choices of constants
        myAnswer        % a symbolic function containing the solution
        prevFuncType    % Tracks the last type of function generated
        lastFive        % a matrix recording the last five attempts on each probOpt
        solnChkAttempts % a vector counting total checked submissions by probOpt
        numResub        % a vector counting total checked submissions by probOpt with newQuestionFlag == 0
        errorCount      % a vector counting total errors by probOpt
        numCorrect      % a vector counting total correct solutions by probOpt
        generatedProbs  % a vector counting total problems generated by probOpt
        recordResults   % a boolean that tracks whether results should be recorded
        fullNames = ["simpleDer" "prodDer" "chainDer" "powerDer" "simpleInt" "subsInt" "byPartsInt" "defInt"; ...
            "Derivada simple" "Derivada por la Regla del Producto" "Derivada por la Regla de la Cadena" "Derivada por las Reglas de Potencia y Linealidad" ...
            "Integral simple" "Integral por Sustitución" "Integración por Partes" "Integral definida"; ...
            "Der. Simple" "Der. Producto" "Der. Cadena" "Der. Potencia y Linealidad" ...
            "Int. Simple" "Int. Sustitución" "Int. por Partes" "Int. Definida"];
        showSoln        % a boolean that tracks whether solutions should be shown
        newQuestionFlag % a boolean that tracks whether a new question is currently showing
        needNewQuesFlag % a boolean that tracks whether the current question is of an unselected probType
    end

    methods (Access = private)

        function addVarOpts(app,var)
            idx = find(app.varOpts == var,1);
            if isempty(idx)
                app.varOpts = [app.varOpts var];
            end
        end

        function dropVarOpts(app,var)
            app.varOpts = app.varOpts(app.varOpts~=var);
            app.allVarsCheckBox.Value = 0;
        end

        function genProb(app)
            % Clear the warning from the previous problem
            app.Warning.Text = " ";
            app.Warning.FontColor = [0.85,0.33,0.10];
            if ~isempty(app.probOpts)
                app.varChoice = app.varOpts(randi([1 length(app.varOpts)], 1));
                app.probType = app.probOpts(randi([1 length(app.probOpts)],1));
                genProbType(app)
                if ~isempty(app.myFun)
                    myFuncStr = latex(app.myFun);
                    if contains(app.probType,"Der")
                        formatSpec = "Calcula la derivada de $f(%s) = %s$ con respecto a %s.";
                        str = compose(formatSpec,[app.varChoice myFuncStr app.varChoice]);
                    elseif contains(app.probType,"def")
                        formatSpec = "Calcula la integral $\\displaystyle\\int_{%i}^{%i}%s\\,d%s$";
                        str = compose(formatSpec,app.aTob(1),app.aTob(2),myFuncStr,app.varChoice);
                    else
                        formatSpec = "Calcula la integral $\\displaystyle\\int %s\\,d%s$";
                        str = compose(formatSpec,[myFuncStr app.varChoice]);
                    end
                    app.ProbStatement.Text = str;
                    % Print the appropriate solution prompt for the problem
                    % type and variable choice
                    if contains(app.probType,"Der")
                        formatStr = "$\\frac{df}{d%s} = $";
                        str = compose(formatStr,app.varChoice);
                    elseif contains(app.probType,"def")
                        formatStr = "$\\displaystyle\\int_{%i}^{%i}f(%s)\\,d%s = $";
                        str = compose(formatStr,app.aTob(1),app.aTob(2),app.varChoice,app.varChoice);
                    else
                        formatStr = "$\\displaystyle\\int f(%s)\\,d%s = $";
                        str = compose(formatStr,app.varChoice,app.varChoice);
                    end
                    app.SolPrompt.Text = str;
                    % Set remaining warning necessary for new problem
                    if contains(app.probType,"Int")
                        app.Warning.Text = app.Warning.Text + " Si es necesario, usa +C. ";
                    end
                    if contains(app.probType,"def")
                        app.Warning.Text = app.Warning.Text + " Si la integral diverge, usa Inf " + ...
                            "para $\infty$ o -Inf para $-\infty$ o DNE para 'no existe'.";
                    end
                end
            else
                app.ProbStatement.Text = "Por favor, selecciona al menos un tipo de problema en la pestaña de Configuración " + ...
                    "y luego haz clic en 'Generar Problema'";
            end
            if app.Warning.Text == " "
                app.Warning.Text = "Si es necesario, las advertencias se mostrarán aquí.";
                app.Warning.FontColor = [0 0 0];
            end
        end

        function genProbType(app)
            f = 1; g = 1; x = 1; %#ok<NASGU> % Define local variables
            switch app.probType
                case "simpleDer"
                    app.myFun = genFunDiff(app,[1 10],app.varChoice,[5 10]);
                case "prodDer"
                    syms f(x) g(x) x
                    f(x) = genFunDiff(app,[1 7],x,[1 10]);
                    g(x) = genFunDiff(app,[1 7],x,[1 10]);
                    app.myFun = f(app.varChoice)*g(app.varChoice);
                case "chainDer"
                    syms f(x) g(x) x
                    f(x) = genFunDiff(app,[1 3],x,[1 10]);
                    g(x) = genFunDiff(app,[1 5],x,[1 10]);
                    app.myFun = f(g(app.varChoice));
                case "powerDer"
                    if app.funcOpts(1)
                        app.myFun = genFunDiff(app,[1 10],app.varChoice,[1 6]);
                    else
                        app.ProbStatement.Text = "Por favor, permite funciones polinómicas para practicar este tipo de problema.";
                        app.Warning.Text = "Puedes añadir funciones polinómicas en la pestaña de Configuración.";
                        app.myFun = string.empty;
                    end
                case "simpleInt"
                    syms f(x)
                    f(x) = genFunDiff(app,[1 7],x,[5 10]);
                    app.myFun = diff(f(app.varChoice),app.varChoice);
                case "byPartsInt"
                    if all(app.funcOpts == [1 0 0])
                        app.ProbStatement.Text = "Por favor, selecciona funciones trigonométricas y/o exponenciales y "...
                            + newline + "logaritmos para practicar este tipo de problema.";
                        app.Warning.Text = "Puedes añadir tipos de funciones en la pestaña de Configuración.";
                        app.myFun = string.empty;
                    else
                        syms f(x) g(x) x
                        [f(x),val] = genFunDiff(app,[1 10],x,[11 14]);
                        if val == 12
                            g(x) = genFunDiff(app,[1 10],x,[8 11]);
                            fun(x) = f(x)*g(x);
                            app.myFun = fun(app.varChoice);
                        else
                            app.myFun = f(app.varChoice);
                        end
                    end
                case "defInt"
                    a = randi([-3, 3], 1);
                    b = a+randi([0, 4], 1);
                    app.aTob = [a b];
                    app.myFun = genFunDiff(app,[1 7],app.varChoice,[1 10]);
                case "subsInt"
                    syms f(x) g(x) x
                    f(x) = genFunDiff(app,[1 3],x,[1 10]);
                    g(x) = genFunDiff(app,[1 5],x,[5 10]);
                    app.myFun = diff(f(g(app.varChoice)),app.varChoice);
            end
        end

        function [myFunc,type] = genFunDiff(app,bds,var,range)
            f = 1; t = 1; %#ok<NASGU> % Define local variables
            syms f(t)                     % Create a symbolic function f(t)
            params = randi(bds,[1 4]);   % Randomly choose parameter values
            shift = randi([0 max(abs(bds))],1); % Randomly choose a shift that may be 0
            sgns = randi([0 1],[1 3]);   % Randomly choose +/- signs

            % For readability, create parameters a,b,c, and d
            a = (-1)^sgns(1)*params(1);
            b = (-1)^sgns(2)*params(2);
            c = max(params(3),params(4));  % c > 0, it is only used as a denominator
            d = (-1)^sgns(3)*shift;

            if all(app.funcOpts)
                type = randi(range,1);
            elseif all(app.funcOpts == [1 0 0]) % Only polys
                localOpts = intersect(range(1):range(2),[1:6 12]);
                type = localOpts(randi(numel(localOpts),1));
            elseif all(app.funcOpts == [0 0 1]) % Only trig
                localOpts = [9 10];
                type = localOpts(randi(1:2,1));
            elseif all(app.funcOpts == [0 1 0]) % Only exp/ln
                localOpts = [7 8 11];
                type = localOpts(randi([1 3],1));
            elseif all(app.funcOpts == [1 0 1]) % No exp/ln
                localOpts = setdiff(range(1):range(2),[7 8 11 13 14]);
                type = localOpts(randi(numel(localOpts),1));
            elseif all(app.funcOpts == [1 1 0]) % No trig
                localOpts = setdiff(range(1):range(2),[9 10 13 14]);
                type = localOpts(randi(numel(localOpts),1));
            elseif all(app.funcOpts == [0 1 1]) % No polynomials
                localOpts = intersect(range(1):range(2),[7:11 13 14]);
                type = localOpts(randi(numel(localOpts),1));
            else
                warning("Esto nunca debería alcanzarse. No se seleccionó ninguna función.")
            end
            switch type
                case 1
                    f(t) = a*t^b+c*t^d;
                case 2
                    f(t) = a*t^b+t^(d/c);
                case 3
                    f(t) = t^a+c*t^b+t^d;
                case 4
                    f(t) = t^a+c*t^b+d;
                case 5
                    f(t) = a*t^(b);
                case 6
                    f(t) = a*t^(b/c);
                case 7
                    f(t) = a*log(abs(b)*t+d);
                    if (app.prevFuncType ~= 7)&&(app.prevFuncType ~= 11)
                        app.Warning.Text = "Recuerda que log(x) es la notación " + ...
                            "para un logaritmo natural de x en MATLAB. ";
                    end
                case 8
                    f(t) = a*exp(b*t+d);
                    if app.prevFuncType ~= 8
                        app.Warning.Text = "Recuerda que exp(x) es la notación " + ...
                            "para $e^x$ en MATLAB. ";
                    end
                case 9
                    f(t) = a*sin(b*t+d);
                case 10
                    f(t) = a*cos(b*t+d);
                case 11
                    f(t) = a*log(ceil(c/4)*t);
                    if (app.prevFuncType ~= 7)&&(app.prevFuncType ~= 11)
                        app.Warning.Text = "Recuerda que log(x) es la notación " + ...
                            "para un logaritmo natural de x en MATLAB. ";
                    end
                case 12
                    f(t) = a*t^c;
                case 13
                    f(t) = a*sin(b*t+d)*exp(b*t+d);
                case 14
                    f(t) = a*cos(b*t+d)*exp(b*t+d);
            end

            myFunc = f(var);
            app.prevFuncType = type;
        end

        function addType(app,opt)
            if isempty(app.probOpts)
                app.probOpts = opt;
                app.lastFive = zeros(1,5);
                app.solnChkAttempts = 0;
                app.errorCount = 0;
                app.generatedProbs = 0;
                app.numCorrect = 0;
                app.numResub = 0;
                app.needNewQuesFlag = 1;
            elseif nnz(contains(app.probOpts,opt)) == 0
                app.probOpts = [app.probOpts opt];
                app.lastFive = [app.lastFive; zeros(1,5)];
                app.solnChkAttempts = [app.solnChkAttempts; 0];
                app.errorCount = [app.errorCount; 0];
                app.generatedProbs = [app.generatedProbs; 0];
                app.numCorrect = [app.numCorrect; 0];
                app.numResub = [app.numResub; 0];
                app.needNewQuesFlag = 0;
            end
        end

        function removeType(app,opt)
            idx = app.probOpts ~= opt;
            app.probOpts = app.probOpts(idx);
            app.allTypesCheckBox.Value = 0;
            if contains(opt,"Der")
                app.allderivativesCheckBox.Value = 0;
            elseif contains(opt,"Int")
                app.allintegralsCheckBox.Value = 0;
            end
            app.lastFive = app.lastFive(idx,:);
            app.solnChkAttempts = app.solnChkAttempts(idx,:);
            app.errorCount = app.errorCount(idx,:);
            app.generatedProbs = app.generatedProbs(idx,:);
            app.numCorrect = app.numCorrect(idx,:);
            app.numResub = app.numResub(idx,:);
            if app.probType == opt
                app.needNewQuesFlag = 1;
            else
                app.needNewQuesFlag = 0;
            end
        end

        function isCorrect = checkSolution(app)
            C = 1; %#ok<NASGU,NASGU> % Define local variables
            syms C
            % Determine the correct solution
            if contains(app.probType,"Der")
                correctAnswer = diff(app.myFun,app.varChoice);
            elseif contains(app.probType,"def")
                correctAnswer = int(app.myFun,app.varChoice,app.aTob(1),app.aTob(2));
            else
                correctAnswer = int(app.myFun,app.varChoice)+C;
            end
            % Check if app.myAnswer is a correct solution
            if correctAnswer == app.myAnswer
                app.FeedbackStatement.Text = "Esta solución es correcta.";
                isCorrect = 1;
            elseif isnan(app.myAnswer)
                if isnan(correctAnswer)
                    app.FeedbackStatement.Text = "Esta solución no existe. Eso es correcto.";
                    isCorrect = 1;
                elseif ~isreal(correctAnswer)
                    app.FeedbackStatement.Text = "Esta solución no converge a un valor real. Eso es correcto.";
                    isCorrect = 1;
                elseif abs(correctAnswer) == Inf
                    app.FeedbackStatement.Text = "Esta integral diverge." + newline;
                    app.FeedbackStatement.Text = app.FeedbackStatement.Text + " De hecho, podemos decir aún más " + ...
                        "que 'no existe' porque cómo diverge es computable.";
                    isCorrect = 1;
                elseif app.showSoln == 1
                    app.FeedbackStatement.Text = "Esta integral diverge." + newline;
                else
                    app.FeedbackStatement.Text = app.FeedbackStatement.Text + "Esta respuesta es incorrecta. ";
                    isCorrect = 0;
                end
            elseif isnan(correctAnswer)
                app.FeedbackStatement.Text = "Esta respuesta es incorrecta. Esta solución no existe.";
                isCorrect = 0;
            elseif simplify(correctAnswer - app.myAnswer) == 0
                app.FeedbackStatement.Interpreter = "latex";
                if has(correctAnswer,C)
                    app.FeedbackStatement.Text = "Esta solución es correcta. Otra forma equivalente es: " + ...
                        "$\displaystyle " + latex(correctAnswer - C) + " + C$";
                else
                    app.FeedbackStatement.Text = "Esta solución es correcta. Otra forma equivalente es: " + ...
                        "$\displaystyle " + latex(correctAnswer) + "$";
                end
                isCorrect = 1;
            elseif contains(app.probType,"def") && isinf(correctAnswer)
                if app.showSoln == 1
                    app.FeedbackStatement.Text = "Esta integral diverge." + newline;
                end
                if isinf(app.myAnswer) && sign(correctAnswer)==sign(app.myAnswer)
                    isCorrect = 1;
                else
                    app.FeedbackStatement.Text = app.FeedbackStatement.Text + " Debes verificar tus signos " + ...
                        "y tus límites. ¿Dónde está la discontinuidad? ";
                    isCorrect = 0;
                end
            elseif contains(app.probType,"def") && has(app.myAnswer,C)
                app.FeedbackStatement.Text = "Esta respuesta es incorrecta. Esta integral definida debería darte " + ...
                    "un resultado numérico. ";
                isCorrect = 0;
            elseif contains(app.probType,"def") && (abs(vpa(correctAnswer)-app.myAnswer) < 1e-16)
                app.FeedbackStatement.Text = "Esta solución es correcta.";
                app.ProposedSoln.Text = app.ProposedSoln.Text + "$\approx$" + vpa(app.myAnswer);
                isCorrect = 1;
            elseif contains(app.probType,"Int") && (correctAnswer-C) == app.myAnswer
                app.FeedbackStatement.Text = "Esta respuesta está faltando +C. ";
                isCorrect = 0;
            elseif contains(app.probType,"Int") && ~contains(app.probType,"def") ...
                    && isAlways(diff(correctAnswer,app.varChoice) == diff(app.myAnswer,app.varChoice))
                app.FeedbackStatement.Text = "Esta solución es correcta. Otra forma equivalente es: " + ...
                    "$\displaystyle " + latex(correctAnswer - C) + " + C$";
                isCorrect = 1;
            else
                [~,outRest] = regexp(app.SolutionEditField.Value,'exp|sin|sqrt|log|tan|cot|cos|sec|csc','match','split');
                newStr = strjoin(outRest);
                outVars = regexp(newStr,'[xtyzwr]','match');
                varStr = strjoin(outVars);
                k = 1;
                while k <= length(varStr)
                    if convertCharsToStrings(varStr(k)) ~= app.varChoice
                        app.FeedbackStatement.Text = "Esta solución debería ser una función de " + app.varChoice + " no de " + varStr(k) + ". ";
                        k = length(varStr)+1;
                    end
                    % Requerido para saltar los caracteres en blanco incluidos por
                    % strjoin al crear varStr
                    k = k + 2;
                end
                app.FeedbackStatement.Text = app.FeedbackStatement.Text + "Esta respuesta es incorrecta. ";
                isCorrect = 0;
            end
            if app.showSoln == 1 && isCorrect == 0
                if contains(latex(correctAnswer),"C")
                    app.FeedbackStatement.Text = app.FeedbackStatement.Text + "La respuesta correcta " + ...
                        "es: $\displaystyle " + latex(correctAnswer-C) + "+ C$";
                elseif isnan(correctAnswer)
                    app.FeedbackStatement.Text = app.FeedbackStatement.Text + "La respuesta correcta es: DNE";
                elseif isinf(correctAnswer)
                    app.FeedbackStatement.Text = app.FeedbackStatement.Text + "La respuesta correcta " + ...
                        "es: $" + latex(sign(correctAnswer)*sym(Inf)) + "$";
                else
                    app.FeedbackStatement.Text = app.FeedbackStatement.Text + "La respuesta correcta " + ...
                        "es: $\displaystyle " + latex(correctAnswer) + "$";
                end
            end
        end

        function createAnalysisFeedbackText(app)
            if app.showSoln == 1
                numSkipped = app.generatedProbs-(app.numCorrect+app.errorCount);
                %                pctTypeWrong = (app.errorCount+numSkipped)./(app.generatedProbs)*100;
                overallRight = sum(app.numCorrect)/sum(app.generatedProbs)*100;
            else
                numSkipped = (app.generatedProbs + app.numResub) - (app.numCorrect + app.errorCount);
                %                pctTypeWrong = (app.errorCount+numSkipped)./(app.generatedProbs+app.numResub)*100;
                overallRight = sum(app.numCorrect)/(sum(app.generatedProbs)+sum(app.numResub))*100;
            end
            subPctWrong = app.errorCount./(app.numCorrect+app.errorCount)*100;
            overallNumSkipped = sum(numSkipped);
            %            pctTypeWrong(app.generatedProbs == 0) = 0;

            % Check if the user has completed any problems at all
            if sum(app.generatedProbs) == 0
                str = "Necesitas practicar antes de que haya resultados para analizar. Por favor, haz clic en la pestaña 'Problemas de Práctica'.";
            else
                if overallNumSkipped == 1
                    grammarChoice = "problema fue";
                else
                    grammarChoice = "problemas fueron";
                end
                str = compose("Tasa de éxito general: %.1f\\%% basada en %i problemas diferentes. %i %s omitidos. \n" + ...
                    "Continúa practicando haciendo clic en la pestaña 'Problemas de Práctica'.\n\n" + ...
                    "Desglose por tipo: \n",overallRight,sum(app.generatedProbs),overallNumSkipped,grammarChoice);
                % Setting up for later
                if max(app.generatedProbs) >= 5
                    lastCorrect = sum(app.lastFive,2);
                    grammarL5Choice = lastCorrect == 1;
                    grammarIdx = grammarL5Choice + 1;
                    grammarOpt = ["soluciones fueron" "solución fue"];
                end
                % Generate individual feedback by problem type
                for k = 1:length(app.probOpts)
                    longName = app.fullNames(2,find(app.fullNames(1,:) == app.probOpts(k)));
                    if app.generatedProbs(k) == 0
                        str = str + compose("%s: No se han generado problemas de este tipo aún. ",longName);
                    else
                        str = str + compose("%s: %i solución(es) enviada(s) de las cuales %.1f\\%% fueron incorrectas. ", ...
                            longName,app.errorCount(k)+app.numCorrect(k),subPctWrong(k));
                    end
                    % If problems of this type have been resubmitted, give
                    % additional feedback on how frequently
                    if app.numResub(k) == 1
                        str = str + "Hubo una reenvío. ";
                    elseif app.numResub(k) > 1
                        str = str + compose("Hubo %i reenvíos.",app.numResub(k));
                    end
                    % Si se han omitido problemas de este tipo, dar
                    % retroalimentación adicional sobre la frecuencia
                    if numSkipped(k) == 1
                        str = str + newline + "Se omitió un problema. ";
                    elseif numSkipped(k) > 1
                        str = str + newline + compose("Se omitieron %i problemas. ",numSkipped(k));
                    end
                    % If there have been more than 5 problems of this type,
                    % give additional feedback on latest rate of success
                    if app.generatedProbs(k) >= 5
                        str = str + compose("De los últimos cinco, %i %s correctos. ", ...
                            lastCorrect(k),grammarOpt(grammarIdx(k)));
                    end
                    str = str + newline;
                end
            end
            app.AnalysisFeedback.Text = str;
        end

        function updateScoreRecords(app,isCorrect)
            if app.recordResults
                idx = find(app.probOpts==app.probType);
                app.lastFive(idx,:) = [app.lastFive(idx,2:5) isCorrect];
                app.errorCount(idx) = app.errorCount(idx) + (1-isCorrect);
                app.numCorrect(idx) = app.numCorrect(idx) + isCorrect;
            else
                app.FeedbackStatement.Text = convertCharsToStrings(app.FeedbackStatement.Text) + newline ...
                    + "Esta entrega no se registra para análisis.";
            end
        end

        function results = previewSolution(app)
            C = 1; x = 1; y = 1; z= 1; w = 1; r = 1; t = 1; %#ok<NASGU> % Define local variables
            syms C x y z w r t %#ok<NASGU>
            app.ProposedSolnLabel.Text = "Mi solución es " + app.SolPrompt.Text;
            try
                if contains(app.SolutionEditField.Value,'DNE')
                    myAnswerStr = "NaN";
                elseif contains(app.SolutionEditField.Value,'int') || contains(app.SolutionEditField.Value,'diff')
                    ME = MException('InputField:invalidArgument','No puedes usar comandos de integración o diferenciación de MATLAB.');
                    throw(ME);
                else
                    % Testing for unknown functions or variables by
                    % stripping out all the known values and seeing what is
                    % left
                    [~,outRest] = regexp(app.SolutionEditField.Value,'exp|sin|sqrt|log|tan|cot|cos|sec|csc|Inf|-Inf','match','split');
                    newStr = strjoin(outRest);
                    [~,outVars] = regexp(newStr,'[xtyzwrC]','match','split');
                    varStr = strjoin(outVars);
                    testStr = regexp(varStr,'[a-zA-Z]*','match');
                    if ~isempty(testStr)
                        outTest = strjoin(testStr);
                        if regexp(outTest,'\<ln\>')
                            ME = MException("InputField:syntaxError","Debes usar log() para el logaritmo natural, no ln().");
                            throw(ME);
                        elseif regexp(outTest,'\<e\>')
                            ME = MException("InputField:syntaxError","Debes usar exp() para la función exponencial, no e^().");
                            throw(ME);
                        else
                            ME = MException("InputField:syntaxError","Variable desconocida o uso incorrecto de la función.");
                            throw(ME);
                        end
                    end
                    myAnswerStr = convertCharsToStrings(app.SolutionEditField.Value);
                end
                app.myAnswer = str2sym(myAnswerStr);
                if has(app.myAnswer,"C")
                    ansStr = latex(app.myAnswer - C);
                    app.ProposedSoln.Text = "$"+ansStr+" + C$";
                elseif myAnswerStr == "NaN"
                    app.ProposedSoln.Text = "DNE";
                else
                    app.ProposedSoln.Text = "$"+latex(str2sym(app.SolutionEditField.Value))+"$";
                end
                results = 1;
                app.FeedbackStatement.Text = " ";
            catch ME
                results = 0;
                str0 = string(1);
                str2 = string(1);
                % Give advice as to how to proceed to fix the error.
                app.FeedbackStatement.Interpreter = "none";
                app.ProposedSolnLabel.Text = "Error: ";
                if ME.identifier == "symbolic:str2sym:UnableToConvert"
                    app.ProposedSoln.Text = " Error de sintaxis";
                elseif ME.identifier == "InputField:syntaxError"
                    app.ProposedSoln.Text = " Uso incorrecto de ln";
                else
                    app.ProposedSoln.Text = " " + ME.identifier;
                end
                if contains(ME.message,"log()")
                    str2 = ME.message;
                    str0 = "Revisa tus logaritmos.";
                elseif ME.identifier == "MATLAB:UndefinedFunction"
                    if ME.message == "Unrecognized function or variable 'e'."
                        str0 = convertCharsToStrings(ME.message);
                        str2 = "¿Estás usando exp() para la función exponencial?";
                    elseif ME.message == "Undefined function 'ln' for input arguments of type 'sym'."
                        str0 = convertCharsToStrings(ME.message);
                        str2 = "¿Estás usando log(x) para el logaritmo natural?";
                    elseif contains(ME.message,"Unrecognized function")
                        str0 = convertCharsToStrings(ME.message);
                        str2 = "¿Estás usando funciones de MATLAB como exp(), cos(), sin(), sqrt() y log()?" + newline + ...
                            "¿Estás usando correctamente el comando de acento circunflejo, ^, para potencias?";
                    end
                elseif ME.identifier == "MATLAB:m_missing_operator"
                    str0 = convertCharsToStrings(ME.message);
                    str2 = "¿Te faltan símbolos *? Revisa todas tus multiplicaciones.";
                elseif contains(ME.message,"SYNER:") && ~contains(ME.message,"EOL")
                    str2 = extractAfter(ME.message,"SYNER:");
                    str0 = " ¿Te faltan símbolos *? Revisa todas tus multiplicaciones.";
                elseif contains(ME.message,"BADFP:")
                    str2 = extractAfter(ME.message,"BADFP:");
                    str0 = " ¿Te faltan símbolos *? Revisa todas tus multiplicaciones.";
                elseif contains(ME.message,"NOPAR:")
                    str2 = extractAfter(ME.message,"NOPAR:");
                    str0 = " ¿Te faltan símbolos *? ¿Todas tus paréntesis coinciden? ¿Estás usando " + ...
                        "nombres de funciones correctos?";
                elseif contains(ME.message,"Cell array")
                    str2 = " Deberías usar paréntesis, (), no llaves, {}, o corchetes, [], para agrupar elementos de tu expresión.";
                    str0 = " ¿Te faltan símbolos *? ¿Todas tus paréntesis coinciden?";
                elseif contains(ME.message,"<EOL>")
                    str0 = " Hay un error al final de la línea. ¿Tienes un operador colgante o " + ...
                        "un paréntesis sin cerrar?" + newline;
                    str2 = ME.message;
                elseif contains(ME.message,"integration or differentiation")
                    str0 = "Por favor, calcula la solución a mano. Puedes usar la práctica.";
                    str2 = ME.message;
                elseif contains(ME.identifier,"MATLAB")
                    str0 = "¿Te faltan símbolos *? Revisa todas tus multiplicaciones." + newline + ...
                        "¿Estás usando funciones de MATLAB como exp(), cos(), sin(), sqrt() y log()?" + newline + ...
                        "¿Estás usando correctamente el comando de acento circunflejo, ^, para potencias como x^n?";
                    str2 = ME.message;
                else
                    str2 = ME.message + newline + "¿Estás usando funciones de MATLAB como " + ...
                        "exp(), cos(), sin(), sqrt() y log()?" + newline + "Los detalles importan.";
                    str0 = "¿Te faltan símbolos *? Revisa todas tus multiplicaciones. " + ...
                        "¿Todas tus paréntesis coinciden?";
                end
                app.FeedbackStatement.Text = str0 + newline + newline + str2;
                app.FeedbackStatement.Interpreter = "latex";
            end
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function StartupFunction(app)
            app.varOpts = ["x" "y" "z" "t" "r" "w"];
            app.showSoln = 1;
            app.probOpts = "simpleDer";
            app.probType = "simpleDer";
            app.PolynomialFunctions.Value = 1;
            app.TrigFunctions.Value = 1;
            app.ExpLnFunctions.Value = 1;
            app.funcOpts = [1 1 1]; % Poly, ExpLn, Trig allowed
            app.simplederivativesCheckBox.Value = 1;
            app.TabGroup.SelectedTab = app.ConfiguracinTab;
            app.SettingsMessage.Text = "Por favor, selecciona los tipos de problemas deseados, variables y modo de visualización de la solución" + newline + "y luego haz clic en " + ...
                "'Problemas de Práctica'.";
            app.ProbStatement.Text = "Haz clic en el botón 'Generar Problema' para crear un nuevo problema.";
            app.SolutionEditField.Value = "Escribe tu solución aquí como código MATLAB.";
            app.lastFive = zeros(1,5);
            app.solnChkAttempts = zeros(1,1);
            app.errorCount = zeros(1,1);
            app.generatedProbs = zeros(1,1);
            app.numCorrect = zeros(1,1);
            app.numResub = zeros(1,1);
            app.newQuestionFlag = -1;
            app.needNewQuesFlag = 0;
            app.FeedbackStatement.Text = "Los comentarios sobre tu solución se muestran aquí cuando envías tu solución.";
            app.Warning.Text = "Las advertencias van aquí";
            app.SolPrompt.Text = "Indicación de la solución";
            app.ProposedSolnLabel.Text = " ";
            app.ProposedSoln.Text = "El botón 'Vista previa de la solución' " + ...
                "te permitirá ver tu solución sin verificarla.";
            app.FeedbackStatement.Text = "Cuando estés satisfecho " + ...
                "con tu solución, haz clic en 'Enviar solución' para registrar tu resultado." ...
                + newline + "Los comentarios sobre tu solución se mostrarán aquí." ...
                + newline + newline + "Cuando hayas resuelto suficientes problemas, selecciona la " + ...
                "pestaña 'Análisis' para ver cómo te va en cada tipo de problema.";
            app.prevFuncType = 0;
            % Set Font Size
            app.ProbStatement.FontSize = 14;
            app.SolutionEditField.FontSize = 14;
        end

        % Button pushed function: GenerarProblemaButton
        function GenerarProblemaButtonPushed(app, event)
            genProb(app)
            idx = find(app.probOpts == app.probType);
            app.generatedProbs(idx) = app.generatedProbs(idx)+1;
            app.newQuestionFlag = 1;
            app.SolutionEditField.Value = " ";
            app.ProposedSolnLabel.Text = "Mi solución es " + app.SolPrompt.Text;
            app.ProposedSoln.Text = "Previsualiza tu solución aquí";
            app.FeedbackStatement.Text = "Haz clic en 'Enviar solución' para registrar tus resultados.";
        end

        % Value changed function: allTypesCheckBox, 
        % ...and 10 other components
        function setTypeOptions(app, event)
            switch event.Source
                case app.allTypesCheckBox
                    if event.Source.Value
                        app.allderivativesCheckBox.Value = 1;
                        app.powerrulelinearityDerCheckBox.Value = 1;
                        app.productruleDerCheckBox.Value = 1;
                        app.chainruleDerCheckBox.Value = 1;
                        app.simplederivativesCheckBox.Value = 1;
                        app.allintegralsCheckBox.Value = 1;
                        app.simpleintegralCheckBox.Value = 1;
                        app.definiteIntCheckBox.Value = 1;
                        app.substitutionIntCheckBox.Value = 1;
                        app.bypartsIntCheckBox.Value = 1;
                        for opt = ["powerDer" "prodDer" "chainDer" "simpleDer" ...
                                "simpleInt" "byPartsInt" "subsInt" "defInt"]
                            addType(app,opt)
                        end
                        app.PolynomialFunctions.Value = 1;
                        app.ExpLnFunctions.Value = 1;
                        FunctionsValueChanged(app,event.Source)
                    else
                        app.allderivativesCheckBox.Value = 0;
                        app.powerrulelinearityDerCheckBox.Value = 0;
                        app.productruleDerCheckBox.Value = 0;
                        app.chainruleDerCheckBox.Value = 0;
                        app.simplederivativesCheckBox.Value = 0;
                        app.allintegralsCheckBox.Value = 0;
                        app.simpleintegralCheckBox.Value = 0;
                        app.definiteIntCheckBox.Value = 0;
                        app.substitutionIntCheckBox.Value = 0;
                        app.bypartsIntCheckBox.Value = 0;
                        for opt = ["powerDer" "prodDer" "chainDer" "simpleDer" ...
                                "simpleInt" "byPartsInt" "subsInt" "defInt"]
                            removeType(app,opt)
                        end
                    end
                case app.allderivativesCheckBox
                    if event.Source.Value
                        app.allderivativesCheckBox.Value = 1;
                        app.powerrulelinearityDerCheckBox.Value = 1;
                        app.productruleDerCheckBox.Value = 1;
                        app.chainruleDerCheckBox.Value = 1;
                        app.simplederivativesCheckBox.Value = 1;
                        for opt = ["powerDer" "prodDer" "chainDer" "simpleDer"]
                            addType(app,opt)
                        end
                        app.PolynomialFunctions.Value = 1;
                        FunctionsValueChanged(app,event.Source)
                    else
                        app.allderivativesCheckBox.Value = 0;
                        app.powerrulelinearityDerCheckBox.Value = 0;
                        app.productruleDerCheckBox.Value = 0;
                        app.chainruleDerCheckBox.Value = 0;
                        app.simplederivativesCheckBox.Value = 0;
                        for opt = ["powerDer" "prodDer" "chainDer" "simpleDer"]
                            removeType(app,opt)
                        end
                    end
                case app.allintegralsCheckBox
                    if event.Source.Value
                        app.allintegralsCheckBox.Value = 1;
                        app.simpleintegralCheckBox.Value = 1;
                        app.definiteIntCheckBox.Value = 1;
                        app.substitutionIntCheckBox.Value = 1;
                        app.bypartsIntCheckBox.Value = 1;
                        for opt = ["simpleInt" "byPartsInt" "subsInt" "defInt"]
                            addType(app,opt)
                        end
                        app.PolynomialFunctions.Value = 1;
                        app.ExpLnFunctions.Value = 1;
                        FunctionsValueChanged(app,event.Source)
                    else
                        app.allintegralsCheckBox.Value = 0;
                        app.simpleintegralCheckBox.Value = 0;
                        app.definiteIntCheckBox.Value = 0;
                        app.substitutionIntCheckBox.Value = 0;
                        app.bypartsIntCheckBox.Value = 0;
                        for opt = ["simpleInt" "byPartsInt" "subsInt" "defInt"]
                            removeType(app,opt)
                        end
                    end
                case app.powerrulelinearityDerCheckBox
                    if app.powerrulelinearityDerCheckBox.Value
                        addType(app,"powerDer")
                    else
                        removeType(app,"powerDer")
                    end
                case app.simplederivativesCheckBox
                    if event.Source.Value
                        addType(app,"simpleDer")
                    else
                        removeType(app,"simpleDer")
                    end
                case app.chainruleDerCheckBox
                    if event.Source.Value
                        addType(app,"chainDer")
                    else
                        removeType(app,"chainDer")
                    end
                case app.productruleDerCheckBox
                    if event.Source.Value
                        addType(app,"prodDer")
                    else
                        removeType(app,"prodDer")
                    end
                case app.definiteIntCheckBox
                    if event.Source.Value
                        addType(app,"defInt")
                    else
                        removeType(app,"defInt")
                    end
                case app.bypartsIntCheckBox
                    if event.Source.Value
                        addType(app,"byPartsInt")
                    else
                        removeType(app,"byPartsInt")
                    end
                case app.substitutionIntCheckBox
                    if event.Source.Value
                        addType(app,"subsInt")
                    else
                        removeType(app,"subsInt")
                    end
                case app.simpleintegralCheckBox
                    if event.Source.Value
                        addType(app,"simpleInt")
                    else
                        removeType(app,"simpleInt")
                    end
            end


        end

        % Selection changed function: OpcionesdeVariablesButtonGroup
        function setVarOpts(app, event)
            selectedButton = app.OpcionesdeVariablesButtonGroup.SelectedObject;
            if selectedButton == app.VariosButton
                app.varOpts = ["x" "y" "z" "t" "r" "w"];
            else
                app.varOpts = ["x" "t"];
            end
        end

        % Button pushed function: EnviarSolucinButton
        function EnviarSolucinButtonPushed(app, event)
            if app.newQuestionFlag == -1
                app.ProposedSoln.Text = "Debes generar un problema antes de poder " + ...
                    "resolverlo.";
                finished = 0;
            else
                finished = previewSolution(app);
            end
            if finished
                idx = find(app.probOpts==app.probType,1);
                app.recordResults = 1;
                if app.newQuestionFlag == 1
                    % Determine the correctness and update the Feedback
                    isCorrect = checkSolution(app);
                else
                    app.numResub(idx) = app.numResub(idx)+1;
                    if app.showSoln == 1
                        app.recordResults = 0;
                    end
                    isCorrect = checkSolution(app);
                end
                app.solnChkAttempts(idx) = app.solnChkAttempts(idx)+1;
                app.newQuestionFlag = 0;
                updateScoreRecords(app,isCorrect);
            end

        end

        % Selection changed function: ShowsolutionsButtonGroup
        function updateSolnsFlag(app, event)
            selectedButton = app.ShowsolutionsButtonGroup.SelectedObject;
            if selectedButton == app.NoButton
                app.showSoln = 0;
            else
                app.showSoln = 1;
            end
        end

        % Button down function: ProblemasdePrcticaTab
        function practiceMoreProblems(app, event)
            app.TabGroup.SelectedTab = app.ProblemasdePrcticaTab;
            if app.needNewQuesFlag == 1 && app.newQuestionFlag ~= -1
                GenerarProblemaButtonPushed(app,[])
            end
        end

        % Button down function: AnlisisTab
        function AnalyzeResultsButtonPushed(app, event)
            % Show components for analysis
            app.TabGroup.SelectedTab = app.AnlisisTab;
            % Set up plot
            app.UIAxes.XLabel.String = "Tipo de Problema";
            app.UIAxes.Title.String = "Tasas de Éxito por Tipo de Problema";
            app.UIAxes.YLabel.String = "Porcentaje";
            app.UIAxes.XTick = 1:length(app.probOpts);
            app.UIAxes.XTickLabel = app.probOpts;
            app.UIAxes.YTick = 0:20:100;
            app.UIAxes.YLim = [0 100];
            if app.showSoln == 1
                pctTypeCorrect = app.numCorrect./(app.generatedProbs)*100;
            else
                pctTypeCorrect = app.numCorrect./(app.generatedProbs+app.numResub)*100;
            end
            pctTypeCorrect(app.generatedProbs == 0) = 0;
            bar(app.UIAxes,pctTypeCorrect)
            % Set up table
            lastCorrect = sum(app.lastFive,2)*20;
            colNames = app.probOpts;
            needPractice = app.probOpts;
            for k = 1:length(app.probOpts)
                colNames(k) = app.fullNames(3,find(app.fullNames(1,:)==app.probOpts(k)));
                if app.generatedProbs(k) < 5 || (pctTypeCorrect(k) < 60 || lastCorrect(k) <= 3)
                    needPractice(k) = "Sí";
                elseif pctTypeCorrect(k) == 100 || (pctTypeCorrect(k) > 80 && lastCorrect(k) == 5)
                    needPractice(k) = "No";
                else
                    needPractice(k) = "Tal vez";
                end
            end
            pctError = (app.errorCount./app.solnChkAttempts)*100;
            pctError(app.solnChkAttempts == 0) = 0;
            pctSkipped = ((app.generatedProbs + app.numResub) - (app.solnChkAttempts))./app.generatedProbs*100;
            pctSkipped(app.generatedProbs == 0) = 0;
            app.UITable.Data = array2table([app.generatedProbs';pctError';pctSkipped';needPractice; ...
                lastCorrect']);
            app.UITable.ColumnName = colNames;
            app.UITable.RowName = ["Num. Generados" "% Incorrecto"  "% Omitido" "¿Necesita práctica?" ...
                "% Correcto de los últimos 5"];
            % Set up textual feedback
            createAnalysisFeedbackText(app)
        end

        % Button pushed function: VistaPreviadelaSolucinButton
        function VistaPreviadelaSolucinButtonPushed(app, event)
            if app.newQuestionFlag == -1
                app.ProposedSoln.Text = "Debes generar un problema antes de poder resolverlo.";
            else
                previewSolution(app);
            end
        end

        % Button pushed function: BorarHistoriaButton
        function BorarHistoriaButtonPushed(app, event)
            app.errorCount = zeros(size(app.errorCount));
            app.lastFive = zeros(size(app.lastFive));
            app.solnChkAttempts = zeros(size(app.solnChkAttempts));
            app.generatedProbs = zeros(size(app.generatedProbs));
            app.numCorrect = zeros(size(app.numCorrect));
            AnalyzeResultsButtonPushed(app,[])
        end

        % Value changed function: ExpLnFunctions, PolynomialFunctions, 
        % ...and 1 other component
        function FunctionsValueChanged(app, event)
            NewPolyValue = app.PolynomialFunctions.Value;
            NewExpLnValue = app.ExpLnFunctions.Value;
            NewTrigValue = app.TrigFunctions.Value;

            if any([NewPolyValue NewExpLnValue NewTrigValue])
                app.funcOpts = [NewPolyValue NewExpLnValue NewTrigValue];
            else
                app.SettingsMessage.Text = "Debes elegir al menos un tipo de función.";
                app.PolynomialFunctions.Value = true;
                app.funcOpts = [1 0 0];
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create AplicacindeTarjetasdeClculoUIFigure and hide until all components are created
            app.AplicacindeTarjetasdeClculoUIFigure = uifigure('Visible', 'off');
            app.AplicacindeTarjetasdeClculoUIFigure.Position = [100 100 805 704];
            app.AplicacindeTarjetasdeClculoUIFigure.Name = 'Aplicación de Tarjetas de Cálculo';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.AplicacindeTarjetasdeClculoUIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.BackgroundColor = [0 0.4471 0.7412];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create ConfiguracinTab
            app.ConfiguracinTab = uitab(app.TabGroup);
            app.ConfiguracinTab.Title = 'Configuración';

            % Create GridLayout12
            app.GridLayout12 = uigridlayout(app.ConfiguracinTab);
            app.GridLayout12.ColumnWidth = {'1x'};
            app.GridLayout12.RowHeight = {'1x', '1x', '4x'};

            % Create TiposdeProblemasPanel
            app.TiposdeProblemasPanel = uipanel(app.GridLayout12);
            app.TiposdeProblemasPanel.TitlePosition = 'centertop';
            app.TiposdeProblemasPanel.Title = 'Tipos de Problemas';
            app.TiposdeProblemasPanel.BackgroundColor = [0 0.4471 0.7412];
            app.TiposdeProblemasPanel.Layout.Row = 3;
            app.TiposdeProblemasPanel.Layout.Column = 1;
            app.TiposdeProblemasPanel.FontWeight = 'bold';
            app.TiposdeProblemasPanel.FontSize = 18;

            % Create GridLayout13
            app.GridLayout13 = uigridlayout(app.TiposdeProblemasPanel);
            app.GridLayout13.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout13.RowHeight = {'1x'};

            % Create DerivadasPanel
            app.DerivadasPanel = uipanel(app.GridLayout13);
            app.DerivadasPanel.TitlePosition = 'centertop';
            app.DerivadasPanel.Title = 'Derivadas';
            app.DerivadasPanel.Layout.Row = 1;
            app.DerivadasPanel.Layout.Column = 1;

            % Create allderivativesCheckBox
            app.allderivativesCheckBox = uicheckbox(app.DerivadasPanel);
            app.allderivativesCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.allderivativesCheckBox.Text = 'Todas las derivadas';
            app.allderivativesCheckBox.Position = [55 286 128 22];

            % Create productruleDerCheckBox
            app.productruleDerCheckBox = uicheckbox(app.DerivadasPanel);
            app.productruleDerCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.productruleDerCheckBox.Text = 'Regla del Producto';
            app.productruleDerCheckBox.Position = [55 69 124 22];

            % Create simplederivativesCheckBox
            app.simplederivativesCheckBox = uicheckbox(app.DerivadasPanel);
            app.simplederivativesCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.simplederivativesCheckBox.Text = 'Derivadas de Funciones';
            app.simplederivativesCheckBox.Position = [55 210 151 22];

            % Create chainruleDerCheckBox
            app.chainruleDerCheckBox = uicheckbox(app.DerivadasPanel);
            app.chainruleDerCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.chainruleDerCheckBox.Text = 'Regla de la Cadena';
            app.chainruleDerCheckBox.Position = [55 116 128 22];

            % Create powerrulelinearityDerCheckBox
            app.powerrulelinearityDerCheckBox = uicheckbox(app.DerivadasPanel);
            app.powerrulelinearityDerCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.powerrulelinearityDerCheckBox.Text = 'Reglas de Potencia y Linealidad';
            app.powerrulelinearityDerCheckBox.WordWrap = 'on';
            app.powerrulelinearityDerCheckBox.Position = [55 155 165 30];

            % Create IntegralesPanel
            app.IntegralesPanel = uipanel(app.GridLayout13);
            app.IntegralesPanel.TitlePosition = 'centertop';
            app.IntegralesPanel.Title = 'Integrales';
            app.IntegralesPanel.Layout.Row = 1;
            app.IntegralesPanel.Layout.Column = 3;

            % Create allintegralsCheckBox
            app.allintegralsCheckBox = uicheckbox(app.IntegralesPanel);
            app.allintegralsCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.allintegralsCheckBox.Text = 'Todas las integrales';
            app.allintegralsCheckBox.Position = [57 286 128 22];

            % Create bypartsIntCheckBox
            app.bypartsIntCheckBox = uicheckbox(app.IntegralesPanel);
            app.bypartsIntCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.bypartsIntCheckBox.Text = 'Integración por Partes';
            app.bypartsIntCheckBox.Position = [54 69 140 22];

            % Create simpleintegralCheckBox
            app.simpleintegralCheckBox = uicheckbox(app.IntegralesPanel);
            app.simpleintegralCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.simpleintegralCheckBox.Text = 'Integrales de Funciones';
            app.simpleintegralCheckBox.Position = [54 210 150 22];

            % Create substitutionIntCheckBox
            app.substitutionIntCheckBox = uicheckbox(app.IntegralesPanel);
            app.substitutionIntCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.substitutionIntCheckBox.Text = 'Sustitución';
            app.substitutionIntCheckBox.Position = [54 116 81 22];

            % Create definiteIntCheckBox
            app.definiteIntCheckBox = uicheckbox(app.IntegralesPanel);
            app.definiteIntCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.definiteIntCheckBox.Text = 'Integrales Definidas';
            app.definiteIntCheckBox.WordWrap = 'on';
            app.definiteIntCheckBox.Position = [54 163 165 22];

            % Create GridLayout14
            app.GridLayout14 = uigridlayout(app.GridLayout13);
            app.GridLayout14.ColumnWidth = {'1x'};
            app.GridLayout14.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout14.Layout.Row = 1;
            app.GridLayout14.Layout.Column = 2;

            % Create AleatorizarPanel
            app.AleatorizarPanel = uipanel(app.GridLayout14);
            app.AleatorizarPanel.TitlePosition = 'centertop';
            app.AleatorizarPanel.Title = 'Aleatorizar';
            app.AleatorizarPanel.Layout.Row = 1;
            app.AleatorizarPanel.Layout.Column = 1;

            % Create allTypesCheckBox
            app.allTypesCheckBox = uicheckbox(app.AleatorizarPanel);
            app.allTypesCheckBox.ValueChangedFcn = createCallbackFcn(app, @setTypeOptions, true);
            app.allTypesCheckBox.Text = {'Todas las derivadas '; 'e integrales'};
            app.allTypesCheckBox.Position = [28 26 181 40];

            % Create TiposdeFuncionesPanel
            app.TiposdeFuncionesPanel = uipanel(app.GridLayout14);
            app.TiposdeFuncionesPanel.TitlePosition = 'centertop';
            app.TiposdeFuncionesPanel.Title = 'Tipos de Funciones';
            app.TiposdeFuncionesPanel.Layout.Row = [2 3];
            app.TiposdeFuncionesPanel.Layout.Column = 1;

            % Create PolynomialFunctions
            app.PolynomialFunctions = uicheckbox(app.TiposdeFuncionesPanel);
            app.PolynomialFunctions.ValueChangedFcn = createCallbackFcn(app, @FunctionsValueChanged, true);
            app.PolynomialFunctions.Text = 'Polinomios';
            app.PolynomialFunctions.Position = [34 147 81 22];

            % Create ExpLnFunctions
            app.ExpLnFunctions = uicheckbox(app.TiposdeFuncionesPanel);
            app.ExpLnFunctions.ValueChangedFcn = createCallbackFcn(app, @FunctionsValueChanged, true);
            app.ExpLnFunctions.Text = 'Exponenciales y logaritmos';
            app.ExpLnFunctions.Position = [34 104 168 22];

            % Create TrigFunctions
            app.TrigFunctions = uicheckbox(app.TiposdeFuncionesPanel);
            app.TrigFunctions.ValueChangedFcn = createCallbackFcn(app, @FunctionsValueChanged, true);
            app.TrigFunctions.Text = 'Funciones trigonométricas';
            app.TrigFunctions.Position = [34 60 163 22];

            % Create GridLayout18
            app.GridLayout18 = uigridlayout(app.GridLayout12);
            app.GridLayout18.RowHeight = {'1x'};
            app.GridLayout18.Layout.Row = 1;
            app.GridLayout18.Layout.Column = 1;
            app.GridLayout18.BackgroundColor = [0 0.4471 0.7412];

            % Create ShowsolutionsButtonGroup
            app.ShowsolutionsButtonGroup = uibuttongroup(app.GridLayout18);
            app.ShowsolutionsButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @updateSolnsFlag, true);
            app.ShowsolutionsButtonGroup.TitlePosition = 'centertop';
            app.ShowsolutionsButtonGroup.Title = '¿Mostrar soluciones después de enviar?';
            app.ShowsolutionsButtonGroup.Layout.Row = 1;
            app.ShowsolutionsButtonGroup.Layout.Column = 2;
            app.ShowsolutionsButtonGroup.FontWeight = 'bold';
            app.ShowsolutionsButtonGroup.FontSize = 16;

            % Create SButton
            app.SButton = uiradiobutton(app.ShowsolutionsButtonGroup);
            app.SButton.Text = 'Sí';
            app.SButton.Position = [92 18 58 22];
            app.SButton.Value = true;

            % Create NoButton
            app.NoButton = uiradiobutton(app.ShowsolutionsButtonGroup);
            app.NoButton.Text = 'No';
            app.NoButton.Position = [231 18 65 22];

            % Create OpcionesdeVariablesButtonGroup
            app.OpcionesdeVariablesButtonGroup = uibuttongroup(app.GridLayout18);
            app.OpcionesdeVariablesButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @setVarOpts, true);
            app.OpcionesdeVariablesButtonGroup.TitlePosition = 'centertop';
            app.OpcionesdeVariablesButtonGroup.Title = 'Opciones de Variables';
            app.OpcionesdeVariablesButtonGroup.Layout.Row = 1;
            app.OpcionesdeVariablesButtonGroup.Layout.Column = 1;
            app.OpcionesdeVariablesButtonGroup.FontWeight = 'bold';
            app.OpcionesdeVariablesButtonGroup.FontSize = 16;

            % Create VariosButton
            app.VariosButton = uiradiobutton(app.OpcionesdeVariablesButtonGroup);
            app.VariosButton.Text = 'Varios';
            app.VariosButton.Position = [92 18 55 22];
            app.VariosButton.Value = true;

            % Create xortButton
            app.xortButton = uiradiobutton(app.OpcionesdeVariablesButtonGroup);
            app.xortButton.Text = 'Solo $x$ or $t$';
            app.xortButton.Interpreter = 'latex';
            app.xortButton.Position = [214 18 83 22];

            % Create GridLayout22
            app.GridLayout22 = uigridlayout(app.GridLayout12);
            app.GridLayout22.ColumnWidth = {'1x'};
            app.GridLayout22.RowHeight = {'1x'};
            app.GridLayout22.Layout.Row = 2;
            app.GridLayout22.Layout.Column = 1;

            % Create SettingsMessage
            app.SettingsMessage = uilabel(app.GridLayout22);
            app.SettingsMessage.HorizontalAlignment = 'center';
            app.SettingsMessage.Layout.Row = 1;
            app.SettingsMessage.Layout.Column = 1;
            app.SettingsMessage.Text = 'Label3';

            % Create ProblemasdePrcticaTab
            app.ProblemasdePrcticaTab = uitab(app.TabGroup);
            app.ProblemasdePrcticaTab.Title = 'Problemas de Práctica';
            app.ProblemasdePrcticaTab.ButtonDownFcn = createCallbackFcn(app, @practiceMoreProblems, true);

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.ProblemasdePrcticaTab);
            app.GridLayout2.ColumnWidth = {'1x'};
            app.GridLayout2.RowHeight = {'1x'};
            app.GridLayout2.BackgroundColor = [0 0.4471 0.7412];

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.GridLayout2);
            app.GridLayout3.ColumnWidth = {95, '1x'};
            app.GridLayout3.RowHeight = {'2x', '1x', '3x'};
            app.GridLayout3.Layout.Row = 1;
            app.GridLayout3.Layout.Column = 1;
            app.GridLayout3.BackgroundColor = [0 0.4471 0.7412];

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.GridLayout3);
            app.GridLayout4.ColumnWidth = {'1x'};
            app.GridLayout4.RowHeight = {'0.2x', '2x', '2x'};
            app.GridLayout4.Layout.Row = 1;
            app.GridLayout4.Layout.Column = 1;
            app.GridLayout4.BackgroundColor = [0 0.4471 0.7412];

            % Create GenerarProblemaButton
            app.GenerarProblemaButton = uibutton(app.GridLayout4, 'push');
            app.GenerarProblemaButton.ButtonPushedFcn = createCallbackFcn(app, @GenerarProblemaButtonPushed, true);
            app.GenerarProblemaButton.WordWrap = 'on';
            app.GenerarProblemaButton.Layout.Row = 2;
            app.GenerarProblemaButton.Layout.Column = 1;
            app.GenerarProblemaButton.Text = 'Generar Problema';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.GridLayout3);
            app.GridLayout5.ColumnWidth = {'1x'};
            app.GridLayout5.RowHeight = {'2x', '1x'};
            app.GridLayout5.Layout.Row = 1;
            app.GridLayout5.Layout.Column = 2;

            % Create ProbStatement
            app.ProbStatement = uilabel(app.GridLayout5);
            app.ProbStatement.HorizontalAlignment = 'center';
            app.ProbStatement.Layout.Row = 1;
            app.ProbStatement.Layout.Column = 1;
            app.ProbStatement.Interpreter = 'latex';
            app.ProbStatement.Text = 'El enunciado del problema va aquí';

            % Create Warning
            app.Warning = uilabel(app.GridLayout5);
            app.Warning.HorizontalAlignment = 'center';
            app.Warning.Layout.Row = 2;
            app.Warning.Layout.Column = 1;
            app.Warning.Interpreter = 'latex';
            app.Warning.Text = 'Las advertencias van aquí';

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.GridLayout3);
            app.GridLayout6.ColumnWidth = {170, '1x'};
            app.GridLayout6.RowHeight = {'1x'};
            app.GridLayout6.Layout.Row = 2;
            app.GridLayout6.Layout.Column = 2;

            % Create SolutionEditField
            app.SolutionEditField = uieditfield(app.GridLayout6, 'text');
            app.SolutionEditField.Layout.Row = 1;
            app.SolutionEditField.Layout.Column = 2;

            % Create SolPrompt
            app.SolPrompt = uilabel(app.GridLayout6);
            app.SolPrompt.HorizontalAlignment = 'right';
            app.SolPrompt.Layout.Row = 1;
            app.SolPrompt.Layout.Column = 1;
            app.SolPrompt.Interpreter = 'latex';
            app.SolPrompt.Text = 'Label2';

            % Create GridLayout7
            app.GridLayout7 = uigridlayout(app.GridLayout3);
            app.GridLayout7.ColumnWidth = {'1x'};
            app.GridLayout7.RowHeight = {'0.1x', '1x', '1.1x', '1x', '1x'};
            app.GridLayout7.Layout.Row = 3;
            app.GridLayout7.Layout.Column = 1;
            app.GridLayout7.BackgroundColor = [0 0.4471 0.7412];

            % Create EnviarSolucinButton
            app.EnviarSolucinButton = uibutton(app.GridLayout7, 'push');
            app.EnviarSolucinButton.ButtonPushedFcn = createCallbackFcn(app, @EnviarSolucinButtonPushed, true);
            app.EnviarSolucinButton.WordWrap = 'on';
            app.EnviarSolucinButton.Layout.Row = 4;
            app.EnviarSolucinButton.Layout.Column = 1;
            app.EnviarSolucinButton.Text = 'Enviar Solución';

            % Create VistaPreviadelaSolucinButton
            app.VistaPreviadelaSolucinButton = uibutton(app.GridLayout7, 'push');
            app.VistaPreviadelaSolucinButton.ButtonPushedFcn = createCallbackFcn(app, @VistaPreviadelaSolucinButtonPushed, true);
            app.VistaPreviadelaSolucinButton.WordWrap = 'on';
            app.VistaPreviadelaSolucinButton.Layout.Row = 2;
            app.VistaPreviadelaSolucinButton.Layout.Column = 1;
            app.VistaPreviadelaSolucinButton.Text = 'Vista Previa de la Solución';

            % Create GridLayout15
            app.GridLayout15 = uigridlayout(app.GridLayout3);
            app.GridLayout15.ColumnWidth = {'1x'};
            app.GridLayout15.RowHeight = {'1x', '9x', '1x'};
            app.GridLayout15.Layout.Row = 2;
            app.GridLayout15.Layout.Column = 1;
            app.GridLayout15.BackgroundColor = [0 0.4471 0.7412];

            % Create GridLayout16
            app.GridLayout16 = uigridlayout(app.GridLayout3);
            app.GridLayout16.ColumnWidth = {'1x'};
            app.GridLayout16.RowHeight = {'1x', '2x'};
            app.GridLayout16.Layout.Row = 3;
            app.GridLayout16.Layout.Column = 2;

            % Create GridLayout17
            app.GridLayout17 = uigridlayout(app.GridLayout16);
            app.GridLayout17.ColumnWidth = {160, '4x'};
            app.GridLayout17.RowHeight = {'1x'};
            app.GridLayout17.Layout.Row = 1;
            app.GridLayout17.Layout.Column = 1;

            % Create ProposedSolnLabel
            app.ProposedSolnLabel = uilabel(app.GridLayout17);
            app.ProposedSolnLabel.HorizontalAlignment = 'right';
            app.ProposedSolnLabel.Layout.Row = 1;
            app.ProposedSolnLabel.Layout.Column = 1;
            app.ProposedSolnLabel.Interpreter = 'latex';
            app.ProposedSolnLabel.Text = {'Etiqueta de Solución'; 'Propuesta'};

            % Create ProposedSoln
            app.ProposedSoln = uilabel(app.GridLayout17);
            app.ProposedSoln.Layout.Row = 1;
            app.ProposedSoln.Layout.Column = 2;
            app.ProposedSoln.Interpreter = 'latex';
            app.ProposedSoln.Text = {'Solución'; 'Propuesta'};

            % Create FeedbackStatement
            app.FeedbackStatement = uilabel(app.GridLayout16);
            app.FeedbackStatement.Layout.Row = 2;
            app.FeedbackStatement.Layout.Column = 1;
            app.FeedbackStatement.Interpreter = 'latex';
            app.FeedbackStatement.Text = 'Declaración de Retroalimentación';

            % Create AnlisisTab
            app.AnlisisTab = uitab(app.TabGroup);
            app.AnlisisTab.Title = 'Análisis';
            app.AnlisisTab.ButtonDownFcn = createCallbackFcn(app, @AnalyzeResultsButtonPushed, true);

            % Create GridLayout19
            app.GridLayout19 = uigridlayout(app.AnlisisTab);
            app.GridLayout19.ColumnWidth = {'1x'};
            app.GridLayout19.RowHeight = {161, '1.5x', '1x'};

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout19);
            title(app.UIAxes, 'Título')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Layout.Row = 3;
            app.UIAxes.Layout.Column = 1;

            % Create UITable
            app.UITable = uitable(app.GridLayout19);
            app.UITable.ColumnName = {'Columna 1'; 'Columna 2'; 'Columna 3'; 'Columna 4'};
            app.UITable.RowName = {};
            app.UITable.Layout.Row = 1;
            app.UITable.Layout.Column = 1;

            % Create GridLayout20
            app.GridLayout20 = uigridlayout(app.GridLayout19);
            app.GridLayout20.ColumnWidth = {'1x', 100};
            app.GridLayout20.RowHeight = {'1x'};
            app.GridLayout20.Layout.Row = 2;
            app.GridLayout20.Layout.Column = 1;
            app.GridLayout20.BackgroundColor = [0 0.4471 0.7412];

            % Create GridLayout23
            app.GridLayout23 = uigridlayout(app.GridLayout20);
            app.GridLayout23.ColumnWidth = {'1x'};
            app.GridLayout23.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout23.Layout.Row = 1;
            app.GridLayout23.Layout.Column = 2;
            app.GridLayout23.BackgroundColor = [0 0.4471 0.7412];

            % Create BorarHistoriaButton
            app.BorarHistoriaButton = uibutton(app.GridLayout23, 'push');
            app.BorarHistoriaButton.ButtonPushedFcn = createCallbackFcn(app, @BorarHistoriaButtonPushed, true);
            app.BorarHistoriaButton.Layout.Row = 2;
            app.BorarHistoriaButton.Layout.Column = 1;
            app.BorarHistoriaButton.Text = 'Borar Historia';

            % Create GridLayout24
            app.GridLayout24 = uigridlayout(app.GridLayout20);
            app.GridLayout24.ColumnWidth = {'0.5x', '10x', '0.5x'};
            app.GridLayout24.RowHeight = {'1x'};
            app.GridLayout24.Layout.Row = 1;
            app.GridLayout24.Layout.Column = 1;

            % Create AnalysisFeedback
            app.AnalysisFeedback = uilabel(app.GridLayout24);
            app.AnalysisFeedback.Layout.Row = 1;
            app.AnalysisFeedback.Layout.Column = 2;
            app.AnalysisFeedback.Interpreter = 'latex';
            app.AnalysisFeedback.Text = 'Retroalimentación de Análisis';

            % Show the figure after all components are created
            app.AplicacindeTarjetasdeClculoUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TarjetasDeCalculo

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.AplicacindeTarjetasdeClculoUIFigure)

            % Execute the startup function
            runStartupFcn(app, @StartupFunction)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.AplicacindeTarjetasdeClculoUIFigure)
        end
    end
end