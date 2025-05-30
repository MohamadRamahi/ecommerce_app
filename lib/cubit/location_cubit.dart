

import 'package:ecommerce/model/user_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/location_repository.dart';


// حالات الـ Cubit
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

  /// جلب الموقع الحالي وتخزينه
  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      UserLocation? location = await locationRepository.getUserLocation();
      if (location != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setDouble('latitude', location.latitude);
        prefs.setDouble('longitude', location.longitude);
        emit(LocationLoaded(location));
      } else {
        emit(LocationError());
      }
    } catch (e) {
      emit(LocationError());
    }
  }

  /// واجهة مختصرة تستخدم في الواجهة
  Future<void> fetchUserLocation() async {
    await getCurrentLocation();
  }

  /// تحميل آخر موقع محفوظ
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
}