# SQL Queries for Belle Airlines Database

## Query 1: Same time zone flights
```sql
SELECT fl_orig AS origin, 
       fl_dest AS destination, 
       strftime('%H:%M', fl_orig_time) AS departure_time,
       strftime('%H:%M', fl_dest_time) AS arrival_time
FROM flight
WHERE fl_time_zones = 0
ORDER BY fl_flight_no;
```

## Query 2: Airports without hub airlines
```sql
SELECT air_code AS code, 
       air_location AS location, 
       air_elevation AS elevation
FROM airport
WHERE air_hub_airline = ''
ORDER BY air_elevation DESC;
```

## Query 3: Departures from Los Angeles
```sql
SELECT f.fl_flight_no, f.fl_orig, f.fl_dest, d.DEP_DEP_DATE
FROM flight f
LEFT JOIN departures d ON f.fl_flight_no = d.DEP_FLIGHT_NO
WHERE f.fl_orig IN (
    SELECT air_code 
    FROM airport 
    WHERE air_location = 'Los Angeles, CA'
);
```

## Query 4: Andy Anderson's reservations
```sql
    SELECT r.RES_FLIGHT_NO, f.fl_orig, f.fl_dest
    FROM reservation r
    JOIN passenger p ON r.RES_CONFIRM_NO = p.PAS_CONFIRM_NO
    JOIN flight f ON r.RES_FLIGHT_NO = f.fl_flight_no
    WHERE r.RES_NAME = 'Andy Anderson';
```

## Query 5: Boeing aircraft specs
```sql
SELECT DISTINCT EQ_SEAT_CAPACITY, EQ_FUEL_CAPACITY, EQ_miles_per_gal
FROM equip_type
WHERE EQ_EQUIP_TYPE LIKE 'BOE%';
```

## Query 6: Pilots not in Texas
```sql
SELECT pil_pilotname
FROM pilots
WHERE pil_state != 'TX'
ORDER BY SUBSTR(pil_pilotname, INSTR(pil_pilotname, ' ')+1);
```

## Query 7: July 2006 tickets
```sql
SELECT t.TIC_FLIGHT_NO, t.TIC_FLIGHT_DATE, f.fl_fare, f.fl_orig, f.fl_dest
FROM ticket t
JOIN flight f ON t.TIC_FLIGHT_NO = f.fl_flight_no
WHERE t.TIC_FLIGHT_DATE LIKE '%-JUL-2006'
ORDER BY t.TIC_FLIGHT_DATE, t.TIC_FLIGHT_NO;
```

## Query 8: Flights from non-hub airports
```sql
SELECT f.fl_flight_no, f.fl_orig, f.fl_dest
FROM flight f
JOIN airport a ON f.fl_orig = a.air_code
WHERE a.air_hub_airline = '' OR a.air_hub_airline IS NULL;
```

## Query 9: Flights to non-hub airports
```sql
SELECT f.fl_flight_no, f.fl_orig, f.fl_dest
FROM flight f
JOIN airport a ON f.fl_dest = a.air_code
WHERE a.air_hub_airline = '' OR a.air_hub_airline IS NULL;
```

## Query 10: Flights both from/to non-hub airports
```sql
SELECT f.fl_flight_no, f.fl_orig, f.fl_dest
FROM flight f
JOIN airport a1 ON f.fl_orig = a1.air_code
JOIN airport a2 ON f.fl_dest = a2.air_code
WHERE a1.air_hub_airline = ''
  AND a2.air_hub_airline = '';
```

## Query 11: Non-Boeing departures
```sql
SELECT d.DEP_FLIGHT_NO, d.DEP_DEP_DATE
FROM departures d
JOIN equip_type e ON d.DEP_EQUIP_NO = e.EQ_EQUIP_NO
WHERE e.EQ_EQUIP_TYPE NOT LIKE 'BOE%'
ORDER BY d.DEP_DEP_DATE, d.DEP_FLIGHT_NO;
```

## Query 12: Distance/fare ratio
```sql
SELECT fl_flight_no, fl_orig, fl_dest, fl_fare,
       ROUND(fl_distance/fl_fare, 2) AS distance_per_dollar
FROM flight
ORDER BY distance_per_dollar DESC;
```

## Query 13: Flights per origin
```sql
SELECT fl_orig, COUNT(*) AS flight_count
FROM flight
GROUP BY fl_orig;
```

## Query 14: Flights per origin with location
```sql
SELECT a.air_location, COUNT(f.fl_flight_no) AS flight_count
FROM airport a
LEFT JOIN flight f ON a.air_code = f.fl_orig
GROUP BY a.air_location;
```

## Query 15: All locations including no flights
```sql
SELECT a.air_location, COUNT(f.fl_flight_no) AS flight_count
FROM airport a
LEFT JOIN flight f ON a.air_code = f.fl_orig
GROUP BY a.air_location
ORDER BY flight_count;
```

