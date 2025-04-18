# scripts/04_visualize.R
library(DBI)
library(ggplot2)

#Establecer la conexión con la base de datos SQLite
con <- dbConnect(RSQLite::SQLite(), "clima.db")

#lee toda la tabla llamada "clima"
df <- dbReadTable(con, "clima") 

#desconecta de bd
dbDisconnect(con)

#grafico
ggplot(df, aes(x = ciudad, y = temperatura, fill = ciudad)) +
  geom_col() +
  labs(title = "Temperatura actual por ciudad") +
  theme_minimal()

#guardamos grafico
ggsave("output/temperaturas.png")
