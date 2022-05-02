--cat names with owner name
SELECT  
	prg_cat.name as CatName, 
	prg_adopter.name as OwnerName
FROM prg_adopter 
RIGHT JOIN prg_cat ON prg_adopter.adopter_id = prg_cat.adopter_id 
WHERE prg_cat.adopter_id IS NOT NULL

--kitten names with owner name
SELECT  
	prg_kitten.name as KittenName, 
	prg_adopter.name as OwnerName
FROM prg_adopter 
RIGHT JOIN prg_kitten ON prg_adopter.adopter_id = prg_kitten.adopter_id 
WHERE prg_kitten.adopter_id IS NOT NULL

--Counts the number of breeds
SELECT
COUNT(DISTINCT breed) as Breeds
FROM prg_characteristic

--Lists the names of the breeds with the Number of cats per breed
SELECT
DISTINCT breed as Breeds,
COUNT(breed) as NumBreeds
FROM prg_characteristic
GROUP BY breed

--names of unvaccinated cats
SELECT 
name
FROM prg_cat
WHERE vaccine_status = 'FALSE'

--names of unvaccinated kittens
SELECT 
name
FROM prg_kitten
WHERE vaccine_status = 'FALSE'

