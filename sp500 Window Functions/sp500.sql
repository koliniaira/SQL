-- Create the tables for the S&P 500 database
-- by importing the data from the csv files provided.
-- They contain information about the companies
-- in the S&P 500 stock market index
-- during some interval of time in 2014-2015.
-- https://en.wikipedia.org/wiki/S%26P_500

-- Familiarize yourself with the tables.
select * from history;
select * from sp500;

-- Change the type of the day column to DATE.
ALTER TABLE history ALTER COLUMN day TYPE DATE
USING to_date(day, 'YYYY-MM-DD');


-- Exercise 1 (3 pts)

-- 1. (1 pts) Find the number of companies for each state, sort descending by the number.
Select sp500."State", count("Security") as num
From sp500
GROUP BY sp500."State"
ORDER BY num DESC;


-- 2. (1 pts) Find the number of companies for each sector, sort descending by the number.
Select sp500."Sector", count("Security") as num
From sp500
GROUP BY sp500."Sector"
ORDER BY num DESC;


-- 3. (1 pts) Order the days of the week by their average volatility.
-- Sort descending by the average volatility.
-- Use 100*abs(high-low)/low to measure daily volatility.
-- No weekends since closed
SELECT EXTRACT(DOW from day) AS dayofweek, AVG(100 * abs(high-low)/low) AS avgVol
FROM history
GROUP BY dayofweek
ORDER BY avgVol DESC;


-- Exercise 2 (4 pts)
-- 1. (2 pts) Find for each symbol and day the pct change from the previous business day.
-- Order descending by pct change. Use adjclose.
SELECT *
FROM (
       SELECT symbol, day, 100 * (adjclose- LAG(adjclose, 1) OVER (PARTITION BY symbol ORDER BY day))
       / LAG (adjclose, 1 ) OVER (PARTITION BY symbol ORDER BY day) AS pct
    FROM history) X
ORDER BY pct;


-- 2. (2 pts)
-- Many traders believe in buying stocks in uptrend
-- in order to maximize their chance of profit.
-- Let us check this strategy.
-- Find for each symbol on Oct 1, 2015
-- the pct change 20 trading days earlier and 20 trading days later.
-- Order descending by pct change with respect to 20 trading days earlier.
-- Use adjclose.

-- Expected result
--symbol,pct_change,pct_change2
--TE,26.0661102331371252,3.0406725557250169
--TAP,24.6107784431137725,5.1057184046131667
--CVC,24.4688922610015175,-0.67052727826882048156
--...

/*
100*(adjclose-adjclose_prev)/adjclose_prev AS pct_change,
100*(adjclose_post-adjclose)/adjclose AS pct_change2

LAG(adjclose,20) OVER (...) AS adjclose_prev,
LEAD(adjclose,20) OVER (...) AS adjclose_post
*/
SELECT *
FROM
    ( SELECT symbol,
             100 * (adjclose - LAG(adjclose,20) OVER (PARTITION BY symbol)) /
             LAG(adjclose,20) OVER (PARTITION BY symbol) AS pct_change,
             100 * ((LEAD(adjclose,20) OVER (PARTITION BY symbol) - adjclose ) / adjclose)
             AS pct_change2
      FROM history
      WHERE day = '2021-10-1') X
ORDER BY pct_change DESC;


-- Exercise 3 (3 pts)
-- Find the top 10 symbols with respect to their average money volume AVG(volume*adjclose).
-- Use round(..., -8) on the average money volume.
-- Give three versions of your query, using ROW_NUMBER(), RANK(), and DENSE_RANK().

CREATE VIEW AvgMoneyVolume AS
SELECT symbol, round(AVG(volume*adjclose),-8) AS moneyvolume
FROM history
GROUP BY symbol;

SELECT symbol, moneyvolume, rank
FROM (
  SELECT symbol, moneyvolume, row_number() over (ORDER BY moneyvolume desc) as rank
  FROM avgmoneyvolume
) X
WHERE rank <= 10;

SELECT symbol, moneyvolume, rank
FROM (
  SELECT symbol, moneyvolume, rank() over (ORDER BY moneyvolume desc) as rank
  FROM avgmoneyvolume
) X
WHERE rank <= 10;

SELECT symbol, moneyvolume, rank
FROM (
    SELECT symbol, moneyvolume, dense_rank() over (ORDER BY moneyvolume desc) as rank
    FROM avgmoneyvolume
     ) X
WHERE rank <= 10


