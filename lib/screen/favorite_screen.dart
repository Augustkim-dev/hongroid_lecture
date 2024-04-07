import 'package:flutter/material.dart';
import 'package:flutter_store_pick_app/model/food_store.dart';
import 'package:flutter_store_pick_app/widget/appbars.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '찜해둔 맛집',
        isLeading: false,
      ),
      body: FutureBuilder(
        future: _getMyFavoriteFoodStore(),
        builder: (context, snapshot) {
          // 데이터가 없을 경우
          if (!snapshot.hasData) {
            // 원형 프로그레스 바 (로딩 역할)
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // 데이터 통신 중 에러가 났을 경우
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              FoodStoreModel foodStoreModel = snapshot.data![index];
              return GestureDetector(
                child: _buildListItemFoodStore(foodStoreModel),
                onTap: () async {
                  // 상세 보기 화면으로 이동
                  var result = await Navigator.pushNamed(context, '/detail',
                      arguments: foodStoreModel);
                  if (result != null) {
                    if (result == 'back_from_detail') {
                      setState(() {});
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<FoodStoreModel>> _getMyFavoriteFoodStore() async {
    List<FoodStoreModel> lstFavoriteFoodStore = [];
    // 내가 찜해둔 맛집 리스트들 불러오기
    final favoriteStoreMap = await supabase
        .from('food_store')
        .select('*, favorite!inner(*)')
        .eq('favorite.favorite_uid', supabase.auth.currentUser!.id);
    lstFavoriteFoodStore =
        favoriteStoreMap.map((e) => FoodStoreModel.fromJson(e)).toList();

    return lstFavoriteFoodStore;
  }

  Widget _buildListItemFoodStore(FoodStoreModel foodStoreModel) {
    // 맛집 리스트 아이템
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(width: 2, color: Colors.black),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 제목 & 찜하기 여부 별모양 아이콘
          Row(
            children: [
              Expanded(
                child: Text(
                  foodStoreModel.storeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.star,
                size: 32,
              ),
            ],
          ),

          /// 메모
          Text(
            foodStoreModel.storeComment,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),

          /// 주소
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              foodStoreModel.storeAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
