import 'package:cloud_firestore/cloud_firestore.dart';

class DbHelper {
  Future<bool> create(String collectionName, dynamic object) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .add(object)
        .then((documentReference) {
      return true;
      //return documentReference.documentID;
    }).catchError((e) {
      return false;
    });
    return false;
  }

  Future<bool> update(
      String collectionName, dynamic object, String documentID) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentID)
        .update(object)
        .then((documentReference) {
      return true;
    }).catchError((e) {
      return false;
    });
    return false;
  }

  Future<bool> delete(String collectionName, String documentID) async {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentID)
        .delete()
        .then((documentReference) {
      return true;
    }).catchError((e) {
      return false;
    });
    return false;
  }

  Future<QuerySnapshot> getAllData(String collectionName) async {
    return FirebaseFirestore.instance.collection(collectionName).get();
  }

  CollectionReference getRef(String collectionName) {
    return FirebaseFirestore.instance.collection(collectionName);
  }

  // // void initState() {
  // //   // Demonstrates configuring to the database using a file
  // //   //_counterRef = FirebaseDatabase.instance.reference().child('counter');
  // //   // Demonstrates configuring the database directly

  // //   //_userRef = database.reference().child('user');
  // //   // database.reference().child('counter').once().then((DataSnapshot snapshot) {
  // //   //   print('Connected to second database and read ${snapshot.value}');
  // //   // });

  // //   database.setPersistenceEnabled(true);
  // //   database.setPersistenceCacheSizeBytes(10000000);
  // //   _counterRef.keepSynced(true);

  // //   _counterSubscription = _counterRef.onValue.listen((Event event) {
  // //     error = null;
  // //     _counter = event.snapshot.value ?? 0;
  // //   }, onError: (Object o) {
  // //     error = o;
  // //   });
  // // }

  // final Firestore _db = Firestore.instance;
  // final String _path;
  // CollectionReference ref;

  // DbHelper(this._path) {
  //   ref = _db.collection(_path);
  // }

  // Future<QuerySnapshot> getDataCollection() {
  //   return ref.getDocuments() ;
  // }

  // Stream<QuerySnapshot> streamDataCollection() {
  //   return ref.snapshots() ;
  // }

  // Future<DocumentSnapshot> getDocumentById(String id) {
  //   return ref.document(id).get();
  // }

  // Future<void> removeDocument(String id){
  //   return ref.document(id).delete();
  // }

  // Future<DocumentReference> addDocument(Map data) {
  //   return ref.add(data);
  // }

  // Future<void> updateDocument(Map data , String id) {
  //   return ref.document(id).updateData(data);
  // }

  // // make this a singleton class
  // DbHelper._privateConstructor();
  // static final DbHelper instance = DbHelper._privateConstructor();

  // // only have a single app-wide reference to the database
  // static Database _database;
  // Future<Database> get database async {
  //   if (_database != null) return _database;
  //   // lazily instantiate the db the first time it is accessed
  //   _database = await _initDatabase();
  //   return _database;
  // }

  // // this opens the database (and creates it if it doesn't exist)
  // _initDatabase() async {
  //   //Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   var databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, 'cms.db');
  //   return await openDatabase(path,
  //       version: 1,
  //       onCreate: _onCreate,
  //       //onOpen: _onOpen
  //       );
  // }

  // // SQL code to create the database table
  // Future _onCreate(Database db, int version) async {
  //   await db.execute(''' CREATE TABLE Users (userid INTEGER PRIMARY KEY AUTOINCREMENT,
  //   fullname TEXT NOT NULL,
  //   username TEXT NOT NULL,
  //   password TEXT NOT NULL,
  //   role TEXT NOT NULL,
  //   companyname TEXT NOT NULL,
  //   isActive BOOLEAN NOT NULL DEFAULT 0)''');

  //   await db.execute(''' CREATE TABLE Customers (customerId INTEGER PRIMARY KEY AUTOINCREMENT,
  //   companyName TEXT NOT NULL,
  //   orderCode TEXT NOT NULL,
  //   customerName TEXT NOT NULL,
  //   orderDetails TEXT NOT NULL,
  //   phoneNumber TEXT NOT NULL,
  //   address TEXT NOT NULL,
  //   city TEXT NOT NULL,
  //   stateCountry TEXT NOT NULL,
  //   postalCode TEXT NOT NULL,
  //   status INTEGER NOT NULL,
  //   createdBy INTEGER,
  //   createdOn TEXT,
  //   modifiedBy INTEGER,
  //   modifiedOn TEXT
  //   )''');
  // }

  // // Future<void> _onOpen(Database db) async {
  // //   //table Users
  // //   await db.execute(''' CREATE TABLE Users (userid INTEGER PRIMARY KEY AUTOINCREMENT,
  // //           fullname TEXT NOT NULL,
  // //           username TEXT NOT NULL,
  // //           password TEXT NOT NULL,
  // //           role TEXT NOT NULL,
  // //           companyname TEXT NOT NULL,
  // //           isActive BOOLEAN NOT NULL DEFAULT 0)''');
  // // }

  // // Future<int> insert(String tableName, Map<String, dynamic> row) async {
  // //   Database db = await instance.database;
  // //   return await db.insert(tableName, row);
  // // }

  // // Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
  // //   Database db = await instance.database;
  // //   return await db.query(tableName);
  // // }

}
