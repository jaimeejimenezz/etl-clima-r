# scripts/02_transform.R
library(dplyr)

#lee y carga el archivo weather_raw.rds desde el directorio data/raw/, que contiene 
#los datos crudos (raw) de la API 
datos_raw <- readRDS("data/raw/weather_raw.rds")

#aqui es donde ocurre la transformación de los datos crudos
#La función bind_rows() se usa para combinar todos los marcos de datos que se 
#crean para cada ciudad en un solo marco de datos (dataframe). Esto es útil porque 
#lapply() devuelve una lista de dataframes, y bind_rows() asegura que todos se 
#unan en una sola tabla.
df <- bind_rows(lapply(datos_raw, function(x) {
  
  #data frame para poder trabajar con datos raw
  data.frame(
    ciudad = x$name,
    temperatura = x$main$temp,
    humedad = x$main$humidity,
    presion = x$main$pressure,
    lat = x$coord$lat,
    lon = x$coord$lon,
    fecha = Sys.time()
  )
  
}))

#el dataframe df, que ahora contiene los datos transformados de todas las 
#ciudades, se guarda en un archivo CSV
write.csv(df, "data/processed/weather_clean.csv", row.names = FALSE)
