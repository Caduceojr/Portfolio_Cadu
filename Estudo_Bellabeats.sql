   ### LIMPEZA DOS DADOS

use estudo_bellabeats;

# Selecionando IDs distintos para achar o numero de participantes com dados em atividade diaria
SELECT DISTINCT Id
FROM atividadereg;
# 33 IDs unicos retornados na consulta

# Selecionando IDs distintos para achar o numero de participantes com dados em registro de sono
SELECT DISTINCT Id
FROM sonoreg;
# 24 IDs unicos retornados na consulta

# Selecionando IDs distintos para achar o numero de participantes com dados em registro de peso
SELECT DISTINCT Id
FROM pesoreg;
# 8 IDs unicos retornados na consulta

# Levantar a data do começo e do fim dos dados acompanhados em atividade diaria
SELECT MIN(ActivityDate) AS dataini, MAX(ActivityDate) AS datafim
FROM atividadereg;
# data inicial 12-04-2016 e data final 12-05-2016

# Levantar a data do começo e do fim dos dados acompanhados em registro de sono
SELECT MIN(SleepDay) AS dataini, MAX(SleepDay) as datafim
FROM sonoreg;
# data inicial 12-04-2016 e data final 12-05-2016

# Levantar a data do começo e do fim dos dados acompanhados em registro de peso
SELECT MIN(Date) AS dataini, MAX(Date) as datafim
FROM pesoreg;
# data inicial 12-04-2016 e data final 12-05-2016

# Encontrando linhas duplicadas, se houverem, em atividade diaria
SELECT Id, ActivityDate, COUNT(*) AS numlin
FROM atividadereg
GROUP BY Id, ActivityDate
HAVING numlin > 1;
# sem resultado, não há linhas duplicadas na tabela atividade diaria

# Encontrando linhas duplicadas, se houverem, em registro de sono
SELECT Id, SleepDay, COUNT(*) AS numlin
FROM sonoreg
GROUP BY Id, SleepDay
HAVING numlin > 1;
# 3 linhas duplicadas retornaram

# Criando nova tabela de registros com todas as linhas distintas
CREATE TABLE sonoreg2 SELECT DISTINCT * FROM sonoreg;

# Checando novamente linhas duplicadas em registro de sono (2)
SELECT Id, SleepDay, COUNT(*) AS numlin
FROM sonoreg2
GROUP BY Id, SleepDay
HAVING numlin > 1;
# sem resultado, não há linhas duplicadas na tabela registro de sono nova

# Dropando a tabela original de registro de sono e renomeando a nova
## ALTER TABLE sonoreg RENAME cair
DROP TABLE IF EXISTS cair;
ALTER TABLE sonoreg2 RENAME sonoreg;
# primeira linha comentada para não correr o risco de excluir a nova sonoreg

# Encontrando linhas duplicadas, se houverem, em registro de peso
SELECT Id, Date, COUNT(*) AS numlin
from pesoreg
GROUP BY Id, Date
HAVING numlin > 1;
# sem resultado, não há linhas duplicadas na tabela de registro de peso

# Verificando se todos os IDs em atividadereg tem os mesmo numero de caracteres
SELECT LENGTH(Id)
FROM atividadereg;

# Procurando por IDS em atividadereg que tenham mais ou menos de 10 caracteres
SELECT Id
FROM atividadereg
WHERE LENGTH(Id) > 10
OR LENGTH(Id) < 10;
# Nenhum valor retornado, todos os IDs tem 10 caracteres

# Procurando por IDS em sonoreg que tenham mais ou menos de 10 caracteres
SELECT Id
FROM sonoreg
WHERE LENGTH(Id) > 10
OR LENGTH(Id) < 10;
# Nenhum valor retornado, todos os IDs tem 10 caracteres

# Procurando por IDS em pesoreg que tenham mais ou menos de 10 caracteres
SELECT Id
FROM pesoreg
WHERE LENGTH(Id) > 10
OR LENGTH(Id) < 10;
# Nenhum valor retornado, todos os IDs tem 10 caracteres

