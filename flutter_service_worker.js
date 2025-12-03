'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"c.html": "fe97e99c4d219830eaa54184280d07a4",
"manifest.json": "ad2fb1df84cf0e157ea303ed102e0982",
"index.html": "728ae7d05f25b8a10ecd39deb6894e9d",
"/": "728ae7d05f25b8a10ecd39deb6894e9d",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "044d2ccec5a8acd374c4b02c56b04647",
"assets/assets/img/12.jpg": "6319c275bce539e343a21c0c929cc6b1",
"assets/assets/img/11.jpg": "7726c548ff01afa8fb0108f111aad4ce",
"assets/assets/img/2.jpg": "402f3dfb8b62911dc64b9946f65ef195",
"assets/assets/img/1.jpg": "ad178a737053516f70f0fb575653c6ac",
"assets/assets/img/10.jpg": "9f64151e274f54250490364a597c473c",
"assets/assets/img/6.jpg": "584d6e8baa1751d5277f33a5da5594f8",
"assets/assets/img/3.jpg": "2115b17823c84ec7fbfbc77f60e16616",
"assets/assets/img/9.jpg": "3843ffd5e25f182832ff522a6e610616",
"assets/assets/img/5.jpg": "a09935777ee26476871a9092409ab65b",
"assets/assets/img/7.jpg": "9f7c0c99e5d4afb88390cba0a04e5775",
"assets/assets/img/8.jpg": "0beaa58495bd531f6f7248b85bf93b0e",
"assets/assets/img/4.jpg": "36ffd80a55b77a53cf56654babd6daa2",
"assets/assets/images/TAP06213.JPG": "561553846e119c8859d1bdcc6a9cae06",
"assets/assets/images/TAP05535.JPG": "4d46357969ceb26db4755685aa898d29",
"assets/assets/images/TAP06026.JPG": "e22afb40edfeab2b05d3a0d2c6793ffb",
"assets/assets/images/TAP05754.JPG": "2ff236b5f0a5e418d98b5c9126f86f95",
"assets/assets/images/5X8A5065.jpg": "de830f6d86b3de52a34b27bbb872a5cf",
"assets/assets/images/TAP06001.JPG": "f4448f269fddd69be99597fcfb9a5442",
"assets/assets/images/TAP05811.JPG": "d513e72759090707d812b0b2be64a812",
"assets/assets/images/5X8A5048.jpg": "db90130d64c963c3bfeb17a0ad778d7d",
"assets/assets/images/TAP05554.JPG": "6d1c65db32a9b6bdfc3365dc117d430c",
"assets/assets/images/TAP05773.JPG": "70e25f9c204be730a6700954b565231d",
"assets/assets/images/TAP05542.JPG": "ad178a737053516f70f0fb575653c6ac",
"assets/assets/images/TAP05918.JPG": "35ea036b068aa9b0af3bba58338440e0",
"assets/assets/images/TAP05638.JPG": "c574044c4ccc964033c13612b26d5a79",
"assets/assets/images/TAP05747.JPG": "20e5ed9c5aeb46b94297b251547c0c87",
"assets/assets/images/5X8A5191.jpg": "787d93294e61038b496598137bce1b35",
"assets/assets/images/TAP05817.JPG": "b7da852176ada4bb3f134caeb8704ce2",
"assets/assets/images/TAP05690.JPG": "9f8550f578bd48c22e349ea6c4bbbeb7",
"assets/assets/images/TAP06233.JPG": "e55e9e5f0e8dc577c6190c753a784c4b",
"assets/assets/images/TAP05580.JPG": "e7eb5fcc40d590d4d4a9ef29be13ea86",
"assets/assets/images/TAP06102.JPG": "c9a193577c0285c8dbe891b92aa1350e",
"assets/assets/images/5X8A5225.jpg": "035adb33a707b296c370edaee34b94ac",
"assets/assets/images/TAP05898.JPG": "2abf9373cf4b8cb9d5c19636a0ce88a7",
"assets/assets/images/TAP05698.JPG": "b99cb840169205b2feba258446f53464",
"assets/assets/images/TAP05924.JPG": "f371c59f350dd8653f15566363d66162",
"assets/assets/images/TAP05575.JPG": "402f3dfb8b62911dc64b9946f65ef195",
"assets/assets/images/5X8A5119.jpg": "9d0b76e4a6216e76181bba2d677d0926",
"assets/assets/images/TAP05766.JPG": "0beaa58495bd531f6f7248b85bf93b0e",
"assets/assets/images/TAP05587.JPG": "bcbd88540dcf26afb066a8704f64a5f3",
"assets/assets/images/TAP06163.JPG": "7726c548ff01afa8fb0108f111aad4ce",
"assets/assets/images/TAP05810.JPG": "ddffee30e33cb3a980b7a6f1f905f571",
"assets/assets/images/TAP06280.JPG": "a05ec428046f1db254c7f5f4e84c3a42",
"assets/assets/images/TAP05648.JPG": "bc77c92bcf9138015e551994e0a6e12e",
"assets/assets/images/5X8A5118.jpg": "9574add455938ed9057aa71ae5f88982",
"assets/assets/images/TAP06049.JPG": "883abb441b0e55d4eab5350253fdb3e5",
"assets/assets/images/TAP05588.JPG": "e39db643b4f78970412b4d7b591d1c9e",
"assets/assets/images/TAP05837.JPG": "08605e4a0a6703f9a263420e4d6f874a",
"assets/assets/images/TAP05639.JPG": "d8ddd65b53752c3cc307f105a8a815b2",
"assets/assets/images/TAP05603.JPG": "63e213c2e4b99d8302b03ba1f7842400",
"assets/assets/images/TAP06096.JPG": "9207524b6c98a8a3ca1d667eda6e1751",
"assets/assets/images/TAP05929.JPG": "44cc0509fbc28c1bee74dbf2590e8462",
"assets/assets/images/TAP05892.JPG": "b0fc455f7b8249c859eab93cbfbbfdb2",
"assets/assets/images/TAP06009.JPG": "bb564e2e712fabec8cafb936cbfdb712",
"assets/assets/images/TAP06055.JPG": "af2fbab3321d74dad7d19655f6eeb168",
"assets/assets/images/TAP06005.JPG": "32336aa931898cd0869b7ac1bbca1056",
"assets/assets/images/TAP05936.JPG": "0c11761e0038b1d91a4dfedacd7f081d",
"assets/assets/images/TAP05845.JPG": "6b83f447c2bfa4f174e515a5b05febd9",
"assets/assets/images/TAP05826.JPG": "d90d01c45da30f66e3a09729bcbd439e",
"assets/assets/images/TAP05696.JPG": "3a03cbd85f03ef26eb92be7ecdbb0bbc",
"assets/assets/images/TAP06268.JPG": "71c034703d3796e2e5f9c50584d5a091",
"assets/assets/images/TAP06093.JPG": "4bc019df12bb886f6210506f4705e610",
"assets/assets/images/TAP05906.JPG": "abd1282404e9a4ce3dc9e58cc23da030",
"assets/assets/images/TAP06202.JPG": "0e9b0ebb76f5ed065cdd7f03b0bb451f",
"assets/assets/images/TAP06222.JPG": "26a14ade40b54b6b7cb2f754918ed73f",
"assets/assets/images/TAP06165.JPG": "f0b63a08a3b00ded2b44b359f10f415c",
"assets/assets/images/TAP05608.JPG": "2115b17823c84ec7fbfbc77f60e16616",
"assets/assets/images/5X8A5140.jpg": "589e9494dc33bc30a841b627ed3631b8",
"assets/assets/images/TAP06307.JPG": "9f7a5ceac7fd93809d944b4c5931797b",
"assets/assets/images/TAP06210.JPG": "635a3e28ddd683de68d30bbf0e0631a9",
"assets/assets/images/TAP05829.JPG": "055b73b7c77e8078663ba0029ff97641",
"assets/assets/images/TAP05862.JPG": "a09935777ee26476871a9092409ab65b",
"assets/assets/images/TAP05668.JPG": "5312af406df971f51b28211082b7d656",
"assets/assets/images/TAP06240.JPG": "abb91b420bd173dddf16584ce9f3ac27",
"assets/assets/images/TAP06252.JPG": "e0b998710557a2c5ac7bc26571dfdd66",
"assets/assets/images/TAP06039.JPG": "8a595a36e02a1912801f89a19d416d88",
"assets/assets/images/TAP06203.JPG": "ec069c79692f738dfefedd091ed64151",
"assets/assets/images/TAP06098.JPG": "0d17bd73bf6fcf4667ddbb92155f7924",
"assets/assets/images/TAP05762.JPG": "feae816a39742ceaea7a221fb614cbbd",
"assets/assets/images/TAP05740.JPG": "9f7c0c99e5d4afb88390cba0a04e5775",
"assets/assets/images/TAP06281.JPG": "2bd69a96e01b36a88322cf3a4e2376e8",
"assets/assets/images/TAP05539.JPG": "f7ccdb93fbe44d98c132ef270f440ec4",
"assets/assets/images/TAP06271.JPG": "0293629fad6993b9a86c7be4c9248090",
"assets/assets/images/TAP05876.JPG": "c4f5d00febb6c448af442efb301c961d",
"assets/assets/images/TAP05667.JPG": "eff25f5bd4391fbc39adab42438bd8ee",
"assets/assets/images/TAP05878.JPG": "faaf27bd75554c4352dbdf5862572b8a",
"assets/assets/images/TAP05615.JPG": "87c00c785854b557603af067d7696a1b",
"assets/assets/images/TAP05736.JPG": "d17ae889dbd434dcbf2750a56feb0561",
"assets/assets/images/TAP06091.JPG": "a2845941c55014c2e8b82c80f9fd640f",
"assets/assets/images/TAP05881.JPG": "65b5ffd41e03f08c4fdb404848b024a3",
"assets/assets/images/TAP06264.JPG": "94cbf1f32f279e4b9d8ab451fb8a50a8",
"assets/assets/images/TAP05902.JPG": "5982c0dc159a3c99b509840ec4cc16e3",
"assets/assets/images/TAP06304.JPG": "43d5c213c7fa7e1f988be34a9cc60f7f",
"assets/assets/images/TAP06188.JPG": "501a7a0dbba3263ee2602aff9d185bfc",
"assets/assets/images/TAP05572.JPG": "dfd9be1e8dae8c8417c9d248b266d79c",
"assets/assets/images/TAP05935.JPG": "a627269b3c6194b242cd18f9d26f6111",
"assets/assets/images/TAP06205.JPG": "6319c275bce539e343a21c0c929cc6b1",
"assets/assets/images/TAP05860.JPG": "28e62653a424fe9ffdc82c6d7a49f11d",
"assets/assets/images/TAP06231.JPG": "62f2c7452e5fa7b001da3d4bd96abae5",
"assets/assets/images/TAP06065.JPG": "3843ffd5e25f182832ff522a6e610616",
"assets/assets/images/5X8A5125.jpg": "cd08de662929f0acaa594bb3e630b3b6",
"assets/assets/images/TAP06125.JPG": "e6ce669360148e48dc769d31172ff594",
"assets/assets/images/TAP05794.JPG": "def61ccd4d9fac7fd53a51a853250015",
"assets/assets/images/TAP05897.JPG": "e74cd4774bfba96aa334123b85f628cd",
"assets/assets/images/TAP06131.JPG": "d370b53e17a842f0c2107e7a0458444a",
"assets/assets/images/5X8A5277.jpg": "e7d3c39f27ebffca787889ff64485894",
"assets/assets/images/TAP06156.JPG": "1fa1442e41b2b9c8140ef7c561c4a719",
"assets/assets/images/TAP05526.JPG": "6cb6fd72a966de02199464ceac4bd8bd",
"assets/assets/images/TAP06245.JPG": "c26b0404855617489507e2ceb26a00ff",
"assets/assets/images/5X8A5059.jpg": "8277c393dd2a65fc3a4ead2477d55554",
"assets/assets/images/TAP06023.JPG": "712d5f3ffc3b8cceb07ab54a4130c661",
"assets/assets/images/5X8A5226.jpg": "fcce2ceb06114555fd19609a80ba72cc",
"assets/assets/images/5X8A5186.jpg": "1d80469e71a884e859a3b41858d2b723",
"assets/assets/images/TAP06182.JPG": "16e0d199a67e62da4e6a103bf3d2a7b6",
"assets/assets/images/TAP05717.JPG": "d5d22c4ca75836d292f3dac1fc70ff53",
"assets/assets/images/TAP06256.JPG": "6df843a23a94a36cd590197e5010a29e",
"assets/assets/images/TAP06297.JPG": "0de2f0597cd18e4881c29d56f4a0197b",
"assets/assets/images/TAP06108.JPG": "f59a8bc275183d4660615c056f1c366e",
"assets/assets/images/TAP06176.JPG": "9f64151e274f54250490364a597c473c",
"assets/assets/images/TAP06148.JPG": "2f7cdea85e360118bee726c334735e1d",
"assets/assets/images/TAP06199.JPG": "bf93b21f18de7ccebc04e75fbaa2c20a",
"assets/assets/images/5X8A5183.jpg": "fa310f1b16c8b851124bedb40d402d31",
"assets/assets/images/TAP05865.JPG": "cca91a1698b680cd80dec327693619f1",
"assets/assets/images/5X8A5136.jpg": "81eb42acd6437df17f57b7f453721858",
"assets/assets/images/TAP06327.JPG": "2af86605b3e7a54e0c5024907bc7c5ab",
"assets/assets/images/TAP06170.JPG": "84d7857fa9ca06b44517e3b9292e369c",
"assets/assets/images/TAP06078.JPG": "feb206c50b3b7edca496537f25fc0c67",
"assets/assets/images/5X8A5279.jpg": "97690dc90153212bda8a8c44cf77ed6e",
"assets/assets/images/TAP06081.JPG": "26e0abae781f1b68728e1c74d707201c",
"assets/assets/images/TAP05741.JPG": "e82884669d754071a07970ff161b0bd2",
"assets/assets/images/TAP06119.JPG": "bfb318b97d4ce9cb0b8a2bbb433e6875",
"assets/assets/images/TAP05687.JPG": "36ffd80a55b77a53cf56654babd6daa2",
"assets/assets/images/TAP06284.JPG": "145baf6160d6157b9ecfeec98eee3865",
"assets/assets/images/TAP06086.JPG": "1d0febca4f296377ea548923d34a15cc",
"assets/assets/images/TAP05564.JPG": "44c5ce89270deea6c01848f95142390d",
"assets/assets/images/TAP06145.JPG": "36fb8fdbf7ecf6a10a38f2edc4cb907d",
"assets/assets/images/5X8A5021.jpg": "393ab41c831ad015f937ac8d1dcb4e07",
"assets/assets/images/TAP05720.JPG": "584d6e8baa1751d5277f33a5da5594f8",
"assets/assets/images/5X8A5230.jpg": "133e5e7d97bf1377cf345446c949041a",
"assets/assets/images/TAP06069.JPG": "56cf8605166111cb9857e5f731d0471b",
"assets/assets/audio/Proud_Of_You.mp3": "20c2e605289bb3edbf9f600b087ac372",
"assets/assets/audio/My_Girl.mp3": "7ec664df5c584cb2d479629403ac29ea",
"assets/assets/audio/What_Makes_You_Beautiful.mp3": "cda84ff9921dc5b1e25b13e0dd2481d6",
"assets/assets/audio/That_Girl.mp3": "74e49b73c5428b6a75f754a4d5b17013",
"assets/assets/audio/I_Do.mp3": "6c48675f3d42bfff70a0f6a12ce2c2b4",
"assets/assets/audio/Girls_Like_You.mp3": "252b16ea947bb0b5b0a8dcbcea5c7693",
"assets/assets/audio/Beautiful_In_White.mp3": "da7c2c274243a6e39a71f49ab2b5db30",
"assets/assets/audio/There_For_You.mp3": "f961c46c1b0c2da0ce09b6ff84519fc7",
"assets/assets/audio/Im_Yours.mp3": "a6b33aaa048abacf406af9ba299c6666",
"assets/assets/audio/A_Little_Love.mp3": "0dbff0225a72fd0d7d74a8e7160060ea",
"assets/assets/bg/2.jpg": "bc77c92bcf9138015e551994e0a6e12e",
"assets/assets/bg/1.jpg": "63e213c2e4b99d8302b03ba1f7842400",
"assets/assets/bg/10.jpg": "c574044c4ccc964033c13612b26d5a79",
"assets/assets/bg/6.jpg": "b0fc455f7b8249c859eab93cbfbbfdb2",
"assets/assets/bg/3.jpg": "9f8550f578bd48c22e349ea6c4bbbeb7",
"assets/assets/bg/9.jpg": "bcbd88540dcf26afb066a8704f64a5f3",
"assets/assets/bg/5.jpg": "cca91a1698b680cd80dec327693619f1",
"assets/assets/bg/7.jpg": "5982c0dc159a3c99b509840ec4cc16e3",
"assets/assets/bg/8.jpg": "7726c548ff01afa8fb0108f111aad4ce",
"assets/assets/bg/4.jpg": "6b83f447c2bfa4f174e515a5b05febd9",
"assets/fonts/MaterialIcons-Regular.otf": "7d2cda6caeafb972d4f8f560ee0df920",
"assets/NOTICES": "303adc52e378cb2a2a4982ea5badf48e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "801c8e7cfa1d105bcc7f76f82fc37400",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "8c67316f0f9203cbd0e02e3b0b6e143c",
"version.json": "40d48bda287c9917081ca442ca8215a5",
"main.dart.js": "8c74b9be0580b54ed5324a247d6c51c3",
"style_c.css": "cf3c125f39ce5ffcf3dc81bc67d9b00f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
