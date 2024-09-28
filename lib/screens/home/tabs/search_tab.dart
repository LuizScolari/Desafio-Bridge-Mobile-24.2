import 'package:beat/api/search.dart';
import 'package:beat/models.dart';
import 'package:beat/screens/home/tab_title.dart';
import 'package:beat/utils/colors.dart';
import 'package:beat/utils/debouncer.dart';
import 'package:beat/widgets/track_item.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late Debouncer<String> _searchDebouncer;
  List<Track> _results = [];
  bool _loading = false;
  String lastTerm = '';

  late ScrollController _scrollController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollChanged);

    _textController = TextEditingController();
    _textController.addListener(_onSearchTermChanged);

    _searchDebouncer = Debouncer<String>(
      const Duration(milliseconds: 500),
      _performSearch,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  void _onScrollChanged() {
    if (_scrollController.offset > 150) {
      FocusScope.of(context).unfocus();
    }
  }

  void _onSearchTermChanged() {
    final term = _textController.value.text;
    setState(() => _loading = false);
    _searchDebouncer.call(term);
  }

  void _performSearch(String term) async {
    if (term == lastTerm) return;

    lastTerm = term;

    setState(() => _loading = true);

    try {
      final results = await fetchSearch(term);
      setState(() {
        _results = results;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: <Widget>[
        const TabTitle(title: 'Pesquisar'),
        const SizedBox(height: 8),
        SearchInput(controller: _textController),
        const SizedBox(height: 24),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_results.isEmpty)
          _buildEmptyState()
        else
          _buildResultsList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    final message = _textController.text.isEmpty
        ? 'Pesquise músicas e artistas! \nBasta clicar no campo de busca.'
        : 'Nenhum resultado encontrado.';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 130),
          const FractionallySizedBox(
            widthFactor: 0.7,
            child: Image(
              image: AssetImage('assets/images/empty-search.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final track = _results[index];
        return TrackItem(track: track, tracks: _results);
      },
    );
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController controller;

  const SearchInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.white),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Procure músicas…',
              hintStyle: TextStyle(
                fontSize: 16,
                color: BeatColors.disabledColor,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: BeatColors.mediumGrey,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
