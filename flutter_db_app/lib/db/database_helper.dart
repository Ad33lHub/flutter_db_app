
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';


class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();


  static Database? _database;
  DatabaseHelper._init();
  Future<Database> get database async {

    if (_database != null) return _database!;


    _database = await _initDB('students.db');
    return _database!;
  }


  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();


    final path = join(dbPath, filePath);


    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }


  Future _createDB(Database db, int version) async {

    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,                           
        email TEXT,                            
        age INTEGER                           
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {

    final db = await instance.database;


    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> getStudents() async {
    final db = await instance.database;

    final result = await db.query('students');

    return result.map((e) => Student.fromMap(e)).toList();
  }

  Future<Student?> getStudent(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Student.fromMap(result.first);
    }

    return null;
  }


  Future<int> updateStudent(Student student) async {
    final db = await instance.database;

    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;

    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}