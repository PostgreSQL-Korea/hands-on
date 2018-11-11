drop table if exists landprice;
create table landprice as select 고유번호 as placeid, 기준년도::int as year, 기준월::int as month, 공시지가::int as price, 공시일자::date as ymd, 표준지여부 as isstandard from 공시지가;
alter table landprice add primary key (placeid,year,month);
alter table addrcode add upcode text;
insert into addrcode values ('11', '서울특별시','');
insert into addrcode select substr(acode, 1, 6), split_part(aname, ' ' , 2), '11' as upcode from addrcode where acode <> '11' group by  substr(acode, 1, 6), split_part(aname, ' ' , 2);
update addrcode set aname =  split_part(aname, ' ' , 3) where length(acode) = length('1174011000');
update addrcode set upcode = substr(acode, 1, 6) where length(acode) = length('1174011000');
