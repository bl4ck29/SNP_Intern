use ThucTapSNP

-- stg_LOCATION
create table stg_LOCATION(LOC_ID int identity(0, 1), REGION char(3), AREA char(5), STACK char(3))
insert into stg_LOCATION
    select REGION, AREA, STACK
        from YARD_AREA
        group by REGION, AREA, STACK

-- stg_TRANSACT
create table stg_TRANSACT(ITEM_KEY int, ITEM_NO char(12), LENGTH numeric(9, 3), AREA char(5), STACK char(4), R_D char(4), DURATION int, EXEC_TS datetime, ITEM_TYPE varchar(1))
insert into stg_TRANSACT
    select item.ITEM_KEY, item.ITEM_NO, item.LENGTH, pregate.AREA, loc.STACK, pregate.R_D,
        datediff(second, item.ARR_TS, item.DEP_TS) DURATION,
        item.ARR_TS EXEC_TS,
        case when item.ITEM_KEY in (select ITEM_KEY from ITEM_REEFER)
            then 'R'
            else case when item.ITEM_KEY in (select ITEM_KEY from ITEM_DANGEROUS)
                then 'D'
                else case when item.ITEM_KEY in (select ITEM_KEY from ITEM_OOG)
                    then 'O'
                    else 'G' end
                end
            end ITEM_TYPE
    from ITEM_LOCATION loc, ITEM item
    inner join PREGATE_TRANSACT pregate
        on item.ITEM_KEY=pregate.ITEM_KEY and pregate.R_D='R'
    where item.ARR_BY='T' and item.SITE_ID='CTL' and year(ARR_TS)>1900 and item.FEL='F' and item.HIST_FLG='Y' and item.ITEM_KEY=loc.ITEM_KEY
    union
    select item.ITEM_KEY, item.ITEM_NO, item.LENGTH, pregate.AREA, loc.STACK, pregate.R_D,
        datediff(second, item.ARR_TS, item.DEP_TS) DURATION,
        item.DEP_TS EXEC_TS,
        case when item.ITEM_KEY in (select ITEM_KEY from ITEM_REEFER)
            then 'R'
            else case when item.ITEM_KEY in (select ITEM_KEY from ITEM_DANGEROUS)
                then 'D'
                else case when item.ITEM_KEY in (select ITEM_KEY from ITEM_OOG)
                    then 'O'
                    else 'G' end
                end
            end ITEM_TYPE
    from ITEM_LOCATION loc, ITEM item
    inner join PREGATE_TRANSACT pregate
        on item.ITEM_KEY=pregate.ITEM_KEY and pregate.R_D='D'
    where item.ARR_BY='T' and item.SITE_ID='CTL' and year(DEP_TS)>1900 and item.FEL='F' and item.HIST_FLG='Y' and item.ITEM_KEY=loc.ITEM_KEY