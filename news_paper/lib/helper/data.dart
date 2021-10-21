import 'package:news_paper/models/catagory_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = new List<CategoryModel>();
  CategoryModel categoryModel = new CategoryModel();

  categoryModel.categoryName = 'Business';
  categoryModel.image = 'images/adeolu-eletu-E7RLgUjjazc-unsplash.jpg';
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = 'Entertainment';
  categoryModel.image = 'images/entertainment.jpg';
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = 'General';
  categoryModel.image = 'images/general.jpg';
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = 'Health';
  categoryModel.image = 'images/health.jpg';
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = 'Science';
  categoryModel.image = 'images/science.jpg';
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = 'Sports';
  categoryModel.image = 'images/sports.jpg';
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = 'Technology';
  categoryModel.image = 'images/technology.jpg';
  category.add(categoryModel);

  return category;
}
