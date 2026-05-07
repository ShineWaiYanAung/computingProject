import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showUserInfoDialog(BuildContext context) {

  final user = FirebaseAuth.instance.currentUser;

  showDialog(
    context: context,

    builder: (_) {

      return Dialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),

        child: Container(
          width: 350,
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              /// AVATAR
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xff6ea8df),

                child: Icon(
                  Icons.person,
                  size: 45,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "User Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// EMAIL BOX
              Container(
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Row(
                  children: [

                    const Icon(Icons.email),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        "mockupemail@gmail.com",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD BOX
              Container(
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: const Row(
                  children: [

                    Icon(Icons.lock),

                    SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        "123456789",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// CLOSE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6ea8df),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}