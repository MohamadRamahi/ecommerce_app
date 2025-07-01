import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/saved_address.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  LatLng? selectedLatLng;
  String addressText = '';
  String? selectedLabel;
  bool isDefault = false;
  final searchController = TextEditingController();
  GoogleMapController? mapController;

  final List<String> addressLabels = ['Home', 'Work', 'Other'];

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          addressText = "${p.street}, ${p.locality}, ${p.country}";
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
        addressText = "${position.latitude}, ${position.longitude}";
      });
    }
  }

  Future<void> _searchLocation(String query) async {
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final latLng = LatLng(loc.latitude, loc.longitude);

        setState(() {
          selectedLatLng = latLng;
        });

        mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
        _getAddressFromLatLng(latLng);
      }
    } catch (e) {
      print("Search error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Address")),
      body: Column(
        children: [
          // 🔍 شريط البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  _searchLocation(query.trim());
                }
              },
              decoration: InputDecoration(
                hintText: 'Search for location...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (searchController.text.trim().isNotEmpty) {
                      _searchLocation(searchController.text.trim());
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 🗺️ الخريطة
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(31.963158, 35.930359), // عمان
                zoom: 14,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              onTap: (pos) {
                setState(() {
                  selectedLatLng = pos;
                });
                _getAddressFromLatLng(pos);
              },
              markers: selectedLatLng != null
                  ? {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: selectedLatLng!,
                )
              }
                  : {},
            ),
          ),

          // 📝 بيانات العنوان
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: responsiveWidth(context, 24,),
                vertical: responsiveHeight(context, 16)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Address",style:
                  TextStyle(
                    color: Colors.black,
                    fontSize: responsiveWidth(context, 18)
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedLabel,
                  items: addressLabels
                      .map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(label),
                  ))
                      .toList(),
                  hint: const Text("Choose one",
                  style: TextStyle(
                    color: Colors.grey,

                  ),),
                  onChanged: (value) {
                    setState(() {
                      selectedLabel = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                 Text("Full Address",style:
                  TextStyle(
                  color: Colors.black,
                  fontSize: responsiveWidth(context, 18)
                ),
                 ),
                const SizedBox(height: 6),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Enter your full address...",hintStyle:
                    TextStyle(
                      color: Colors.grey
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: TextEditingController(text: addressText),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: Colors.grey,

                      ),
                      activeColor: Colors.black,
                      value: isDefault,
                      onChanged: (value) {
                        setState(() {
                          isDefault = value!;
                        });
                      },
                    ),
                     Text("Make this as a default address",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: responsiveWidth(context, 16)
                    ),),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedLatLng != null && selectedLabel != null && addressText.isNotEmpty
                        ? () {
                      Navigator.pop(
                        context,
                        SavedAddress(
                          label: selectedLabel!,
                          address: addressText,
                          latitude: selectedLatLng!.latitude,
                          longitude: selectedLatLng!.longitude,

                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Add", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
