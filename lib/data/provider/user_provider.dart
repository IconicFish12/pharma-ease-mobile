import 'package:mobile_course_fp/data/model/user_model.dart';
import 'package:mobile_course_fp/data/provider/provider.dart';

class UserProvider extends Provider<Datum> {
  UserProvider(super.repository);

  bool isLoading = false;
  List<Datum> listData = [];
  String errorMessage = '';

  int _currentPage = 1;
  bool hasMoreData = true;

  Future<void> getMany({String? search, bool isLoadMore = false}) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    if (!isLoadMore) {
      _currentPage = 1;
      listData.clear();
      hasMoreData = true;
    } else {
      _currentPage++;
    }

    Map<String, dynamic> queryParams = {'page': _currentPage};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final result = await repository.getMany(queryParams: queryParams);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
        if (isLoadMore) _currentPage--;
        notifyListeners();
      },
      (data) {
        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          listData.addAll(data);
          if (data.length < 15) {
            hasMoreData = false;
          }
        }
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> create(Datum data) async {
    isLoading = true;
    notifyListeners();
    final result = await repository.create(data: data);
    return result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
        notifyListeners();
        return false;
      },
      (newData) async {
        listData.insert(0, newData);
        isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> update(dynamic id, Datum data) async {
    final result = await repository.update(id, data: data);

    return result.fold(
      (failure) {
        errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (updatedData) {
        final index = listData.indexWhere((element) => element.id == id);
        if (index != -1) {
          listData[index] = data;
          notifyListeners(); 
        } else {
          getMany();
        }
        return true;
      },
    );
  }

  Future<bool> delete(dynamic id) async {
    final result = await repository.delete(id);

    return result.fold(
      (failure) {
        errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (success) {
        if (success) {
          listData.removeWhere((element) => element.id == id);
          notifyListeners(); 
        }
        return success;
      },
    );
  }
}
