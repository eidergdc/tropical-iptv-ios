part of 'locale.dart';

class FavoriteLocale {
  final GetStorage _box = GetStorage("favorites");
  static const String _favoritesKey = 'favorites_list';

  Future<void> addFavorite(Map<String, dynamic> item) async {
    try {
      final List<Map<String, dynamic>> list = await getFavorites();

      // Check if already exists
      final exists = list
          .any((fav) => fav['id'] == item['id'] && fav['type'] == item['type']);

      if (!exists) {
        list.add(item);
        await _box.write(_favoritesKey, jsonEncode(list));
      }
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(String id, String type) async {
    try {
      final List<Map<String, dynamic>> list = await getFavorites();
      list.removeWhere((item) => item['id'] == id && item['type'] == type);
      await _box.write(_favoritesKey, jsonEncode(list));
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final String? data = _box.read(_favoritesKey);
      if (data == null) return [];

      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  Future<bool> isFavorite(String id, String type) async {
    try {
      final List<Map<String, dynamic>> list = await getFavorites();
      return list.any((item) => item['id'] == id && item['type'] == type);
    } catch (e) {
      return false;
    }
  }

  Future<void> clearFavorites() async {
    await _box.remove(_favoritesKey);
  }

  Future<List<Map<String, dynamic>>> getFavoritesByType(String type) async {
    try {
      final List<Map<String, dynamic>> list = await getFavorites();
      return list.where((item) => item['type'] == type).toList();
    } catch (e) {
      return [];
    }
  }
}
