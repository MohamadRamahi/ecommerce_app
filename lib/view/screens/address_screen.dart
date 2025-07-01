import 'package:ecommerce/address_storage.dart';
import 'package:ecommerce/cubit/location_cubit.dart';
import 'package:ecommerce/model/saved_address.dart';
import 'package:ecommerce/view/screens/add_new_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../responsive.dart';
import '../widget/notification_icon_widget.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String? selectedAddressTitle;
  bool hasFetchedAddress = false;
  List<SavedAddress> savedAddresses = [];
  int? selectedAddressIndex; // -1 = current location, 0+ = saved
  SavedAddress? selectedSavedAddress; // للـ Apply
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().loadLastSavedLocation();
    _loadSavedAddresses();
  }



  Future<void> _loadSavedAddresses() async {
    final addresses = await AddressStorage.loadAddresses();
    setState(() {
      savedAddresses = addresses;
      if (savedAddresses.isNotEmpty && selectedAddressIndex == null) {
        selectedAddressIndex = 0;
        selectedSavedAddress = savedAddresses[0];
      }
    });
  }

  Future<void> _convertCoordinatesToAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          selectedAddressTitle = "${placemark.street}, ${placemark.locality}, ${placemark.country}";
          hasFetchedAddress = true;
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsiveHeight(context, 16),
            horizontal: responsiveWidth(context, 24),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BackButton(),
                          Text(
                            "Address",
                            style: TextStyle(
                              fontSize: responsiveWidth(context, 24),
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          NotificationIcon(),
                        ],
                      ),
                      SizedBox(height: responsiveHeight(context, 16)),

                      // Saved Address Label
                      Text(
                        'Saved Address',
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: responsiveHeight(context, 16)),

                      // Current Location
                      BlocBuilder<LocationCubit, LocationState>(
                        builder: (context, state) {
                          if (state is LocationLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is LocationLoaded) {
                            final location = state.location;
                            final latLng = LatLng(location.latitude, location.longitude);

                            if (!hasFetchedAddress) {
                              _convertCoordinatesToAddress(latLng);
                            }

                            return Column(
                              children: [
                                AddressCard(
                                  label: "Current Location",
                                  address: selectedAddressTitle ?? "${location.latitude}, ${location.longitude}",
                                  isDefault: true,
                                  isSelected: selectedAddressIndex == -1,
                                  showRadio: true,
                                  radioValue: -1, // Unique value
                                  radioGroupValue: selectedAddressIndex,
                                  onRadioChanged: (int? value) {
                                    setState(() {
                                      selectedAddressIndex = value!;
                                      selectedSavedAddress = SavedAddress(
                                        label: "Current Location",
                                        address: selectedAddressTitle ?? "${location.latitude}, ${location.longitude}",
                                        latitude: location.latitude,
                                        longitude: location.longitude,
                                      );
                                    });
                                  },
                                ),

                                SizedBox(height: responsiveHeight(context, 12)),
                              ],
                            );
                          } else if (state is LocationError) {
                            return const Text(
                              "Failed to load address",
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),

                      // Saved Addresses
                      ...savedAddresses.asMap().entries.map((entry) {
                        int index = entry.key;
                        SavedAddress address = entry.value;

                        return Column(
                          children: [
                            Dismissible(
                              key: Key('${address.label}-${address.latitude}-${address.longitude}'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Address"),
                                    content: const Text("Are you sure you want to delete this address?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) async {
                                setState(() {
                                  savedAddresses.removeAt(index);
                                  // If deleted item was selected
                                  if (selectedAddressIndex == index) {
                                    selectedAddressIndex = null;
                                    selectedSavedAddress = null;
                                  } else if (selectedAddressIndex != null && selectedAddressIndex! > index) {
                                    selectedAddressIndex = selectedAddressIndex! - 1;
                                  }
                                });

                                // Save updated list
                                await AddressStorage.saveAddresses(savedAddresses);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Address deleted")),
                                );
                              },
                              child: AddressCard(
                                label: address.label,
                                address: address.address,
                                isDefault: false,
                                isSelected: selectedAddressIndex == index,
                                showRadio: true,
                                radioValue: index,
                                radioGroupValue: selectedAddressIndex,
                                onRadioChanged: (int? value) {
                                  setState(() {
                                    selectedAddressIndex = value;
                                    selectedSavedAddress = address;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: responsiveHeight(context, 12)),
                          ],
                        );
                      }).toList(),


                      SizedBox(height: responsiveHeight(context, 16)),

                      // Add New Address
                      GestureDetector(
                        onTap: () async {
                          final newAddress = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddNewAddressScreen()),
                          );

                          if (newAddress != null && newAddress is SavedAddress) {
                            final existing = await AddressStorage.loadAddresses();
                            existing.add(newAddress);
                            await AddressStorage.saveAddresses(existing);
                            _loadSavedAddresses();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(responsiveHeight(context, 14)),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add),
                              SizedBox(width: responsiveWidth(context, 8)),
                              Text(
                                "Add New Address",
                                style: TextStyle(
                                  fontSize: responsiveWidth(context, 16),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ Apply Button
              SizedBox(height: responsiveHeight(context, 16)),
              SizedBox(
                width: double.infinity,
                height: responsiveHeight(context, 54),
                child: ElevatedButton(
                  onPressed: selectedSavedAddress != null
                      ? () {
                    Navigator.pop(context, selectedSavedAddress);
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String label;
  final String address;
  final bool isDefault;
  final bool isSelected;

  final bool showRadio;
  final int? radioValue;
  final int? radioGroupValue;
  final ValueChanged<int?>? onRadioChanged;

  const AddressCard({
    Key? key,
    required this.label,
    required this.address,
    this.isDefault = false,
    this.isSelected = false,
    this.showRadio = false,
    this.radioValue,
    this.radioGroupValue,
    this.onRadioChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDefault ? Colors.black : Colors.black87,
                        ),
                      ),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Default",
                            style: TextStyle(fontSize: 10, color: Colors.black87),
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (showRadio)
              Radio<int>(
                value: radioValue!,
                groupValue: radioGroupValue,
                onChanged: onRadioChanged,
                activeColor: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}
