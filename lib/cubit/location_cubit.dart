import 'package:ecommerce/model/user_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/location_repository.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final UserLocation location;
  LocationLoaded(this.location);
}

class LocationError extends LocationState {}

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository locationRepository;

  LocationCubit(this.locationRepository) : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      final location = await locationRepository.getUserLocation();
      if (location != null) {
        await _saveLocation(location.latitude, location.longitude);
        emit(LocationLoaded(location));
      } else {
        emit(LocationError());
      }
    } catch (_) {
      emit(LocationError());
    }
  }

  Future<void> fetchUserLocation() async => await getCurrentLocation();

  Future<void> loadLastSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('latitude');
    final lon = prefs.getDouble('longitude');

    if (lat != null && lon != null) {
      emit(LocationLoaded(UserLocation(latitude: lat, longitude: lon)));
    } else {
      emit(LocationError());
    }
  }

  Future<void> saveLocation(LatLng newLocation) async {
    await _saveLocation(newLocation.latitude, newLocation.longitude);
    emit(LocationLoaded(UserLocation(
        latitude: newLocation.latitude, longitude: newLocation.longitude)));
  }

  Future<void> _saveLocation(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }
}
