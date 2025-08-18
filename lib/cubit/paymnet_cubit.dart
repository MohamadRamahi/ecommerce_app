import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../model/card_payment_model.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentState(cards: [], selectedCardIndex: 0));

  Future<void> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList("savedCards") ?? [];

    final cards = saved
        .map((cardStr) => CardModel.fromJson(json.decode(cardStr)))
        .toList();

    final selectedIndex = prefs.getInt("selectedCardIndex") ?? 0;

    emit(state.copyWith(cards: cards, selectedCardIndex: selectedIndex));
  }

  Future<void> addCard(CardModel card) async {
    final updated = [...state.cards, card];
    emit(state.copyWith(cards: updated));
    await _saveToPrefs(updated);
  }

  void selectCard(int index) {
    emit(state.copyWith(selectedCardIndex: index));
  }

  Future<void> applySelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedCardIndex", state.selectedCardIndex ?? 0);
  }

  Future<void> _saveToPrefs(List<CardModel> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final list = cards.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList("savedCards", list);
  }

  void removeCard(int index) {
    final updatedCards = List<CardModel>.from(state.cards)..removeAt(index);
    emit(state.copyWith(
      cards: updatedCards,
      selectedCardIndex: null, // نلغي الاختيار إذا انحذف
    ));
  }

}
