import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController mapController;
  String _selectedCategory = "All";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final LatLng _initialPosition = const LatLng(9.0300, 38.7400);

  final List<Map<String, dynamic>> _locationData = [
    {
      'id': 'cbe-1',
      'title': 'CBE - Main Branch',
      'lat': 9.0200,
      'lng': 38.7400,
      'type': 'Branches',
      'hue': BitmapDescriptor.hueBlue
    },
    {
      'id': 'awash-1',
      'title': 'Awash ATM - Bole',
      'lat': 9.0100,
      'lng': 38.7600,
      'type': 'ATMs',
      'hue': BitmapDescriptor.hueOrange
    },
    {
      'id': 'dashen-1',
      'title': 'Dashen Bank - Kazanchis',
      'lat': 9.0250,
      'lng': 38.7550,
      'type': 'Branches',
      'hue': BitmapDescriptor.hueBlue
    },
     {
      'id': 'cbe-2',
      'title': 'CBE ATM - Piazza',
      'lat': 9.0350,
      'lng': 38.7450,
      'type': 'ATMs',
      'hue': BitmapDescriptor.hueOrange
    },
  ];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> get _markers {
    return _locationData
        .where((loc) {
          final categoryMatch = _selectedCategory == "All" || loc['type'] == _selectedCategory;
          final searchMatch = _searchQuery.isEmpty || 
              loc['title'].toLowerCase().contains(_searchQuery.toLowerCase());
          return categoryMatch && searchMatch;
        })
        .map((loc) => Marker(
              markerId: MarkerId(loc['id']),
              position: LatLng(loc['lat'], loc['lng']),
              infoWindow: InfoWindow(title: loc['title']),
              onTap: () => context.push('/details/${loc['id']}'),
              icon: BitmapDescriptor.defaultMarkerWithHue(loc['hue']),
            ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: "Search branch or ATM...",
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
            suffixIcon: _searchQuery.isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: AppColors.primary),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = "");
                    },
                  )
                : null,
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 13.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Horizontal Filter Bar
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMapFilterChip("All"),
                  _buildMapFilterChip("Branches"),
                  _buildMapFilterChip("ATMs"),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location_rounded, color: AppColors.primary),
      ),
    );
  }

  Widget _buildMapFilterChip(String label) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
