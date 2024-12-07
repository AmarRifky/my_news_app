import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/models/article_model.dart';
import 'package:my_news_app/state/app_state.dart';

class AddToCategoryDialog extends StatefulWidget {
  final Article article;

  AddToCategoryDialog({required this.article});

  @override
  _AddToCategoryDialogState createState() => _AddToCategoryDialogState();
}

class _AddToCategoryDialogState extends State<AddToCategoryDialog> {
  String? _selectedCategory;
  final _categoryController = TextEditingController();
  String? _message;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return AlertDialog(
      title: Text('Add to Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select an existing category or create a new one:'),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedCategory,
              hint: Text('Select Category'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _categoryController.clear();
                  _message = null; // Reset message when category changes
                });
              },
              items: appState.categories.keys
                  .map<DropdownMenuItem<String>>((String categoryName) {
                return DropdownMenuItem<String>(
                  value: categoryName,
                  child: Text(categoryName),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'New Category',
                border: OutlineInputBorder(),
              ),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color: _isSuccess ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final categoryName =
                _selectedCategory ?? _categoryController.text.trim();

            if (categoryName.isEmpty) {
              setState(() {
                _message = 'Please select or enter a category';
                _isSuccess = false;
              });
              return;
            }

            if (appState.categories.containsKey(categoryName) &&
                appState.categories[categoryName]!.contains(widget.article)) {
              setState(() {
                _message =
                'Error: Article already exists in the selected category.';
                _isSuccess = false;
              });
            } else {
              appState.addCategory(categoryName);
              appState.addArticleToCategory(categoryName, widget.article);
              setState(() {
                _message = 'Success: Article added to "$categoryName".';
                _isSuccess = true;
              });
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }
}
