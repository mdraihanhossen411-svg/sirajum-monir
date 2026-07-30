import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.mosque,
                size: 100,
                color: Color(0xFF0E6B50),
              ),

              const SizedBox(height: 25),

              const Text(
                "السلام عليكم",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Welcome to Sirajum Monir",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Learn Quran, Hadith, Dua, Prayer Time, Qibla, Islamic Books and many more Islamic resources.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 45),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  onPressed: () {

                    Navigator.pushReplacement(

                      context,

                      MaterialPageRoute(

                        builder: (_) => const HomeScreen(),

                      ),

                    );

                  },

                  style: ElevatedButton.styleFrom(

                    backgroundColor: const Color(0xFF0E6B50),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),

                    ),

                  ),

                  child: const Text(

                    "Let's Begin",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}
