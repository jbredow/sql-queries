DROP TABLE AAA6863.CUSTOMER_TYPES;

CREATE TABLE AAA6863.CUSTOMER_TYPES
	(
	CUSTOMER_TYPE VARCHAR(20),
	C_TYPE_DESC VARCHAR(55),
	C_TYPE_GROUPING VARCHAR(55)
	)
;

INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('B_COMMER', 'COMMERCIAL CONSTRUCTION', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('B_INDUS', 'INDUSTRIAL CONSTRUCTION', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_CARPENTRY', 'CARPENTRY WORK (INCLUDING CABINETS}', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_CONCRETE', 'CONCRETE WORK CONTRACTORS', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_ELECTRIC', 'ELECTRICAL', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_ENERGY', 'ENERGY MANAGEMENT CONTRACTORS', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_ENVIRON', 'ENVIRONMENTAL CONSULTANT CONTRACTORS', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_HANDYMAN', 'HANDYMAN', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_MASON', 'MASONRY AND OTHER STONEWORK', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_PLASTER', 'PLASTERING, DRYWALL AND INSULATION', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_POOL', 'POOL CONTRACTOR', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_ROOFING', 'ROOFING AND SIDING CONTRACTORS', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_STRUCTRL', 'STRUCTURAL STEEL ERECTION CONTRACTORS', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_SURFACING', 'SURFACING AND PAVING CONTRACTORS', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_WATERPRF', 'WATER PROOFING', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_WRECKING', 'WRECKING AND DEMOLITION WORK CONTRACTORS', 'ASSOCIATED CONTRACTOR');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('B_MULTI', 'HOTEL/MOTEL, MULTI-FAMILY CONSTRUCTION', 'BUILDER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('B_PREFAB', 'PRE FABRICATED HOUSING AND COMPONENTS', 'BUILDER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('B_SGLNEW', 'SINGLE FAMILY CONSTRUCTION (NEW)', 'BUILDER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('B_SGLREMDL', 'SINGLE FAMILY CONSTRUCTION (REMODEL)', 'BUILDER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_CHURCH', 'CHURCHES', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_COMMPROP', 'COMMERCIAL PROPERTY MANAGEMENT', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_EDUCATION', 'SCHOOLS, UNIVERSITIES, COLLEGES', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_HEALTH_PRIV', 'PRIVATE HLTH SRVCS HOSPITAL NURSING HOME DR OFFICE', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_REALEST', 'REAL ESTATE COMPANIES', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_RESPROP', 'RESIDENTIAL PROPERTY MANAGEMENT', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_RENOV_HOTEL', 'HOSPITALITY RENOVATION CONTRACTOR', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_RENOV_MULFAM', 'MULTI-FAMILY RENOVATION CONTRACTOR', 'FACILITIES MANAGEMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('M_FIRE', 'FIRE SPRINKLER CONTRACTOR', 'FIRE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('M_FIRE_FAB', 'FIRE SPRINKLER FABRICATION', 'FIRE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_AGENT', 'GOVERNMENT CONTRACTOR - FEDERAL, STATE, OR LOCAL', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_ARRA', 'GOVERNMENT STIMULUS FUNDS CUSTOMER', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_CMAS', 'GSA SCHEDULE PURCHASES CA STATE', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_DISREC', 'DISASTER RECOVERY USING GOVT FUNDS', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_FEDERAL', 'FEDERAL GOVERNMENT AGENCY', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_HEALTH', 'FED STATE LOCAL HOSPITAL HEALTH INSTITUTION', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_LOCAL', 'LOCAL GOVERNMENT AGENCY', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_STATE', 'STATE GOVERNMENT AGENCY', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('GOVT_TXMAS', 'GSA SCHEDULE PURCHASES TX STATE', 'GOVERNMENT');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_HOTEL', 'HOTEL AND ROOMING HOUSES', 'HOSPITALITY');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_BOILERFRN', 'BOILER AND FURNACE CONTRACTORS', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_HVACAORRNC', 'HEAVY IN AOR, LIGHT IN RNC', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_HVACCON', 'HVAC CONTRACTOR', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_HVACDANDLR', 'DAY AND NIGHT DEALERS', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_HVACPROSPECT', 'HVAC NEW PROSPECTS', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_HVACRNCAOR', 'HEAVY IN RNC, LIGHT IN AOR', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_HVACTCSDLR', 'TCS DEALERS', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_REFRIG', 'REFRIGERATION CONTRACTOR', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_SOLARENR', 'SOLAR ENERGY CONTRACTOR', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_VENTDUCT', 'VENTILATION AND DUCT CONTRACTOR', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('H_WARMAC', 'WARM AIR HEATING AND AC CONTRACTOR', 'HVAC');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_COMMACHIN', 'INDUSTRIAL/COMMERCIAL MACHINARY, COMPUTER EQUIP', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_DURABLE', 'MANUFACTURED DURABLE GOODS', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_FABRICATE', 'FABRICATED METAL PRODUCTS, EXCEPT MACHINARY', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_FURNFIX', 'FURNITURE AND FIXTURES', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_MARINE', 'SHIP BUILDING AND MARINE SERVICES', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_PRIMRYMTL', 'PRIMARY METAL INDUSTRIES', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_RUBBER', 'RUBBER AND MISCELLANEOUS PLASTIC PRODUCTS', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_STONE', 'STONE, CLAY, GLASS AND CONCRETE PRODUCTS', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_PIPING', 'INDUSTRIAL PIPING', 'INDUSTRIAL MFG DURABLE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_PAPER', 'PAPER AND ALLIED PRODUCTS', 'INDUSTRIAL MFG MILL');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_TEXTILE', 'TEXTILE MILL PRODUCTS', 'INDUSTRIAL MFG MILL');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_APPAREL', 'APPAREL AND OTHER FABRIC PRODUCTS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_ELECTRON', 'ELECTRONIC EQUIP AND COMPONENTS, EXCEPT COMPUTERS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_FOOD', 'FOOD AND KINDRED PRODUCTS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_MEASURING', 'MEASURING, ANALYZING, AND CONTROLLING INSTRUMENTS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_MEDICAL', 'MEDICAL EQUIPMENT AND RELATED MEDICAL PRODUCTS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_NONDURABLE', 'MANUFACTURED NON-DURABLE GOODS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_PHARM', 'PHARMACEUTICALS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_PRINTING', 'PRINTING, PUBLISHING AND ALLIED INDUSTRIES', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_TOBACCO', 'TOBACCO PRODUCTS', 'INDUSTRIAL MFG PRECISION');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_COALMNG', 'COAL MINING', 'INDUSTRIAL NAT RESC AND MINING');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_LUMBER', 'LUMBER AND WOOD PRODUCTS, EXCEPT FURNITURE', 'INDUSTRIAL NAT RESC AND MINING');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_MNGNMT', 'MINING AND QUARRYING OF NONMETALLIC MINERALS', 'INDUSTRIAL NAT RESC AND MINING');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_MTLMINING', 'METAL MINING', 'INDUSTRIAL NAT RESC AND MINING');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_OILGASEX', 'OIL AND GAS EXTRACTION', 'INDUSTRIAL NAT RESC AND MINING');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_CHEMICALS', 'CHEMICALS AND ALLIED PRODUCTS', 'INDUSTRIAL PETRO AND CHEM');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_PETROLEUM', 'PETROLEUM REFINING AND RELATED INDUSTRIES', 'INDUSTRIAL PETRO AND CHEM');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_GASPOWER', 'GENERATION, GAS POWER', 'INDUSTRIAL POWER AND TRANS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_POWER', 'POWER GENERATION', 'INDUSTRIAL POWER AND TRANS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('I_TRANSPORT', 'TRANSPORTATION EQUIPMENT', 'INDUSTRIAL POWER AND TRANS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('N_OEMFABDOM', 'OEM FABRICATOR NUCLEAR DOMESTIC', 'INDUSTRIAL POWER AND TRANS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('N_OEMFABEXP', 'OEM FABRICATOR NUCLEAR EXPORT', 'INDUSTRIAL POWER AND TRANS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('N_OEMMACDOM', 'OEM MACHINE SHOP NUCLEAR DOMESTIC', 'INDUSTRIAL POWER AND TRANS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('N_OEMMACEXP', 'OEM MACHINE SHOP NUCLEAR EXPORT', 'INDUSTRIAL POWER AND TRANS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('E_EMPLOY', 'FERGUSON EMPLOYEE', 'INTERCOMPANY/COST');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('O_BRCHACCT', 'BRANCH ACCOUNTING', 'INTERCOMPANY/COST');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('O_INTRBRNCH', 'INTER BRANCH SALES', 'INTERCOMPANY/COST');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('S_ARCHITECT', 'ARCHITECTS', 'INTERIOR DESIGNER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('S_INTERIOR', 'INTERIOR DESIGNERS', 'INTERIOR DESIGNER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('R_KITCHBATH', 'KITCHEN AND BATH DEALER', 'K AND B DEALERS');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('M_COMMPLBG', 'COMMERCIAL PLUMBER', 'MECHANICAL');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('M_HYDRONICS', 'MECHANICAL BOILER - WET HEAT', 'MECHANICAL');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('M_MECH', 'MECHANICAL CONTRACTOR', 'MECHANICAL');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('M_PIPING', 'PROCESS PIPING CONTRACTOR', 'PIPING');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_PLBGHVAC', 'PLUMBING AND HVAC CONTRACTORS', 'PLUMBER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('P_PLBGCON_RANDR', 'PLUMBING CONTRACTOR - REPAIR AND REMODEL', 'PLUMBER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('P_PLUMBCON_NEW', 'PLUMBING CONTRACTOR - NEW WORK', 'PLUMBER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('E_ENDUSER', 'END USER', 'RETAIL');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('E_ETAILER', 'INTERNET RESELLER / E-TAILER', 'RETAIL');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('O_EXPORTER', 'EXPORTER', 'TRADE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('S_ENGINEERS', 'ENGINEERS', 'TRADE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_BUSINSER', 'BUSINESS SERVICES', 'TRADE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_FURNITURE', 'FURNITURE MANUFACTURERS', 'TRADE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_MISCRTL', 'MISCELLANEOUS RETAIL', 'TRADE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_RECREAT', 'RECREATION, AMUSEMENT, CAMPS', 'TRADE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('T_RESTURNT', 'RESTAURANT AND BAR BUSINESSES', 'TRADE');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('C_EXCAVAT', 'EXCAVATION WORK CONTRACTORS', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('O_FARM', 'FARM AND AGRICULTURAL PRODUCTS', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('P_IRRAG', 'IRRIGATION CONTRACTOR', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('P_SEPTIC', 'SEPTIC SYSTEM CONTRACTOR', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('P_WELLDRILL', 'WELL DRILLER CONTRACTOR', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_HVYMECH', 'HEAVY MECHANICAL CONTRACTOR', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_METER', 'PROCUREMENT IMPLEMENTATION MAINTENANCE OF METERS', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_NUCDOM', 'UTILITY PLANT DOMESTIC', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_NUCEXP', 'UTILITY PLANT EXPORT', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_PLANTCON', 'TREATMENT PLANT CONTRACTOR', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_PUBLCWRKS', 'MUNICIPALITY/WATER AUTHORITY', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_SITEWORK', 'SITE PREPARATION GRADING AND EXCAVATING', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_UTLTYCOM', 'UTILITY SITE CONTRACTOR - COMMERCIAL', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_UTLTYCON', 'UTILITY SITE CONTRACTOR - RES/COMMERCIAL', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_UTLTYPW', 'UTILITY SITE CONTRACTOR - PUBLIC WORKS', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_UTLTYRES', 'UTILITY SITE CONTRACTOR - RESIDENTIAL', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('U_WWOTHERS', 'MISCELLANEOUS WATERWORKS', 'UNDERGROUND');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('R_HMECNTR', 'RETAIL HOME CENTERS', 'WHOLESALER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('R_RTLHARD', 'RETAIL HARDWARE STORE', 'WHOLESALER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('R_WHOLEHARD', 'WHOLESALE HARDWARE', 'WHOLESALER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('R_WHOLEPH', 'WHOLESALE PLUMBING AND HEATING', 'WHOLESALER');
INSERT INTO AAA6863.CUSTOMER_TYPES VALUES ('R_BGKITCHBATH', 'BUYING GROUP - KITCHEN AND BATH DEALERS', 'WHOLESALER');

