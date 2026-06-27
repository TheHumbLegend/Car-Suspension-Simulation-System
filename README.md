# Car Suspension System Simulation

A MATLAB/Simulink project modelling and analysing quarter-car and whole-axle suspension systems. Completed as part of a Year 1 Physical Systems module.

---

## Project Overview

This project simulates the dynamic behaviour of a car suspension system under various conditions, comparing **Sport** and **Cruise** modes across four tasks:

| Task | Description |
|------|-------------|
| Task 1 | Quarter-car suspension step response — rise time, overshoot, settling time |
| Task 2 | Adding a saturation block to limit suspension travel to ±2 cm |
| Task 3 | Parameter sweep over damping (C2) and stiffness (K2) to find optimal values |
| Task 4 | Whole-axle validation using a realistic road profile (RMSE & MAE analysis) |

---

## System Parameters

| Parameter | Symbol | Value |
|-----------|--------|-------|
| Unsprung mass (wheel/axle) | M1 | 50 kg |
| Sprung mass (chassis) | M2 | 250 kg |
| Seat + driver mass | M3 | 100 kg |
| Tyre stiffness | K3 | 120,000 N/m |
| Seat stiffness | K1 | 2,200 N/m |
| Tyre damping | C1 | 700 Ns/m |
| Seat damping | C3 | 300 Ns/m |

### Mode-Specific Parameters

| Parameter | Sport Mode | Cruise Mode |
|-----------|-----------|-------------|
| K2 (suspension stiffness) | 13,000 N/m | 8,000 N/m |
| C2 (suspension damping) | 1,500 Ns/m | 900 Ns/m |

---

## Key Results

### Task 1 — Step Response

| Metric | Sport | Cruise |
|--------|-------|--------|
| Rise Time | 0.187 s | 0.233 s |
| Overshoot | 49.2% | 56.2% |
| Settling Time (2%) | 1.975 s | 3.139 s |
| Settling Time (5%) | 1.409 s | 2.351 s |

Sport mode responds faster due to higher K2; cruise mode has more overshoot due to lower C2.

### Task 3 — Optimal Parameters

Target: overshoot < 72%, settling time < 0.25 s

**Optimal: C2 = 6000 Ns/m, K2 = 30,000 N/m**
- Overshoot: 67.0%
- Settling Time: 0.192 s

### Task 4 — Road Profile Validation (RMSE & MAE)

- **RMSE** measures how closely wheel displacement tracks the road profile (traction)
- **MAE** measures the difference between left and right wheel response (horizontal stability)
- Cruise mode produces lower RMSE and MAE — better traction and stability
- Sport mode produces higher values — prioritises handling responsiveness over comfort

---

## File Structure

```
├── task1.m                          # Quarter-car step response simulation
├── task4.m                          # Whole-axle road profile validation
├── roadprofiletimeseries.m          # Converts road profile data to timeseries
├── car_suspension_absolutedisplacements.slx   # Simulink model (Tasks 1-3)
├── Whole_Axle_Suspension_Model.slx  # Simulink model (Task 4)
├── roadProfile.mat                  # Raw road profile data (left & right)
├── roadProfile_ts.mat               # Timeseries road profile data
└── README.md
```

---

## How to Run

### Prerequisites
- MATLAB R2021a or later
- Simulink

### Task 1
```matlab
run('task1.m')
% Enter 'sport' or 'cruise' when prompted
```

### Task 4
```matlab
% First generate the timeseries road profile (if not already done):
run('roadprofiletimeseries.m')

% Then run the validation:
run('task4.m')
% Enter 'sport' or 'cruise' when prompted
```

---

## Notes

- The `.slx` Simulink models must be on your MATLAB path before running the scripts
- `roadProfile_ts.mat` is pre-generated but can be regenerated using `roadprofiletimeseries.m`
- Task 4 uses `Simulink.SimulationInput` for cleaner parameter passing

---

## Author

**Rotimi Dayo** #
