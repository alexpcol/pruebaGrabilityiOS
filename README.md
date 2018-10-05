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

3) Upcoming - UpcomingViewController.swift: "Controlador anidado en un navigationController cuenta con un collectionView el cual despliega en este caso las peliculas que se van a estrenar próximamente, se realizan configuraciónes en la navBar, de las celdas del collectionView, manejo del scroll y las respuestas del API para obtener las Upcoming Movies"

4) Search - SearchViewController.swift: "Controlador anidado en un navigationController cuenta con un collectionView el cual despliega en este caso los elementos que se recuperan el endpoint de busqueda y se filtran a que solo se obtengan los elementos de tipo 'tv'o 'movie', se realizan configuraciónes en la navBar, de las celdas del collectionView, manejo del scroll y las respuestas del API para obtener los Resultados de  la busqueda"


