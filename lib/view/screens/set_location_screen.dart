
import 'package:ecommerce/cubit/location_cubit.dart';
import 'package:ecommerce/model/user_location.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  _SetLocationScreenState createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  TextEditingController searchController = TextEditingController();
  Set<Marker> markers = {}; // لتخزين العلامات على الخريطة
  String selectedAddressTitle = 'Loading...'; // متغير لتخزين العنوان المختار

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // تحديد الموقع الحالي باستخدام Geolocator
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: currentLocation!,
      ));
    });

    // تحويل الإحداثيات إلى عنوان نصي
    _getAddressFromCoordinates(position.latitude, position.longitude);

    // تحريك الكاميرا إلى الموقع الحالي
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLocation!, 15));
  }

  // تحويل الإحداثيات إلى عنوان نصي
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          selectedAddressTitle = '${placemark.name}, ${placemark.locality}, ${placemark.country}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  // إذا كان المستخدم قد اختار عنوانًا من البحث
  void _searchAddress() async {
    String query = searchController.text;
    if (query.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(query);
        if (locations.isNotEmpty) {
          final location = locations.first;
          setState(() {
            currentLocation = LatLng(location.latitude, location.longitude);
            markers.clear(); // إخفاء أي علامات سابقة
            markers.add(Marker(
              markerId: MarkerId('searchedLocation'),
              position: currentLocation!,
            ));
          });
          _getAddressFromCoordinates(location.latitude, location.longitude); // تحويل الإحداثيات للعنوان
          mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLocation!, 15));
        }
      } catch (e) {
        print("Error searching address: $e");
      }
    }
  }

  // تحديد الموقع عند النقر على الخريطة
  void _onMapTapped(LatLng tappedLocation) {
    setState(() {
      currentLocation = tappedLocation;
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('selectedLocation'),
        position: currentLocation!,
      ));
    });
    _getAddressFromCoordinates(tappedLocation.latitude, tappedLocation.longitude); // تحويل الإحداثيات للعنوان
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Stack(
          children: [
            // خريطة جوجل
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(31.963158, 35.930359), // عمان كموقع مبدئي
                zoom: 12,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              myLocationEnabled: true,
              onTap: _onMapTapped, // تحديد الموقع عند النقر على الخريطة
              markers: markers,
            ),

            // خانة البحث
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsiveWidth(context, 30),
                vertical: responsiveHeight(context, 60),
              ),
              child: Row(
                children: [
                  BackButton(),
                  Expanded(
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(40),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Find your location",
                          prefixIcon: Icon(Icons.search, color: Color(0xff25AE4B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Color(0xffD6D6D6)),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        onSubmitted: (_) => _searchAddress(),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            // عرض العنوان في Card
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  // الجدول (Card) الذي يعرض العنوان المختار
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        selectedAddressTitle, // عرض العنوان المختار هنا
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // زر تأكيد الموقع مع تحسين التصميم
                  ElevatedButton(
                    onPressed: currentLocation == null
                        ? null
                        : () async {
                      // خزّن الموقع المختار باستخدام Cubit
                      final locationCubit = context.read<LocationCubit>();
                      final newLocation = UserLocation(
                        latitude: currentLocation!.latitude,
                        longitude: currentLocation!.longitude,
                      );

                      // خزّنه في SharedPreferences وحدث الحالة
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setDouble('latitude', newLocation.latitude);
                      prefs.setDouble('longitude', newLocation.longitude);

                      locationCubit.emit(LocationLoaded(newLocation));

                      // رجوع إلى شاشة CheckoutScreen بعد التحديث
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                      );

                    },

                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // عرض كامل وارتفاع 50
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Confirm Location',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


