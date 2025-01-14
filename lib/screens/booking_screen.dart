import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/venue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

const kPrimaryColor = Color(0xFF06AEAF);
const kDefaultPadding = 16.0;
const kBorderRadius = 16.0;

class BookingScreen extends StatefulWidget {
  final Venue venue;

  const BookingScreen({Key? key, required this.venue}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteVenues = prefs.getStringList('favoriteVenues') ?? [];
    setState(() {
      isFavorite =
          favoriteVenues.contains(json.encode(widget.venue.toJson()));
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteVenues = prefs.getStringList('favoriteVenues') ?? [];
    final venueJson = json.encode(widget.venue.toJson());

    setState(() {
      if (isFavorite) {
        favoriteVenues.remove(venueJson);  
      } else {
        favoriteVenues.add(venueJson);
      }
      isFavorite = !isFavorite;
    });

    
    await prefs.setStringList('favoriteVenues', favoriteVenues);
    _showFavoriteSnackBar();
  }

  void _showFavoriteSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? '${widget.venue.name} added to favorites!'
              : '${widget.venue.name} removed from favorites!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVenueHeader(),
              const SizedBox(height: 20),
              _buildVenueInformation(),
              const SizedBox(height: 20),
              _buildFieldsInformation(),
              const SizedBox(height: 20),
              _buildFacilities(),
              const SizedBox(height: 20),
              _buildReviews(),
              const SizedBox(height: 20),
              _buildLocation(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.venue.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: kPrimaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: _toggleFavorite,
        ),
      ],
    );
  }

  void _showShareSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Share functionality coming soon!"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildVenueHeader() {
    return Stack(
      children: [
        _buildHeaderImage(),
        _buildHeaderOverlay(),
        _buildHeaderInfo(),
        _buildHeaderRating(),
      ],
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.venue.image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    );
  }

  Widget _buildHeaderOverlay() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.venue.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.venue.category,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRating() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(
              widget.venue.rating.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Venue Information"),
        const SizedBox(height: 8),
        VenueCard(venue: widget.venue),
      ],
    );
  }

  Widget _buildFieldsInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Fields Information"),
        const SizedBox(height: 8),
        ..._buildFieldCards(),
      ],
    );
  }

  List<Widget> _buildFieldCards() {
    return widget.venue.fields.map((field) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Morning: ${field.morningPrice} IDR / Hour",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    "Afternoon: ${field.afternoonPrice} IDR / Hour",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _showBookingModal(field),
                child: const Text("Book"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _showBookingModal(Field field) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return BookingModal(field: field, venue: widget.venue);
      },
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Facilities"),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: widget.venue.facilities.map((facility) {
            return Chip(
              label: Text(facility),
              backgroundColor: kPrimaryColor.withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Reviews"),
        const SizedBox(height: 8),
        ..._buildReviewCards(),
      ],
    );
  }

  List<Widget> _buildReviewCards() {
    return widget.venue.reviews.map((review) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(review['name']),
          subtitle: Text(review['comment']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 16,
                color: index < review['rating'] ? Colors.amber : Colors.grey,
              );
            }),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Location"),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(widget.venue.latitude, widget.venue.longitude),
                zoom: 15,
                maxZoom: 19,
                minZoom: 3,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point:
                          LatLng(widget.venue.latitude, widget.venue.longitude),
                      builder: (ctx) => const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class VenueCard extends StatelessWidget {
  final Venue venue;

  const VenueCard({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    venue.address,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "${venue.fields.map((f) => f.morningPrice).join(', ')} IDR / Hour",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blueAccent),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Open Hours: ${venue.openHours}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookingModal extends StatefulWidget {
  final Field field;
  final Venue venue;

  const BookingModal({
    Key? key,
    required this.field,
    required this.venue,
  }) : super(key: key);

  @override
  _BookingModalState createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  late DateTime selectedDate;
  late String selectedTime;
  List<String> selectedHours = [];
  int totalPrice = 0;

  static const morningSlots = [
    "07.00 - 08.00",
    "08.00 - 09.00",
    "09.00 - 10.00",
    "10.00 - 11.00",
    "11.00 - 12.00",
  ];

  static const afternoonSlots = [
    "12.00 - 13.00",
    "13.00 - 14.00",
    "14.00 - 15.00",
    "15.00 - 16.00",
    "16.00 - 17.00",
    "17.00 - 18.00",
    "18.00 - 19.00",
    "19.00 - 20.00",
    "20.00 - 21.00",
    "21.00 - 22.00",
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = 'Morning';
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    final pricePerHour = selectedTime == 'Morning'
        ? widget.field.morningPrice
        : widget.field.afternoonPrice;
    setState(() {
      totalPrice = selectedHours.length * pricePerHour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildDateSelection(),
              const SizedBox(height: 16),
              _buildTimeSelection(),
              const SizedBox(height: 24),
              _buildPriceSummary(),
              const SizedBox(height: 24),
              _buildBookButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Book ${widget.field.name}",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Date",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy').format(selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildTimeSelection() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Time",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildTimeDropdown(),
            const SizedBox(height: 16),
            const Text(
              "Available Slots",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            _buildTimeSlots(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedTime,
          items: ["Morning", "Afternoon"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedTime = newValue!;
              selectedHours.clear();
              totalPrice = 0;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    final slots = selectedTime == 'Morning' ? morningSlots : afternoonSlots;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: slots
          .map((slot) => FilterChip(
                label: Text(slot),
                selected: selectedHours.contains(slot),
                selectedColor: kPrimaryColor.withOpacity(0.2),
                checkmarkColor: kPrimaryColor,
                labelStyle: TextStyle(
                  color: selectedHours.contains(slot)
                      ? kPrimaryColor
                      : Colors.black87,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedHours.add(slot);
                    } else {
                      selectedHours.remove(slot);
                    }
                    _calculateTotalPrice();
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _buildPriceSummary() {
    return Card(
      elevation: 0,
      color: kPrimaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Price",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              NumberFormat.currency(
                locale: 'id',
                symbol: 'IDR ',
                decimalDigits: 0,
              ).format(totalPrice),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: () => _handleBooking(),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Book Now",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleBooking() {
    if (selectedHours.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one time slot."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final bookingMessage = "Halo, saya ingin booking ${widget.field.name} "
        "di ${widget.venue.name} tanggal ${DateFormat('dd MMMM yyyy').format(selectedDate)} "
        "untuk jam ${selectedHours.join(', ')}.";

    final whatsappUrl = "https://wa.me/${widget.venue.whatsappNumber}"
        "?text=${Uri.encodeComponent(bookingMessage)}";

    launchUrl(Uri.parse(whatsappUrl));
  }
}
