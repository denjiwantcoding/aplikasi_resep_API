import '../models/recipe_model.dart';

final List<Recipe> dummyRecipes = [
  Recipe(
    id: 'r1',
    title: 'Nasi Goreng Spesial',
    category: 'Makanan',
    imageUrl:
        'https://asset.kompas.com/crops/VcgvggZKE2VHqIAUp1pyHFXXYCs=/202x66:1000x599/1200x800/data/photo/2023/05/07/6456a450d2edd.jpg',
    ingredients: [
      '2 piring nasi putih',
      '1 butir telur',
      '2 siung bawang putih',
      '1 buah cabai merah',
      'Kecap manis, garam, minyak goreng',
    ],
    instructions:
        'Tumis bawang putih dan cabai sampai harum, tuang telur lalu orak-arik. Masukkan nasi putih, bumbui dengan kecap dan garam, aduk hingga rata dan hangat.',
    rating: 4.8,
  ),
  Recipe(
    id: 'r2',
    title: 'Es Cendol Segar',
    category: 'Minuman',
    imageUrl: 'assets/images/cendol.jpg',
    ingredients: [
      '1 mangkuk cendol hijau',
      '200 ml santan',
      '150 ml gula merah cair',
      'Es batu secukupnya',
    ],
    instructions:
        'Siapkan gelas tinggi, masukkan cendol lalu siram dengan gula merah cair. Tambahkan santan dan es batu, sajikan segera.',
    rating: 4.6,
  ),
  Recipe(
    id: 'r3',
    title: 'Pancake Pisang Madu',
    category: 'Sarapan',
    imageUrl: 'https://images.unsplash.com/photo-1481070555726-e2fe8357725c',
    ingredients: [
      '2 buah pisang matang',
      '150 g tepung terigu',
      '1 butir telur',
      '200 ml susu cair',
      '2 sdm madu',
    ],
    instructions:
        'Haluskan pisang, campur dengan telur, tepung, dan susu hingga licin. Tuang adonan ke wajan anti lengket, masak hingga kedua sisi kecokelatan. Sajikan dengan madu.',
    rating: 4.7,
  ),
  Recipe(
    id: 'r4',
    title: 'Ayam Bakar Madu',
    category: 'Makanan',
    imageUrl: 'assets/images/ayambakarmadu.jpg',
    ingredients: [
      '500 g ayam potong',
      '3 siung bawang putih',
      '2 sdm madu',
      '2 sdm kecap manis',
      '1 sdm air jeruk nipis',
    ],
    instructions:
        'Lumuri ayam dengan bawang putih halus, madu, kecap, dan air jeruk. Diamkan 30 menit lalu bakar sambil dioles sisa bumbu hingga matang dan karamel.',
    rating: 4.9,
  ),
  Recipe(
    id: 'r5',
    title: 'Smoothie Berry Yogurt',
    category: 'Minuman',
    imageUrl: 'https://images.unsplash.com/photo-1510626176961-4b57d4fbad03',
    ingredients: [
      '150 g stroberi beku',
      '100 g blueberry',
      '200 ml yogurt plain',
      '2 sdm madu',
      'Es batu secukupnya',
    ],
    instructions:
        'Masukkan seluruh bahan ke blender, proses hingga halus dan creamy. Tuang ke gelas saji dan nikmati selagi dingin.',
    rating: 4.5,
  ),
  Recipe(
    id: 'r6',
    title: 'Brownies Cokelat Lembut',
    category: 'Dessert',
    imageUrl: 'assets/images/browniescoklat.jpg',
    ingredients: [
      '200 g dark chocolate',
      '120 g butter',
      '150 g gula pasir',
      '2 butir telur',
      '80 g tepung terigu',
    ],
    instructions:
        'Lelehkan cokelat dan butter, dinginkan. Kocok telur dan gula hingga larut, tuang cokelat leleh lalu masukkan tepung. Panggang 30 menit pada suhu 170°C.',
    rating: 4.8,
  ),
];
