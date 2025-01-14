import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:projectuas1/model/venue.dart';
import 'package:projectuas1/screens/booking_screen.dart';
import '../data/venue_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredVenues = selectedCategory == 'All'
        ? venues
        : venues.where((venue) => venue.category == selectedCategory).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Explore Sports Venues",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.notifications,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 130,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCategoryButton("Badminton"),
                        _buildCategoryButton("Soccer"),
                        _buildCategoryButton("Basketball"),
                        _buildCategoryButton("Gym"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Popular Offers",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: CarouselSlider.builder(
                      itemCount: venues.length,
                      itemBuilder: (context, index, realIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildPopularItem(venues[index]),
                        );
                      },
                      options: CarouselOptions(
                        height: 180,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    selectedCategory == 'All'
                        ? "All Venues"
                        : "$selectedCategory Venues",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: filteredVenues.map((venue) {
                      return _buildNearbyItem(venue);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedCategory == category
                  ? Colors.blue
                  : Colors.grey.withOpacity(0.2),
            ),
            child: Icon(
              _getCategoryIcon(category),
              size: 28,
              color: selectedCategory == category ? Colors.white : Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Badminton':
        return Icons.sports_tennis;
      case 'Soccer':
        return Icons.sports_soccer;
      case 'Basketball':
        return Icons.sports_basketball;
      case 'Gym':
        return Icons.fitness_center;
      default:
        return Icons.help;
    }
  }

  Widget _buildPopularItem(Venue venue) {
    return GestureDetector(
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
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(venue.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Lapangan Tersedia",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyItem(Venue venue) {
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
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
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
