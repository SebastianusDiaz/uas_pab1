import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/venue.dart';
import 'booking_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Venue> favoriteVenues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJsonList = prefs.getStringList('favoriteVenues') ?? [];
    print("Favorites from SharedPreferences: $favoriteJsonList");

    setState(() {
      favoriteVenues = favoriteJsonList
          .map((venueJson) => Venue.fromJson(json.decode(venueJson)))
          .toList();
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(Venue venue) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteVenues.remove(venue);
    });
    await prefs.setStringList(
      'favoriteVenues',
      favoriteVenues.map((venue) => json.encode(venue.toJson())).toList(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${venue.name} removed from favorites'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF06AEAF),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteVenues.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding venues to your favorites!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteVenues.length,
      itemBuilder: (context, index) {
        final venue = favoriteVenues[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF06AEAF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.sports_soccer,
                color: Color(0xFF06AEAF),
              ),
            ),
            title: Text(
              venue.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Color(0xFF06AEAF),
              ),
              onPressed: () => _removeFavorite(venue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(
                    venue: venue,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
