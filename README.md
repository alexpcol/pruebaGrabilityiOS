# The Movie Data Base
Test Rappi
El proyecto esta realizado en swift

# Respuesta Preguntas

1) ¿En qué consiste el principio de responsabilidad única? ¿Cuál es su propósito?

Se refiere a que las clases tienen una responsabilidad única, la finalidad de esto es el poder reutilzar esta clase cuantas veces se requiera y que la funcionalidad principal este concentrada solo en esa y si se presenta algún problema es más sencillo detectar los errores.

2)  ¿Qué caracteristicas tiene, según su opinión, un "buen" código o código limpio?

Debe ser intuitivo, el nombre de variables, métodos, clases, carpetas deben ser explicitas e indicar que es lo que realizan, evitar abreviaciones ya que no para todos es obvio que significan.

Debe ser modulado, que las secciones tengan un específico próposito y estas puedan reutilizarse.

Evitar exceso de código no utilizado ya sea que se deja comentado o implementaciones que ya no tienen uso, ya que esto puede generar confusión para nuevos integrantes en un proyecto.

Ya a gusto personal contar con un archivo de constantes ya que es muy pesado estar cambiando los textos "hardcodeados" en varios archivos.


# Estructura del proyecto

El proyecto en Xcode se divide en 5 capas principales

1) Models
2) Constants
3) Helpers
4) Controllers
5) Views

----------------------------------------------------------------------------------------------------------------------------------------

1) Models

En esta se encuentran las clases para almacenar los objetos con los que se trabajan, como se estan realizando consultas al API de The Movie Database los principales elementos que necesitamos son "Movie" o "TVSerie"

Los objetos de esta API contienen varios campos para dichos elementos (Movie, TVSeire) de los cuales solo obtengo algunos campos como se pueden ver en los ejemplos de las clases:

    class MovieData: BaseItem {

    var title: String?
    var releaseDate: String?

    init(id: NSInteger?,
        title: String?,
        posterPath: String?,
        releaseDate: String?,
        overview: String?)
        {
            super.init(id: id, posterPath: posterPath, overview: overview)
            self.title = title
            self.releaseDate = releaseDate
        }
    }

Los cuales se almacenan en las clases "TVSerieData" y "MovieData" respectivamente, heredando de una clase base que contiene los elementos en común el id, el posterPath y el overview.

Adicionalemente se cuenta con una clase "VideoData" ya que al obtener los videos de alguno de los elementos vienen como un arreglo de objetos de igual manera solo tomo la información que necesito.

Por último esta la clase  "SearchItem" donde se almecnan los objetos al momento de realizar una busqueda online ya que esta trae ambos elementos, "Movie" y "TVSerie"

----------------------------------------------------------------------------------------------------------------------------------------

2) Constants

Se utiliza para manejar y administrar los strings hardcodeados, que se requieren para acceder a los nodos de la aplicación o identificadores de controladores, por medio de enums y estan divididos por categorias:

    enum ServicesFieldsKeys: String{
        case totalPages = "total_pages"
        case results = "results"
        case errors = "errors"
        case statusMessage = "status_message"
        case mediaType = "media_type"

        case title = "title"
        case name = "name"
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case releadeDate = "release_date"
        case overview = "overview"
        case id = "id"
        case key = "key"
        case site = "site"
    }
Este es un ejemplo de como estan organizados los campos de los objetos de los servicios

----------------------------------------------------------------------------------------------------------------------------------------

3) Helpers

En helpers se encuantran varias clases, que como su nombre lo indica, nos ayudan a realizar "tareas genericas" o funciones que se requieren a lo largo de la aplicación algunas de ellas se han obtenido a lo largo de proyectos previos. Los Helpers son los siguientes (Con sus respectivas clases).

1) DeviceHelper - NetworkHelper.swift: "Revisa si el dispositivo cuenta con Internet"

2) UIHelper - UIHelper.swift: "Cuenta con métodos para modificar elementos visuales de manera génerica, como poner bordes, cambiar el alpha con animación, etc..."

3) Alerts - AlertsPresenterswift: "Crea Alertas de enterado o alertas para mandarles acciones y también para mostrar el action sheet (Estas cuentan con diferentes parámetros respectivamente)"

4) APIRestServices  
- HttpMethods.swift: "Se realizan las URLRequests existe un método para cada protocolo HTTP que se requería (En este caso se probo inicialmente con GET pero se terminó utilizando el GET with Authorization ya que el API requería unos encabezados en su llamada)  adicionalmente se crea un protocolo llamado ResponseServicesProtocol con el cual se van a manejar las respuestas onSuccess u onError y se van a pasar por delegate a APIServices.swift"
- APIServices.swift "Metodos que preparan la URL para acceder al endpoint ya sea obtener el TopRatedMovies o PopularMovies y hace la llamada por medio de la clase anterior."
Adicionalmente cuenta con un enum de identificadores de los endpoints que se estan accediendo, ya que en los Controladores que extiendan el protocolo puedan identificar la respuesta de cada edpoint al que se accedió.

6) DataTypeChanger - DataTypeChanger.swift: "Se encarga de generar los arreglos del tipo de los modelos, de las respuestas del API para poder trabajar con ellos"

7) CacheHelper 
- CacheBase.swift: "Cuenta con las variables de tipo NSCache que nos ayudan a almacenar las respuestas del servidor"
- CacheGetter.swift: "Encargato de obtener los arreglos salvados en cache"
- CacheSaver.swift: "Encargado de salvar los arreglos en cache"

----------------------------------------------------------------------------------------------------------------------------------------

