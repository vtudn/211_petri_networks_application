# petri_networks_application

**SCENARIO**: Under a SARS pandemic where a huge lack of ICU beds occurs in city H, patients should consult specialists in the outpatient clinic of a hospital, we describe the course of business around a specialist in this outpatient clinic of hospital X as a process model, formally, we use Petri Network - a special place/transition system that operates to describe processes.

**PACKAGE DESCRIPTION**:

[ITEM 1] PATIENT NETWORK
1) MAX: 10 patients in place wait.
2) Only one patient being treated at a time.
3) The process will run until there is no patient left in the waiting room.

[ITEM 2] SPECIALIST NETWORK
1) MAX: 1 specialist on duty.
2) Only one patient being treated at a time.
3) The number of firing times will define the final display.

[ITEM 3] SUPERIMPOSED NETWORK
1) MAX: 10 patients in place wait and 1 specialist on duty.
2) Only one patient being treated at a time.
3) The process will run until there is no patient left in the waiting room.

[ITEM 4] CALCULATOR
