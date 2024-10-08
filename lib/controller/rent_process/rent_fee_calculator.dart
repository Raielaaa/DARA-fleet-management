class RentFeeCalculator {
  // Function to calculate the delivery fee
  static double calculateDeliveryFee(double deliveryDistance) {
    double baseDeliveryFee = 300;
    double distanceIncrement = 0;

    int stepSize = 15; // Every 15km increases the fee
    int baseIncrement = 50; // Each step increases the fee by 50

    // Calculate the step based on delivery distance
    int step = (deliveryDistance / stepSize).ceil() - 1; // Start counting from 0 for <15km

    // Calculate the distance increment based on the step (no clamping, so unlimited steps)
    distanceIncrement = baseIncrement * (step + 1);

    return baseDeliveryFee + distanceIncrement;
  }

  // Function to calculate the mileage fee
  static double calculateMileageFee(double totalDistanceTravelled) {
    double baseMileageFee = 500;
    double mileageFee = 0;

    // Define step size and increment amount
    int stepSize = 75; // Every 75 km, the fee increases
    int baseIncrement = 500; // Increment starts at 500 and increases by 500 for each step

    // Calculate which step the total distance traveled falls into
    int step = ((totalDistanceTravelled - 76) / stepSize).ceil(); // Starts counting from 76km

    // If distance is less than 76km, no mileage fee
    if (totalDistanceTravelled < 76) {
      return 0;
    }

    // Calculate the mileage fee based on the step (no clamping, so the fee can go beyond 300km)
    mileageFee = baseMileageFee + (step * baseIncrement);

    return mileageFee;
  }

  // Function to calculate the rental fee (as before)
  static double calculateRentalFee(String vehicleType, int rentalMinutes) {
    double ratePer12hrs = 0;
    double ratePer24hrs = 0;

    // Assign rates based on vehicle type
    if (vehicleType.toLowerCase() == "sedan") {
      ratePer12hrs = 1500;
      ratePer24hrs = 2000;
    } else if (vehicleType.toLowerCase() == "suv") {
      ratePer12hrs = 2500;
      ratePer24hrs = 3000;
    } else {
      throw Exception('Invalid vehicle type. Please choose either Sedan or SUV.');
    }

    double rentalFee = 0;

    // Convert minutes to hours for easier calculations
    double rentalHours = rentalMinutes / 60.0;

    // Calculate based on hours or days
    if (rentalHours <= 12) {
      rentalFee = ratePer12hrs; // 12-hour rate
    } else if (rentalHours > 12 && rentalHours <= 24) {
      rentalFee = ratePer24hrs; // 24-hour rate
    } else {
      int rentalDays = (rentalHours / 24).ceil(); // Convert hours to full days

      // Calculate the total fee based on rental days and apply discounts
      if (rentalDays == 2) {
        rentalFee = 2 * ratePer24hrs * (1 - 0.10); // 10% discount
      } else if (rentalDays == 3) {
        rentalFee = 3 * ratePer24hrs * (1 - 0.25); // 25% discount
      } else if (rentalDays >= 4 && rentalDays <= 7) {
        rentalFee = rentalDays * ratePer24hrs * (1 - 0.30); // 30% discount
      } else if (rentalDays >= 8) {
        rentalFee = rentalDays * ratePer24hrs * (1 - 0.35); // 35% discount capped
      }
    }

    return rentalFee;
  }

  // Separate function to calculate the driver fee
  static double calculateDriverFee(int rentalMinutes) {
    int rentalDays = (rentalMinutes / 1440).ceil(); // Convert rental minutes to full days
    return rentalDays * 700; // 1000 per day for the driver
  }

  // Main function to calculate the total fees
  static double calculateTotalFee({
    required String vehicleType,
    required int rentalMinutes,
    required bool isDelivery,
    required double deliveryDistance,
    required double totalDistanceTravelled,
    bool withDriver = false,
  }) {
    // Step 1: Calculate the rental fee
    double rentalFee = calculateRentalFee(vehicleType, rentalMinutes);

    // Step 2: Calculate the mileage fee
    double mileageFee = calculateMileageFee(totalDistanceTravelled);

    // Step 3: Calculate the delivery fee (if applicable)
    double deliveryFee = isDelivery ? calculateDeliveryFee(deliveryDistance) : 0;

    // Step 4: Calculate the driver fee (if applicable)
    double driverFee = withDriver ? calculateDriverFee(rentalMinutes) : 0;

    // Step 5: Calculate the total fee
    double totalFee = rentalFee + mileageFee + deliveryFee + driverFee;

    return totalFee;
  }
}
