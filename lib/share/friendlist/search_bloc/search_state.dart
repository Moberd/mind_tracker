part of 'search_bloc.dart';

@immutable
abstract class SearchState {
  final List<String> search =[];
}

class SearchLoading extends SearchState {
  final List<String> search =[];
}
class SearchLoaded extends SearchState{
  final List<String> search;

  SearchLoaded(this.search);
}
class ShowSnackBarSearchState extends SearchState{
  final String message;

  ShowSnackBarSearchState(this.message);
}