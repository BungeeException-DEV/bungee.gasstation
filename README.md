# bungee.gasstation

# Bungee Gas Station Script

## Overview

The `bungee.gasstation` script is a custom ESX script for FiveM that allows players to refuel their vehicles at gas stations. The script supports both manual refueling and full refueling, offering an intuitive HUD interface for selecting the payment method and displaying the refueling progress.

## Features

- **Manual Refueling:** Players can refuel a specific amount of fuel based on the selected price and quantity.
- **Full Refuel:** Players can fill their vehicle’s tank to 100% with a single click.
- **Payment Methods:** Players can choose between cash and card payment.
- **Progress Display:** The refueling progress is displayed as a percentage above the vehicle during the refueling process.
- **Refueling Animation:** An appropriate animation is played during the refueling process.
- **Gas Station Blips:** All gas stations on the map are marked with blips.

## Installation

1. **Download the Script:**
   - Download the `bungee.gasstation` script and extract it into your `resources` folder.

2. **Database Integration:**
   - Ensure that your ESX database is correctly configured and that `oxmysql` or another compatible MySQL solution is in use.

3. **Configure the Script:**
   - Open the `config.lua` file and customize the settings to your preference. You can define gas stations, prices, and more.

4. **Server CFG:**
   - Add `start bungee.gasstation` to your `server.cfg` to load the script on server start.

5. **Restart the Server:**
   - Restart your FiveM server to activate the script.

## Configuration

### config.lua

```lua
Config = {}

-- Gas Station Coordinates
Config.GasStations = {
    vector3(49.4187, 2778.793, 58.043),
    vector3(263.894, 2606.463, 44.983),
    vector3(1039.958, 2671.134, 39.550),
    vector3(1207.260, 2660.175, 37.899),
    vector3(2539.685, 2594.192, 37.944),
    vector3(2679.858, 3263.946, 55.240),
    vector3(2005.055, 3773.887, 32.403),
    vector3(1687.156, 4929.392, 42.078),
    vector3(1701.314, 6416.028, 32.763),
    vector3(179.857, 6602.839, 31.868),
    vector3(-94.4619, 6419.594, 31.489),
    vector3(-2554.996, 2334.40, 33.078),
    vector3(-1800.375, 803.661, 138.651),
    vector3(-1437.622, -276.747, 46.207),
    vector3(-2096.243, -320.286, 13.168),
    vector3(-724.619, -935.1631, 19.213),
    vector3(-526.019, -1211.003, 18.184),
    vector3(-70.2148, -1761.792, 29.534),
    vector3(265.648, -1261.309, 29.292),
    vector3(819.653, -1028.846, 26.403),
    vector3(1208.951, -1402.567,35.224),
    vector3(1181.381, -330.847, 69.316),
    vector3(620.843, 269.100, 103.089),
    vector3(2581.321, 362.039, 108.468),
    vector3(176.631, -1562.025, 29.263),
    vector3(-319.292, -1471.715, 30.549),
    vector3(1784.324, 3330.55, 41.253)
}

-- Fuel Prices
Config.FuelPrice = {
    min = 2.5,
    max = 3.5
}

-- Pump Models
Config.PumpModels = {
    [-2007231801] = true,
    [1339433404] = true,
    [1694452750] = true,
    [1933174915] = true,
    [-462817101] = true,
    [-469694731] = true,
    [-164877493] = true
}
```

Exports

# Example:
```lua
exports["bungee.gasstation"]:SetFuel(vehicle, 50)
```

# Example:
```lua
local fuelLevel = exports["bungee.gasstation"]:GetFuel(vehicle)
```

# Dependencies
ESX: This script requires the ESX framework.
oxmysql: Make sure that oxmysql is installed and configured for database connectivity.

# Usage
-Visit Gas Stations: Drive to one of the configured gas stations on the map.
-Refuel: Exit your vehicle, approach the pump, and press E to start refueling.
-Select Payment Method: Choose a payment method in the HUD and decide whether to refuel a specific amount or fill the tank completely.
-Monitor Progress: Watch the refueling progress above your vehicle.
