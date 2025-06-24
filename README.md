# Project ChronoLogic

## Content
1. [Overview](#1-overview)
2. [Requirements Definition](#2-requirements-definition)
3. [System Design](#3-system-design)
4. [Testing & Validation](#4-testing--validation)
5. [Improvements](#5-improvements)

## 1. Overview

This project was carried out as part of a junior-year course assignment in the Department of Computer Engineering at Hanbat National University, and was entirely researched and developed individually.
The main objective is to implement a hardware-based alarm clock system using Verilog HDL.

Beyond the basic alarm functionality, the system introduces an interactive feature where the user must press a button a certain number of times to deactivate the alarm, encouraging a more active response compared to conventional alarm systems.

Key components include an FND (Flexible Numeric Display) array for time display, a piezo buzzer for melody playback, and logic circuits for time comparison and alarm cancellation. The project was fully implemented on an FPGA board, achieving a complete hardware-level realization.

Rather than targeting a specific user group or commercial application, the purpose of this project is to deepen understanding of digital logic design and practice real-world hardware control using Verilog-based development.

## 2. Requirements Definition

### · Functional Requirements

1. The system shall provide a clock function.
2. The system shall provide an alarm function.
3. The system shall play a melody using piezo buzzer when the alarm time is reached.
4. The system shall require a mission to be completed in order to deactivate the alarm.
5. The system shall allow the user to switch between clock mode and alarm mode.
6. The system shall allow the user to view the current time.
7. The system shall allow the user to set the initial current time.
8. The system shall allow the user to deactivate the alarm.

### · Non-functional Requirements

1. The system shall operate in real-time.
2. The system shall operate with low power consumption.
3. The user interface shall be intuitive and easy to use.
4. The system shall maintain stable operation for extended periods.

### · Use Case

| 항목 | 내용  |
| --- | --- |
| **Use Case Name** | Operate Alarm Clock System |
| **Actor** | User |
| **Description** | The user interacts with the alarm clock system to view and set the current time, configure an alarm, and deactivate the alarm by completing a mission. The system functions in real time with intuitive controls. |
| **Preconditions** | - The system is powered on and initialized<br>- The user has access to input controls (e.g., buttons or switches) |
| **Postconditions** | - Time is correctly displayed and updated<br>- Alarms are set and triggered properly<br>- The alarm is deactivated upon mission |

#### ✅ Main Flow (Basic Scenario)

1. The user powers on the system.
2. The system displays the current time on the FND.
3. The user switches to "alarm mode".
4. The user sets the desired alarm time.
5. The system stores the alarm time and switches back to clock mode.
6. The system continuously compares current time with alarm time (real-time operation).
7. When the alarm time is reached:
    - The system activates the piezo buzzer to play a melody.
    - The system requires the user to complete a mission (e.g., pressing a button multiple times).
8. The user performs the mission.
9. Upon successful mission completion, the system deactivates the alarm and returns to normal clock mode.

## 3. System Design

### · System Architecture

![clock_architecture](./Attached_files/architecture.png)

1. WATCH.v : Top-level module
2. WATCH_SEP.v
    1. H_SEP.v : Unit division of hour
    2. M_SEP.v : Unit division of minute
    3. S_SEP.v : Unit division of second
3. WATCH_CLCD_DISP.v : Display time and alarm message on Character LCD
4. SET_TIME.v : Toggle alarm setting mode (Enable/Disable)
5. PUT_ALARM_SET.v : Configure alarm for the specified time
6. PIEZO_OUT.v : Piezo Buzzer for melody playback
7. DISP_REMAIN_COUNT.v : Display remaining attempts to deactivate the alarm
8. CHECK_TIME.v : Compare the current time with the configured alarm time
9. CANCEL_ALARM.v : Cancel the configured alarm time
10. ALARM_FND.v : Display alarm time currently being set with FND Array
11. ALARM_DISABLE.v : Control function to deactivate the alarm

### · Stack

 <!-- Verilog HDL -->
![verilog hdl](https://img.shields.io/badge/Verilog_HDL-90EE90?style=flat-square&logo=StackOverflow&logoColor=black)

## 4. Testing & Validation

The system was tested using FPGA equipment provided by the Hanbat National University.
Key test scenarios included:

- Verifying that the Character LCD correctly displays the current time in clock mode.
- Ensuring the alarm triggers at the configured time and plays the melody.
- Confirming that the alarm is deactivated only after pressing the button 10 times.
- Checking mode switching between clock and alarm modes.

All test cases passed under normal operating conditions, and the system remained stable during extended operation.

## 5. Improvements

- Multiple Alarm Configurations
- Multiple Alarms Configuration
- Multiple Types of Alarm Deactivation Missions

## 6. Conclusion

The ChronoLogic project successfully demonstrates the implementation of a hardware-based alarm clock system, utilizing Verilog HDL and an FPGA platform. The system achieved its primary objective of providing a functional alarm clock with an interactive element, where users must engage actively to deactivate the alarm, moving beyond traditional alarm clock designs.

The design features a real-time clock display, an alarm trigger mechanism, and a mission-based alarm deactivation process, providing a more engaging user experience. The integration of an FND array, piezo buzzer, and multiple logic circuits on the FPGA board effectively met all the functional and non-functional requirements, while offering valuable insights into hardware-level control and digital logic design.

Through rigorous testing, the system was validated for its core functionalities, including time display, alarm activation, and mission-based deactivation. The stable performance during prolonged use confirmed the system's robustness and reliability. Additionally, the project successfully demonstrated the ease of switching between modes, such as clock and alarm settings, providing users with intuitive control.

This project not only helped to deepen the understanding of Verilog-based design but also highlighted the importance of system architecture and real-time functionality in embedded hardware systems. It stands as a foundational step toward more complex projects involving FPGA-based hardware design and embedded systems development.

The lessons learned from this project can be applied to future endeavors in digital logic design, particularly in areas where real-time operations and user interaction are key components. Going forward, improvements can be made by integrating more advanced features like wireless connectivity, personalized alarm sounds, and energy optimization strategies for portable devices.