4) Controllers

Aqui las carpetas se agrupan por como esta el flujo de la aplicación, la cual describiré brevemente en este momento:
Inicia con un TabBar controller que contiene 4 Tabs:
    
1) Popular - PopularViewController.swift: "Controlador anidado en un navigationController que cuenta con 3 elementos un SegmentedControl y 2 ContainersView el controlador se encarga de mostrar u ocultar alguno de los containers dependiendo de lo que seleccione en el segmentedControl"

2) TopRated - TopRatedViewController.swift: "Controlador anidado en un navigationController que cuenta con 3 elementos un SegmentedControl y 2 ContainersView el controlador se encarga de mostrar u ocultar alguno de los containers dependiendo de lo que seleccione en el segmentedControl"

3) Upcoming - UpcomingViewController.swift: "Controlador anidado en un navigationController cuenta con un collectionView el cual despliega en este caso las peliculas que se van a estrenar próximamente, se realizan configuraciónes en la navBar, las celdas del collectionView, manejo del scroll y las respuestas del API para obtener las Upcoming Movies"

4) Search - SearchViewController.swift: "Controlador anidado en un navigationController cuenta con un collectionView el cual despliega en este caso los elementos que se recuperan el endpoint de busqueda y se filtran a que solo se obtengan los elementos de tipo 'tv'o 'movie', se realizan configuraciónes en la navBar, las celdas del collectionView, manejo del scroll y las respuestas del API para obtener los Resultados de la busqueda"

Y por último se encuentra sa sección de detalle

   Detail- DetailViewController.swift: "Controlador que se encarga de la vista del detalle ya sea de una película o de una serie de TV en este se muestran el poster el elemento, su título, la fecha en la que se estreno o la fecha en la que salió al aire (en el caso de ser una serie de tv) y un resumen del elemento; el controlador añade un boton de play en la navBar para que se pueda obtenga de la API los videos de elemento si es que cuenta con ellos y te dirige a un webView para mostrar el video de Youtube"

   -WebViewController.swift: "Controlador que se encarga de hacer la petición a la pagina de youtube del trailer del elemento selecionado"


----------------------------------------------------------------------------------------------------------------------------------------

5) Views

Cabe destacar que en los primeros 2 controladores PopularViewController.swift y TopRatedViewController.swift tienen 2 containerViews cada uno, los cuales se encuentran en esta carpeta de Views ya que son subViews que viven en ambos controladores respectivamente y se encuentran en la carpeta de SubViews--> ContainerViews

POPULAR:
- PopularMoviesViewController.swift: "Controlador que cuenta con un collectionView el cual despliega en este caso las peliculas más populares, se realizan configuraciónes en la navBar, las celdas del collectionView, manejo del scroll y las respuestas del API para obtener las Popular Movies"

- PopularTVSeriesViewController.swift: "Controlador que cuenta con un collectionView el cual despliega en este caso las series de TV más populares, se realizan configuraciónes en la navBar, las celdas del collectionView, manejo del scroll y las respuestas del API para obtener las Popular TV Series"

TOP RATED:

- TopRatedMoviesViewController.swfit: "Controlador que cuenta con un collectionView el cual despliega en este caso las peliculas top rated, se realizan configuraciónes en la navBar, las celdas del collectionView, manejo del scroll y las respuestas del API para obtener las Top Rated Movies"

- TopRatedTVSeriesViewController.swift: "Controlador que cuenta con un collectionView el cual despliega en este caso las series de TV Top Rated, se realizan configuraciónes en la navBar, las celdas del collectionView, manejo del scroll y las respuestas del API para obtener las Top Rated TV Series"

Otra carpeta que se encuentra dento de SubViews es CellViews las cuales son las celdas que se utilizan en los collectionVies, para desplegar los items obtenidos del API, estas clases cuentan con su XIB File con sus respectivos elementos visuales

FOOTER
- LoaderFooterView.swift: "Controlador encarcado de la vista que se usa para mostrar la celda con un activityIndicator cuando se cargan más elementos en el collectionView, o sea la siguiente pagina de los resultados que se consultaron, cuenta con metodos de para animar este activityIndicator ya que para visualizarlo se tiene scrollear hacia arriba el collectionView unos ciertos puntos y esta celda se va a ir mostrando poco a poco, hasta soltarla, cuando esta se suelta se queda en pantalla hasta que se obtienen los nuevos elementos"

MOVIETVSERIECELL

- MovieCollectionViewCell.swift: "Controlador encargado de la celda en la que se presentan los elementos obtenidos"


Un elemento custom que se creó fue el CustomImageView.swift que hereda de UIImageView pero cuenta con un método para descargar las imagenes de las URL's de PosterPath y una vez que se hayan descargado se almacenan en cache, para no volver a realizar la llamada para obtenerlas nuevamente cuando estas celdas se reciclen en el collectionView

Por último se encuenta la carpeta donde están los Storyboards, el Main donde se encuentran las pantallas que se utilizan, y el LaunchScreen.

----------------------------------------------------------------------------------------------------------------------------------------

# Notas finales


El proyecta cuenta con UnitTest File un poco sencillo, ya que la verdad es la primera vez que realizo este tipo de archivo, en el que testeo la descarga de imagenes mi clase customImageView


Los iconos que se encuentran en la tabBar, los que no son los genéricos de Xcode, no se ven en la mejor calidad, ya que tuve que utilizar unos de la siguiente página https://icons8.com/icon/new-icons/all?1535574885923

Y el icono de la App lo realice en Keynote 😅

