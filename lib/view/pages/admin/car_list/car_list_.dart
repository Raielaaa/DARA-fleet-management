import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue,
        width: double.infinity,
        height: double.infinity,
        child: const Text("Car list"),
      ),
    );
  }
}