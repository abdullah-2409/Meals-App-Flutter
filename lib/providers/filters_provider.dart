import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meal_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where(
    (element) {
      if (activeFilters[Filter.glutenFree]! && !element.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !element.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !element.isVegan) {
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !element.isVegetarian) {
        return false;
      }
      return true;
    },
  ).toList();
});
