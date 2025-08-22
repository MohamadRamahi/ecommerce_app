import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cubit/profile_detalis_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState>{
  ProfileDetailsCubit():super(ProfileDetailsLoading());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future <void> fetchUserDetails() async {
    try {
      emit(ProfileDetailsLoading());
      final user = _auth.currentUser;
      if (user == null) {
        emit(ProfileDetailsError("User not logged in"));
        return;
      }
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        emit(ProfileDetailsError("User data not found"));
        return;
      }
      emit(ProfileDetailsLoaded(doc.data()!));
    }
    catch (e) {
      emit(ProfileDetailsError("Failed to fetch user details: $e"));
    }
  }

  Future<void> updateUserDetails({
    String? phone,
    String? dateOfBirth,
    String?name,
    String?email,
    String?gender}) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(ProfileDetailsError("User not logged in"));
      return;
    }

    try {
      emit(ProfileDetailsLoading());

      await _firestore.collection('users').doc(user.uid).update({
        if(name!=null) 'name':name,
        //if(email!=null) 'email':email,
        if (phone != null) 'phone': phone,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
        if(gender!=null) 'gender':gender
      });

      // بعد التحديث، يمكنك جلب البيانات مرة أخرى
      final doc = await _firestore.collection('users').doc(user.uid).get();
      emit(ProfileDetailsLoaded(doc.data()!));
    } catch (e) {
      emit(ProfileDetailsError("Failed to update user details: $e"));
    }
  }

}