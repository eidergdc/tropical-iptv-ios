import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/live_caty/live_caty_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';
import 'package:tropical_iptv_ios/repository/models/channel_live.dart';

class LiveTvScreenV2 extends StatefulWidget {
  const LiveTvScreenV2({super.key});

  @override
  State<LiveTvScreenV2> createState() => _LiveTvScreenV2State();
}

class _LiveTvScreenV2State extends State<LiveTvScreenV2> {
  CategoryModel? selectedCategory;
  List<ChannelLive> channels = [];
  List<ChannelLive> filteredChannels = [];
  ChannelLive? selectedChannel;
  bool isLoadingChannels = false;
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
        filteredChannels = channels;
      } else {
        filteredChannels = channels
            .where((channel) =>
                channel.name?.toLowerCase().contains(query) ?? false)
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

  Future<void> _loadChannels(String categoryId) async {
    setState(() {
      isLoadingChannels = true;
      selectedChannel = null;
    });

    try {
      final loadedChannels = await IpTvApi().getLiveChannels(categoryId);
      setState(() {
        channels = loadedChannels;
        filteredChannels = loadedChannels;
        isLoadingChannels = false;
        if (loadedChannels.isNotEmpty) {
          selectedChannel = loadedChannels.first;
        }
      });
    } catch (e) {
      setState(() {
        isLoadingChannels = false;
      });
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os canais',
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
      _loadChannels(category.categoryId!);
    }
  }

  void _onChannelSelected(ChannelLive channel) {
    setState(() {
      selectedChannel = channel;
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
                  Expanded(child: _buildChannelList()),
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
            'Live TV',
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
                  hintText: 'Search',
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
          _buildIconButton(Icons.play_circle_outline, kColorPrimary),
          const SizedBox(width: 15),
          _buildIconButton(Icons.movie_outlined, Colors.white),
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
                      hintText: 'Search Category',
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
            child: BlocBuilder<LiveCatyBloc, LiveCatyState>(
              builder: (context, state) {
                if (state is LiveCatyLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: kColorPrimary,
                    ),
                  );
                }

                if (state is LiveCatyFailed) {
                  return Center(
                    child: Text(
                      'Erro ao carregar categorias',
                      style: TextStyle(
                        color: kColorTextSecondary,
                      ),
                    ),
                  );
                }

                if (state is LiveCatySuccess) {
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
                    {'name': 'All', 'count': channels.length},
                    {'name': 'Recently Viewed', 'count': 0},
                    {'name': 'Favorite', 'count': 0},
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
                          0, // Contagem será atualizada quando carregar canais
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
                isSelected && channels.isNotEmpty
                    ? channels.length.toString()
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

  Widget _buildChannelList() {
    return Container(
      color: kColorBackground,
      child: isLoadingChannels
          ? Center(
              child: CircularProgressIndicator(
                color: kColorPrimary,
              ),
            )
          : filteredChannels.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum canal disponível',
                    style: TextStyle(
                      color: kColorTextSecondary,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredChannels.length,
                  itemBuilder: (context, index) {
                    final channel = filteredChannels[index];
                    final isSelected =
                        selectedChannel?.streamId == channel.streamId;
                    return _buildChannelItem(channel, index + 1, isSelected);
                  },
                ),
    );
  }

  Widget _buildChannelItem(ChannelLive channel, int number, bool isSelected) {
    return GestureDetector(
      onTap: () => _onChannelSelected(channel),
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

            // Logo
            if (channel.streamIcon != null && channel.streamIcon!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  channel.streamIcon!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderLogo();
                  },
                ),
              )
            else
              _buildPlaceholderLogo(),

            const SizedBox(width: 15),

            // Nome do canal
            Expanded(
              child: Text(
                channel.name ?? 'Sem nome',
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

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: kColorElevated2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.live_tv,
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
      child: selectedChannel == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tv_off,
                    size: 80,
                    color: kColorTextSecondary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selecione um canal',
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
                // Preview do canal
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: selectedChannel!.streamIcon != null &&
                            selectedChannel!.streamIcon!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              selectedChannel!.streamIcon!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.live_tv,
                                    size: 100,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.live_tv,
                              size: 100,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                  ),
                ),

                // Nome do canal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    selectedChannel!.name ?? 'Sem nome',
                    style: TextStyle(
                      color: kColorText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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
                            if (selectedChannel?.streamId != null) {
                              final videoUrl =
                                  await StreamUrlBuilder.buildLiveUrl(
                                selectedChannel!.streamId!,
                              );

                              if (videoUrl.isNotEmpty) {
                                Get.toNamed('/player', arguments: {
                                  'videoUrl': videoUrl,
                                  'title': selectedChannel!.name ?? 'Live TV',
                                  'posterUrl': selectedChannel!.streamIcon,
                                });
                              } else {
                                Get.snackbar(
                                  'Erro',
                                  'Não foi possível carregar o canal',
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
                              'Canal adicionado aos favoritos',
                              backgroundColor: kColorPrimary,
                              colorText: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Add to Favorite'),
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
