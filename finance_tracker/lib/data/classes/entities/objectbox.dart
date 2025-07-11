import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:finance_tracker/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  late final Box<FinancialEntry> expenseBox;

  late final Stream<Query<FinancialEntry>> expenseStream;

  ObjectBox._create(this.store) {
    expenseBox = Box<FinancialEntry>(store);

    final qBuilder = expenseBox.query()..order(FinancialEntry_.date, flags: Order.descending);
    expenseStream = qBuilder.watch(triggerImmediately: true);
  }
  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }
  
}
