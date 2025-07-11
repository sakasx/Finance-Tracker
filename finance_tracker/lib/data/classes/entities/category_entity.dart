import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:objectbox/objectbox.dart';
//import 'objectbox.g.dart';

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

enum EntryType { income, expense }

extension TypeExtension on EntryType {
  String get name {
    switch (this) {
      case EntryType.income:
        return 'Income';
      case EntryType.expense:
        return 'Expense';
    }
  }

  Color get color {
    switch (this) {
      case EntryType.income:
        return Colors.green;
      case EntryType.expense:
        return Colors.red;
    }
  }

  String get valueType {
    switch (this) {
      case EntryType.income:
        return '+';
      case EntryType.expense:
        return '-';
    }
  }
}

@Entity()
class FinancialEntry {
  @Id()
  int id = 0;

  @Property()
  int categoryIndex;

  @Property()
  int typeIndex;

  @Property(type: PropertyType.date)
  DateTime date;

  double amount;
  String description;

  @Transient()
  Category get category => Category.values[categoryIndex];
  @Transient()
  set category(Category value) => categoryIndex = value.index;

  @Transient()
  EntryType get type => EntryType.values[typeIndex];
  @Transient()
  set type(EntryType value) => typeIndex = value.index;

  FinancialEntry({
    required this.categoryIndex,
    required this.typeIndex,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory FinancialEntry.withEnums({
    required Category category,
    required EntryType type,
    required double amount,
    required DateTime date,
    required String description,
  }) => FinancialEntry(
    categoryIndex: category.index,
    typeIndex: type.index,
    amount: amount,
    date: date,
    description: description,
  );

  Map<String, dynamic> toJson() => {
    'category': category.name,
    'amount': amount,
    'date': date,
    'description': description,
    'type': type.name,
  };

  factory FinancialEntry.fromJson(Map<String, dynamic> json) => FinancialEntry.withEnums(
    category: Category.values.firstWhere((element) => element.name == json['category']),
    type: EntryType.values.firstWhere((element) => element.name == json['type']),
    amount: json['amount'],
    date: json['date'] is Timestamp
        ? (json['date'] as Timestamp).toDate()
        : json['date'] as DateTime,
    description: json['description'],
  );
}

class CategorySpending {
  final Category category;
  final double totalAmount;

  CategorySpending({required this.category, required this.totalAmount});
}
