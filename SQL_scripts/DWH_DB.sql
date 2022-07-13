use DWH_ThucTapSNP

create table d_LOCATION(LOC_ID int identity(0, 1), REGION char(3), AREA char(5), STACK char(3))
insert into d_LOCATION
    select REGION, AREA, STACK
    from ThucTapSNP.dbo.YARD_AREA
    group by REGION, AREA, STACK

create table f_TRANSACT(EXEC_TS datetime, LOC_ID int, R_D char(4), LENGTH numeric(9, 3), ITEM_TYPE varchar(1), QUANTITY int, SUM_DURATION int)
insert into f_TRANSACT
    select stg.EXEC_TS, loc.LOC_ID, stg.R_D, stg.LENGTH, stg.ITEM_TYPE, count(stg.ITEM_KEY) QUANTITY, sum(stg.DURATION) SUM_DURATION
    from ThucTapSNP.dbo.stg_TRANSACT
    join d_LOCATION loc
        on stg.AREA=loc.AREA and stg.STACK=loc.STACK
    group by stg.EXEC_TS, loc.LOC_ID, stg.R_D, stg.LENGTH, stg.ITEM_TYPE