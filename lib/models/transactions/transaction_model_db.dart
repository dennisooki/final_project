import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;
import 'package:fin_trackr/models/account_group/account_group_model_db.dart';
import 'package:fin_trackr/models/category/category_model_db.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'transaction_model_db.g.dart';

@HiveType(typeId: 6)
class TransactionModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final AccountType account;

  @HiveField(4)
  final CategoryType categoryType;

  @HiveField(5)
  final CategoryModel category;

  @HiveField(6)
  final String note;

  @HiveField(7)
  String? image;
  TransactionModel(
      {required this.id,
      required this.date,
      required this.account,
      required this.amount,
      required this.categoryType,
      required this.category,
      required this.note,
      this.image}) {
    // id = DateTime.now().microsecondsSinceEpoch.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'account': account.toString(), // Assuming AccountType can be represented as a String
      'categoryType': categoryType.toString(), // Assuming CategoryType can be represented as a String
      //'category': category.toJson(), // Assuming CategoryModel has a toJson() method
      'note': note,
      'image': image,
    };
  }
}



class DBConnection {
  static DBConnection? _instance;
  final String _host = "127.0.0.1";
  final String _port = "27017";
  final String _dbName = "finance";
  Db? _db;

  static getInstance () {
    if (_instance == null) {
      _instance = DBConnection ();
    }
    return _instance;
  }

  Future<Db> getConnection () async {
    if (_db == null) {
      try {
        _db = Db (_getConnectionString ());
        await _db!.open ();
      } catch (e) {
        print (e);
      }
    }
    return _db!;
  }

  _getConnectionString () {
    return "mongodb://$_host:$_port/$_dbName";
  }

  closeConnection () {
    _db!.close ();
  }
}

// Insert a document
void insertDocument(Map<String, dynamic> document) async {
  var db = await DBConnection.getInstance().getConnection();
  var collection = db.collection('finance_app');
  await collection.insert(document);
}

// Update a document
void updateDocument(Map<String, dynamic> document) async {
  var db = await DBConnection.getInstance().getConnection();
  var collection = db.collection('finance_app');
  await collection.update({'_id': document['_id']}, document);
}

// Delete a document
void deleteDocument(Map<String, dynamic> document) async {
  var db = await DBConnection.getInstance().getConnection();
  var collection = db.collection('finance_app');
  await collection.remove({'_id': document['_id']});
}
