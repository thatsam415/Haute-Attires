import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row with Payment Methods and Contact Information
          Text(
            'Payment Methods',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Card Payment', style: TextStyle(color: Colors.white70)),
              SizedBox(width: 20),
              Text('Google Pay', style: TextStyle(color: Colors.white70)),
              SizedBox(width: 20),
              Text('Cash on Delivery (COD)', style: TextStyle(color: Colors.white70)),
            ],
          ),
          
          SizedBox(height: 30),
          
          // Contact Information Section
          Text(
            'Contact Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.white70, size: 16),
              SizedBox(width: 10),
              Text('+91 9529086195', style: TextStyle(color: Colors.white70)),
              SizedBox(width: 30),
              Icon(Icons.email, color: Colors.white70, size: 16),
              SizedBox(width: 10),
              Text('thatipamula2001@gmail.com', style: TextStyle(color: Colors.white70)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.white70, size: 16),
              SizedBox(width: 10),
              Text('+91 8080234290', style: TextStyle(color: Colors.white70)),
              SizedBox(width: 30),
              Icon(Icons.email, color: Colors.white70, size: 16),
              SizedBox(width: 10),
              Text('harshgupta1887@gmail.com', style: TextStyle(color: Colors.white70)),
            ],
          ),

          SizedBox(height: 30),

          // Copyright Section
          Center(
            child: Text(
              '© 2024, Haute Attires By Samiksha And Harsh. All rights reserved.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