# Consultando em coluna LogId na tabela pesoreg para determinar se é chave primaria
SELECT LogId, COUNT(*) AS numlin
FROM pesoreg
GROUP BY LogId
HAVING numlin > 1 
ORDER BY numlin DESC;
# Dez LogIds tem a contagem maior que 1, sugerindo que a coluna não contem chave primaria da tabela

# Verificando registros com 0 passos na coluna TotalSteps da tabela atividadereg (Atividade diaria)
SELECT Id, COUNT(*) AS zeropassos
FROM atividadereg
Where TotalSteps = 0
GROUP BY Id
ORDER BY zeropassos DESC;
# 15 participantes tiveram dias com zero passos
 
# Verificando o total de registros (numeros de dias) com zero passos
SELECT SUM(zeropassos) as totalzeropassos
FROM( SELECT COUNT(*) AS zeropassos
		FROM atividadereg
        WHERE TotalSteps = 0
        ) AS z;
# 77 registros com zero passos

# Varificando cada atributo de cada dia com zero passos
SELECT *, ROUND((SedentaryMinutes / 60), 2) AS HorasSedent
FROM atividadereg
WHERE TotalSteps = 0;
# Enquanto esses registros poderiam estar refletindo o dia que o usuario ficou inativo totalmente (A grande maioria dos registros retornados da Query acima mostram um total de 24 horas de atividade sedentaria), muito provavelmente os usuarios não usaram suas FitBits nesses dias tornando esses registros enganosos ou equivocados.

# Deletando as linhas com zero passos no dia
DELETE FROM atividadereg
WHERE TotalSteps = 0;

  ### QUERIES DO ESTUDO DE CASO

# Selecionando datas e dias correspondentes da semana para identificar dias da semana e fim de semana
SELECT ActivityDate, DAYNAME(ActivityDate) AS DiaDaSemana
FROM atividadereg;

SELECT ActivityDate,
	CASE	
		WHEN DiaDaSemana = 'Monday' THEN 'Weekday'
		WHEN DiaDaSemana = 'Tuesday' THEN 'Weekday'
		WHEN DiaDaSemana = 'Wednesday' THEN 'Weekday'
		WHEN DiaDaSemana = 'Thursday' THEN 'Weekday'
		WHEN DiaDaSemana = 'Friday' THEN 'Weekday'
		ELSE 'Weekend' 
	END AS Semana
FROM (SELECT *, DAYNAME(ActivityDate) AS DiaDaSemana FROM atividadereg) AS temp;

# Verificando a média de passos, distancia e calorias em dia de semana vs fim de semana

SELECT Semana, AVG(TotalSteps) AS MedPassos, AVG(TotalDistance) AS MedDistancia, AVG(Calories) AS MedCalorias
FROM (SELECT *,
		CASE	
			WHEN DiaDaSemana = 'Monday' THEN 'Weekday'
			WHEN DiaDaSemana = 'Tuesday' THEN 'Weekday'
			WHEN DiaDaSemana = 'Wednesday' THEN 'Weekday'
			WHEN DiaDaSemana = 'Thursday' THEN 'Weekday'
			WHEN DiaDaSemana = 'Friday' THEN 'Weekday'
			ELSE 'Weekend' 
		END AS Semana
	FROM (SELECT *, DAYNAME(ActivityDate) AS DiaDaSemana FROM atividadereg) AS temp) AS temp2
GROUP BY Semana;    

# Verificando média de passos, distancia e calorias por dia da semana
SELECT DAYNAME(ActivityDate) AS DiaDaSemana, AVG(TotalSteps) AS MedPassos, AVG(TotalDistance) AS MedDistancia, AVG(Calories) AS MedCalorias
FROM atividadereg
GROUP BY DiaDaSemana
ORDER BY MedPassos DESC;

# Verificando a média de tempo de gasto no sono e média de tempo para pegar no sono por dia de semana 
SELECT DAYNAME(SleepDay) AS DiaDaSemana, AVG(TotalMinutesAsleep) AS MedMinSono, AVG(TotalMinutesAsleep / 60) AS MedHoraSono, AVG (TotalTimeInBed - TotalMinutesAsleep) As MedParaDormir
FROM sonoreg
GROUP BY DiaDaSemana
ORDER BY MedHoraSono DESC;

