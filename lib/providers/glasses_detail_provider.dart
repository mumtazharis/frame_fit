import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/glasses_model.dart';

class GlassesDetailNotifier extends StateNotifier<Glasses?> {
  GlassesDetailNotifier() : super(null);

  void setGlassesDetail(Glasses glasses) {
    state = glasses;
  }
}

final glassesDetailProvider =
    StateNotifierProvider<GlassesDetailNotifier, Glasses?>(
  (ref) => GlassesDetailNotifier(),
);
