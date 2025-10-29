import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/series_caty/series_caty_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';
import 'package:tropical_iptv_ios/repository/models/channel_serie.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  CategoryModel? selectedCategory;
  List<ChannelSerie> series = [];
  List<ChannelSerie> filteredSeries = [];
  ChannelSerie? selectedSerie;
  bool isLoadingSeries = false;
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
        filteredSeries = series;
      } else {
        filteredSeries = series
            .where(
                (serie) => serie.name?.toLowerCase().contains(query) ?? false)
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

  Future<void> _loadSeries(String categoryId) async {
    setState(() {
      isLoadingSeries = true;
      selectedSerie = null;
    });

    try {
      final loadedSeries = await IpTvApi().getSeriesChannels(categoryId);
      setState(() {
        series = loadedSeries;
        filteredSeries = loadedSeries;
        isLoadingSeries = false;
        if (loadedSeries.isNotEmpty) {
          selectedSerie = loadedSeries.first;
        }
      });
    } catch (e) {
      setState(() {
        isLoadingSeries = false;
      });
      Get.snackbar(
        'Erro',
        'Não foi possível carregar as séries',
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
      _loadSeries(category.categoryId!);
    }
  }

  void _onSerieSelected(ChannelSerie serie) {
    setState(() {
      selectedSerie = serie;
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
                  Expanded(child: _buildSerieList()),
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
            'Séries',
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
                  hintText: 'Buscar séries',
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
          _buildIconButton(Icons.movie_outlined, Colors.white),
          const SizedBox(width: 15),
          _buildIconButton(Icons.tv, kColorPrimary),
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
            child: BlocBuilder<SeriesCatyBloc, SeriesCatyState>(
              builder: (context, state) {
                if (state is SeriesCatyLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: kColorPrimary,
                    ),
                  );
                }

                if (state is SeriesCatyFailed) {
                  return Center(
                    child: Text(
                      'Erro ao carregar categorias',
                      style: TextStyle(
                        color: kColorTextSecondary,
                      ),
                    ),
                  );
                }

                if (state is SeriesCatySuccess) {
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
                    {'name': 'Todas', 'count': series.length},
                    {'name': 'Recentes', 'count': 0},
                    {'name': 'Favoritas', 'count': 0},
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
                isSelected && series.isNotEmpty
                    ? series.length.toString()
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

  Widget _buildSerieList() {
    return Container(
      color: kColorBackground,
      child: isLoadingSeries
          ? Center(
              child: CircularProgressIndicator(
                color: kColorPrimary,
              ),
            )
          : filteredSeries.isEmpty
              ? Center(
                  child: Text(
                    'Nenhuma série disponível',
                    style: TextStyle(
                      color: kColorTextSecondary,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredSeries.length,
                  itemBuilder: (context, index) {
                    final serie = filteredSeries[index];
                    final isSelected =
                        selectedSerie?.seriesId == serie.seriesId;
                    return _buildSerieItem(serie, index + 1, isSelected);
                  },
                ),
    );
  }

  Widget _buildSerieItem(ChannelSerie serie, int number, bool isSelected) {
    return GestureDetector(
      onTap: () => _onSerieSelected(serie),
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
            if (serie.cover != null && serie.cover!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  serie.cover!,
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

            // Nome da série
            Expanded(
              child: Text(
                serie.name ?? 'Sem nome',
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
        Icons.tv,
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
      child: selectedSerie == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tv_outlined,
                    size: 80,
                    color: kColorTextSecondary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selecione uma série',
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
                // Poster da série
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: selectedSerie!.cover != null &&
                            selectedSerie!.cover!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              selectedSerie!.cover!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.tv,
                                    size: 100,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.tv,
                              size: 100,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                  ),
                ),

                // Nome da série
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    selectedSerie!.name ?? 'Sem nome',
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
                          onPressed: () {
                            // TODO: Implementar Player/Episódios
                            Get.snackbar(
                              'Episódios',
                              'Lista de episódios em desenvolvimento',
                              backgroundColor: kColorPrimary,
                              colorText: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Episódios'),
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
                              'Série adicionada aos favoritos',
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
