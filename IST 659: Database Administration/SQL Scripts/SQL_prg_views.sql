--Counts the total number of cats
CREATE OR ALTER VIEW CatCount AS
SELECT COUNT(cat_id) as NumberOfCats from prg_cat
GO

SELECT * FROM CatCount

--Counts the total number of kittens
CREATE OR ALTER VIEW KittenCount AS
SELECT COUNT(kitten_id) as NumberOfKittens from prg_kitten
GO

SELECT * FROM KittenCount

--Counts the number of vaccinated cats
CREATE OR ALTER VIEW CatVaccine AS
SELECT COUNT(vaccine_status) AS NumberVacinate from prg_cat
WHERE vaccine_status = 'TRUE'
GO

SELECT * FROM CatVaccine

--Counts the number of vaccinated kittens
CREATE OR ALTER VIEW KittenVaccine AS
SELECT COUNT(vaccine_status) AS NumberVacinate from prg_kitten
WHERE vaccine_status = 'TRUE'
GO

SELECT * FROM KittenVaccine

CREATE OR ALTER VIEW AvaliableCats AS
SELECT name FROM prg_cat
WHERE prg_cat.adopter_id IS NULL
GO

SELECT * FROM AvaliableCats

CREATE OR ALTER VIEW AvaliableKittens AS
SELECT name FROM prg_kitten
WHERE prg_kitten.adopter_id IS NULL
GO

SELECT * FROM AvaliableCats
SELECT * FROM AvaliableKittens

