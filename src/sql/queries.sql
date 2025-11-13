-- MISSION 1
-- 1.1

SELECT * FROM observations limit 10;

-- 1.2

SELECT distinct region_id FROM observations;

-- 1.3

SELECT count(distinct species_id) FROM observations;

-- 1.4 

SELECT count(*) FROM observations where region_id = 2;

-- 1.5

SELECT * FROM observations where observation_date = '1998-08-08';



-- MISSION 2

-- 2.1
-- Which region_id has the most observations?
-- Group by region and count how many times each appears.

SELECT r.name, count(*) as ct FROM observations o
join regions r on o.region_id = r.id
group by region_id
having count(*) =
    (
        select count(*)
        from Observations
       group by region_id
        order by count(*) desc
        limit 1
    );
    
-- 2.2
-- What are the 5 most frequent species_id?
-- Group, order by descending count, and limit the result.

select s.scientific_name, count(*) as "Number of recorded observations" from observations o 
join species s on o.species_id = s.id
group by 1
order by count(*) desc
limit 5;

-- 2.3
-- Which species (species_id) have fewer than 5 records?
-- Group by species and use HAVING to apply a condition.

select s.scientific_name, count(*) from observations o 
join species s on o.species_id = s.id
group by 1
having count(*) < 5; 

-- 2.4
--Which observers (observer) recorded the most observations?
--Group by observer name and count the records.

select o.observer, count(*) from observations o 
group by 1
order by count(*) desc;


-- MISSION 3

-- 3.1
--Show the region name (regions.name) for each observation.
--Join observations with regions using region_id.

select r.name, o.* from regions r
join observations o on o.region_id = r.id;


-- 3.2
--Show the scientific name of each recorded species (species.scientific_name).
--Join observations with species using species_id.

select distinct s.scientific_name from observations o
join species s on o.species_id = s.id;


-- 3.3
--Which is the most observed species in each region?
--Group by region and species, and order by count.

WITH regional_species_counts as (
    select r.name as "Region",
    s.scientific_name as "Species_Name",
    count(*) as "Total_Observations",
    row_number() over (partition by r.name order by count(*) desc) as "rn"
    from observations o
    join species s on o.species_id = s.id
    join regions r on o.region_id = r.id
    group by r.name, s.scientific_name
)
select rsc.Region, rsc.Species_Name, rsc.Total_Observations
from regional_species_counts rsc
where rn = 1
order by 3 desc;



