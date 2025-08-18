import '../model/card_payment_model.dart';

class PaymentState {
  final List<CardModel> cards;
  final int? selectedCardIndex;

  PaymentState({
    required this.cards,
    this.selectedCardIndex,
  });

  PaymentState copyWith({
    List<CardModel>? cards,
    int? selectedCardIndex,
  }) {
    return PaymentState(
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
    );
  }
}
