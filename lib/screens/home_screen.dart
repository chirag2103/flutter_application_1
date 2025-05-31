import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'planning_screen.dart';
import 'material_screen.dart';
import 'labour_screen.dart';
import 'profile_screen.dart';
import 'order_summary_screen.dart';
import '../utils/api_service.dart';
import 'add_service_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _currentLocation = 'Fetching location...';

  final List<Widget> _screens = [
    const AddServiceScreen(),
    const PlanningScreen(),
    const MaterialScreen(),
    const LabourScreen(),
    const OrderSummaryScreen(cartItems: []),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add Service'),
    BottomNavigationBarItem(icon: Icon(Icons.architecture), label: 'Planning'),
    BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Material'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Labour'),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
  ];

  final List<String> _titles = [
    'Add Service',
    'Planning',
    'Material',
    'Labour',
    'Orders',
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = 'Location services are disabled';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = 'Location permission denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = 'Location permission permanently denied';
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _currentLocation = 'Error fetching location';
      });
      print('Error getting location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentLocation =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          _currentLocation = "No address found";
        });
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
      setState(() {
        _currentLocation = "Error fetching address";
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLocationDialog() {
    TextEditingController locationController = TextEditingController(
      text: _currentLocation,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Location'),
          content: TextField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'Enter your location',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentLocation = locationController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton.icon(
          onPressed: _showLocationDialog,
          icon: const Icon(Icons.location_on, color: Colors.white),
          label: Text(
            _currentLocation,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: _goToProfile),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: _navItems,
      ),
    );
  }
}
