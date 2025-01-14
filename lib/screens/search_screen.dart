import 'package:flutter/material.dart';
import 'package:projectuas1/model/venue.dart';
import 'package:projectuas1/screens/booking_screen.dart';
import '../data/venue_data.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final filteredVenues = query.isEmpty
        ? venues
        : venues
            .where((venue) =>
                venue.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Venues",
          style: TextStyle(
            color: Colors.white, 
            fontWeight:
                FontWeight.bold, 
          ),
        ),
        centerTitle: true, 
        backgroundColor: const Color(0xFF06AEAF), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by venue name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredVenues.isEmpty
                  ? const Center(
                      child: Text(
                        "No venues found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredVenues.length,
                      itemBuilder: (context, index) {
                        return _buildSearchResultItem(filteredVenues[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(Venue venue) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(venue: venue),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.asset(
                venue.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < venue.rating.floor()
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${venue.fields.map((field) => field.name).join(', ')}",
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Open: ${venue.openHours}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
