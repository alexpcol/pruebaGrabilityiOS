# pruebaGrabilityiOS The Movie Data Base
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
2) Constans
3) Helpers
4) Controllers
5) Views

----------------------------------------------------------------------------------------------------------------------------------------

1) Models

    En esta se encuentran las clases para almacenar los objetos con los que se trabajan, como se estan realizando consultas al API de The Movie Database los principales elementos que necesitamos son "Movie" o "TVSerie"
    
    Los objetos de esta API contienen varios campos para dichos elementos (Movie, TVSeire) de los cuales solo obtengo los siguientes:
    
        Movie
        - id, title, posterPath, releaseDate, overview
        
        TVSerie
        - id, name, posterPath, firstAirDate, overview
        
    Los cuales se almacenan en las clases "TVSerieData" y "MovieData" respectivamente, heredando de una clase base que contiene los elementos en común
    

    
    

