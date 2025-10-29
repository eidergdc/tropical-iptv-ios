import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/live_caty/live_caty_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';
import 'package:tropical_iptv_ios/repository/models/channel_live.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  CategoryModel? selectedCategory;
  List<ChannelLive> channels = [];
  List<ChannelLive> filteredChannels = [];
  bool isLoadingChannels = false;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
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

  Future<void> _loadChannels(String categoryId) async {
    setState(() {
      isLoadingChannels = true;
    });

    try {
      final loadedChannels = await IpTvApi().getLiveChannels(categoryId);
      setState(() {
        channels = loadedChannels;
        filteredChannels = loadedChannels;
        isLoadingChannels = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF0F0F0F),
              Color(0xFF0A0A0A),
            ],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildCategoriesTabs(),
              Expanded(
                child: _buildChannelsGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Botão Voltar
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: kColorText,
            ),
          ),

          // Título ou Campo de Busca
          Expanded(
            child: isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(color: kColorText),
                    decoration: InputDecoration(
                      hintText: 'Buscar canal...',
                      hintStyle: TextStyle(color: kColorTextSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  )
                : Text(
                    'TV ao Vivo',
                    style: TextStyle(
                      color: kColorText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          // Botão de Busca
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                }
              });
            },
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: kColorPrimary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTabs() {
    return BlocBuilder<LiveCatyBloc, LiveCatyState>(
      builder: (context, state) {
        if (state is LiveCatyLoading) {
          return Container(
            height: 60,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: kColorPrimary,
              strokeWidth: 2,
            ),
          );
        }

        if (state is LiveCatyFailed) {
          return Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(
              'Erro ao carregar categorias',
              style: TextStyle(color: kColorTextSecondary),
            ),
          );
        }

        if (state is LiveCatySuccess) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                'Nenhuma categoria disponível',
                style: TextStyle(color: kColorTextSecondary),
              ),
            );
          }

          // Selecionar primeira categoria automaticamente
          if (selectedCategory == null && categories.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onCategorySelected(categories.first);
            });
          }

          return Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected =
                    selectedCategory?.categoryId == category.categoryId;

                return GestureDetector(
                  onTap: () => _onCategorySelected(category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [kColorPrimary, kColorSecondary],
                            )
                          : null,
                      color: isSelected ? null : kColorElevated1,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: kColorPrimary.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        category.categoryName ?? 'Sem nome',
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : kColorTextSecondary,
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChannelsGrid() {
    if (selectedCategory == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tv,
              size: 80,
              color: kColorTextSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Selecione uma categoria',
              style: TextStyle(
                color: kColorTextSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (isLoadingChannels) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: kColorPrimary,
            ),
            const SizedBox(height: 16),
            Text(
              'Carregando canais...',
              style: TextStyle(
                color: kColorTextSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (filteredChannels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isNotEmpty
                  ? Icons.search_off
                  : Icons.tv_off,
              size: 80,
              color: kColorTextSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Nenhum canal encontrado'
                  : 'Nenhum canal disponível',
              style: TextStyle(
                color: kColorTextSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (selectedCategory?.categoryId != null) {
          await _loadChannels(selectedCategory!.categoryId!);
        }
      },
      color: kColorPrimary,
      backgroundColor: kColorElevated2,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: filteredChannels.length,
        itemBuilder: (context, index) {
          final channel = filteredChannels[index];
          return _buildChannelCard(channel);
        },
      ),
    );
  }

  Widget _buildChannelCard(ChannelLive channel) {
    return GestureDetector(
      onTap: () {
        // TODO: Abrir player
        Get.snackbar(
          'Canal',
          'Abrindo ${channel.name}...',
          backgroundColor: kColorPrimary,
          colorText: Colors.white,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: kColorElevated1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kColorElevated2,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo do Canal
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: kColorElevated2,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child:
                    channel.streamIcon != null && channel.streamIcon!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              channel.streamIcon!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderIcon();
                              },
                            ),
                          )
                        : _buildPlaceholderIcon(),
              ),
            ),

            // Informações do Canal
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome do Canal
                  Text(
                    channel.name ?? 'Sem nome',
                    style: TextStyle(
                      color: kColorText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Badge "Ao Vivo"
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AO VIVO',
                        style: TextStyle(
                          color: kColorTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        Icons.live_tv,
        size: 60,
        color: kColorTextSecondary.withOpacity(0.3),
      ),
    );
  }
}