# Verificando calorias e minutos ativos
SELECT Id, ActivityDate, Calories, SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes
FROM atividadereg;

# Verificando calorias e distacia de movimentação
SELECT Id, ActivityDate, Calories, SedentaryActiveDistance, LightActiveDistance, ModeratelyActiveDistance, VeryActiveDistance, TotalDistance
FROM atividadereg;

# Verificando calorias e o total de passos
SELECT Id, ActivityDate, Calories, TotalSteps
FROM atividadereg;

# Verificando calorias e total de minutos dormidos
SELECT a.Id , ActivityDate, Calories, TotalMinutesAsleep
FROM atividadereg AS a
INNER JOIN sonoreg as s
ON a.Id = s.Id AND a.ActivityDate = s.SleepDay;

# Verificando calorias e total de minutos e horas dormidas no dia anterior
SELECT a.Id, a.ActivityDate, Calories, TotalMinutesAsleep,
			LAG(TotalMinutesAsleep, 1) OVER (ORDER BY a.Id, a.ActivityDate) AS MinutosDormidosAntes,
			LAG(TotalMinutesAsleep, 1) OVER (ORDER BY a.Id, a.ActivityDate) / 60 AS HorasDormidasAntes
FROM atividadereg AS a
INNER JOIN sonoreg AS s 
ON a.Id = s.Id AND a.ActivityDate = s.SleepDay;

# Verificando reports manuais vs automaticos na tabela pesoreg, verificando também peso médio dos participantes que fizeram registro manual ou automatico
SELECT IsManualReport, COUNT(DISTINCT Id)
FROM pesoreg
GROUP BY IsManualReport;

SELECT IsManualReport, COUNT(*) AS num_registros, AVG(WeightPounds) AS PesoMed
FROM pesoreg
GROUP BY IsManualReport;

# Verificando todos o minutos (nova coluna minutos totais) na tabela ativiadereg
SELECT Id, ActivityDate, (SedentaryMinutes + LightlyActiveMinutes + FairlyActiveMinutes + VeryActiveMinutes) AS MinutosTotais, SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes
FROM atividadereg;

# Verificando minutos não sedentarios a total de sono
SELECT a.Id, ActivityDate, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes, (LightlyActiveMinutes + FairlyActiveMinutes + VeryActiveMinutes) AS MinutosTotais, TotalMinutesAsleep, (TotalTimeInBed - TotalMinutesAsleep) AS MinutosParaDormir
FROM atividadereg as a
INNER JOIN  sonoreg as s
ON a.Id = s.Id AND ActivityDate = SleepDay;

# Verificando todos os minutos de atividade e total de sono
SELECT a.Id, ActivityDate, SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes, (SedentaryMinutes + LightlyActiveMinutes + FairlyActiveMinutes + VeryActiveMinutes) AS MinutosTotais, TotalMinutesAsleep, (TotalTimeInBed - TotalMinutesAsleep) AS MinutosParaDormir
FROM atividadereg as a
INNER JOIN  sonoreg as s
ON a.Id = s.Id AND ActivityDate = SleepDay;

# Verificando o numero de dias onde o total de passos foi igual ou maior que o recomendado pela OMS (10.000)
SELECT DAYNAME(ActivityDate) AS DiaDaSemana, COUNT(*)
FROM atividadereg
WHERE TotalSteps >= 10000
GROUP BY DiaDaSemana;

# Verificando o numero de dias onde o total de sono em minutos foi entre 7h a 9h (quantidade recomendada)
SELECT DAYNAME(ActivityDate) AS DiaDaSemana, COUNT(*) AS NumDias
FROM atividadereg AS a
JOIN sonoreg AS s
ON a.Id = s.Id AND ActivityDate = SleepDay
WHERE TotalMinutesAsleep >= 420 AND TotalMinutesAsleep <= 540
GROUP BY DiaDaSemana
ORDER BY NumDias DESC;



