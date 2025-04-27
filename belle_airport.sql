/*******************************************************************************
    Belle Airport Database Schema Documentation
    
    This database manages the operations of Belle Airport, including flights, 
    reservations, and personnel management.

Tables:
-------
FLIGHT
    Stores flight route information including flight numbers, origin/destination
    airports, times, meal service, fare, distance and time zone differences.

AIRPORT 
    Contains airport reference data including location codes, physical location,
    elevation, contact info and primary airline hub information.

PILOTS
    Maintains pilot personnel records including ID, personal information,
    compensation details and employment dates.

EQUIP_TYPE
    Aircraft equipment catalog containing specifications like capacity,
    fuel details and efficiency metrics.

DEPARTURES
    Records specific flight instances - linking flights, dates, assigned pilots
    and equipment.

RESERVATION
    Tracks customer booking information including confirmation numbers,
    contact details and flight selections.

PASSENGER
    Stores passenger details including name, itinerary number, fare paid
    and reservation confirmation.

TICKET
    Maps passengers to specific seats on flights through itinerary numbers,
    flight numbers and dates.

Relationships:
-------------
- Flights reference origin and destination airports
- Departures link flights with pilots and equipment
- Reservations connect to specific departure instances
- Passengers are linked to reservations
- Tickets connect passengers to specific seats on departures

*******************************************************************************/

CREATE TABLE airport (
    air_code         VARCHAR2(3)     PRIMARY KEY,
    air_location     VARCHAR2(20),
    air_elevation    NUMBER,
    air_phone        VARCHAR2(10),
    air_hub_airline  VARCHAR2(20)
);

CREATE TABLE flight (
    fl_flight_no    NUMBER(6)    PRIMARY KEY,
    fl_orig         VARCHAR2(3)  CONSTRAINT flight_orig_fk REFERENCES airport(air_code),
    fl_dest         VARCHAR2(3)  CONSTRAINT flight_dest_fk REFERENCES airport(air_code),
    fl_orig_time    DATE,
    fl_dest_time    DATE,
    fl_meal         CHAR(1)      CONSTRAINT flight_meal_cc CHECK (fl_meal IN ('B','L','D','S','')),
    fl_fare         NUMBER       CONSTRAINT flight_fare_cc CHECK (fl_fare BETWEEN 30 AND 350),
    fl_distance     NUMBER,
    fl_time_zones   NUMBER       CONSTRAINT flight_zone_cc CHECK (fl_time_zones BETWEEN -2 AND 2)
);

CREATE TABLE pilots (
    pil_pilot_id    VARCHAR2(3)     PRIMARY KEY,
    pil_pilotname   VARCHAR2(30),
    pil_ssn         VARCHAR2(9),
    pil_street      VARCHAR2(20),
    pil_city        VARCHAR2(12),
    pil_state       VARCHAR2(2),
    pil_zip         VARCHAR2(5),
    pil_flight_pay  NUMBER(4),
    pil_brthdate    DATE,
    pil_hiredate    DATE
);

CREATE TABLE equip_type (
    eq_equip_no       NUMBER          PRIMARY KEY,
    eq_equip_type     VARCHAR2(10),
    eq_seat_capacity  NUMBER,
    eq_fuel_capacity  NUMBER,
    eq_miles_per_gal  NUMBER(5,2)
);

CREATE TABLE departures (
    dep_flight_no    NUMBER      REFERENCES flight(fl_flight_no),
    dep_dep_date     DATE,
    dep_pilot_id     VARCHAR2(3) REFERENCES pilots(pil_pilot_id),
    dep_equip_no     NUMBER      REFERENCES equip_type(eq_equip_no),
    CONSTRAINT departures_flightno_date_pk PRIMARY KEY (dep_flight_no, dep_dep_date)
);

CREATE TABLE reservation (
    res_confirm_no   NUMBER        PRIMARY KEY,
    res_date         DATE,
    res_name         VARCHAR2(20),
    res_phone        VARCHAR2(10),
    res_flight_no    NUMBER,
    res_flight_date  DATE,
    FOREIGN KEY (res_flight_no, res_flight_date) REFERENCES departures(dep_flight_no, dep_dep_date)
);

CREATE TABLE passenger (
    pas_name          VARCHAR2(20),
    pas_itinerary_no  NUMBER        PRIMARY KEY,
    pas_fare          NUMBER,
    pas_confirm_no    NUMBER        REFERENCES reservation(res_confirm_no)
);

CREATE TABLE ticket (
    tic_itinerary_no  NUMBER,
    tic_flight_no     NUMBER,
    tic_flight_date   DATE,
    tic_seat          VARCHAR2(3),
    CONSTRAINT ticket_itno_flightno_pk PRIMARY KEY (tic_itinerary_no, tic_flight_no, tic_flight_date),
    CONSTRAINT ticket_itno_fk FOREIGN KEY (tic_itinerary_no) REFERENCES passenger(pas_itinerary_no),
    CONSTRAINT ticket_flight_date_fk FOREIGN KEY (tic_flight_no, tic_flight_date) 
        REFERENCES departures(dep_flight_no, dep_dep_date)
);

