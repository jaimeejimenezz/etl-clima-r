# scripts/01_extract.R

#extraer datos del clima desde la API de OpenWeather para diferentes ciudades 
# y guardarlos en un archivo de formato RDS.

#Este paquete se utiliza para hacer solicitudes HTTP a APIs. Aquí se usará para 
#hacer una solicitud GET a la API de OpenWeather.
library(httr)

#Este paquete se utiliza para trabajar con archivos JSON. Aquí se usará para 
#convertir la respuesta de la API (que es un JSON) en un formato que R pueda 
#manejar, como un dataframe.
library(jsonlite)

#Esta función recibe el nombre de una ciudad y una clave API, construye la URL 
#de la API de OpenWeather para esa ciudad, hace la solicitud y devuelve los 
#datos en formato dataframe.
get_weather_data <- function(city, api_key) {
  
  #construye la URL para la API
  url <- paste0("http://api.openweathermap.org/data/2.5/weather?q=", 
                URLencode(city), 
                "&appid=", api_key, "&units=metric")
  
  print(url)
  
  #envía una solicitud HTTP a la URL construida y obtiene la respuesta del 
  #servidor (los datos del clima en formato JSON)
  res <- GET(url)
  print(status_code(res))  # Muestra el código de estado HTTP
  
  #Extrae el contenido de la respuesta (res) en formato de texto. La respuesta 
  #original es un JSON, por lo que se convierte en un texto legible.
  json <- content(res, "text")
  print(json)  # Muestra el contenido de la respuesta JSON
  
  #convierte el texto JSON a una lista o dataframe en R. 
  #flatten = TRUE convierte las listas anidadas (como las de coordenadas o 
  #condiciones del clima) en columnas simples de un dataframe.
  fromJSON(json, flatten = TRUE)
  
}

ciudades <- c("Buenos Aires", "Lima", "Bogota", "Madrid")

#La función Sys.getenv() en R se utiliza para obtener valores de las variables 
#de entorno del sistema, En este caso, "OPENWEATHER_API_KEY" es el nombre de la 
#variable de entorno que contiene la clave API para acceder a OpenWeather.
#debemos buscarla en la web y definirla en nuestras variables de entorno
api_key <- Sys.getenv("OPENWEATHER_API_KEY")  # mejor que hardcodearlo
print(api_key)

#Esta función de R aplica la función get_weather_data a cada uno de los elementos 
#del vector ciudades. En otras palabras, para cada ciudad, get_weather_data 
#obtiene los datos del clima y los devuelve en una lista.
datos <- lapply(ciudades, get_weather_data, api_key = api_key)

#Esta función guarda el objeto datos (la lista de datos del clima) en un archivo 
#RDS. Este archivo es específico de R y permite guardar y cargar objetos de R de 
#manera eficiente.
saveRDS(datos, file = "data/raw/weather_raw.rds")
