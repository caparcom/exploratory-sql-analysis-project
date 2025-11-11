-- MISSION 1
-- 1.1

--SELECT * FROM observations limit 10;

-- 1.2

--SELECT distinct region_id FROM observations;

-- 1.3

--SELECT count(distinct species_id) FROM observations;

-- 1.4 

--SELECT count(*) FROM observations where region_id = 2;

-- 1.5

--SELECT * FROM observations where observation_date = '1998-08-08';



-- MISSION 2

-- 2.1

SELECT region_id, count(*) as ct FROM observations
group by region_id
having count(*) =
    (
        select count(*)
        from Observations
        group by region_id
        order by count(*) desc
        limit 1
    );
    

