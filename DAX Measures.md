# DAX Measures for Power-BI Dashboard

#### Characteristics Groups:

Industry Group =

SWITCH(
    TRUE(),
    CONTAINSSTRING(supply_chain_data[Characteristics], "Agriculture, forestry, fishing and hunting"), "Primary Resources",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Mining, quarrying, and oil and gas extraction"), "Primary Resources",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Construction"), "Construction & Manufacturing",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Manufacturing"), "Construction & Manufacturing",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Wholesale trade"), "Trade & Logistics",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Retail trade"), "Trade & Logistics",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Transportation and warehousing"), "Trade & Logistics",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Information and cultural industries"), "Services",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Finance and insurance"), "Financial Services",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Real estate and rental and leasing"), "Services",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Professional, scientific and technical services"), "Professional Services",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Administrative and support"), "Services",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Health care and social assistance"), "Healthcare & Social",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Arts, entertainment and recreation"), "Entertainment & Hospitality",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Accommodation and food services"), "Entertainment & Hospitality",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Other services"), "Other Services",
    "Not Industry Specific"
)

---

Business Size =

SWITCH(
    TRUE(),
    CONTAINSSTRING(supply_chain_data[Characteristics], "1 to 4 employees"), "Micro (1-4)",
    CONTAINSSTRING(supply_chain_data[Characteristics], "5 to 19 employees"), "Small (5-19)",
    CONTAINSSTRING(supply_chain_data[Characteristics], "20 to 99 employees"), "Medium (20-99)",
    CONTAINSSTRING(supply_chain_data[Characteristics], "100 or more employees"), "Large (100+)",
    "Size Not Specified"
)

---

Business Age Group =

SWITCH(
    TRUE(),
    CONTAINSSTRING(supply_chain_data[Characteristics], "2 years or less"), "Startup (≤2 years)",
    CONTAINSSTRING(supply_chain_data[Characteristics], "3 to 10 years old"), "Young (3-10 years)",
    CONTAINSSTRING(supply_chain_data[Characteristics], "11 to 20 years old"), "Mature (11-20 years)",
    CONTAINSSTRING(supply_chain_data[Characteristics], "more than 20 years old"), "Established (20+ years)",
    "Age Not Specified"
)

---

Ownership Type =

SWITCH(
    TRUE(),
    CONTAINSSTRING(supply_chain_data[Characteristics], "Majority ownership, woman"), "Women-Owned",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Majority ownership, First Nations"), "Indigenous-Owned",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Majority ownership, immigrant"), "Immigrant-Owned",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Majority ownership, visible minority"), "Visible Minority-Owned",
    CONTAINSSTRING(supply_chain_data[Characteristics], "Majority ownership, person with a disability"), "Disability-Owned",
    "Standard Ownership"
)

---


#### Adjustment Groups:

Adjustment Category =

SWITCH(
    TRUE(),
    supply_chain_data[Adjustments] = "Relocate supply chain activities to Canada", "Domestic Relocation",
    supply_chain_data[Adjustments] = "Relocate supply chain activities outside of Canada", "International Relocation",
    supply_chain_data[Adjustments] = "Shift to local suppliers", "Local Sourcing",
    supply_chain_data[Adjustments] = "Substitute inputs, products or supplies with alternate inputs, products or supplies", "Input Substitution",
    supply_chain_data[Adjustments] = "Partner with new suppliers", "Supplier Diversification",
    supply_chain_data[Adjustments] = "Work with suppliers to improve timeliness", "Supplier Optimization",
    supply_chain_data[Adjustments] = "Implement technological improvements", "Technology Enhancement",
    supply_chain_data[Adjustments] = "Invest in research and development projects to identify alternate inputs, products, supplies, or production processes", "R&D Investment",
    supply_chain_data[Adjustments] = "Adjustments planned for supply chain, none", "No Adjustments",
    supply_chain_data[Adjustments] = "Adjustments planned for supply chain, unknown", "Unknown Plans",
    "Other Adjustments"
)

---


Region =

SWITCH(
    supply_chain_data[Provinces],
    "Newfoundland and Labrador", "Atlantic",
    "Prince Edward Island", "Atlantic",
    "Nova Scotia", "Atlantic",
    "New Brunswick", "Atlantic",
    "Quebec", "Central",
    "Ontario", "Central",
    "Manitoba", "Western",
    "Saskatchewan", "Western",
    "Alberta", "Western",
    "British Columbia", "Western",
    "Yukon", "Territories",
    "Northwest Territories", "Territories",
    "Nunavut", "Territories",
    "Other"
)

---

#### Calculated Columns:


Average Adjustment Rate =
AVERAGE(supply_chain_data[Values])

---

Data Coverage Gap % = 100 - [Data Reliability %]

---

Data Reliability % =
DIVIDE([Reliable Data Points], COUNTROWS(supply_chain_data), 0) * 100

---

Offshoring Rate =
([Average Adjustment Rate] * 0.4) +
(CALCULATE(AVERAGE(supply_chain_data[Values]), supply_chain_data[Adjustment Category] = "International Relocation") * 0.6)


---


Industry Priority Score =

SUMX(
    supply_chain_data,
    SWITCH(
        supply_chain_data[Industry Group],
        "Primary Resources", supply_chain_data[Values] * 1.5,
        "Construction & Manufacturing", supply_chain_data[Values] * 1.3,
        "Trade & Logistics", supply_chain_data[Values] * 1.4,
        "Services", supply_chain_data[Values] * 1.0,
        "Financial Services", supply_chain_data[Values] * 1.2,
        "Professional Services", supply_chain_data[Values] * 1.1,
        "Healthcare & Social", supply_chain_data[Values] * 1.3,
        "Entertainment & Hospitality", supply_chain_data[Values] * 0.9,
        "Other Services", supply_chain_data[Values] * 1.0,
        "Not Industry Specific", supply_chain_data[Values] * 1.0,
        supply_chain_data[Values] * 1.0
    )
) / COUNTROWS(supply_chain_data)


---


Risk Indicators =

VAR NegativeRate =
   CALCULATE(
       AVERAGE(supply_chain_data[Values]),
       supply_chain_data[Adjustment Category] IN {
           "No Adjustments",
           "Unknown Plans",
           "International Relocation"
       }
   )
VAR PendingRate =
   CALCULATE(
       AVERAGE(supply_chain_data[Values]),
       supply_chain_data[Adjustment Category] IN {
           "Input Substitution",
           "Supplier Diversification",
           "Supplier Optimization",
           "Technology Enhancement",
           "R&D Investment"
       }
   )
VAR PositiveRate =
   CALCULATE(
       AVERAGE(supply_chain_data[Values]),
       supply_chain_data[Adjustment Category] IN {
           "Domestic Relocation",
           "Local Sourcing"
       }
   )
VAR DeficitRate =
   CALCULATE(
       AVERAGE(supply_chain_data[Values]),
       supply_chain_data[Adjustment Category] = "Other Adjustments"
   )
RETURN
(NegativeRate * 0.6) + (PendingRate * 0.2) - (PositiveRate * 0.4) + (DeficitRate * 0.1)

