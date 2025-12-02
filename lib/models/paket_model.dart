class WorkoutMovement {
  final String name;       
  final String type;      
  final int amount;      

  WorkoutMovement({
    required this.name,
    required this.type,
    required this.amount,
  });
}

class WorkoutPackage {
  final String level;       // Noob, Pro, Hacker
  final List<WorkoutMovement> movements; // Daftar gerakan

  WorkoutPackage({
    required this.level,
    required this.movements,
  });
}

// ============================
// DATABASE LOKAL PAKET LATIHAN
// ============================

final List<WorkoutPackage> workoutPackages = [

  // ============================
  // 1. Paket Noob (Pemula)
  // ============================
  WorkoutPackage(
    level: "Noob",
    movements: [
      WorkoutMovement(name: "Forearm Plank", type: "detik", amount: 30),
      WorkoutMovement(name: "Crunches", type: "repetisi", amount: 12),
      WorkoutMovement(name: "Laying Leg Raises", type: "repetisi", amount: 12),
      WorkoutMovement(name: "Bicycle Crunch", type: "repetisi", amount: 12),
      WorkoutMovement(name: "Slow Tempo Mountain Climber", type: "repetisi", amount: 20),
      WorkoutMovement(name: "Cobra Stretch", type: "detik", amount: 30),
    ],
  ),

  // ============================
  // 2. Paket Pro (Menengah)
  // ============================
  WorkoutPackage(
    level: "Pro",
    movements: [
      WorkoutMovement(name: "Forearm Plank", type: "detik", amount: 30),
      WorkoutMovement(name: "Reverse Crunch", type: "repetisi", amount: 15),
      WorkoutMovement(name: "Bodyweight Russian Twist", type: "repetisi", amount: 20),
      WorkoutMovement(name: "Laying Leg Raises", type: "repetisi", amount: 12),
      WorkoutMovement(name: "Long Lever Plank", type: "detik", amount: 30),
      WorkoutMovement(name: "Bicycle Crunch", type: "repetisi", amount: 20),
      WorkoutMovement(name: "Child Pose Arms Extended", type: "detik", amount: 30),
    ],
  ),

  // ============================
  // 3. Paket Hacker (Lanjutan)
  // ============================
  WorkoutPackage(
    level: "Hacker",
    movements: [
      WorkoutMovement(name: "Plank Saw", type: "detik", amount: 30),
      WorkoutMovement(name: "Bicycle Crunch", type: "repetisi", amount: 15),
      WorkoutMovement(name: "Laying Leg Raises", type: "repetisi", amount: 15),
      WorkoutMovement(name: "Forearm Plank", type: "detik", amount: 30),
      WorkoutMovement(name: "Slow Tempo Mountain Climber", type: "repetisi", amount: 20),
      WorkoutMovement(name: "Reverse Crunch", type: "repetisi", amount: 15),
      WorkoutMovement(name: "Bodyweight Russian Twist", type: "repetisi", amount: 20),
      WorkoutMovement(name: "Bicycle Crunch", type: "repetisi", amount: 15),
      WorkoutMovement(name: "Cobra Stretch", type: "detik", amount: 30),
    ],
  ),

];