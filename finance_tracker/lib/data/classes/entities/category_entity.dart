import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum Category { food, shopping, transport, entertainment, other }

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.food:
        return 'Food';
      case Category.shopping:
        return 'Shopping';
      case Category.transport:
        return 'Transport';
      case Category.entertainment:
        return 'Entertainment';
      case Category.other:
        return 'Other';
    }
  }

  Color get color {
    switch (this) {
      case Category.food:
        return Colors.red.shade300;
      case Category.shopping:
        return Colors.green.shade300;
      case Category.transport:
        return Colors.blue.shade200;
      case Category.entertainment:
        return Colors.yellow.shade300;
      case Category.other:
        return Colors.orange.shade300;
    }
  }

  IconData get icon {
    switch (this) {
      case Category.food:
        return Icons.fastfood;
      case Category.shopping:
        return Icons.shopping_cart;
      case Category.transport:
        return Icons.directions_bus;
      case Category.entertainment:
        return Icons.movie;
      case Category.other:
        return Icons.other_houses;
    }
  }
}

enum Type { income, expense }

extension TypeExtension on Type {
  String get name {
    switch (this) {
      case Type.income:
        return 'Income';
      case Type.expense:
        return 'Expense';
    }
  }

  Color get color {
    switch (this) {
      case Type.income:
        return Colors.green;
      case Type.expense:
        return Colors.red;
    }
  }

  String get valueType {
    switch (this) {
      case Type.income:
        return '+';
      case Type.expense:
        return '-';
    }
  }
}

class FinancialEntry {
  final Category category;
  final double amount;
  final DateTime date;
  final String description;
  final Type type;

  FinancialEntry({
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
    required this.type,
  });

  //toJson
  Map<String, dynamic> toJson() => {
    'category': category.name,
    'amount': amount,
    'date': date,
    'description': description,
    'type': type.name,
  };

  //fromJson
  factory FinancialEntry.fromJson(Map<String, dynamic> json) => FinancialEntry(
    category: Category.values.firstWhere((element) => element.name == json['category']),
    amount: json['amount'],
    date: json['date'] is Timestamp
        ? (json['date'] as Timestamp).toDate()
        : json['date'] as DateTime,
    description: json['description'],
    type: Type.values.firstWhere((element) => element.name == json['type']),
  );
}

class CategorySpending {
  final Category category;
  final double totalAmount;

  CategorySpending({required this.category, required this.totalAmount});
}
