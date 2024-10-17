import 'package:flutter/material.dart';
import 'package:uquiz/profile.dart';
import 'home.dart';

class Shopping extends StatefulWidget {
  const Shopping({super.key});

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  @override
  Widget build(BuildContext context) {
    const products = [
      {
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        "name": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": "\$109.95"
      },
      {
        "image":
            "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
        "name": "Mens Casual Premium Slim Fit T-Shirts",
        "price": "\$22.3"
      },
      {
        "image": "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
        "name": "Mens Cotton Jacket",
        "price": "\$55.99"
      },
      {
        "image": "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
        "name":
            "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
        "price": "\$695"
      },
      {
        "image":
            "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
        "name": "Solid Gold Petite Micropave ",
        "price": "\$168"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("UQuiz Shopping"),
      ),
      body: ListView.separated(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          final product = products[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // ตั้งค่าอัตราส่วนให้เหมาะสมกับภาพ
                    child: Image.network(
                      product['image']!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    product['price']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const Shopping(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const Profile(),
              ),
            );
          }
        },
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.shop), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Profile'),
        ],
      ),
    );
  }
}
