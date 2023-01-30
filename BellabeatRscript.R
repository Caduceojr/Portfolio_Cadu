library(tidyverse)
library(gridExtra)

Tabela1 <- rename(TaBellaBeats_pre2, 
                  c("Atvidade_sedentaria" = "SedentaryMinutes", 
                    "Atividade_leve" =  "LightlyActiveMinutes", 
                    "Atividade_moderada" = "FairlyActiveMinutes", 
                    "Atividade_intensa" = "VeryActiveMinutes", 
                    "Minutos_sono" = "TotalMinutesAsleep"))


g1 <- ggplot(Tabela1, aes(Atvidade_sedentaria, Minutos_sono)) + geom_point() +
  geom_smooth(method = "lm")
g2 <- ggplot(Tabela1, aes(Atividade_leve, Minutos_sono)) + geom_point() +
  geom_smooth(method = "lm")
g3 <- ggplot(Tabela1, aes(Atividade_moderada, Minutos_sono)) + geom_point() +
  geom_smooth(method = "lm")
g4 <- ggplot(Tabela1, aes(Atividade_intensa, Minutos_sono)) + geom_point() +
  geom_smooth(method = "lm")

grid.arrange(g1, g2, g3, g4)

cor(Tabela1$Atvidade_sedentaria,Tabela1$Minutos_sono) ^ 2
cor(Tabela1$Atividade_leve,Tabela1$Minutos_sono) ^ 2
cor(Tabela1$Atividade_moderada,Tabela1$Minutos_sono) ^ 2
cor(Tabela1$Atividade_intensa,Tabela1$Minutos_sono) ^ 2


Tabela2 <- rename(TaBellaBeats, 
                  c("Atvidade_sedentaria" = "SedentaryMinutes", 
                    "Atividade_leve" =  "LightlyActiveMinutes", 
                    "Atividade_moderada" = "FairlyActiveMinutes", 
                    "Atividade_intensa" = "VeryActiveMinutes", 
                    "Calorias" = "Calories"))

d1 <- ggplot(Tabela2, aes(Atvidade_sedentaria, Calorias)) + geom_point() +
  geom_smooth(method = "lm")
d2 <- ggplot(Tabela2, aes(Atividade_leve, Calorias)) + geom_point() +
  geom_smooth(method = "lm")
d3 <- ggplot(Tabela2, aes(Atividade_moderada, Calorias)) + geom_point() +
  geom_smooth(method = "lm")
d4 <- ggplot(Tabela2, aes(Atividade_intensa, Calorias)) + geom_point() +
  geom_smooth(method = "lm")

grid.arrange(d1, d2, d3, d4)

cor(Tabela2$Atvidade_sedentaria,Tabela2$Calorias) ^ 2
cor(Tabela2$Atividade_leve,Tabela2$Calorias) ^ 2
cor(Tabela2$Atividade_moderada,Tabela2$Calorias) ^ 2
cor(Tabela2$Atividade_intensa,Tabela2$Calorias) ^ 2

Tabela3 <- rename(TaBellaBeats, 
                  c("Passos_totais"= "TotalSteps", 
                    "Calorias" = "Calories"))

ggplot(Tabela3, aes(Passos_totais, Calorias)) + geom_point() +
  geom_smooth(method = "lm")

cor(Tabela3$Passos_totais,Tabela3$Calorias) ^ 2
