# Belle Airport Database System

## Project Overview
This is a SQLite database system for managing airport operations including flights, reservations, and personnel management.

## Database Schema
The system consists of 8 interconnected tables:

### Tables Structure

1. **Airport Table**
   - Airport Code (Primary Key)
   - Airport Location
   - Elevation
   - Phone Number
   - Hub Airlines

2. **Flight Table**
   - Flight Number (Primary Key)
   - Origin (Foreign Key -> Airport)
   - Destination (Foreign Key -> Airport)
   - Departure Time
   - Arrival Time
   - Meal Code (B/L/D/S/'')
   - Base Fare (30-350)
   - Mileage
   - Time Zone Changes (-2 to +2)

3. **Departures Table**
   - Flight Number (Foreign Key -> Flight)
   - Departure Date
   - Pilot ID (Foreign Key -> Pilots)
   - Equipment Number (Foreign Key -> Equip_Type)
   - Primary Key (Flight Number, Departure Date)

4. **Pilots Table**
   - Pilot ID (Primary Key)
   - Pilot Name
   - SSN
   - Street Address
   - City
   - State
   - Zip Code
   - Flight Pay
   - Date of Birth
   - Date Hired

5. **Equip_Type Table**
   - Equipment Number (Primary Key)
   - Equipment Type
   - Seating Capacity
   - Fuel Capacity
   - Miles Per Gallon

6. **Passenger Table**
   - Passenger Name
   - Itinerary Number (Primary Key)
   - Fare
   - Confirmation Number (Foreign Key -> Reservation)

7. **Reservation Table**
   - Confirmation Number (Primary Key)
   - Reservation Date
   - Reservation Name
   - Phone Number
   - Flight Number
   - Flight Date

8. **Ticket Table**
   - Itinerary Number (Foreign Key -> Passenger)
   - Flight Number
   - Flight Date
   - Seat Number
   - Primary Key (Itinerary Number, Flight Number, Flight Date)

## Setup Instructions

1. **Install SQLite**
   ```bash
   sudo apt-get update
   sudo apt-get install sqlite3
   ```

2. **Create Database**
   ```bash
   sqlite3 belle_airport.db
   ```

3. **Create Tables**
   ```bash
   .read belle_airport.sql
   ```

4. **Verify Tables**
   ```sql
   .tables
   .schema
   ```

## Data Insertion

1. **Begin Transaction**
   ```sql
   BEGIN TRANSACTION;
   ```

2. **Insert Data**
   - Insert Airport data first
   - Follow with Flight data
   - Then Pilots and Equipment
   - Finally add Departures, Reservations, Passengers, and Tickets

3. **Commit Changes**
   ```sql
   COMMIT;
   ```

## Verification Queries

Check data integrity with these queries:

```sql
-- Check Airports
SELECT * FROM airport;

-- Check Flights
SELECT * FROM flight;

-- Check Departures
SELECT d.*, p.pil_pilotname 
FROM departures d 
JOIN pilots p ON d.dep_pilot_id = p.pil_pilot_id;

-- Check Reservations and Tickets
SELECT r.*, t.tic_seat 
FROM reservation r 
JOIN ticket t ON r.res_flight_no = t.tic_flight_no 
AND r.res_flight_date = t.tic_flight_date;
```

## Important Notes
- All tables have referential integrity constraints
- Insert data in proper order to avoid foreign key violations
- Use transactions for bulk inserts
- Verify data after each major insertion
