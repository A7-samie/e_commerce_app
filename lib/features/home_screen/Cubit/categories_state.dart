abstract class CategoriesState {

  
}
class CategoriesInitialState extends CategoriesState{

}

class CategoriesLodingState extends CategoriesState{}


class CategoriesLodedState extends CategoriesState{
  final List<String> categories;

  CategoriesLodedState(this.categories);
}



class CategoriesErrorState extends CategoriesState{
    final String massage;

  CategoriesErrorState( this.massage);
}