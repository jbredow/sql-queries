CREATE TABLE PRICE_MGMT.BLENDED_DIRECTORS (
  "DISTRICT_ID" VARCHAR2 ( 4 CHAR ),
  "ACCOUNT_NUMBER_NK" INTEGER,
  "ALIAS_NAME" VARCHAR2 ( 20 CHAR ),
  "PRICE_CONTACT" VARCHAR2 ( 40 CHAR ),
  "DISTRICT_MGR" VARCHAR2 ( 20 CHAR ),
  "DIR_BRANCH_MGMT" VARCHAR2 ( 20 CHAR ),
  "DIR_COMM" VARCHAR2 ( 20 CHAR ),
  "DIR_RES_SHRM_BLDR" VARCHAR2 ( 20 CHAR ),
  "DIR_RES_TRADE" VARCHAR2 ( 20 CHAR ),
  "DIR_HVAC" VARCHAR2 ( 20 CHAR ),
  "DIR_INDUSTRIAL" VARCHAR2 ( 20 CHAR )
);

INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D01', '1350', 'SOCAL', 'Mike Vaughn', 'Ron Kern', 'Randy Cross', 'David Luman', 'Keith Hammond', 'Gary Grosslight', '', 'Chris Lang');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D01', '3014', 'HONOLULU', 'Brian Brown', 'Ron Kern', 'Randy Cross', 'David Luman', 'Keith Hammond', 'Gary Grosslight', '', 'Chris Lang');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D02', '1001', 'SOUTHWEST', 'Kimberly Roberts', 'Marty Young', 'Eric Wilber', 'Jeff Day', 'Chris Norris', 'Matt Di Santo', '', 'Jimmy Armentrout');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D03', '686', 'NORCAL', 'James Heupel', 'Keith Hubbard', 'Stewart Escalle', 'Rich Butler', 'Greg Lourence', 'Paul Mazzei', '', 'Kevin Finn');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D03', '2504', 'CALSTEAM', 'James Heupel', 'Keith Hubbard', 'Stewart Escalle', 'Rich Butler', 'Greg Lourence', 'Paul Mazzei', '', 'Kevin Finn');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D04', '3007', 'NORTHWEST', 'Garth Leatham', 'Steve Johnson', 'Gregg Burback', 'Jason Stevens', 'Chris Hoag', 'Brandon Emineth', '', 'Ty Baker');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D04', '3017', 'ANCHORAGE', 'Dylan Lish', 'Steve Johnson', 'Gregg Burback', 'Jason Stevens', 'Chris Hoag', 'Brandon Emineth', '', 'Ty Baker');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D05', '109', 'ROCKIES', 'Jason Goettsch', 'Chris Cline', 'Matt McGuire', 'Greg Foutz', 'Zac Frank', 'Corey Newton', '', 'Marc Brown');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D10', '1657', 'UPPER_MIDWEST', '', 'Mike Draper', 'Chris Nichol', 'Dean Widenski', 'Chris Navarra', 'Alex Nahvi', 'Michael Honnoll', 'Rick Riermann');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D11', '1550', 'CENTRAL_MIDWEST', 'Chris Held / Jim Munch', 'Brian Dombrowicki', 'Steve Speers', 'Jim Kuenn', 'Drew Guenther', 'Steve Mangels', '', 'Bill Harrison');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D12', '1480', 'OHVAL', 'Kevin Johnson / Scott Willoughby', 'Victor Hernandez', 'David Wilkinson', '', 'Clark Cutshaw', 'Kristin Hogan', '', 'Marty Kaiser');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D14', '2000', 'GREAT_LAKES', 'PJ LaRose', 'Casey Bradley', '', 'John Wheatley', 'Mike McColgan', 'Brad Kozel', 'Brad Kozel', 'John Wheatley');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D30', '20', 'MID_SOUTH', 'Andy Ethridge', 'Jeff Hargis', 'Kyle Grose', 'Jamie Morgan Jr', 'Noland Noffsinger', 'Rich Gardner', 'Doug Reichert', 'Derek Goodwin');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D31', '61', 'TEXAS', 'Derrick Seidenberg / Jeff Nelson', 'Gregg Turner', 'Chris Couvillion', 'Trey Hale', 'Joey Babb', 'Tony Dixon', '', '');
INSERT INTO PRICE_MGMT.BLENDED_DIRECTORS VALUES ('D32', '215', 'SOUTHERN_PLAINS', 'Andrew Robison / Mike Llewellyn', 'Scott Rayburn', 'James Reid', 'Micah Harris', 'Allen Gregory', '', 'Jeremy Zellers', 'Ted Jones');

GRANT SELECT ON PRICE_MGMT.BLENDED_DIRECTORS TO PUBLIC;