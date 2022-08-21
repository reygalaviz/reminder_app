import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstore/localstore.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/screens/edit_notes.dart';
import '../models/note_data_store.dart';
import 'all_notes.dart' as all_notes;
import 'package:reminder_app/main.dart';

List<Notes> suggestions = [];

class MySearchDelegate extends SearchDelegate {
  //List<Notes> searchResults = <Notes>[];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null), //close search bar
      icon: const Icon(FontAwesomeIcons.arrowLeft));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestions = searchResults.where((searchResult) {
      final result = searchResult.title.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return Card(
          child: ListTile(
            title: Text(suggestion.title),
            onTap: () {
              close(context, suggestions[index]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditNote(id: suggestion.id)));

              showResults(context);
            },
          ),
        );
      },
    );
  }
}

class SearchNote extends StatefulWidget {
  const SearchNote({Key? key}) : super(key: key);
  @override
  State<SearchNote> createState() => SearchNoteState();
}

class SearchNoteState extends State<SearchNote> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          showSearch(context: context, delegate: MySearchDelegate());
        },
        icon: const Icon(FontAwesomeIcons.magnifyingGlass));
  }
}
