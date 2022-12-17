select * from project.dataset1;

select * from project.dataset2;

-- number of rows into our dataset
use project;
select count(*) from project.dataset1
select count(*) from project.dataset2

-- dataset for Jharkhand and Bihar
select * from project.dataset1 where state in ('Jharkhand','Bihar')

-- population of India
select sum(population) as Population from project.dataset2

-- Average growth 
select avg(growth)*100 as avg_growth from project.dataset1;
select state,avg(growth)*100 as avg_growth from project.dataset1 group by state;

-- Average sex ratio
select state,round(avg(Sex_Ratio),0) as avg_sex_ratio from project.dataset1 group by state order by avg_sex_ratio desc;

-- Average literacy rate
select state,round(avg(Literacy),0) as avg_literacy_ratio from project.dataset1
 group by state order by avg_literacy_ratio desc;
 
select state,round(avg(Literacy),0) as avg_literacy_ratio from project.dataset1
group by state having round(avg(Literacy),0)>90 order by avg_literacy_ratio desc;

-- Top 3 states showing highest growth ratio
select state, avg(growth)*100 as avg_growth from project.dataset1 group by state order by avg_growth desc limit 3; 

-- Bottom 3 states showing lowest sex ratio
select state,round(avg(Sex_Ratio),0) as avg_sex_ratio from project.dataset1 group by state order by avg_sex_ratio asc limit 4;

-- top and bottom 3 states in literacy state
use project;
drop table if exists top_states;
create table top_states(
state varchar(255),
topstates float
);

insert into top_states
select state,round(avg(Literacy),0) as avg_literacy_ratio from project.dataset1
 group by state order by avg_literacy_ratio desc;
 select * from top_states order by top_states.topstates desc limit 3;

create table bottom_states(
state varchar(255),
bottomstates float
);

insert into bottom_states
select state,round(avg(Literacy),0) as avg_literacy_ratio from project.dataset1
 group by state order by avg_literacy_ratio asc;
 select * from bottom_states order by bottom_states.bottomstates asc limit 4;
 
 -- union operator
 select * from (
 select * from top_states order by top_states.topstates desc limit 3) a
 union
 select * from (
 select * from bottom_states order by bottom_states.bottomstates asc limit 4) b;
 
 -- states starting with letter a or b
 select distinct state from project.dataset1 where lower(state) like 'a%' or lower(state) like 'b%'
 
 -- states starting with letter a and ending with letter m
 select distinct state from project.dataset1 where lower(state) like 'a%' and lower(state) like '%m'
 
 -- Joining both table
 -- Total males and females
 use project;
 select d.state, sum(d.males) total_males, sum(d.females) total_females from
 (select c.district, c.state, round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
 (select a.district, a.state, a.sex_ratio/1000 sex_ratio, b.population from project.dataset1 as a
 inner join project.dataset2 as b on a.district=b.district) c) d
 group by d.state;
 
-- Total literacy rate
select c.state, sum(literate_people) total_literate_pop,sum(illiterate_people) total_illiterate_pop from
(select d.district, d.state, round(d.literacy_ratio*d.population,0) literate_people,round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district, a.state, a.literacy/100 literacy_ratio, b.population from project.dataset1 as a inner join project.dataset2 as b on a.district=b.district) d) c
 group by c.state;
 
 -- Population in previous census
 select sum(m.previous_census_population) previous_census_population, sum(m.current_census_population) current_census_population from(
 select e.state, sum(e.previous_census_population) previous_census_population, sum(e.current_census_population) current_census_population from
(select d.district, d.state,round(d.population/(1+growth),0) previous_census_population, d.population current_census_population from
(select a.district, a.state, a.growth growth, b.population from project.dataset1 as a
 inner join project.dataset2 as b on a.district=b.district) d) e
 group by e.state) m
 
-- population vs area
select (g.total_area/g.previous_census_population) as previous_census_population_vs_area, (g.total_area/g.current_census_population) as current_census_population_vs_area from
(select q.*, r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) as previous_census_population, sum(m.current_census_population) as current_census_population from(
 select e.state, sum(e.previous_census_population) previous_census_population, sum(e.current_census_population) current_census_population from
(select d.district, d.state,round(d.population/(1+growth),0) previous_census_population, d.population current_census_population from
(select a.district, a.state, a.growth growth, b.population from project.dataset1 as a
 inner join project.dataset2 as b on a.district=b.district) d) e
 group by e.state) m) n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from project.dataset2)z) r on q.keyy=r.keyy) g

-- Window function
output top 3 districts from each state with highest literacy ratio

select a.* from
(select district, state, literacy, rank() over( partition by state order by literacy desc) rnk from project.dataset1) a

where a.rnk in (1,2,3) order by state






