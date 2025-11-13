import 'package:flutter/material.dart';
import 'package:tp1/Atelier5.dart';

void main() {
runApp(const MyApp());
}
class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Flutter Material 3',
theme: ThemeData(useMaterial3: true),
home: const ProductListPageM5() // Nous commençons par l'atelier 1
);
}
}