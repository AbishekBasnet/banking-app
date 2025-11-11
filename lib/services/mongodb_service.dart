import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user.dart';

/// Service class to handle MongoDB database operations
/// Manages user authentication, registration, and database connection
class MongoDBService {
  static Db? _db;
  static DbCollection? _usersCollection;
  
  // MongoDB connection string - Connected to local MongoDB
  static const String MONGO_URL = "mongodb://localhost:27017/banking";
  static const String COLLECTION_NAME = "users";

  /// Connect to MongoDB database
  static Future<void> connect() async {
    try {
      _db = await Db.create(MONGO_URL);
      await _db!.open();
      _usersCollection = _db!.collection(COLLECTION_NAME);
      
      // Create unique index on clientCard to prevent duplicates
      await _usersCollection!.createIndex(
        key: 'clientCard',
        unique: true,
      );
      
      print('Connected to MongoDB successfully');
    } catch (e) {
      print('Error connecting to MongoDB: $e');
      rethrow;
    }
  }

  /// Close MongoDB connection
  static Future<void> close() async {
    await _db?.close();
  }

  /// Hash password using SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Register a new user with client card number and password
  /// Returns true if successful, false if client card already exists
  static Future<bool> registerUser({
    required String clientCard,
    required String password,
    required String name,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _usersCollection!.findOne(
        where.eq('clientCard', clientCard),
      );

      if (existingUser != null) {
        print('User with this client card already exists');
        return false;
      }

      // Create new user
      final user = User(
        clientCard: clientCard,
        passwordHash: hashPassword(password),
        name: name,
      );

      await _usersCollection!.insertOne(user.toJson());
      print('User registered successfully');
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  /// Login user with client card and password
  /// Returns User object if credentials are valid, null otherwise
  static Future<User?> loginUser({
    required String clientCard,
    required String password,
  }) async {
    try {
      final hashedPassword = hashPassword(password);
      
      final userDoc = await _usersCollection!.findOne(
        where.eq('clientCard', clientCard).eq('passwordHash', hashedPassword),
      );

      if (userDoc != null) {
        print('Login successful');
        return User.fromJson(userDoc);
      } else {
        print('Invalid client card or password');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  /// Check if user exists by client card
  static Future<bool> userExists(String clientCard) async {
    try {
      final user = await _usersCollection!.findOne(
        where.eq('clientCard', clientCard),
      );
      return user != null;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}
