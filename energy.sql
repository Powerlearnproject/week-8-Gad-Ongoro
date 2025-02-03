CREATE TABLE Regions (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(100),
    Population INT,
    GridAccess VARCHAR(3)
);

CREATE TABLE Energy_Providers (
    ProviderID INT PRIMARY KEY,
    ProviderName VARCHAR(100),
    ProviderType VARCHAR(50)
);

CREATE TABLE Energy_Projects (
    ProjectID INT PRIMARY KEY,
    RegionID INT,
    ProviderID INT,
    ProjectType VARCHAR(50),
    Capacity INT,
    InstallationDate DATE,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID),
    FOREIGN KEY (ProviderID) REFERENCES Energy_Providers(ProviderID)
);

CREATE TABLE Energy_Consumption (
    ConsumptionID INT PRIMARY KEY,
    RegionID INT,
    ConsumptionDate DATE,
    EnergyConsumed INT,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
);

CREATE TABLE Costs (
    CostID INT PRIMARY KEY,
    ProjectID INT,
    InstallationCost DECIMAL(10, 2),
    MaintenanceCost DECIMAL(10, 2),
    EnergyProductionCost DECIMAL(10, 2),
    FOREIGN KEY (ProjectID) REFERENCES Energy_Projects(ProjectID)
);


-- SAMPLE DATA
INSERT INTO Regions (RegionID, RegionName, Population, GridAccess)
VALUES (1, 'Mountain Village', 5000, 'No'),
       (2, 'Rural Plains', 10000, 'Yes'),
       (3, 'Coastal City', 30000, 'Yes');

INSERT INTO Energy_Providers (ProviderID, ProviderName, ProviderType)
VALUES (1, 'SolarPowerCo', 'Solar'),
       (2, 'WindEnergyInc', 'Wind');

INSERT INTO Energy_Projects (ProjectID, RegionID, ProviderID, ProjectType, Capacity, InstallationDate)
VALUES (1, 1, 1, 'Solar', 50, '2024-01-15'),
       (2, 2, 2, 'Wind', 150, '2023-08-20');

INSERT INTO Energy_Consumption (ConsumptionID, RegionID, ConsumptionDate, EnergyConsumed)
VALUES (1, 1, '2024-02-01', 300),
       (2, 2, '2024-02-01', 500);

INSERT INTO Costs (CostID, ProjectID, InstallationCost, MaintenanceCost, EnergyProductionCost)
VALUES (1, 1, 20000, 1000, 0.15),
       (2, 2, 50000, 2000, 0.10);



-- SQL QUERIES
-- Energy projects in regions with no grid access:
SELECT R.RegionName, P.ProviderName, E.ProjectType, E.Capacity, E.InstallationDate
FROM Energy_Projects E
JOIN Regions R ON E.RegionID = R.RegionID
JOIN Energy_Providers P ON E.ProviderID = P.ProviderID
WHERE R.GridAccess = 'No';

-- Total energy consumption by region:
SELECT R.RegionName, SUM(C.EnergyConsumed) AS TotalConsumption
FROM Energy_Consumption C
JOIN Regions R ON C.RegionID = R.RegionID
GROUP BY R.RegionName;

-- Energy Projects in Regions with Grid Access
SELECT R.RegionName, P.ProviderName, E.ProjectType, E.Capacity, E.InstallationDate
FROM Energy_Projects E
JOIN Regions R ON E.RegionID = R.RegionID
JOIN Energy_Providers P ON E.ProviderID = P.ProviderID
WHERE R.GridAccess = 'Yes';

-- Average Energy Consumption per Region
SELECT R.RegionName, AVG(C.EnergyConsumed) AS AverageConsumption
FROM Energy_Consumption C
JOIN Regions R ON C.RegionID = R.RegionID
GROUP BY R.RegionName;

-- Total Costs for Each Energy Project (Installation + Maintenance + Production Cost):
SELECT E.ProjectID, R.RegionName, P.ProviderName, E.ProjectType, 
       (C.InstallationCost + C.MaintenanceCost + (E.Capacity * C.EnergyProductionCost)) AS TotalCost
FROM Energy_Projects E
JOIN Regions R ON E.RegionID = R.RegionID
JOIN Energy_Providers P ON E.ProviderID = P.ProviderID
JOIN Costs C ON E.ProjectID = C.ProjectID;

