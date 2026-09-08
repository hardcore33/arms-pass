{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    // Initialize the Flutter engine
    let appRunner = await engineInitializer.initializeEngine({
      useColorEmoji: true,
    });
    // Run the app
    await appRunner.runApp();

    // Suavemente remove a tela de splash inicial
    var loader = document.getElementById('loading-screen');
    if (loader) {
      loader.classList.add('fade-out');
      setTimeout(function() {
        if (loader && loader.parentNode) {
          loader.parentNode.removeChild(loader);
        }
      }, 450);
    }
  }
});
