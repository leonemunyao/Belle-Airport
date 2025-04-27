CREATE TABLE PILOTS (
    Pilot_ID TEXT PRIMARY KEY,
    Pilot_Name TEXT,
    SSN TEXT,
    Street_Address TEXT,
    City TEXT,
    State TEXT,
    Zip_Code TEXT,
    Flight_Pay REAL,
    DOB DATE,
    Date_Hired DATE
);

CREATE TABLE FLIGHT (
    Flight_Number TEXT PRIMARY KEY,
    Origin TEXT,
    Destination TEXT,
    Departure_Time DATETIME,
    Arrival_Time DATETIME,
    Meal_Code TEXT,
    Base_Fare REAL,
    Mileage INTEGER,
    Time_Zone_Changes INTEGER,
    FOREIGN KEY (Origin) REFERENCES AIRPORT(Airport_Code),
    FOREIGN KEY (Destination) REFERENCES AIRPORT(Airport_Code)
);

CREATE TABLE PASSENGER (
    Passenger_Name TEXT,
    Itinerary_Number TEXT PRIMARY KEY,
    Confirmation_Number TEXT,
    FOREIGN KEY (Confirmation_Number) REFERENCES RESERVATION(Confirmation_Number)
);

CREATE TABLE EQUIP_TYPE (
    Equipment_Number TEXT PRIMARY KEY,
    Equipment_Type TEXT,
    Seating_Capacity INTEGER,
    Fuel_Capacity REAL,
    Miles_Per_Gallon REAL
);

CREATE TABLE RESERVATION (
    Confirmation_Number TEXT PRIMARY KEY,
    Reservation_Date DATE,
    Reservation_Name TEXT,
    Reservation_Phone TEXT,
    Reservation_Flight_Number TEXT,
    Reservation_Flight_Date DATE,
    FOREIGN KEY (Reservation_Flight_Number) REFERENCES FLIGHT(Flight_Number)
);

CREATE TABLE DEPARTURES (
    Flight_Number TEXT,
    Departure_Date DATE,
    Pilot_ID TEXT,
    Equipment_Number TEXT,
    PRIMARY KEY (Flight_Number, Departure_Date),
    FOREIGN KEY (Flight_Number) REFERENCES FLIGHT(Flight_Number),
    FOREIGN KEY (Pilot_ID) REFERENCES PILOTS(Pilot_ID),
    FOREIGN KEY (Equipment_Number) REFERENCES EQUIP_TYPE(Equipment_Number)
);

CREATE TABLE AIRPORT (
    Airport_Code TEXT PRIMARY KEY,
    Location TEXT,
    Elevation INTEGER,
    Phone_Number TEXT,
    Hub_Airlines TEXT
);

CREATE TABLE TICKET (
    Itinerary_Number TEXT,
    Flight_Number TEXT,
    Flight_Date DATE,
    Seat_Assignment TEXT,
    PRIMARY KEY (Itinerary_Number, Flight_Number, Flight_Date),
    FOREIGN KEY (Itinerary_Number) REFERENCES PASSENGER(Itinerary_Number),
    FOREIGN KEY (Flight_Number) REFERENCES FLIGHT(Flight_Number)
);


