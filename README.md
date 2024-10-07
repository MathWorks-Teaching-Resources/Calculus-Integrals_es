# <span style="color:rgb(213,80,0)">Cálculo \- Integrales</span>


[![Ver en File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/173655-calculo-integrales) or [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj)

![Versiones de MATLAB Probadas](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2FMathWorks-Teaching-Resources%2FCalculus-Integrals_es%2Frelease%2FImages%2FTestedWith.json)

**Módulo Curricular**

_Creado con R2021b. Compatible con R2021b y versiones posteriores._

# Información

Las soluciones están disponibles a petición del instructor. Contacta al equipo de recursos didácticos de MathWorks si deseas solicitar soluciones, proporcionar comentarios o si tienes alguna pregunta.

Este módulo curricular contiene [live scripts de MATLAB®](https://www.mathworks.com/products/matlab/live-editor.html) interactivos que enseñan conceptos fundamentales y terminología básica relacionada con el cálculo integral. Se enfoca en la aproximación numérica y la representación gráfica como herramientas para entender los conceptos del cálculo integral.

Este módulo ha sido traducido automáticamente del inglés.

## Antecedentes

Puedes utilizar estos live scripts como [demostraciones](#H_9AAE657C) en conferencias, actividades en clase o asignaciones interactivas fuera de clase. Cálculo - Integrales cubre aproximaciones de sumas de Riemann a integrales definidas, integrales indefinidas como antiderivadas, y el teorema fundamental del cálculo. También abarca las integrales indefinidas de potencias, exponenciales, logaritmos naturales, senos y cosenos, así como sustitución e integración por partes. Las aplicaciones incluyen área y potencia. Además de los scripts completos, visualizaciones y scripts de práctica, también se incluye una [aplicación de Tarjetas Educativas de Cálculo](#H_1F9459BC).


Las instrucciones dentro de los live scripts te guiarán a través de los ejercicios y actividades. Comienza con cada live script ejecutándolo una sección a la vez. Para detener la ejecución del script o una sección a mitad de camino (por ejemplo, cuando una animación está en progreso), utiliza el botón de Detener <img src="Images/EndIcon.png" width="19" alt="Icono de finalizar"> en la sección **EJECUTAR** de la pestaña **Live Editor** en la Barra de Herramientas de MATLAB.


¿Buscas más? ¿Encontraste un problema? ¿Tienes una sugerencia? Por favor, contacta al [equipo de enseñanza en línea de MathWorks](mailto:%20onlineteaching@mathworks.com).


## Contáctanos
Las soluciones están disponibles a petición del instructor. Contacta al [equipo de recursos didácticos de MathWorks](mailto:onlineteaching@mathworks.com) si deseas solicitar soluciones, proporcionar retroalimentación o si tienes alguna pregunta.

<a name="H_30BC7141"></a>

## Prerrequisitos

Este módulo asume un conocimiento de funciones que es estándar en los materiales del curso de precálculo con respecto a potencias, exponenciales, valores absolutos, logaritmos, senos, cosenos, funciones racionales y asíntotas. También asume conocimiento de fórmulas básicas de área, incluyendo el área de un trapecio. Con la excepción de <samp>Riemann.mlx</samp> y <samp>RiemannViz.mlx</samp>, los scripts están escritos para seguir a [Cálculo-Derivadas](https://github.com/MathWorks-Teaching-Resources/Calculus-Derivatives_es) y esperan un entendimiento básico de derivadas y reglas de derivación. Hay poca expectativa de familiaridad con MATLAB, pero podrías usar [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted) como otro recurso para adquirir familiaridad con MATLAB.

<a name="H_330E72C3"></a>

## Comenzando
### Accediendo al Módulo
### **En MATLAB Online:**

Utiliza el enlace [<img src="Images/OpenInMO.png" width="136" alt="Abrir en MATLAB Online">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj) para descargar el módulo. Se te pedirá que inicies sesión o crees una cuenta de MathWorks. El proyecto se cargará y verás una aplicación con varias opciones de navegación para comenzar.

### **En Escritorio:**

Descarga o clona este repositorio. Abre MATLAB, navega a la carpeta que contiene estos scripts y haz doble clic en [Integrals.prj](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj). Esto agregará los archivos apropiados a tu ruta de MATLAB y abrirá una aplicación que te preguntará dónde te gustaría comenzar.


Asegúrate de tener todos los productos requeridos ([listados a continuación](#H_E850B4FF)) instalados. Si necesitas incluir un producto, agrégalo usando el Explorador de Complementos. Para instalar un complemento, ve a la pestaña **Inicio** y selecciona <img src="Images/AddOnsIcon.png" width="16" alt="Icono de Complementos"> **Complementos** > **Obtener Complementos**. 

<a name="H_E850B4FF"></a>

## Productos

MATLAB® se utiliza a lo largo de todo. Las herramientas del Symbolic Math Toolbox™ también se utilizan con frecuencia.

# Scripts
| **Script Completo** <br>  | **Visualizaciones** <br>  | **Objetivos de Aprendizaje** <br> En este script, los estudiantes... <br>  | **Práctica** <br>   |
| :-- | :-- | :-- | :-- |
| [Antiderivatives.mlx](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/Antiderivatives.mlx) <br> <img src="Images/adf.png" width="135" alt="Familia de antiderivadas"> <br>  | [Visualizando Antiderivadas](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/AntiderivativesViz.mlx) <br> <img src="Images/family.gif" width="135" alt="Familia animada de antiderivadas"> <br>  | $\bullet$ ver una presentación gráfica del concepto de antiderivadas generales. <br> $\bullet$ desarrollar fluidez computacional con las antiderivadas de potencias, <br> senos, cosenos y exponenciales. <br>  | [Calcular Antiderivadas](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/AntiderivativesPractice.mlx) <br> $\displaystyle {\int \sin (3z)\;dz=-\frac{\cos (3z)}{3}+C}$ <br>   |
| [FundamentalTheorem.mlx](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/FundamentalTheorem.mlx) <br> <img src="Images/Ski-Area.png" width="135" alt="Distancia recorrida por el esquiador"> <br>  | [Visualizando el Teorema Fundamental del Cálculo](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/FundamentalTheoremViz.mlx) <br> <img src="Images/FTC-generated.png" width="135" alt="Área con signo bajo una curva"> <br>  |    $\bullet$ explicar el teorema fundamental del cálculo. <br> $\bullet$ entender por qué el Teorema Fundamental del Cálculo tiene sentido gráficamente. <br> $\bullet$ desarrollar fluidez computacional para integrales definidas que involucran combinaciones lineales y <br>racionales de potencias, senos, cosenos, exponenciales y logaritmos naturales. <br>  | [Aplicar el Teorema Fundamental del Cálculo](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/FundamentalTheoremPractice.mlx) <br> $\displaystyle {\int_1^3 \frac{1}{w^2 }\;dw=-\frac{1}{3}+1=\frac{2}{3}}$ <br>   | 
| [Riemann.mlx](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/Riemann.mlx) <br> <img src="Images/animSolar.gif" width="135" alt="Mejor aproximación con rectángulos más pequeños"> <br>  | [Visualizando Sumas de Riemann](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/RiemannViz.mlx) <br> <img src="Images/AreaUnderCurve.png" width="135" alt="Aproximación por rectángulos"> <br>  | $\bullet$ explicar y aplicar las diferentes aproximaciones calculadas por un <br>método de punto final izquierdo, punto final derecho, punto medio, máximo o mínimo <br>para seleccionar un valor de altura en una suma de Riemann. <br> $\bullet$ explicar y aplicar la aproximación trapecial. <br> $\bullet$ explicar por qué aumentar el número de intervalos en una aproximación disminuirá el error. <br> $\bullet$ discutir las implicaciones de aplicar el cálculo en aplicaciones con valores que son discretos o continuos. <br> |    |
| [Substitution.mlx](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/Substitution.mlx) <br> <img src="Images/SubstIm.png" width="135" alt="f(flor)"> <br>  | [Visualizando Sustitución](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/SubstitutionViz.mlx) <br> <img src="Images/animSubst.gif" width="135" alt="Animación de dx y du"> <br>  | $\bullet$ explicar qué es el método de sustitución y cómo funciona. <br> $\bullet$ desarrollar fluidez con el cálculo de integrales de combinaciones de <br>potencias, senos, cosenos, exponenciales y logaritmos que son solubles <br>por sustitución a mano. <br> $\bullet$ ver una comprensión gráfica del método de sustitución. <br>  | [Aplicar el método de sustitución](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/SubstitutionPractice.mlx) <br> $\displaystyle {\int \frac{\cos \left(\ln (t)+1\right)}{t}\;dt=\sin \left(\ln (t)+1\right)+C}$ <br>   |
| [ByParts.mlx](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/ByParts.mlx) <br> <img src="Images/IBP.png" width="135" alt="Integración geométrica por partes"> <br>  | [Visualizando la Integración por Partes](.Scripts/ByPartsViz.mlx) <br> <img src="Images/ibp-generated.png" width="135" alt="Integración horizontal y vertical"> <br>  |  $\bullet$ explicar qué es el método de integración por partes y cómo funciona. <br> $\bullet$ desarrollar fluidez con el cálculo de integrales que involucran potencias, senos,<br> cosenos, exponenciales y logaritmos que son solubles por integración por <br>partes a mano. <br> $\bullet$ ver una comprensión gráfica de la fórmula de integración por partes. <br>  | [Aplicar el método de integración por partes](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Scripts/ByPartsPractice.mlx) <br> $\displaystyle {\int y^2 e^y \;dy=y^2 e^y -2ye^y +2e^y +C}$ <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $\displaystyle =(y^2 -2y+2)e^y +C$ <br>   |

<a name="H_1F9459BC"></a>

# [Aplicación de Tarjetas Didácticas de Cálculo](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Apps/CalculusFlashcards.mlapp")
| 1. Elige el tipo de práctica. <br>  | 2. Resuelve problemas. <br>  | 3. Analiza tu progreso. <br>   |
| :-- | :-- | :-- |
| <img src="Images/CalcFlashcardsSettings.png" width="276" alt="Configuraciones de Tarjetas Didácticas de Cálculo">  | <img src="Images/CalcFlashcardsPractice.png" width="276" alt="Práctica de Tarjetas Didácticas de Cálculo"> | <img src="Images/CalcFlashcardsAnalysis.png" width="276" alt="Análisis de Tarjetas Didácticas de Cálculo">  |

# Configuración para Usar la Aplicación de Tarjetas Didácticas de Cálculo

MATLAB Desktop

1.  Asegúrate de tener MATLAB R2021a o una versión más reciente instalada.
2. Descarga <samp>TarjetasDeCalculo.m</samp> o descarga y descomprime el repositorio completo.
3. Haz clic derecho en la aplicación dentro de MATLAB y selecciona ejecutar o escribe <samp>TarjetasDeCalculo</samp> en la Command Window.

MATLAB Online

1.  [<img src="Images/OpenInMO.png" width="136" alt="Insignia de Abrir en MATLAB Online">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals_es&project=Integrals.prj&file=Apps/CalculusFlashcards.mlapp)
<a name="H_F61733D7"></a>

# Licencia

La licencia para este módulo está disponible en [LICENSE.md](https://github.com/MathWorks-Teaching-Resources/Calculus-Integrals_es/blob/release/LICENSE.md).

# Módulos de Material Didáctico Relacionados
| **Módulo de Material Didáctico** <br>  | **Contenido de Muestra** <br>  | **Disponible en:** <br>   |
| :-- | :-- | :-- |
| [**Cálculo: Derivadas**](https://www.mathworks.com/matlabcentral/fileexchange/173660-calculo-derivadas)  <br>  | <img src="Images/CalcDer.png" width="171" alt="image_17.png"> <br>  | [<img src="Images/OpenInFX.png" width="91" alt="image_18.png">](https://www.mathworks.com/matlabcentral/fileexchange/173660-calculo-derivadas) <br> [<img src="Images/OpenInMO.png" width="136" alt="Insignia de Abrir en MATLAB Online">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Derivatives_es/project=Derivatives.prj) <br> [GitHub](https://github.com/MathWorks-Teaching-Resources/Calculus-Derivatives_es)  <br>   |
| <br>[**Métodos Numéricos con Aplicaciones** (en inglés)](https://www.mathworks.com/matlabcentral/fileexchange/111490-numerical-methods-with-applications) <br>  | <img src="Images/AreaLake.png" width="171" alt="image_20.png"> <br>  |[<img src="Images/OpenInFX.png" width="91" alt="image_21.png">](https://www.mathworks.com/matlabcentral/fileexchange/111490-numerical-methods-with-applications) <br> [<img src="Images/OpenInMO.png" width="136" alt="Insignia de Abrir en MATLAB Online">](https://matlab.mathworks.com/open/v1?repo=MathWorks-Teaching-Resources/Numerical-Methods-with-Applications/project=NumericalMethods.prj)   <br>[GitHub](https://github.com/MathWorks-Teaching-Resources/Numerical-Methods-with-Applications)  <br>   |

O siéntase libre de explorar nuestro otro [contenido de material didáctico modular](https://www.mathworks.com/matlabcentral/fileexchange/?q=tag%3A%22courseware+module%22&sort=downloads_desc_30d).

# Recursos para Educadores
-  [Página para Educadores](https://www.mathworks.com/academia/educators.html) 
<a name="H_0FA5DA18"></a>

# Contribuir

¿Buscas más? ¿Encontraste un problema? ¿Tienes una sugerencia? Por favor, contacta al [equipo de recursos didácticos de MathWorks](mailto:%20onlineteaching@mathworks.com). Si quieres contribuir directamente a este proyecto, puedes encontrar información sobre cómo hacerlo en la página de [CONTRIBUTING.md](https://github.com/MathWorks-Teaching-Resources/Calculus-Integrals_es/blob/release/CONTRIBUTING.md) en GitHub.


 *©* Derechos de autor 2023 The MathWorks™, Inc