## Query 16: Average flight pay by state for pilots
```sql
SELECT pil_state, AVG(pil_flight_pay) AS avg_flight_pay
FROM pilots
GROUP BY pil_state;
```

## Query 17: Pilots above average pay
```sql
SELECT pil_pilotname, pil_flight_pay
FROM pilots
WHERE pil_flight_pay > (SELECT AVG(pil_flight_pay) FROM pilots);
```

## Query 18: Pilots above state average
```sql
SELECT p.pil_pilotname, p.pil_flight_pay
FROM pilots p
WHERE p.pil_flight_pay > (
    SELECT AVG(p2.pil_flight_pay) 
    FROM pilots p2 
    WHERE p2.pil_state = p.pil_state
);
```

## Query 19: Most recent departure by pilot
```sql
SELECT p.pil_pilotname, MAX(d.DEP_DEP_DATE) AS last_departure
FROM pilots p
JOIN departures d ON p.pil_pilot_id = d.DEP_PILOT_ID
GROUP BY p.pil_pilotname;
```

## Query 20: Days since last departure date by pilot
```sql
SELECT p.pil_pilotname, 
       MAX(d.DEP_DEP_DATE) AS last_departure,
       julianday('now') - julianday(MAX(d.DEP_DEP_DATE)) AS days_since_last_flight
FROM pilots p
JOIN departures d ON p.pil_pilot_id = d.DEP_PILOT_ID
GROUP BY p.pil_pilotname
ORDER BY days_since_last_flight DESC;
```

## Query 21: Departures by time zone difference
```sql
SELECT fl_time_zones, COUNT(*) AS departure_count
FROM flight f
JOIN departures d ON f.fl_flight_no = d.DEP_FLIGHT_NO
GROUP BY fl_time_zones;
```

## Query 22: Airports per state
```sql
SELECT SUBSTR(air_location, INSTR(air_location, ',')+2) AS state,
       COUNT(*) AS airport_count
FROM airport
GROUP BY SUBSTR(air_location, INSTR(air_location, ',')+2);
```

## Query 23: Long-haul departures
```sql
SELECT COUNT(*) AS long_haul_departures
FROM departures d
JOIN flight f ON d.DEP_FLIGHT_NO = f.fl_flight_no
WHERE f.fl_distance >= 1000;
```

## Query 24: Age difference between pilots
```sql
SELECT (MAX(julianday('now') - julianday(pil_brthdate))/365.25) - 
       (MIN(julianday('now') - julianday(pil_brthdate))/365.25) AS age_difference
FROM pilots;
```

## Query 25: Aircraft range
```sql
SELECT EQ_EQUIP_TYPE, 
       (EQ_FUEL_CAPACITY * EQ_miles_per_gal) AS max_distance
FROM equip_type
ORDER BY max_distance DESC;
```

## Query 26: Reservation responsibility
```sql
SELECT p.PAS_NAME, r.RES_NAME AS reservation_holder
FROM passenger p
JOIN reservation r ON p.PAS_CONFIRM_NO = r.RES_CONFIRM_NO;
```

## Query 27: Non-self reservations
```sql
SELECT p.PAS_NAME, r.RES_NAME AS reservation_holder
FROM passenger p
JOIN reservation r ON p.PAS_CONFIRM_NO = r.RES_CONFIRM_NO
WHERE p.PAS_NAME != r.RES_NAME;
```

## Query 28: Pilot for each reservation
```sql
SELECT r.RES_CONFIRM_NO, p.pil_pilotname
FROM reservation r
JOIN departures d ON r.RES_FLIGHT_NO = d.DEP_FLIGHT_NO 
                  AND r.RES_FLIGHT_DATE = d.DEP_DEP_DATE
JOIN pilots p ON d.DEP_PILOT_ID = p.pil_pilot_id;
```

## Query 29: Single-flight tickets
```sql
SELECT t.TIC_ITINERARY_NO, t.TIC_FLIGHT_NO, t.TIC_FLIGHT_DATE
FROM ticket t
WHERE t.TIC_ITINERARY_NO IN (
    SELECT TIC_ITINERARY_NO
    FROM ticket
    GROUP BY TIC_ITINERARY_NO
    HAVING COUNT(*) = 1
);
```

## Query 30: Passengers with single-flight tickets
```sql
SELECT p.PAS_NAME
FROM passenger p
WHERE p.PAS_ITINERARY_NO IN (
    SELECT TIC_ITINERARY_NO
    FROM ticket
    GROUP BY TIC_ITINERARY_NO
    HAVING COUNT(*) = 1
);
```


## Notes
- All queries are adapted for SQLite syntax
- Date/time functions use SQLite's `strftime()` instead of Oracle's `TO_CHAR`
- Some functions like `MONTHS_BETWEEN` and `SYSDATE` need to be replaced with SQLite equivalents
- Each query is tested against the Belle Airport database schema