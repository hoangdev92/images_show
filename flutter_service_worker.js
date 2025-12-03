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
"index.html": "0693ce427ed9f5c885a3c84cf1cd69a2",
"/": "0693ce427ed9f5c885a3c84cf1cd69a2",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "b402562f35b4579c0434e44a1a0218a5",
"assets/assets/img/12.jpg": "c0bde3295537e1bd8434dfea962bba8f",
"assets/assets/img/11.jpg": "f3f04802ed7bbc09690fd6eb1291c2dc",
"assets/assets/img/2.jpg": "b7f75bdea9c99705acc46058f8f813c2",
"assets/assets/img/1.jpg": "c85075690269f736a7c4148e2189725d",
"assets/assets/img/10.jpg": "b29cdd5ca431bef8a724f7c8f67671b9",
"assets/assets/img/6.jpg": "05a138c09507a61e27f7edc4932937b9",
"assets/assets/img/3.jpg": "011b9189ceda2723c2852ae68a9e8583",
"assets/assets/img/9.jpg": "cd27eefb1959826119b3ea7d9221fea8",
"assets/assets/img/5.jpg": "599937d6ef3201c2d5e08142ef781104",
"assets/assets/img/7.jpg": "4b9029056833785e83bfa3e1ee0ab538",
"assets/assets/img/8.jpg": "393f0573dee7c6a7a4b6cf9044bcd0f2",
"assets/assets/img/4.jpg": "36c79419149fdf14c447de543dbc495a",
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
"assets/assets/bg/2.jpg": "ae3b8aeebdc1976dda9a7fb84488886a",
"assets/assets/bg/1.jpg": "87ad20514314c9da230727e457675555",
"assets/assets/bg/10.jpg": "fd4b95761acfda4882c28f9947c32002",
"assets/assets/bg/6.jpg": "eb6411e3383f21bfef7236ee9ced9a23",
"assets/assets/bg/3.jpg": "75c6b1bf750f89da64201d50a8b84f26",
"assets/assets/bg/9.jpg": "d6c2982a3afa51c163fcd0e3a268ce92",
"assets/assets/bg/5.jpg": "7fa89e5325a42e440d626df14777da00",
"assets/assets/bg/7.jpg": "8a776cf8ee493110839cdf0baf67e10b",
"assets/assets/bg/8.jpg": "15a15667913172cc3befff193021c618",
"assets/assets/bg/4.jpg": "db29e41c14242993ce6702234e202b8f",
"assets/fonts/MaterialIcons-Regular.otf": "ab7ee0db4e9c06e20c7f9f4a7751b597",
"assets/NOTICES": "303adc52e378cb2a2a4982ea5badf48e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "07a32504fb1a6fddd01a0e0097f3121e",
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
"flutter_bootstrap.js": "327c0e3af79865833bf40d0a1672dd00",
"version.json": "40d48bda287c9917081ca442ca8215a5",
"main.dart.js": "5c2068f5ac7bcb0b05745089795a7222",
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
