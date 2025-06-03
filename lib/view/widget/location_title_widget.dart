
import 'package:ecommerce/cubit/location_cubit.dart';
import 'package:ecommerce/model/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';


class LocationTitleWidget extends StatefulWidget {

  const LocationTitleWidget({super.key,});

  @override
  State<LocationTitleWidget> createState() => _LocationTitleWidgetState();
}

class _LocationTitleWidgetState extends State<LocationTitleWidget> {
  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().getCurrentLocation();
  }

  Future<String> _getAddressFromLocation(UserLocation location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}';
      } else {
        return 'Unknown location';
      }
    } catch (e) {
      return 'Unable to fetch address';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return _buildLocationText('Loading...');
        } else if (state is LocationLoaded) {
          return FutureBuilder<String>(
            future: _getAddressFromLocation(state.location),
            builder: (context, snapshot) {
              return _buildLocationText(snapshot.data ?? 'Loading...');
            },
          );
        } else if (state is LocationError) {
          return _buildLocationText('Location not available');
        }
        return _buildLocationText('Loading...');
      },
    );
  }

  Widget _buildLocationText(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Home",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
      ],
    );
  }
}