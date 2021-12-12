import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karobar/config/dbCollections.dart';
import 'package:karobar/models/dbUser.dart';
import 'package:karobar/models/transaction.dart';

class FirebaseService {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reference to users collection
  static final usersColsRefs = _db
      .collection(USERSCOLLECTION)
      .withConverter<DbUser>(
          fromFirestore: (doc, _) => DbUser.fromMap(doc.id, doc.data()!),
          toFirestore: (user, _) => user.toMap());

  // All functionality related to users

  /// Create Dbuser by Dbuser
  /// If the user is new then it is created in database
  /// If it already exists then
  static Future<void> createDbUserById(DbUser dbuser) async {
    var userIfExist =
        await usersColsRefs.where("username", isEqualTo: dbuser.username).get();
    if (userIfExist.docs.isEmpty) {
      print("Creating a new user in db");
      await usersColsRefs.doc(dbuser.username).set(dbuser);
    } else
      print("User already exists");
  }

  /// Get stream of db user by id
  static Stream<DbUser?> streamDbUserById(String id) {
    final refUser = usersColsRefs.doc(id).snapshots();

    return refUser.map((doc) {
      return doc.data()!;
    });
  }

  /// Get db user by id
  static Future<DbUser> getDbUserById(String id) async {
    DocumentSnapshot<DbUser> userSnap = await usersColsRefs.doc(id).get();
    return userSnap.data()!;
  }

  // All functionality related to transactions

  /// Streams all transaction item
  static Stream<List<DbTransaction>> getAllDbTransaction(String username) {
    
    final transactionsColsRefs = _db
        .collection("$USERSCOLLECTION/$username/$TRANSACTIONSSCOLLECTION")
        .withConverter<DbTransaction>(
            fromFirestore: (doc, _) => DbTransaction.fromMap(doc.id, doc.data()!),
            toFirestore: (item, _) => item.toMap());
    final transactionsRefs = transactionsColsRefs.snapshots();
    return transactionsRefs.map((list) {
      return list.docs.map((doc) => doc.data()).toList();
    });
  }
  // Get transaction by id
  static Future<DbTransaction> getDbTransactionById(String username,String id) async{
    
    final transactionsColsRefs = _db
        .collection("$USERSCOLLECTION/$username/$TRANSACTIONSSCOLLECTION")
        .withConverter<DbTransaction>(
            fromFirestore: (doc, _) => DbTransaction.fromMap(doc.id, doc.data()!),
            toFirestore: (item, _) => item.toMap());
    var transactionSnap = await transactionsColsRefs.doc(id).get();
    return transactionSnap.data()!;
   

  }

  /// Create a transaction item
  static Future<void> createDbTransaction(String username, DbTransaction dbTransaction) async {
    final transactionsColsRefs = _db
        .collection("$USERSCOLLECTION/$username/$TRANSACTIONSSCOLLECTION")
        .withConverter<DbTransaction>(
            fromFirestore: (doc, _) => DbTransaction.fromMap(doc.id, doc.data()!),
            toFirestore: (item, _) => item.toMap());
    await transactionsColsRefs.add(dbTransaction);
  }

  /// Delete transaction item
  static Future<void> deleteDbTransaction(String username, String id) async {
    final transactionsColsRefs = _db
        .collection("$USERSCOLLECTION/$username/$TRANSACTIONSSCOLLECTION")
        .withConverter<DbTransaction>(
            fromFirestore: (doc, _) => DbTransaction.fromMap(doc.id, doc.data()!),
            toFirestore: (DbTransaction, _) => DbTransaction.toMap());
    await transactionsColsRefs.doc(id).delete();
  }

  /// Update transaction item
  static Future<void> updateDbTransaction(String username, DbTransaction dbTransaction) async {
    final transactionsColsRefs = _db
        .collection("$USERSCOLLECTION/$username/$TRANSACTIONSSCOLLECTION")
        .withConverter<DbTransaction>(
            fromFirestore: (doc, _) => DbTransaction.fromMap(doc.id, doc.data()!),
            toFirestore: (item, _) => item.toMap());
    await transactionsColsRefs.doc(dbTransaction.id).set(dbTransaction, SetOptions(merge: true));
  }
  
}