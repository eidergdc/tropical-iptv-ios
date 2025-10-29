import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/movie_caty/movie_caty_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';
import 'package:tropical_iptv_ios/repository/models/channel_movie.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  CategoryModel? selectedCategory;
  List<ChannelMovie> movies = [];
  List<ChannelMovie> filteredMovies = [];
  ChannelMovie? selectedMovie;
  bool isLoadingMovies = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categorySearchController =
      TextEditingController();
  List<CategoryModel> allCategories = [];
  List<CategoryModel> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _categorySearchController.addListener(_onCategorySearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _categorySearchController.removeListener(_onCategorySearchChanged);
    _searchController.dispose();
    _categorySearchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredMovies = movies;
      } else {
        filteredMovies = movies
            .where(
                (movie) => movie.name?.toLowerCase().contains(query) ?? false)
            .toList();
      }
    });
  }

  void _onCategorySearchChanged() {
    final query = _categorySearchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCategories = allCategories;
      } else {
        filteredCategories = allCategories
            .where((category) =>
                category.categoryName?.toLowerCase().contains(query) ?? false)
            .toList();
      }
    });
  }

  Future<void> _loadMovies(String categoryId) async {
    setState(() {
      isLoadingMovies = true;
      selectedMovie = null;
    });

    try {
      final loadedMovies = await IpTvApi().getMovieChannels(categoryId);
      setState(() {
        movies = loadedMovies;
        filteredMovies = loadedMovies;
        isLoadingMovies = false;
        if (loadedMovies.isNotEmpty) {
          selectedMovie = loadedMovies.first;
        }
      });
    } catch (e) {
      setState(() {
        isLoadingMovies = false;
      });
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os filmes',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _onCategorySelected(CategoryModel category) {
    setState(() {
      selectedCategory = category;
      _searchController.clear();
    });
    if (category.categoryId != null) {
      _loadMovies(category.categoryId!);
    }
  }

  void _onMovieSelected(ChannelMovie movie) {
    setState(() {
      selectedMovie = movie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),
                  Expanded(child: _buildMovieList()),
                  _buildPreviewPanel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: kColorElevated1,
        border: Border(
          bottom: BorderSide(
            color: kColorBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Botão Voltar
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 20),

          // Título
          const Text(
            'Filmes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // Campo de Busca
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              height: 50,
              decoration: BoxDecoration(
                color: kColorElevated2,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: kColorBorder,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: kColorText),
                decoration: InputDecoration(
                  hintText: 'Buscar filmes',
                  hintStyle: TextStyle(
                    color: kColorTextSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: kColorTextSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Ícones
          _buildIconButton(Icons.play_circle_outline, Colors.white),
          const SizedBox(width: 15),
          _buildIconButton(Icons.movie_outlined, kColorPrimary),
          const SizedBox(width: 15),
          _buildIconButton(Icons.tv, Colors.white),
          const SizedBox(width: 15),
          _buildIconButton(Icons.settings, Colors.white),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: kColorElevated2,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: kColorElevated1,
        border: Border(
          right: BorderSide(
            color: kColorBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Campo de busca de categoria
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: kColorElevated2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: kColorBorder,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: kColorTextSecondary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _categorySearchController,
                    style: TextStyle(color: kColorText),
                    decoration: InputDecoration(
                      hintText: 'Buscar Categoria',
                      hintStyle: TextStyle(
                        color: kColorTextSecondary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de categorias
          Expanded(
            child: BlocBuilder<MovieCatyBloc, MovieCatyState>(
              builder: (context, state) {
                if (state is MovieCatyLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: kColorPrimary,
                    ),
                  );
                }

                if (state is MovieCatyFailed) {
                  return Center(
                    child: Text(
                      'Erro ao carregar categorias',
                      style: TextStyle(
                        color: kColorTextSecondary,
                      ),
                    ),
                  );
                }

                if (state is MovieCatySuccess) {
                  if (allCategories.isEmpty) {
                    allCategories = state.categories;
                    filteredCategories = state.categories;
                  }

                  // Selecionar primeira categoria automaticamente
                  if (selectedCategory == null &&
                      filteredCategories.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _onCategorySelected(filteredCategories.first);
                    });
                  }

                  // Adicionar categorias especiais
                  final specialCategories = [
                    {'name': 'Todos', 'count': movies.length},
                    {'name': 'Recentes', 'count': 0},
                    {'name': 'Favoritos', 'count': 0},
                  ];

                  return ListView(
                    children: [
                      // Categorias especiais
                      ...specialCategories.map((cat) => _buildCategoryItem(
                            cat['name'] as String,
                            cat['count'] as int,
                            false,
                          )),

                      // Categorias normais
                      ...filteredCategories.map((category) {
                        final isSelected =
                            selectedCategory?.categoryId == category.categoryId;
                        return _buildCategoryItem(
                          category.categoryName ?? 'Sem nome',
                          0,
                          isSelected,
                          onTap: () => _onCategorySelected(category),
                        );
                      }),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    String name,
    int count,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [kColorPrimary, kColorSecondary],
                )
              : null,
          color: isSelected ? null : kColorElevated2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected ? Colors.white : kColorText,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (count > 0 || isSelected)
              Text(
                isSelected && movies.isNotEmpty
                    ? movies.length.toString()
                    : count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : kColorTextSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList() {
    return Container(
      color: kColorBackground,
      child: isLoadingMovies
          ? Center(
              child: CircularProgressIndicator(
                color: kColorPrimary,
              ),
            )
          : filteredMovies.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum filme disponível',
                    style: TextStyle(
                      color: kColorTextSecondary,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    final isSelected =
                        selectedMovie?.streamId == movie.streamId;
                    return _buildMovieItem(movie, index + 1, isSelected);
                  },
                ),
    );
  }

  Widget _buildMovieItem(ChannelMovie movie, int number, bool isSelected) {
    return GestureDetector(
      onTap: () => _onMovieSelected(movie),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [kColorPrimary, kColorSecondary],
                )
              : null,
          color: isSelected ? null : kColorElevated1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Número
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : kColorElevated2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: isSelected ? kColorPrimary : kColorText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // Poster
            if (movie.streamIcon != null && movie.streamIcon!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.streamIcon!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderPoster();
                  },
                ),
              )
            else
              _buildPlaceholderPoster(),

            const SizedBox(width: 15),

            // Nome do filme
            Expanded(
              child: Text(
                movie.name ?? 'Sem nome',
                style: TextStyle(
                  color: isSelected ? Colors.white : kColorText,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderPoster() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: kColorElevated2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.movie,
        color: kColorTextSecondary,
        size: 30,
      ),
    );
  }

  Widget _buildPreviewPanel() {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: kColorElevated1,
        border: Border(
          left: BorderSide(
            color: kColorBorder,
            width: 1,
          ),
        ),
      ),
      child: selectedMovie == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_outlined,
                    size: 80,
                    color: kColorTextSecondary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selecione um filme',
                    style: TextStyle(
                      color: kColorTextSecondary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Poster do filme
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: selectedMovie!.streamIcon != null &&
                            selectedMovie!.streamIcon!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              selectedMovie!.streamIcon!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.movie,
                                    size: 100,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.movie,
                              size: 100,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                  ),
                ),

                // Nome do filme
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    selectedMovie!.name ?? 'Sem nome',
                    style: TextStyle(
                      color: kColorText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 30),

                // Botões
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Implementar Player
                            if (selectedMovie?.streamId != null) {
                              final videoUrl =
                                  await StreamUrlBuilder.buildMovieUrl(
                                selectedMovie!.streamId!,
                                selectedMovie!.containerExtension,
                              );

                              if (videoUrl.isNotEmpty) {
                                Get.toNamed('/player', arguments: {
                                  'videoUrl': videoUrl,
                                  'title': selectedMovie!.name ?? 'Filme',
                                  'posterUrl': selectedMovie!.streamIcon,
                                });
                              } else {
                                Get.snackbar(
                                  'Erro',
                                  'Não foi possível carregar o filme',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Assistir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColorPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implementar Favoritos
                            Get.snackbar(
                              'Favorito',
                              'Filme adicionado aos favoritos',
                              backgroundColor: kColorPrimary,
                              colorText: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Favoritar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kColorPrimary,
                            side: BorderSide(
                              color: kColorPrimary,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
    );
  }
}
